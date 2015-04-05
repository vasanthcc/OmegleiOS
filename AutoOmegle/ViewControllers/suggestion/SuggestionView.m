//
//  SuggestionView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "SuggestionView.h"
#import "AppMacros.h"
@interface SuggestionView()
{
    
}
@end
@implementation SuggestionView
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
    [self setTitle:@"Issues or Suggestion"];
    [self setBackgroundColor:[UIColor orangeColor]];
}
@end
