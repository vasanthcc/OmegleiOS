//
//  BoringViewController.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "BoringViewController.h"
#import "BoringView.h"
#import "AppMacros.h"
@interface BoringViewController()

@end

@implementation BoringViewController

-(id) init
{
    self=[super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)onCreate
{
    self.view=[[BoringView alloc] initWithFrame:SCREEN_FRAME withHeader:YES withMenu:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)identifier
{
    return @"BoringVC";
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
