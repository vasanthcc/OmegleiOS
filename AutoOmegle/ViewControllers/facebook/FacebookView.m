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
        [self showHeaderWithSave:NO withSettings:NO andSend:NO];
        [self showUnderDevelopmentLabel];
    }
    return self;
}
-(void)showUnderDevelopmentLabel
{
    UILabel *lblUnderDevelopment=[[UILabel alloc] initWithFrame:CGRectMake(10,0,self.contentContainer.frame.size.width-20,self.contentContainer.frame.size.height)];
    lblUnderDevelopment.backgroundColor=[UIColor clearColor];
    lblUnderDevelopment.textColor=BLUE_COLOR_THEME;
    lblUnderDevelopment.textAlignment=NSTextAlignmentCenter;
    lblUnderDevelopment.font=[UIFont fontWithName:FONT_STATUS_BOLD size:18];
    lblUnderDevelopment.numberOfLines=0;
    lblUnderDevelopment.text=@"Hopefully You can get this feature in the next updates";
    [self.contentContainer addSubview:lblUnderDevelopment];
    [self setTitle:@"Facebook Login"];
}
-(void)createView
{
        [self setTitle:@"Facebook Login"];
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
