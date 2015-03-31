//
//  CCBaseViewController.h
//  CC
//
//  Created by Vasanth Ravichandran on 12/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
typedef enum
{
    NAVIGATION_MENU,
    NAVIGATION_OTHERSCREEN,
    NAVIGATION_INETRNAL_SWIPE,
    NAVIGATION_BACK,
    NAVIGATION_APPBECOMEACTIVE,
    NAVIGATION_CHART,
    
} NAVIGATION_SCENARIOS;

@interface CCBaseViewController : BaseViewController<MFMailComposeViewControllerDelegate>

@property NSString* screenID;
@property NAVIGATION_SCENARIOS navigationType;

-(id)isPresentInNavigationStack:(NSString *) viewControllerType;
-(void) navigateAfterPushOrPop:(NSString*) viewControllerType;
-(void) clearData;
-(void) removeLoggedInUserDetails;
-(void) getReadyForNewLoginAfterRemovingLoggedInUserDetails:(NSString*)alertMessageToDisplay;
-(void) composeMessage;
-(void) composeMail;
-(void)sendMail:(NSString*)emailID;
-(void) shareWithFriends;
@end
