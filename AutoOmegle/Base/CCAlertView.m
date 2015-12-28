//
//  OSKAlertView.m
//  OSK
//
//  Created by Saranya Sivanandham on 17/12/13.
//  Copyright (c) 2013 Saranya Sivanandham. All rights reserved.
//

#import "CCAlertView.h"
#import "AppMacros.h"
#define CONTENT_WIDTH (self.frame.size.width-30)
#define CONTENT_HEIGHT (self.frame.size.height-(self.frame.size.height/(2.5)))

@interface CCAlertView()
{
    UIView *contentContainer;
    UILabel *lbl_header;
    UIButton *closeBtn;
}
@end

@implementation CCAlertView
@synthesize alertViewDelegate;
-(id) initWithFrame:(CGRect)frame withTitle:(BOOL) hasTitle
{
    self = [super initWithFrame:SCREEN_FRAME];
    
    
    if (self) {
        // Initialization code
        [self createOuterView];
        [self createBaseContent:hasTitle];
        
    }
    return self;
}

-(id)initWithTitle:(NSString*) alertTitle withButtontitle:(NSString *) title withContentView:(UIView*) content withDelegate:(id<CCAlertViewDelegate>) delegate
{
    return [self initWithTitle:alertTitle
               withButtontitle:title withContentView:content withDelegate:delegate withColorTheme:[UIColor blackColor]];
}

- (id)initWithTitle:(NSString*) alertTitle withButtontitle:(NSString *) title withContentView:(UIView*) content withDelegate:(id<CCAlertViewDelegate>) delegate withColorTheme:(UIColor*) color
{
    self = [self initWithFrame:SCREEN_FRAME withTitle:([alertTitle length]>0)];
    if (self) {
      
        // Initialization code
        if(content.frame.size.height>0)
        {
        CGFloat height=content.frame.size.height+41;
        contentContainer.frame=CGRectMake((self.frame.size.width-CONTENT_WIDTH)/2,((self.frame.size.height-height)/2)-60 , CONTENT_WIDTH, height);//width-60 for overall txtbox keyboard
        }
        if(lbl_header)
        {
        lbl_header.text=alertTitle;
        
        lbl_header.textColor=color;
        }
        alertViewDelegate=delegate;
        UIButton *alertBtn;
        if(title)
        {
            alertBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            alertBtn.layer.borderWidth=1;
            alertBtn.layer.borderColor=UIColorFromRGB(0x5A5650).CGColor;
            alertBtn.backgroundColor=BLUE_COLOR_THEME;
            [alertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [alertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [alertBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
            [alertBtn setTitle:title forState:UIControlStateNormal];
            alertBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
            alertBtn.frame=CGRectMake((contentContainer.frame.size.width-contentContainer.frame.size.width/2)/2, contentContainer.frame.size.height-40, contentContainer.frame.size.width/2, 35);
            [contentContainer addSubview:alertBtn];
        }
        content.frame=CGRectMake(5, (lbl_header?lbl_header.frame.size.height:0)+1, contentContainer.frame.size.width-10, contentContainer.frame.size.height-((lbl_header?lbl_header.frame.size.height:0)+alertBtn.frame.size.height+10));
        [contentContainer addSubview:content];
        
        [contentContainer bringSubviewToFront:alertBtn];
        [contentContainer bringSubviewToFront:closeBtn];
        
    }
    return self;
}
-(void) buttonClicked:(UIButton*) button
{
    [alertViewDelegate ccAlertView:self clickedButton:button];
}
-(void) createOuterView
{
    self.backgroundColor = UIColorFromARGB(0x40000000);
}
-(void) createBaseContent:(BOOL) hasTitle
{
    contentContainer=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-CONTENT_WIDTH)/2,(self.frame.size.height-CONTENT_HEIGHT)/2 , CONTENT_WIDTH, CONTENT_HEIGHT)];
    contentContainer.backgroundColor=[UIColor whiteColor];
    contentContainer.alpha=1;
    contentContainer.layer.cornerRadius=5;
    [self addSubview:contentContainer];
    
    if(hasTitle)
    {
    lbl_header=[[UILabel alloc] initWithFrame:CGRectMake(8,0,contentContainer.frame.size.width-16,40)];
    lbl_header.backgroundColor=[UIColor clearColor];
    lbl_header.textColor=[UIColor blackColor];
    lbl_header.font=[UIFont fontWithName:@"Helvetica" size:15];
    [contentContainer addSubview:lbl_header];
    
    
    UIView *separatorLine=[[UIView alloc] initWithFrame:CGRectMake(0,lbl_header.frame.size.height,contentContainer.frame.size.width,1)];
    separatorLine.backgroundColor=[UIColor blackColor];
    [contentContainer addSubview:separatorLine];
    }
    
    UIImage *close_Img=[UIImage imageNamed:@"btn_close"];
     closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor=[UIColor clearColor];
    
    [closeBtn setImage:close_Img forState:UIControlStateNormal];
    closeBtn.frame=CGRectMake(contentContainer.frame.size.width-close_Img.size.width-5,5,close_Img.size.width,close_Img.size.height);
    [closeBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
    [contentContainer addSubview:closeBtn];
}
-(void) showInView:(UIView *) view
{
    contentContainer.transform=CGAffineTransformMakeScale(0, 0);
    [view addSubview:self];
    [self animateContentView:YES];
}

-(void) hideView
{
    [self animateContentView:NO];
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.6];
}
-(void) animateContentView:(BOOL) expand
{
    if(expand)
    contentContainer.transform=CGAffineTransformMakeScale(0, 0);
    else
    contentContainer.transform=CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        contentContainer.transform=CGAffineTransformMakeScale(1.08, 1.08);
    } completion:^(BOOL finished) {

            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                if(!expand)
                    contentContainer.transform=CGAffineTransformMakeScale(0, 0);
                else
                    contentContainer.transform=CGAffineTransformMakeScale(1, 1);
                
            }completion:^(BOOL finished) {
            }];
        
    }];
   
}


@end
