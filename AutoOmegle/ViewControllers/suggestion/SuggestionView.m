//
//  SuggestionView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "SuggestionView.h"
#import "AppMacros.h"
#import "OmegleTextBox.h"
#import <MessageUI/MessageUI.h>
@interface SuggestionView()
{
    OmegleTextBox *txtSubject,*txtBody;
    UILabel *lbl_Result;
}
@end
@implementation SuggestionView
- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithSave:NO withSettings:NO andSend:YES];
        [self createView];
    }
    return self;
}
-(void)createView
{
    [self setTitle:@"Suggestion or Issues"];
    [self setBackgroundColor:[UIColor orangeColor]];
    
    UILabel *lbl_To =[[UILabel alloc] initWithFrame:CGRectMake(10,20,self.contentContainer.frame.size.width-20, 30)];
    lbl_To.textColor=[UIColor blackColor];
    lbl_To.backgroundColor=[UIColor whiteColor];
    lbl_To.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_To.text=@"To Whom : Auto Omegle Tech Team";
    lbl_To.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_To];
    
    UILabel *lbl_Subject =[[UILabel alloc] initWithFrame:CGRectMake(10,lbl_To.frame.origin.y+lbl_To.frame.size.height+20,self.contentContainer.frame.size.width-20, 30)];
    lbl_Subject.textColor=[UIColor blackColor];
    lbl_Subject.backgroundColor=[UIColor whiteColor];
    lbl_Subject.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_Subject.text=@"Subject for your Suggestion / Issue";
    lbl_Subject.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_Subject];
    
    
    txtSubject=[[OmegleTextBox alloc] initWithFrame:CGRectMake(10,lbl_Subject.frame.origin.y+lbl_Subject.frame.size.height,self.contentContainer.frame.size.width-20, 35)];
    
    txtSubject.returnKeyType=UIReturnKeyDone;
    txtSubject.backgroundColor=[UIColor whiteColor];
    txtSubject.font=[UIFont fontWithName:@"Helvetica" size:13];
    txtSubject.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtSubject.delegate=self;
    txtSubject.borderStyle=UITextBorderStyleNone;
    txtSubject.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [txtSubject addTarget:self action:@selector(doneWithTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.contentContainer addSubview:txtSubject];

    
    UILabel *lbl_Body =[[UILabel alloc] initWithFrame:CGRectMake(10,txtSubject.frame.origin.y+txtSubject.frame.size.height+20,self.contentContainer.frame.size.width-20, 30)];
    lbl_Body.textColor=[UIColor blackColor];
    lbl_Body.backgroundColor=[UIColor whiteColor];
    lbl_Body.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_Body.text=@"Content of Suggestion / Issue";
    lbl_Body.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_Body];
    
    
    txtBody=[[OmegleTextBox alloc] initWithFrame:CGRectMake(10,lbl_Body.frame.origin.y+lbl_Body.frame.size.height,self.contentContainer.frame.size.width-20, 80)];
    
    txtBody.returnKeyType=UIReturnKeyDone;
    txtBody.backgroundColor=[UIColor whiteColor];
    txtBody.font=[UIFont fontWithName:@"Helvetica" size:13];
    txtBody.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtBody.delegate=self;
    txtBody.borderStyle=UITextBorderStyleNone;
    txtBody.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [txtBody addTarget:self action:@selector(doneWithTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.contentContainer addSubview:txtBody];
    
    lbl_Result =[[UILabel alloc] initWithFrame:CGRectMake(10,txtBody.frame.origin.y+txtBody.frame.size.height+20,self.contentContainer.frame.size.width-20, 40)];
    lbl_Result.textColor=BLUE_COLOR_THEME;
    lbl_Result.backgroundColor=[UIColor whiteColor];
    lbl_Result.numberOfLines=0;
    lbl_Result.font=[UIFont fontWithName:@"Helvetica" size:14];
    lbl_Result.textAlignment = NSTextAlignmentCenter;
    [self.contentContainer addSubview:lbl_Result];
    
    UIButton *sendBtn=[[UIButton alloc] initWithFrame:CGRectMake((self.contentContainer.frame.size.width/3), self.contentContainer.frame.size.height-80, 150, 40)];
    sendBtn.backgroundColor=BLUE_COLOR_THEME;
    [sendBtn setTitle:@"Send Mail" forState:UIControlStateNormal];
    [sendBtn setTitle:@"Send Mail" forState:UIControlStateSelected];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.layer.borderColor=UIColorFromRGB(0x3A3D41).CGColor;
    sendBtn.layer.borderWidth=1;
    [sendBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [sendBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentContainer addSubview:sendBtn];
    
}
-(void)showing
{
    [super showing];
}
-(void)doneWithTextField:(OmegleTextBox*)sender
{
    [sender resignFirstResponder];
}
-(void)sendMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:txtSubject.text];
        [mail setMessageBody:txtBody.text isHTML:NO];
        [mail setToRecipients:@[@"testingEmail@example.com"]];
        
        [self.viewControllerDelegate presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        lbl_Result.text = @"Oops! This device cannot send email";
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            lbl_Result.text = @"You sent the email succesfully.";
            break;
        case MFMailComposeResultSaved:
            lbl_Result.text = @"You saved a draft of this email";
            break;
        case MFMailComposeResultCancelled:
            lbl_Result.text = @"You cancelled sending this email.";
            break;
        case MFMailComposeResultFailed:
            lbl_Result.text = @"Oops! Mail failed:  An error occurred when trying to compose this email";
            break;
        default:
            lbl_Result.text = @"Oops! An error occurred when trying to compose this email";
            break;
    }
    
    [self.viewControllerDelegate dismissViewControllerAnimated:YES completion:NULL];
}
@end
