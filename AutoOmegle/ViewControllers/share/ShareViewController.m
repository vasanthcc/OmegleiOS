//
//  ShareViewController.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
#import "AppMacros.h"
@interface ShareViewController()

@end

@implementation ShareViewController

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
    self.view=[[ShareView alloc] initWithFrame:SCREEN_FRAME withHeader:YES withMenu:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)identifier
{
    return @"ShareVC";
}
-(void)shareAppWithThisViewController
{
    NSArray * shareItems = @[@"Auto Omegle App for iPhone",[UIImage imageNamed:@"add.png"]];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    
    [self presentViewController:avc animated:YES completion:nil];
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

