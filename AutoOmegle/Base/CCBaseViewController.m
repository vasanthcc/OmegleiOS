

//
//  CCBaseViewController.m
//  CC
//
//  Created by Vasanth Ravichandran on 12/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "CCBaseViewController.h"
#import "CCBaseView.h"
#import <MessageUI/MessageUI.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController


-(id) init
{
    self=[super init];
    if(self)
    {
        self.navigationType=NAVIGATION_MENU;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) clearData
{
    self.data = nil;
}
- (void)didReceiveMemoryWarning
{
    // [self clearMemory];
    [super didReceiveMemoryWarning];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.view respondsToSelector:@selector(afterShowing)])
    {
        [self.view performSelector:@selector(afterShowing) withObject:nil afterDelay:0];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)sendMail:(NSString*)emailID
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        //            [picker setSubject:[node fetchByPathStr:@"subject"].nodeValue];
        
        //NSString *emailBody = [node fetchByPathStr:@"body"].nodeValue;
        //[picker setMessageBody:emailBody isHTML:NO];
        [picker setToRecipients:@[emailID]];
        //ios 8 sdk
        //        [self dismissViewControllerAnimated:YES completion:^{
        //            [self presentViewController:picker animated:YES completion:^{}];
        //        }];
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        [(CCBaseView*)self.view showErrorAlertWithMessage:@"Mail not supported on this device"];
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma  mark Navigation Helpers

- (id)isPresentInNavigationStack:(NSString *) viewControllerType
{
    for (BaseViewController *v in self.navigationController.viewControllers)
    {
        NSString *viewControllerClassInStack = NSStringFromClass([v class]);
        
        if([viewControllerType isEqualToString:viewControllerClassInStack])
        {
            return v;
        }
    }
    return nil;
    
}

- (void)navigateAfterPushOrPop:(NSString*) viewControllerType
{
    CCBaseViewController *viewController = (CCBaseViewController*)[self isPresentInNavigationStack:viewControllerType];
    
    if (!viewController)
    {
        viewController.navigationType=NAVIGATION_MENU;
        [self.navigationController pushViewController:[[NSClassFromString(viewControllerType) alloc] init] animated:YES];
    }
    else
    {
        viewController.navigationType=NAVIGATION_MENU;
        viewController.data=nil;
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

#pragma mark Login DB Object Helpers

-(void)saveTreeItemInDB:(NSDictionary*) responseDict
{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:responseDict forKey:LOGIN_TREEKEY];
//    [prefs synchronize];
}

-(void) deleteTreeItemFromDB
{
//    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
//    [prefs removeObjectForKey:LOGIN_TREEKEY];
//    [prefs synchronize];
}


// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
-(void) clearMemory
{
    
    double freemem = [self availableMemory];
    
    /* Allocate the remaining amount of free memory, minus 2 megs */
    size_t size = freemem - 2048;
    void *allocation = malloc(freemem - 2048);
    //    bzero(allocation, size);
    //   free(allocation);
    
}

-(double)availableMemory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}


@end
