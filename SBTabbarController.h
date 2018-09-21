//
//  SBTabbarController.h
//  Declan Land
//
//  Created by Declan Land
//  Copyright Declan Land. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SBTabbarController : NSObject

/*
 @brief Shared instance of SBTabbarController.
 @discussion This instance will be updated when a SBTabbarController is initialized.
 @return id Shared instance.
*/

+ (id)sharedInstance;

/*!
 @brief Initialize SBTabbarController with UIViewController
 @discussion Create a new UIStoryboard file containing 1 UIViewController. Set the Storyboard Identifier of this UIViewController to 'SBTabbarController'. Then create your tab bar controller how you want it. Then create a UIView - this view will be used as the "Active" view.. when you change the UIViewController, this view will be used to display the content of the given controller. Set the "Active" restoration identifier to 'SBTabbarController'.
 @param controller Custom UIViewController that contains your "Active" view and custom navigation system.
 @return id Instance of SBTabbarController.
*/

- (id)initWithController:(UIViewController *)controller;

/*!
 @brief Set the Custom Controller
 @discussion Set the UIViewController which must contain your "Active" view.
*/

- (void)setCustomController:(UIViewController *)controller;

/*!
 @brief NSArray of UIViewControllers used in the tab bar controller stack.
 @return NSArray Collection of UIViewControllers currently in use.
 */

- (NSArray *)tabbarControllers;

/*!
 @brief Set the array of UIViewControllers to use in the tab bar system.
 @param controllers NSArray of UIViewControllers.
*/

- (void)setTabbarControllers:(NSArray *)controllers;

/*!
 @brief Change the current tab.
 @discussion This function will do nothing if the index is out of range.
 @param index of the tab you want to change to.
*/

- (void)changeTab:(int)index;

/*!
 @brief Push a UIViewController to the stack.
 @discussion Pushes the UIView of the given UIViewController onto the stack of the current tab.
 @param controller UIViewController that you want to push.
*/

- (void)pushViewController:(UIViewController *)controller;

/*!
 @brief Remove the top controller from the stack.
 @discussion This function will make it look as close as possible to a normal UINavigationController system.
*/

- (void)popViewController;

/*!
 @brief Replace the current controller with another one.
 @discussion This will replace the current view in the navigation stack with a given one.
 @param animated Optional animation.
*/

- (void)replaceViewController:(UIViewController *)controller animated:(BOOL)animated;

/*!
 @breif Unwind navigation stack with given index.
 @discussion Similar to the function of UITabbarController - when there are views stacked up on top of the tab and you click the tab bar button, the navigation stack will be unwinded and you will be brought to the root of the tabbar controller.
 @param index Index of the tab.
*/

- (void)unwindStackAtIndex:(int)index;

/*! @controller UIViewController containing sidebar and root view. */
@property (strong, nonatomic) UIViewController *controller;

/*! @selectedIndex Currently selected tab in int format. */
@property (nonatomic, assign) int selectedIndex;

@end
