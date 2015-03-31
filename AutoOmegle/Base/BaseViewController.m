//
//  BaseViewController.m
//  OSK
//
//  Created by Sharma Elanthiraiyan on 16/01/14.
//  Copyright (c) 2014 Sharma Elanthiraiyan. All rights reserved.
//


#import "BaseViewController.h"
#import "BaseView.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize objectToBePassedThroughShowing;
@synthesize data;
@synthesize errorMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self) {
        
        [self onCreate];
    }
    return self;
}

- (void)onCreate
{
    
}

#pragma mark ViewBased Methods

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [broker subscribe:self.view forChannel:@"/events/screenBecameActive"];
    
    if([self.view respondsToSelector:@selector(setViewControllerDelegate:)])
    {
        [(BaseView*)self.view setViewControllerDelegate:self];
    }
    
    if([self.view respondsToSelector:@selector(showing)])
    {
        [(BaseView*)self.view showing];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.objectToBePassedThroughShowing = nil;
    //[broker unsubscribe:self.view forChannel:@"/events/screenBecameActive"];
    
    if([self.view respondsToSelector:@selector(hiding)])
    {
        [(BaseView*)self.view hiding];
    }
}

-(void)putLogoutRequest
{
//    LogoutLoginModelRequest *logoutRequest=[[LogoutLoginModelRequest alloc] init];
//    [self sendRequest:logoutRequest];
}

#pragma mark response handling methods
- (void)handleResponse:(NSDictionary *)dic
{
    [(BaseView*)self.view ready];

}
#pragma ViewController Rotation Methods

- (BOOL)shouldAutorotate
{
    if([self respondsToSelector:@selector(allowRotation)])
    {
        return [self allowRotation];
    }
    else
        return NO;
}

@end
