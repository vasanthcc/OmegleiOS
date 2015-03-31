//
//  BaseViewController.h
//  OSK
//
//  Created by Sharma Elanthiraiyan on 16/01/14.
//  Copyright (c) 2014 Sharma Elanthiraiyan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import  "BaseView.h"


@interface BaseViewController : UIViewController

@property (retain) id objectToBePassedThroughShowing;
@property id data;
@property NSString *errorMsg;
- (void)navigateToLogin;
- (BOOL)allowRotation;

@end
