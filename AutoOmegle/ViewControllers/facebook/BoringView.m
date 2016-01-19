//
//  BoringView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "BoringView.h"
#import "AppMacros.h"
@interface BoringView()
{
    
}
@end
@implementation BoringView
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
    lblUnderDevelopment.text=@"You will get this feature in the next updates";
    [self.contentContainer addSubview:lblUnderDevelopment];
    [self setTitle:@"Mini Games"];
}
-(void)createView
{
    [self setBackgroundColor:[UIColor orangeColor]];
}


@end
