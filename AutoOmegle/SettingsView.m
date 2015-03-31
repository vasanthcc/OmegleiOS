//
//  SettingsView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 16/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "SettingsView.h"
#import "AppMacros.h"
@interface SettingsView()
{
    
}
@end
@implementation SettingsView
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
    [self setBackgroundColor:[UIColor orangeColor]];
}
@end
