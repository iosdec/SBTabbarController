# SBTabbarController

Storyboard based UITabBarController.

Want to create a custom UITabBarController from the interface builder? Here is your solution.

## Installation:

Drag these files into your project:

*"SBTabbarController.m"*<br>
*"SBTabbarController.h"*

Then import the header into your project where needed:

```objc
#import "SBTabbarController.h"
```

## Setup:

For SBTabbarController to function, create a UIViewController in the interface builder; in this you will create your navigation system (I'm going to use a sidebar as an example):

![Controller Setup](https://github.com/iosdec/SBTabbarController/raw/master/Images/controller_setup.png)

#### "Active View"

We need to create an active view in the controller.. when we change tabs or push controllers onto the stack, this is where they will be displayed - so feel free to customise the frame.

All we have to do, is set the Restoration ID of this view to "SBTabbarController":

![Restoration ID Setup](https://github.com/iosdec/SBTabbarController/raw/master/Images/restoration_id.png)

## Initialise:

Now we have our controller setup, we just need to initialise a SBTabbarController instance and set the controllers.

We will simply create a UIViewController class for our custom controller:

![Custom Class Setup](https://github.com/iosdec/SBTabbarController/raw/master/Images/custom_class.png)

Now in our custom class.. we can setup our SBTabbarController:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabbarController];
}

#pragma mark	-	Custom Tabbar controller setup:

- (void)setupTabbarController {
	
    SBTabbarController *tabBar	=	[[SBTabbarController alloc] initWithController:self];
    
    UIViewController *first		=	[UIViewController new];
    UIViewController *second	=	[UIViewController new];
    UIViewController *third		=	[UIViewController new];
    UIViewController *fourth	=	[UIViewController new];
    
    NSArray *controllers		=	@[first, second, third, fourth];
    [tabBar setTabbarControllers:controllers];
	
}
```

## Usage:

Let's say that we've setup custom actions for our example buttons (tab1, tab2, etc) - when we click these 'tabs', we want to change to a tab in the controllers that we set. Easily done.

```objc
- (IBAction *)changeToTab1 {
	[[SBTabbarController sharedInstance] changeTab:0];
}
- (IBAction *)changeToTab2 {
	[[SBTabbarController sharedInstance] changeTab:1];
}
```

#### Navigation stack:

SBTabbarController also supports a navigation stack - using the same "active" view.<br>
Similar methods to UINavigationController have been created:

##### Push

```objc
- (IBAction *)toToNextScreen {
    UIViewController *nextController = [UIViewController new];
    [[SBTabbarController sharedInstance] pushViewController:nextController];
}
```

##### Pop

```objc
- (IBAction *)goBack {
	[[SBTabbarController sharedInstance] popViewController];
}
```

##### Replace

```objc
- (IBAction *)replaceScreen {
	UIViewController *replacement = [UIViewController new];
    [[SBTabbarController sharedInstance] replaceViewController:replacement animated:YES];
}
```

##### Unwind

```objc
- (IBAction *)unwindNavigationStack {
	[[SBTabbarController sharedInstance] 0];
}
```

## Credits:

iOSDec








