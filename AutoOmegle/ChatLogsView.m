//
//  ChatLogsView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 16/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ChatLogsView.h"
#import "AppMacros.h"
@interface ChatLogsView()
{
    
}
@end
@implementation ChatLogsView
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
    [self.contentContainer setBackgroundColor:RED_COLOR_THEME];
    
    UILabel *lbl_Msg =[[UILabel alloc] initWithFrame:CGRectMake(20,(self.contentContainer.frame.size.height/2)-50,self.contentContainer.frame.size.width-40,100)];
    lbl_Msg.textColor=[UIColor whiteColor];
    lbl_Msg.backgroundColor=[UIColor clearColor];
    lbl_Msg.numberOfLines=0;
    lbl_Msg.font=[UIFont fontWithName:@"Helvetica" size:20];
    lbl_Msg.textAlignment = NSTextAlignmentCenter;
    lbl_Msg.tag=1;
    [self.contentContainer addSubview:lbl_Msg];
    
    lbl_Msg.text=@"To be Done";
}
@end