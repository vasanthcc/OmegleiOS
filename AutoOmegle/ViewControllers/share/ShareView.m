//
//  ShareView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ShareView.h"
#import "AppMacros.h"
#import "ShareViewController.h"
@interface ShareView()
{
    
}
@end
@implementation ShareView
- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithSave:NO withSettings:NO andSend:NO];
        [self createView];
    }
    return self;
}
-(void)createView
{
    [self setTitle:@"Share to Friends"];
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height-40)];
    [self.contentContainer addSubview:imgBG];
    
    imgBG.image = [UIImage imageNamed:@"add.png"];
    
    UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame=CGRectMake(0,self.contentContainer.frame.size.height-40,self.contentContainer.frame.size.width,40);
    [btnDone setTitle:@"SHARE" forState:UIControlStateNormal];
    [btnDone setTitle:@"SHARE" forState:UIControlStateSelected];
    [btnDone addTarget:self action:@selector(sharePress) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnDone.backgroundColor=BLUE_COLOR_THEME;
    btnDone.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
    btnDone.titleLabel.backgroundColor=[UIColor clearColor];
    btnDone.imageView.backgroundColor=[UIColor clearColor];
    [self.contentContainer addSubview:btnDone];
}
-(void)showing
{
    [super showing];
}
-(void)sharePress
{
    [(ShareViewController*)self.viewControllerDelegate shareAppWithThisViewController];
}

@end