//
//  OmegleTextBox.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "OmegleTextBox.h"

@implementation OmegleTextBox

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1.5, frame.size.width, 1.5  )];
    borderView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:borderView];
    return self;
}
@end
