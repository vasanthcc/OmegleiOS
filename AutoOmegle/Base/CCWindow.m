//
//  OSKWindow.m
//  OSK
//
//  Created by suresh ramasamy on 5/5/14.
//  Copyright (c) 2014 Sharma Elanthiraiyan. All rights reserved.
//

#import "CCWindow.h"

@implementation CCWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    NSSet* allTouches = [event allTouches];
    UITouch* touch = [allTouches anyObject];

    if (touch.phase == UITouchPhaseBegan)
    {
 //       [[AlarmManager getInstance] resetTimer];
    }
}


@end
