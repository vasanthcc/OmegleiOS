//
//  MainViewController.m
//  OSK
//
//  Created by Vasanth Ravichandran on 19/11/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "MainViewController.h"
#import "BaseView.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithRootViewController:(UIViewController *)rootViewController
{
    self=[super initWithRootViewController:rootViewController];
    
    return self;
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

-(UIViewController*) popViewControllerAnimated:(BOOL)animated
{
   return [super popViewControllerAnimated:animated];
}

#pragma ViewController Rotation Methods

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

#pragma ViewController Default Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
