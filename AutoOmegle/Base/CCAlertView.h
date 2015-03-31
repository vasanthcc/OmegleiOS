//
//  OSKAlertView.h
//  OSK
//
//  Created by Saranya Sivanandham on 17/12/13.
//  Copyright (c) 2013 Saranya Sivanandham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCAlertView;

@protocol CCAlertViewDelegate <NSObject>
-(void) ccAlertView:(CCAlertView*)alertView clickedButton:(UIButton*) button ;
@end

@interface CCAlertView : UIView
@property id alertViewDelegate;
@property CGSize contentSize;
- (id)initWithTitle:(NSString*) alertTitle withButtontitle:(NSString *) title withContentView:(UIView*) content withDelegate:(id<CCAlertViewDelegate>) delegate;
- (id)initWithTitle:(NSString*) alertTitle withButtontitle:(NSString *) title withContentView:(UIView*) content withDelegate:(id<CCAlertViewDelegate>) delegate withColorTheme:(UIColor*) color;
-(void) showInView:(UIView *) view;
-(void) hideView;

@end
