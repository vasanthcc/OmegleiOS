//
//  FacebookView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "FacebookView.h"
#import "AppMacros.h"
@interface FacebookView()
{
    
}
@end
@implementation FacebookView
- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithRefresh:NO withSearch:NO andAdd:YES];
        [self createView];
    }
    return self;
}
-(void)createView
{
        [self setTitle:@"Login to Facebook"];
    [self setBackgroundColor:[UIColor orangeColor]];
}
//FBLoginView *loginView=[[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"user_friends",@"basic_info",@"email", nil] ];
//FBLoginView *loginView=[[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"public_profile",@"user_friends",@"email", nil] ];
-(void)loadParseLogin
{
//    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects:@"public_profile",@"user_friends",@"email", nil] block:^(PFUser *user, NSError *error) {
//        if (!user)
//        {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        }
//        else if (user.isNew)
//        {
//            NSLog(@"User signed up and logged in through Facebook!");
//            if(canNavigate)
//            {
//                canNavigate =NO;
//                [self navigateToDashboard];
//            }
//        }
//        else
//        {
//            NSLog(@"User logged in through Facebook!");
//            if(canNavigate)
//            {
//                canNavigate =NO;
//                [self navigateToDashboard];
//            }
//        }
//    }];
    
}

@end
