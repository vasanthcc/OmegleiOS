//
//  ChatLogsViewController.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 16/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ChatLogsViewController.h"
#import "ChatLogsView.h"
#import "AppMacros.h"
@interface ChatLogsViewController()

@end

@implementation ChatLogsViewController

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
    self.view=[[ChatLogsView alloc] initWithFrame:SCREEN_FRAME withHeader:YES withMenu:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)identifier
{
    return @"ChatLogsVC";
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