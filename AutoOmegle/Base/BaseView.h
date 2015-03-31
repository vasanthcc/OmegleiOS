//
//  BaseView.h
//  OSK
//
//  Created by Vasanth Ravichandran on 02/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseView : UIView
{
    
    ;
}
@property (strong) UIView *baseContentView;
@property (weak) id viewControllerDelegate;

-(void) busy:(NSString*) message;
-(void) ready;

- (void)showErrorAlertWithMessage:(NSString*)message;
- (void)showErrorAlert:(NSString*)message buttonTitle:(NSString*)btnTitle;

-(void) showing;
-(void) hiding;

@end
