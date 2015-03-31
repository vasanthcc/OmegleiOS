//
//  BaseView.m
//  OSK
//
//  Created by Vasanth Ravichandran on 02/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "BaseView.h"
#import "BaseViewController.h"
#import "AppMacros.h"
#define kErrorAlertTag 10000
@implementation BaseView

@synthesize viewControllerDelegate,baseContentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        baseContentView =[[UIView alloc]init];
        baseContentView.frame= CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-(iOS7orAbove?0:StatusBarHeight)) ;
        baseContentView.backgroundColor=[UIColor clearColor];
        [self addSubview:baseContentView];
        
        
    }
    return self;
}

-(void) busy:(NSString*) message
{
    //[baseContentView busy:message];
}

-(void) ready
{
//[baseContentView ready:nil];
}


-(void) showing
{
    
}

-(void) hiding
{
    
}



-(void) showErrorAlert:(NSString *) message buttonTitle:(NSString *) btnTitle
{
    [self ready];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Auto Omegle" message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles: nil];
    alertView.center=CGPointMake(baseContentView.center.x,baseContentView.center.y);
    alertView.tag=kErrorAlertTag;
    [alertView show];
    
}
-(void) showErrorAlertWithMessage:(NSString*) message
{
    [self showErrorAlert:message buttonTitle:@"OK"];
}
@end
