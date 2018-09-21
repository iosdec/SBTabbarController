//
//  SBTabbarController.m
//  Declan Land
//
//  Created by Declan Land
//  Copyright Declan Land. All rights reserved.
//

#import "SBTabbarController.h"

@implementation SBTabbarController {
    NSArray     *tabbarControllers_;
    UIView      *activeView;
}

static id sharedInstance;

- (id)initWithController:(UIViewController *)controller {
    
    self = [super init];
    
    if (self) {
        
        if (controller) {
            self.controller = controller;
            [self findActiveView];
        }
        
    }
    
    sharedInstance = self;
    return self;
    
}

+ (id)sharedInstance {
    
    //  for this method.. we will return
    //  our static instance
    
    return sharedInstance;
    
}

#pragma mark    -   Find View Controller:

- (void)findActiveView {
    
    if (!self.controller) { return; }
    
    for (id obj in self.controller.view.subviews) {
        
        if ([obj isKindOfClass:[UIView class]]) {
            
            UIView *view    =   (UIView *)obj;
            
            if ([view.restorationIdentifier isEqualToString:NSStringFromClass([self class])]) {
                
                activeView  =   view; return;
                
            }
            
        }
        
    }
    
}

#pragma mark    -   Tab Bar Controllers:

- (NSArray *)tabbarControllers {
    
    return tabbarControllers_;
    
}

- (void)setTabbarControllers:(NSArray *)controllers {
    
    tabbarControllers_ = controllers;
    
    if (controllers.count != 0) {
        
        //  update the stack with the first controller:
        [self changeTab:0];
        
    }
    
}

#pragma mark    -   Set Custom Controller:

- (void)setCustomController:(UIViewController *)controller {
    
    self.controller = controller;
    [self findActiveView];
    
}

#pragma mark    -   Change Tab:

- (void)changeTab:(int)index {
    
    //  first, we will check the count of the tab bar controllers.
    //  we can't change to a tab if the controllers contain nothing.
    
    if (self.tabbarControllers.count == 0) { return; }
    
    //  now we will check if the index is in range.
    
    if ((self.tabbarControllers.count - 1) < index) { return; }
    
    //  before proceeding.. we will need to mimic the behaviour
    //  the tabbar controller. let's check if the index is the
    //  same as the selected index. if so, we need to unwind the
    //  controller stack.
    
    if (index == self.selectedIndex && activeView.subviews.count != 0) {
        [self unwindStackAtIndex:self.selectedIndex]; return;
    }
    
    self.selectedIndex                  =   index;
    UIViewController *controller        =   self.tabbarControllers[index];
    UIView *view                        =   [self viewFromController:controller];
    UIView *reusableView                =   [self reusableView];
    NSArray *navigationStack            =   [self navigationStackForIndex:index];
    
    //  if the navigation stack is more than 1.. then
    //  we must use the tabbar logic of displaying
    //  the view at the top of the stack.
    
    if (navigationStack.count > 1) {
        for (UIView *view in navigationStack) {
            [activeView bringSubviewToFront:view];
        } return;
    }
    
    //  now check if we have a reusable view. If so,
    //  then we just need to bring this to the front
    //  instead of inserting it again.
    
    if (reusableView) {
        [activeView bringSubviewToFront:view];
    }
    
    //  if not.. we need to insert it:
    
    if (!reusableView) {
        [activeView insertSubview:view atIndex:0];
        [activeView bringSubviewToFront:view];
    }
    
}

#pragma mark    -   Push View Controller:

- (void)pushViewController:(UIViewController *)controller {
    
    NSArray *navigationStack        =   [self navigationStackForIndex:self.selectedIndex];
    
    if (navigationStack.count == 0) { return; }
    
    //  now.. we need to prevent adding multiple views into the stack
    //  instead.. we will check for an existing controller in the stack
    //  if it exists, we will raise it to the front with a "push" animation
    //  so it looks like it's being pushed.
    
    NSString *classname             =   NSStringFromClass(controller.class);
    
    for (UIView *view in navigationStack) {
        
        if ([view.restorationIdentifier isEqualToString:classname]) {
            
            [self raiseNavigationStack:navigationStack frontController:controller];
            
            //  return because we don't want to do more.
            
            return;
            
        }
        
    }
    
    //  resume as normal. now, we want to create a uiview from the
    //  view controller and add it to the staack with an animation.
    
    CGFloat offscreen   =   activeView.frame.size.width;
    UIView *view        =   [self viewFromController:controller];
    view.frame          =   CGRectMake(offscreen, 0, view.frame.size.width, view.frame.size.height);
    [activeView addSubview:view];
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame      =   CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [self.controller addChildViewController:controller];
        [self.controller didMoveToParentViewController:controller];
    }];
    
}

#pragma mark    -   Pop View Controller:

- (void)popViewController {
    
    //  pop the highest view in the navigation stack out of it.
    
    NSArray *navigationStack        =   [self navigationStackForIndex:self.selectedIndex];
    
    if (navigationStack.count < 1) { return; }
    
    UIView *currentView             =   [navigationStack lastObject];
    
    if (!currentView) { return; }
    
    //  now we need to simulate the animation moving the view
    //  off of the screen.. like UINavigationController.
    
    [UIView animateWithDuration:0.2 animations:^{
        
        currentView.frame       =   CGRectMake(self->activeView.frame.size.width, 0, self->activeView.frame.size.width, self->activeView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        for (UIViewController *child in self.controller.childViewControllers) {
            if ([NSStringFromClass(child.class) isEqualToString:currentView.restorationIdentifier]) {
                [child removeFromParentViewController];
            }
        }
        
        [currentView removeFromSuperview];
        
    }];
    
}

#pragma mark    -   Replace View Controller:

- (void)replaceViewController:(UIViewController *)controller animated:(BOOL)animated {
    
    //  replace the current controller in the stack
    
    NSArray *navigationStack        =   [self navigationStackForIndex:self.selectedIndex];
    
    if (navigationStack.count < 1) { return; }
    
    UIView *currentView             =   [navigationStack lastObject];
    
    if (!currentView) { return; }
    
    UIView *view                    =   [self viewFromController:controller];
    
    //  check animation:
    
    if (!animated) {
        [activeView addSubview:view];
        [currentView removeFromSuperview];
        [self.controller didMoveToParentViewController:controller];
        return;
    }
    
    //  perform animation:
    
    view.alpha                      =   0;
    [activeView addSubview:view];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        view.alpha                  =   1;
        
    } completion:^(BOOL finished) {
        
        [currentView removeFromSuperview];
        [self.controller didMoveToParentViewController:controller];
        
    }];
    
}

#pragma mark    -   Unwind Stack:

- (void)unwindStackAtIndex:(int)index {
    
    //  let's start by getting the navigation stack with the given index:
    
    NSArray *navigationStack    =   [self navigationStackForIndex:index];
    
    if (navigationStack.count <= 1) { return; }
    
    UIView *tabRootView         =   [navigationStack firstObject];
    
    //  this requires us to reverse the array order
    
    NSArray *reversed           =   [[navigationStack reverseObjectEnumerator] allObjects];
    
    for (UIView *view in reversed) {
        
        if (view != tabRootView) {
            
            //  check for child view controller:
            
            for (UIViewController *child in self.controller.childViewControllers) {
                
                if ([NSStringFromClass([child class]) isEqualToString:view.restorationIdentifier]) {
                    
                    [child removeFromParentViewController];
                    
                }
                
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                view.frame          =   CGRectMake(view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                [view removeFromSuperview];
                
            }];
            
        }
        
    }
    
}

#pragma mark    -   View From UIViewController:

- (UIView *)viewFromController:(UIViewController *)controller {
    UIView *view                =   controller.view;
    view.frame                  =   CGRectMake(0, 0, activeView.frame.size.width, activeView.frame.size.height);
    view.tag                    =   self.selectedIndex;
    view.restorationIdentifier  =   NSStringFromClass(controller.class);
    return view;
}

- (UIView *)reusableView {
    for (UIView *view in activeView.subviews) {
        if (view.tag == self.selectedIndex) {
            return view;
        }
    } return nil;
}

- (NSArray *)navigationStackForIndex:(int)index {
    NSMutableArray *stack       =   [[NSMutableArray alloc] init];
    for (UIView *view in activeView.subviews) {
        if (view.tag == index) {
            [stack addObject:view];
        }
    } return stack;
}

- (void)raiseNavigationStack:(NSArray *)stack frontController:(UIViewController *)controller {
    
    UIView *frontView = nil;
    
    for (UIView *view in stack) {
        
        if ([view.restorationIdentifier isEqualToString:NSStringFromClass(controller.class)]) {
            frontView = view;
        } else {
            [activeView bringSubviewToFront:view];
        }
        
    }
    
    if (frontView) {
        
        CGFloat offscreen = activeView.frame.size.width;
        [frontView setFrame:CGRectMake(offscreen, frontView.frame.origin.y, frontView.frame.size.width, frontView.frame.size.height)];
        [activeView bringSubviewToFront:frontView];
        
        [UIView animateWithDuration:0.2 animations:^{
            [frontView setFrame:CGRectMake(0, 0, self->activeView.frame.size.width, self->activeView.frame.size.height)];
        } completion:^(BOOL finished) {
            [self.controller didMoveToParentViewController:controller];
        }];
        
    }
    
}

@end
