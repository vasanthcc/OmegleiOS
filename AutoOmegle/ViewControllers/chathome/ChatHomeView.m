//
//  ChatHome.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 11/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ChatHomeView.h"
#import "AppMacros.h"
#import "TTTAttributedLabel.h"
#import "CCAlertView.h"
#import "AppData.h"
#import "OmegleTextBox.h"
#import "CCBaseViewController.h"

#define OFFSET_X 10
#define OFFSET_Y 5
#define ALIGNMENT_LEFT @"LEFT"
#define ALIGNMENT_RIGHT @"RIGHT"
#define BASE_URL @"http://front3.omegle.com/"

#define CHAT_INITIATING @"initiating chat"
#define LOOKING_FOR_STRANGERS @"looking for strangers"
#define STRANGERS_CONNECTED @"stranger connected."

@interface ChatHomeView()
{
    UITableView *tableChat;
    UISwitch *switchWelcomeMessage,*switchCommonLikes,*switchDoubleTapON,*switchReconnect;
    OmegleTextBox *txtWelcomeMessage,*txtCommonLikes;
    OmegleTextBox *txtMsg;
    UIActionSheet *popupTemplate;
    NSMutableArray *arrayChat;
    UIScrollView *contentScrollView;
    CCAlertView *longPressAlertView,*settingsAlertView,*disclaimerAlertView;
    
    NSString *baseChatURL,*chatName;
    bool initiated;
    
    NSURLConnection *baseURLConnection;
    NSURLConnection *startConnection;
    NSURLConnection *eventsURL;
    NSTimer *eventsTimer;
    NSURLConnection *sendConnection;
    NSURLConnection *disconnectConnection;
    NSURLConnection *stoplookingforcommonlikes;
    NSURLConnection *robotConnection;
    
    // Typing, BLECH.
    NSURLConnection *startTypingConnection;
    NSURLConnection *stoppedTypingConnection;
    UILabel *lblChatStatus;
    int frequency,users,waitingTime;
    BOOL connectionON;
    UIView *viewDisclaimer,*viewSticky;
}
@end
@implementation ChatHomeView

- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithSave:NO withSettings:NO andSend:NO];
        [self createView];
    }
    return self;
}
-(void)createView
{
    [self setTitle:@""];
    
    lblChatStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,StatusBarHeight,self.headerContainer.frame.size.width-80,self.headerContainer.frame.size.height-StatusBarHeight)];
    lblChatStatus.backgroundColor=[UIColor clearColor];
    lblChatStatus.textColor=[UIColor whiteColor];
    lblChatStatus.textAlignment=NSTextAlignmentCenter;
    lblChatStatus.font=[UIFont fontWithName:FONT_Helvetica size:16];
    [self.headerContainer addSubview:lblChatStatus];
    
    contentScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.contentContainer.frame.size.width,self.contentContainer.frame.size.height)];
    contentScrollView.backgroundColor=[UIColor whiteColor];
    contentScrollView.contentSize=CGSizeMake(contentScrollView.frame.size.width,contentScrollView.frame.size.height);
    [self.contentContainer addSubview:contentScrollView];
    
    tableChat=[[UITableView alloc] initWithFrame:CGRectMake(0,-20,contentScrollView.frame.size.width,contentScrollView.frame.size.height-40-OFFSET_Y)];
    tableChat.backgroundColor=[UIColor whiteColor];
    tableChat.transform = CGAffineTransformMakeRotation(-M_PI);
    tableChat.dataSource=self;
    tableChat.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableChat.delegate=self;
    [contentScrollView addSubview:tableChat];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    //[tableChat addGestureRecognizer:lpgr];For Further updates
    
    
    
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [tableChat addGestureRecognizer:doubleTap];
    
    UIButton *btnGetTemplate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetTemplate.frame = CGRectMake(tableChat.frame.origin.x+5, tableChat.frame.size.height+tableChat.frame.origin.y+OFFSET_Y+3, 32, 32);
    [btnGetTemplate addTarget:self
                       action:@selector(clickGetTemplate)
             forControlEvents:UIControlEventTouchUpInside];
    [btnGetTemplate setBackgroundImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [btnGetTemplate setBackgroundImage:[UIImage imageNamed:@"list"] forState:UIControlStateSelected];
    [contentScrollView addSubview:btnGetTemplate];
    
    
    txtMsg=[[OmegleTextBox alloc] initWithFrame:CGRectMake(btnGetTemplate.frame.origin.x+btnGetTemplate.frame.size.width+5,btnGetTemplate.frame.origin.y-3,contentScrollView.frame.size.width-95, 35)];
    txtMsg.returnKeyType=UIReturnKeySend;
    txtMsg.backgroundColor = [UIColor whiteColor];
    txtMsg.font=[UIFont fontWithName:@"Helvetica" size:13];
    txtMsg.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtMsg.delegate=self;
    txtMsg.borderStyle=UITextBorderStyleNone;
    txtMsg.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtMsg.autocorrectionType = UITextAutocorrectionTypeNo;
    txtMsg.placeholder=@"type message";
    [txtMsg addTarget:self action:@selector(doneWithTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [txtMsg addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [contentScrollView addSubview:txtMsg];
    
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(txtMsg.frame.origin.x+txtMsg.frame.size.width+10, txtMsg.frame.origin.y+3, 32, 32);
    [btnSend addTarget:self
                action:@selector(clickSend)
      forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"sendLight"] forState:UIControlStateNormal];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"sendLight"] forState:UIControlStateSelected];
    [contentScrollView addSubview:btnSend];
    
    UIButton *btnSettings = [[UIButton alloc] init];
    btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.backgroundColor=[UIColor clearColor];
    btnSettings.layer.cornerRadius = 15;
    btnSettings.layer.borderWidth = 1;
    btnSettings.layer.borderColor = [UIColor clearColor].CGColor;
    btnSettings.frame = CGRectMake(self.headerContainer.frame.size.width-35,25,32,32);
    //[btnClear setTitle:@"Clear" forState:UIControlStateNormal];
    [btnSettings setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(clickSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.headerContainer addSubview:btnSettings];
    
    
    [self newChat];
    [self startChat];//[self beginChat];
    [self createPopOverForSettings];
    [self createSticky];
}
-(void)createPopOverForSettings
{
    UIView *viewSettings = [[UIView alloc]initWithFrame:CGRectMake(20, 0,self.baseContentView.frame.size.width-40,330)];
    viewSettings.backgroundColor=[UIColor whiteColor];
    
    switchWelcomeMessage = [[UISwitch alloc]initWithFrame:CGRectMake(10,20,10,10)];
    [switchWelcomeMessage addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [viewSettings addSubview:switchWelcomeMessage];
    
    txtWelcomeMessage=[[OmegleTextBox alloc] initWithFrame:CGRectMake(switchWelcomeMessage.frame.origin.x+switchWelcomeMessage.frame.size.width+5,switchWelcomeMessage.frame.origin.y,viewSettings.frame.size.width-80, 30)];
    txtWelcomeMessage.returnKeyType=UIReturnKeyDone;
    txtWelcomeMessage.backgroundColor = [UIColor whiteColor];
    txtWelcomeMessage.font=[UIFont fontWithName:@"Helvetica" size:12];
    txtWelcomeMessage.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtWelcomeMessage.contentHorizontalAlignment=UIControlContentVerticalAlignmentCenter;
    txtWelcomeMessage.delegate=self;
    txtWelcomeMessage.borderStyle=UITextBorderStyleNone;
    txtWelcomeMessage.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtWelcomeMessage.placeholder=@"   welcome message";
    [txtWelcomeMessage addTarget:self action:@selector(doneWithTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[txtWelcomeMessage addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [viewSettings addSubview:txtWelcomeMessage];
    
    switchCommonLikes = [[UISwitch alloc]initWithFrame:CGRectMake(switchWelcomeMessage.frame.origin.x,switchWelcomeMessage.frame.origin.y+switchWelcomeMessage.frame.size.height+40,10,10)];
    [switchCommonLikes addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [viewSettings addSubview:switchCommonLikes];
    
    txtCommonLikes=[[OmegleTextBox alloc] initWithFrame:CGRectMake(switchCommonLikes.frame.origin.x+switchCommonLikes.frame.size.width+5,switchCommonLikes.frame.origin.y,viewSettings.frame.size.width-80, 30)];
    txtCommonLikes.returnKeyType=UIReturnKeyDone;
    txtCommonLikes.backgroundColor = [UIColor whiteColor];
    txtCommonLikes.font=[UIFont fontWithName:@"Helvetica" size:12];
    txtCommonLikes.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtCommonLikes.contentHorizontalAlignment=UIControlContentVerticalAlignmentCenter;
    txtCommonLikes.delegate=self;
    txtCommonLikes.borderStyle=UITextBorderStyleNone;
    txtCommonLikes.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtCommonLikes.placeholder=@"    interest (eg:kik,love)";
    [txtCommonLikes addTarget:self action:@selector(doneWithTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[txtCommonLikes addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [viewSettings addSubview:txtCommonLikes];
    
    switchDoubleTapON = [[UISwitch alloc]initWithFrame:CGRectMake(switchCommonLikes.frame.origin.x,switchCommonLikes.frame.origin.y+switchCommonLikes.frame.size.height+40,10,10)];
    [switchDoubleTapON addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    switchDoubleTapON.userInteractionEnabled = NO;
    [viewSettings addSubview:switchDoubleTapON];
    
    UILabel *lbl_Msg =[[UILabel alloc] initWithFrame:CGRectMake(switchDoubleTapON.frame.origin.x+switchDoubleTapON.frame.size.width+5,switchDoubleTapON.frame.origin.y,viewSettings.frame.size.width-60, 30)];
    lbl_Msg.textColor=[UIColor blackColor];
    lbl_Msg.backgroundColor=[UIColor whiteColor];
    lbl_Msg.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_Msg.text=@"Double tap to connect / disconnect";
    lbl_Msg.textAlignment = NSTextAlignmentLeft;
    [viewSettings addSubview:lbl_Msg];
    
    
    switchReconnect = [[UISwitch alloc]initWithFrame:CGRectMake(switchDoubleTapON.frame.origin.x,switchDoubleTapON.frame.origin.y+switchDoubleTapON.frame.size.height+40,10,10)];
    [switchReconnect addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [viewSettings addSubview:switchReconnect];
    
    UILabel *lbl_Reconnect =[[UILabel alloc] initWithFrame:CGRectMake(switchReconnect.frame.origin.x+switchReconnect.frame.size.width+5,switchReconnect.frame.origin.y,viewSettings.frame.size.width-60, 30)];
    lbl_Reconnect.textColor=[UIColor blackColor];
    lbl_Reconnect.backgroundColor=[UIColor whiteColor];
    lbl_Reconnect.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_Reconnect.text=@"Auto Reconnect";
    lbl_Reconnect.textAlignment = NSTextAlignmentLeft;
    [viewSettings addSubview:lbl_Reconnect];
    
    //    UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(viewSettings.frame.size.width/3, viewSettings.frame.size.height-40, viewSettings.frame.size.width/2, 25)];
    //    saveBtn.backgroundColor=BLUE_COLOR_THEME;
    //    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    //    [saveBtn setTitle:@"SAVE" forState:UIControlStateSelected];
    //    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    saveBtn.layer.borderColor=UIColorFromRGB(0x3A3D41).CGColor;
    //    saveBtn.layer.borderWidth=1;
    //    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    //    [saveBtn addTarget:self action:@selector(saveSettingsClicked) forControlEvents:UIControlEventTouchUpInside];
    //    [viewSettings addSubview:saveBtn];
    
    
    if(settingsAlertView == nil)
        settingsAlertView=[[CCAlertView alloc] initWithTitle:HEADER_MSGBOX withButtontitle:@"save" withContentView:viewSettings withDelegate:self];
    
}
-(void)createSticky
{
    int stickHeight = 30;
    viewSticky = [[UIView alloc]init];
    viewSticky.backgroundColor = UIColorFromRGB(0xFFDA34);
    viewSticky.frame =CGRectMake(0, 0, self.frame.size.width,stickHeight);
    [self.contentContainer addSubview:viewSticky];
    
    UILabel *lblSticky=[[UILabel alloc] initWithFrame:CGRectMake(5,0,viewSticky.frame.size.width-stickHeight,stickHeight)];
    lblSticky.backgroundColor=[UIColor clearColor];
    lblSticky.textColor=[UIColor blackColor];
    lblSticky.text=@"Double tap the screen for connect / disconnect stranger";
    lblSticky.font=[UIFont fontWithName:@"Helvetica" size:13];
    [viewSticky addSubview:lblSticky];
    
    UIImage *close_Img=[UIImage imageNamed:@"btn_close"];
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor=[UIColor clearColor];
    
    [closeBtn setImage:close_Img forState:UIControlStateNormal];
    closeBtn.frame=CGRectMake(viewSticky.frame.size.width-stickHeight-2,0,stickHeight,stickHeight);
    [closeBtn addTarget:self action:@selector(hideStickyView) forControlEvents:UIControlEventTouchDown];
    [viewSticky addSubview:closeBtn];
}
-(void)hideStickyView
{
    [viewSticky removeFromSuperview];
}
-(void)showSettingsAlertView
{
    [self setDBStatus];
    [settingsAlertView showInView:self];
}
-(void)setDBStatus
{
    [switchCommonLikes setOn:[AppData getAppData].boolLikes_ON_OFF animated:YES];
    [switchDoubleTapON setOn:YES animated:YES];
    [switchWelcomeMessage setOn:[AppData getAppData].boolWelcomeMsg_ON_OFF animated:YES];
    
    if([AppData getAppData].strWelcomeMsg != nil && ![[AppData getAppData].strWelcomeMsg isEqualToString:@""] && txtWelcomeMessage !=nil)
        txtWelcomeMessage.text =[AppData getAppData].strWelcomeMsg;
    
    if([AppData getAppData].strCommonLikes != nil && ![[AppData getAppData].strCommonLikes isEqualToString:@""] && txtCommonLikes !=nil)
        txtCommonLikes.text =[AppData getAppData].strCommonLikes;
    
    
}
-(void)saveSettingsClicked
{
    if(switchWelcomeMessage.isOn)
    {
        [AppData getAppData].boolWelcomeMsg_ON_OFF = NO;
        
        txtWelcomeMessage.text = [txtWelcomeMessage.text stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceCharacterSet]];
        
        if([txtWelcomeMessage.text isEqualToString:@""])
        {
            [self showErrorAlertWithMessage:@"Welcome Message field should not be empty"];
            [txtWelcomeMessage resignFirstResponder];
            return;
        }
        else
        {
            //[[AppData getAppData] saveWelcomeMessage:txtWelcomeMessage.text];
            [AppData getAppData].boolWelcomeMsg_ON_OFF = YES;
            [AppData getAppData].strWelcomeMsg = txtWelcomeMessage.text;
        }
    }
    else
    {
        [AppData getAppData].boolWelcomeMsg_ON_OFF = NO;
    }
    
    
    if(switchCommonLikes.isOn)
    {
        [AppData getAppData].boolLikes_ON_OFF = NO;
        
        txtCommonLikes.text = [txtCommonLikes.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
        
        if([txtCommonLikes.text isEqualToString:@""])
        {
            [self showErrorAlertWithMessage:@"Likes field should not be empty"];
            [txtCommonLikes resignFirstResponder];
            return;
        }
        else
        {
            //            txtCommonLikes.text = [txtCommonLikes.text stringByTrimmingCharactersInSet:
            //                                   [NSCharacterSet whitespaceCharacterSet]];
            [AppData getAppData].boolLikes_ON_OFF = YES;
            [AppData getAppData].strCommonLikes = txtCommonLikes.text;
        }
        
    }
    else
    {
        [AppData getAppData].boolLikes_ON_OFF = NO;
    }
    
    [settingsAlertView hideView];
}
-(void)showing
{
    [super showing];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"isDisclaimerAccepted"] == nil && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"isDisclaimerAccepted"] isEqualToString:@"YES"])
    {
        [self disclaimerAcceptance];
    }
    //    if(![self isNetworkON])
    //        [self showLiveStatus:@"check internet connection"];
    //For refreshing template items when we navigated from template screen
    
    if(popupTemplate !=nil)
        popupTemplate=nil;
}
-(void)disclaimerAcceptance
{
    viewDisclaimer = [[UIView alloc]init];
    viewDisclaimer.backgroundColor = [UIColor whiteColor];
    viewDisclaimer.frame =CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-20);
    [self addSubview:viewDisclaimer];
    
    UILabel *lblHeader = [[UILabel alloc]init];
    lblHeader.frame=CGRectMake(0,0,viewDisclaimer.frame.size.width,40);
    lblHeader.font = [UIFont fontWithName:FONT_Helvetica size:18];
    lblHeader.backgroundColor = BLUE_COLOR_THEME;
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.text=@"Terms and Conditions";
    [viewDisclaimer addSubview:lblHeader];
    
    UITextView *disclaimerTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, lblHeader.frame.origin.y+lblHeader.frame.size.height, viewDisclaimer.frame.size.width, viewDisclaimer.frame.size.height-lblHeader.frame.size.height-40)];
    disclaimerTextView.backgroundColor=[UIColor clearColor];
    disclaimerTextView.textAlignment=NSTextAlignmentLeft;
    disclaimerTextView.editable=NO;
    disclaimerTextView.font = [UIFont fontWithName:FONT_Helvetica size:14];
    disclaimerTextView.showsVerticalScrollIndicator=NO;
    disclaimerTextView.text=[self getDisclaimerText];
    [viewDisclaimer addSubview:disclaimerTextView];
    
    UIButton *btnOk=[UIButton buttonWithType:UIButtonTypeCustom ];
    btnOk.frame=CGRectMake(0,disclaimerTextView.frame.origin.y+disclaimerTextView.frame.size.height,disclaimerTextView.frame.size.width,40);
    [btnOk setTitle:@"Accept" forState:UIControlStateNormal];
    [btnOk setTitle:@"Accept" forState:UIControlStateSelected];
    [btnOk addTarget:self action:@selector(proceedWithDisclaimerOK) forControlEvents:UIControlEventTouchUpInside];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOk.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnOk.titleLabel.backgroundColor=[UIColor orangeColor];
    btnOk.imageView.backgroundColor=[UIColor orangeColor];
    btnOk.backgroundColor = [UIColor orangeColor];
    [viewDisclaimer addSubview:btnOk];
    
}
-(void)proceedWithDisclaimerOK
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isDisclaimerAccepted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [viewDisclaimer removeFromSuperview];
    [self startChat];//[self beginChat];
}
- (void)setState:(id)checkBox
{
    if(checkBox == switchCommonLikes)
    {
        if(switchCommonLikes.isOn)
        {
            [txtCommonLikes setEnabled:TRUE];
        }
        else
        {
            [txtCommonLikes setEnabled:FALSE];
        }
    }
    else if(checkBox == switchWelcomeMessage)
    {
        if(switchWelcomeMessage.isOn)
        {
            [txtWelcomeMessage setEnabled:TRUE];
        }
        else
        {
            [txtWelcomeMessage setEnabled:FALSE];
        }
    }
    else if(checkBox == switchDoubleTapON)
    {
        //        if(switchFBInterest.isOn)
        //        {
        //            [AppData getAppData].boolFacebook_ON_OFF = YES;
        //            //if([AppData getAppData].getFacebookSession ==nil || [[AppData getAppData].getFacebookSession isEqualToString:@""])
        //            if([AppData getAppData].strFBSession ==nil || [[AppData getAppData].strFBSession isEqualToString:@""])
        //            {
        //                UIAlertView *fbAlert=[[UIAlertView alloc] initWithTitle:HEADER_MSGBOX message:@"You are not logged into facebook.Do you want to login now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        //
        //                fbAlert.tag = 12;
        //
        //                fbAlert.delegate=self;
        //
        //                [fbAlert show];
        //            }
        //            else
        //            {
        //                [switchFBInterest setOn:FALSE];
        //            }
        //        }
        //        else
        //        {
        //            [AppData getAppData].boolFacebook_ON_OFF = NO;
        //        }
        if(switchDoubleTapON.isOn)
            [AppData getAppData].boolDoubleTap_ON_OFF = YES;
        else
            [AppData getAppData].boolDoubleTap_ON_OFF = NO;
    }
    else if(checkBox == switchReconnect)
    {
        if(switchReconnect.isOn)
        {
            [AppData getAppData].boolReconnect_ON_OFF = YES;
        }
        else
        {
            [AppData getAppData].boolReconnect_ON_OFF = NO;
        }
    }
    
}
-(void)sendMessageIfWelcomeMessageOn
{
    //if([AppData getAppData].isWelcomeMessageOn && [[AppData getAppData] getWelcomeMessage] != nil && ![[[AppData getAppData] getWelcomeMessage] isEqualToString:@""])
    if([AppData getAppData].boolWelcomeMsg_ON_OFF && [[AppData getAppData] strWelcomeMsg] != nil && ![[[AppData getAppData] strWelcomeMsg] isEqualToString:@""] && arrayChat.count==0)
    {
        [self AddChatAndSendMessage:[AppData getAppData].strWelcomeMsg];//[[AppData getAppData] getWelcomeMessage]];
    }
}
-(void)doneWithTextField:(OmegleTextBox*)sender
{
    if(sender ==txtMsg)
    {
        if(connectionON)
        {
            txtMsg.text = [txtMsg.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
            
            if(![txtMsg.text isEqualToString:@""])
            {
                [self AddChatAndSendMessage:txtMsg.text];
                txtMsg.text=@"";
                [tableChat setScrollsToTop:YES];
            }
            else
            {
                [self showToast:@"Message field should not be empty."];
            }
        }
        else
        {
            [self showToast:@"Please connect with stranger."];
        }
        [contentScrollView setContentOffset:CGPointZero animated:YES];
    }
    [sender resignFirstResponder];
}
-(void)AddChatAndSendMessage:(NSString*)strInputMsg
{
    if(connectionON)
    {
        [self addChatMessage:[NSString stringWithFormat:@"%@|%@",strInputMsg,ALIGNMENT_RIGHT]];
        [self sendMessage:strInputMsg];
    }
    else
        [self showToast:@"Please connect with stranger."];
}
-(void)doDoubleTap
{
    if([AppData getAppData].boolDoubleTap_ON_OFF)
        [self clickDoConnect];
}
-(void)gotFocus
{
    //[contentScrollView setContentOffset:CGPointMake(contentScrollView.frame.origin.x,contentScrollView.frame.size.height/2) animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -230; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.contentContainer.frame = CGRectOffset(self.contentContainer.frame, 0, movement);
    [UIView commitAnimations];
}
-(void)clickDoConnect
{
    if(chatName==nil)
        [self startChat];
    else
    {
        if([AppData getAppData].boolDisconnectConfirmation_ON_OFF)
        {
            UIAlertView *confirmationAlert=[[UIAlertView alloc] initWithTitle:HEADER_MSGBOX message:@"Are you sure you want to disconnect?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            
            confirmationAlert.tag = 32;
            
            confirmationAlert.delegate=self;
            
            [confirmationAlert show];
        }
        else
            [self disconnectChat];
    }
    
}
-(void)clickSend
{
    [self doneWithTextField:txtMsg];
}
-(void)clickGetTemplate
{
    if([AppData getAppData].arrayTemplateItems==nil || [[AppData getAppData].arrayTemplateItems count] ==0)
    {
        UIAlertView *templateAlert=[[UIAlertView alloc] initWithTitle:HEADER_MSGBOX message:@"Do you want to create or edit template message now? This will disconnect your current chat.Click Ok to proceed." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        templateAlert.tag = 22;
        
        templateAlert.delegate=self;
        
        [templateAlert show];
        
        return;
    }
    
    if(popupTemplate==nil)
    {
        popupTemplate = [[UIActionSheet alloc] initWithTitle:@"Select to send a message:" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for( NSString *title in [AppData getAppData].arrayTemplateItems)
            [popupTemplate addButtonWithTitle:title];
    }
    [popupTemplate showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:tableChat];
    
    NSIndexPath *indexPath = [tableChat indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        //NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //NSLog(@"long press on table view at row %ld", (long)indexPath.row);
        //NSLog(@"Selected Item %@",[arrayChat objectAtIndex:indexPath.row]);
        //[self showLongPressPopup];
    }
    else {
        //NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        cell.backgroundView=nil;
        cell.selectedBackgroundView=nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI);
        cell.clipsToBounds=YES;
        cell.backgroundColor=[UIColor clearColor];
        
        self.contentContainer.clipsToBounds = YES;
        
        UIView *viewStrip = [[UIView alloc]initWithFrame:CGRectMake(3, 10, 3, cell.frame.size.height-20)];
        
        viewStrip.tag = 2;
        [cell addSubview:viewStrip];
        
        UILabel *lbl_Msg =[[UILabel alloc] initWithFrame:CGRectMake(OFFSET_X,0,tableView.frame.size.width-2*OFFSET_X,40)];
        lbl_Msg.textColor=[UIColor blackColor];
        lbl_Msg.backgroundColor=[UIColor clearColor];
        lbl_Msg.numberOfLines=0;
        lbl_Msg.layer.cornerRadius=8;
        lbl_Msg.layer.masksToBounds=YES;
        lbl_Msg.font=[UIFont fontWithName:@"Helvetica" size:15];
        lbl_Msg.textAlignment = NSTextAlignmentLeft;
        lbl_Msg.tag=1;
        [cell addSubview:lbl_Msg];
    }
    
    NSString *strMsg,*strAlignment;
    
    strMsg=[[[arrayChat objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0];
    
    strAlignment=[[[arrayChat objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:1];
    
    ((UILabel *)[cell viewWithTag:1]).text=strMsg;
    
    if( [strAlignment isEqualToString:ALIGNMENT_LEFT])
    {
        ((UILabel *)[cell viewWithTag:1]).textAlignment =NSTextAlignmentLeft;
        ((UILabel *)[cell viewWithTag:2]).backgroundColor =BLUE_COLOR_THEME;
        ((UILabel *)[cell viewWithTag:2]).frame =CGRectMake(3, 10, 3, cell.frame.size.height-20);
    }
    else
    {
        ((UILabel *)[cell viewWithTag:1]).textAlignment =NSTextAlignmentRight;
        ((UILabel *)[cell viewWithTag:2]).backgroundColor =[UIColor orangeColor];
        ((UILabel *)[cell viewWithTag:2]).frame =CGRectMake((cell.frame.size.width-OFFSET_X)+3, 10, 3, cell.frame.size.height-20);
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (int)arrayChat.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 if([self getRowHeightBaseOnThisText:[[[arrayChat objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0]] > 50)
 {
     [self showErrorAlertWithMessage:[[[arrayChat objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0]];
 }
}

#pragma mark Chat Code
-(void)newChat
{
    frequency = 3;
    waitingTime=0;
    initiated = NO;
    chatName = nil;
    
    if(arrayChat ==nil)
        arrayChat = [[NSMutableArray alloc]init];
    
    [self clearChatTable];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSString *mat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // will never be more than two chunks (other than BASEURL, but we dont need to append that data, we only care about the second one)
    if (connection == baseURLConnection)
    {
        NSString *dat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self baseURLDidReceiveData:dat];
        
    }
    else if (connection == startConnection)
    {
        NSString *dat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([dat rangeOfString:@"events"].location == NSNotFound)
        {//Yes
            if([dat isEqualToString:@"{}"])
            {
                
            }
            else
            {
                [self showLiveStatus:CHAT_INITIATING];
                [self chatBeganWithID:dat];
            }
        }
        else
        {//Doesnt have
            [self showLiveStatus:STRANGERS_CONNECTED];
            NSDictionary *likesResp =[NSJSONSerialization JSONObjectWithData:[dat dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
            if([dat rangeOfString:@"commonLikes"].location != NSNotFound)
            {
                NSLog(@"%@",[likesResp valueForKey:@"events"]);
                
                NSArray *arrayItem = [likesResp valueForKey:@"events"];
                
                for(int i=0;i<arrayItem.count;i++)
                {
                    NSArray *arrayCurItems =[arrayItem objectAtIndex:i];
                    if(arrayCurItems.count==2)
                    {
                        if([[arrayCurItems objectAtIndex:0] isEqualToString:@"commonLikes"])
                        {
                            NSString *strToast = [[NSString stringWithFormat:@"Both Likes : %@",[arrayCurItems objectAtIndex:1]] stringByReplacingOccurrencesOfString:@"(" withString:@""];
                            

                            [self showToast:[strToast stringByReplacingOccurrencesOfString:@")" withString:@""]];
                        }
                    }
                }
            }
            
            if([dat rangeOfString:@"clientID"].location != NSNotFound)
                [self chatBeganWithID:[likesResp valueForKey:@"clientID"]];
        }
    }
    else if (connection == eventsURL)
    {
        NSString *dat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self eventsDidReceiveData:dat];
        
    }
    else if (connection == sendConnection)
    {
        NSLog(@"Message Success: ?= %@", mat);
    }
    else if (connection == startTypingConnection)
    {
        NSLog(@"Started Typing: ?= %@", mat);
    }
    else if (connection == stoppedTypingConnection)
    {
        NSLog(@"Stopped Typing: ?= %@", mat);
    }
    else if (connection == disconnectConnection)
    {
        //[self doAfterDisconnected];put disconnected time
    }
    //else if(connection == stoplookingforcommonlikes)
    else
    {
        [self eventsDidReceiveData:mat];
    }
}
-(void)doAfterDisconnected
{
    [self newChat];
    [self showLiveStatus:@"you disconnected."];
    connectionON = NO;
    
    if([AppData getAppData].boolReconnect_ON_OFF)
        [self clickDoConnect];
}
//waiting
//connected
//gotMessage
//strangerDisconnected
//typing
//stoppedTyping
//recaptchaRequired
//recaptchaRejected
//statusInfo
//question
//antinudeBanned
//error
-(void)eventsDidReceiveData:(NSString *)dat
{
    NSLog(@"Response ::: %@",dat);
    if (![dat isEqualToString:@"null"])
    {
        waitingTime = 0;
        NSArray *response =[NSJSONSerialization JSONObjectWithData:[dat dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        __block int total = response.count;
        __block int start = 1;
        __block int array = 0;
        
        //else if
        while (total >= start)
        {
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"strangerDisconnected"])
            {
                [self showLiveStatus:@"stranger disconnected."];
                //[self newChat];
                connectionON = NO;
                chatName=nil;//for putting connection req if double tap instead of disconnecting again
                [eventsTimer invalidate];
                
                if([AppData getAppData].boolReconnect_ON_OFF)
                    [self clickDoConnect];
                
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"gotMessage"])
            {
                NSString *chatMessage = [[response objectAtIndex:array] objectAtIndex:1];
                
                [self addChatMessage:[NSString stringWithFormat:@"%@|%@",chatMessage,ALIGNMENT_LEFT]];
                
                NSLog(@"GOT_MESSAGE: %@", chatMessage);
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"connected"])
            {
                [self showLiveStatus:STRANGERS_CONNECTED];
[self sendMessageIfWelcomeMessageOn];
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"commonLikes"])
            {
                [self showLiveStatus:STRANGERS_CONNECTED];
                [self sendMessageIfWelcomeMessageOn];
                
                NSString *strToast = [[NSString stringWithFormat:@"Both likes : %@",[[response objectAtIndex: array] objectAtIndex:1]]stringByReplacingOccurrencesOfString:@"(" withString:@""];
                
                
                [self showToast:[strToast stringByReplacingOccurrencesOfString:@")" withString:@""]];
                
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"waiting"])
            {
                
                [self showLiveStatus:@"stranger waiting..."];
                NSLog(@"WAITING");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"count"])
            {
                
                users = [[[response objectAtIndex:array] objectAtIndex:1] intValue];
                NSLog(@"USER_COUNT: %d", users);
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"typing"])
            {
                NSLog(@"USER_TYPING");
                [self showLiveStatus:@"stranger typing..."];
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"stoppedTyping"])
            {
                NSLog(@"STOPPED_TYPING");
                [self showLiveStatus:@""];
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"recaptchaRequired"])
            {
                NSLog(@"recaptchaRequired");
                [self showErrorAlertWithMessage:@"You need to prove your a real person. Use omegle in your web browser and fill out the capacha to continue chatting."];
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"recaptchaRejected"])
            {
                NSLog(@"recaptchaRejected");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"statusInfo"])
            {
                NSLog(@"statusInfo");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"question"])
            {
                NSLog(@"question");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"antinudeBanned"])
            {
                NSLog(@"antinudeBanned");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"error"])
            {
                NSLog(@"error");
            }
            start++;
            array++;
        }
        
    }
    else
    {
                waitingTime = waitingTime+1;
                if(waitingTime > 5*frequency && arrayChat.count==0)
                    if([AppData getAppData].boolLikes_ON_OFF)
                        [self showToast:@"Omegle couldn't find anyone who shares interests with you, Try adding more interests!"];
    }
}
-(void)getResponseFromRobot:(NSString *)message {
    
    // LETS DO THIS.
}
-(void)showLiveStatus:(NSString*)strLiveMsg
{
    //[self setTitle:strLiveMsg];
    lblChatStatus.text = strLiveMsg;
}
-(void)addChatMessage:(NSString*)strMessage
{
    //    [arrayChat addObject:strMessage];
    [arrayChat insertObject:strMessage atIndex:0];
    [tableChat reloadData];
    
    [self scrollChatTableToTheBottom];
}
-(void)scrollChatTableToTheBottom
{
    NSInteger lastSectionIndex = MAX(0, [tableChat numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [ tableChat numberOfRowsInSection:lastSectionIndex] - 1);
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    
    if([arrayChat count] > 0)
    {
        //[tableChat scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void)clearChatTable
{
    [arrayChat removeAllObjects];
    [tableChat reloadData];
}
-(void)beginChat
{
    [self getBaseURL];
}
-(void)getBaseURL
{
    [self showLiveStatus:@"connecting to server..."];
    NSURL *url = [NSURL URLWithString:BASE_URL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    baseURLConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}
-(void)startChat
{
    baseChatURL=BASE_URL;
    
    [self clearChatTable];
    
    //    vars.put("rcs", "1"); vars.put("firstevents", firstEvents ? "1" : "0"); if(topics!=null){ System.out.println("Topics: "+topics); vars.put("topics", topics); } vars.put("m","1"); if(language!=null){ vars.put("lang",language);
    
    
    [self showLiveStatus:LOOKING_FOR_STRANGERS];
    
    NSString *events = [NSString stringWithFormat:@"%@start",baseChatURL];
    
    NSString *webString=@"";
    
    if([AppData getAppData].boolLikes_ON_OFF && txtCommonLikes != nil && ![txtCommonLikes.text isEqualToString:@""])
        webString =[events stringByAppendingString:[@"?rcs=1&firstevents=1&m=1&topics=" stringByAppendingString:[self getLikes]]];
    else
        webString =[events stringByAppendingString:@"?rcs=1&firstevents=1&m=1"];
    
    NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webString]];
    
    startConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
}
-(void)disconnectChat
{
    [self showLiveStatus:@"disconnecting..."];
    [eventsTimer invalidate];
    NSString *events =@"/disconnect";
    events = [NSString stringWithFormat:@"%@disconnect", baseChatURL];
    //NSLog(@"URL: %@", events);
    NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
    [eventsRequest setHTTPMethod:@"POST"];
    NSString *postString = [@"id=" stringByAppendingString:chatName];
    [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    disconnectConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
    
    [self doAfterDisconnected];
}
-(void)stopLookingForCommonLikes
{
    [self showLiveStatus:@"Omegle couldn't find anyone who shares interests with you, so this stranger is completely random. Try adding more interests!"];
    
    NSString *events =@"/stoplookingforcommonlikes";
    events = [NSString stringWithFormat:@"%@stoplookingforcommonlikes", baseChatURL];
    //NSLog(@"URL: %@", events);
    NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
    [eventsRequest setHTTPMethod:@"POST"];
    NSString *postString = [@"id=" stringByAppendingString:chatName];
    [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    disconnectConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
}
-(void)startTyping
{
    if (chatName != nil)
    {
        NSString *events =@"/typing";
        events = [NSString stringWithFormat:@"%@typing", baseChatURL];
        //NSLog(@"URL: %@", events);
        NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
        [eventsRequest setHTTPMethod:@"POST"];
        NSString *postString = [@"id=" stringByAppendingString:chatName];
        //NSLog(@"Post Data: %@", postString);
        [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        startTypingConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
    }
    
}
-(void)stopTyping
{
    if (chatName != nil)
    {
        NSString *events =@"/stoppedtyping";
        events = [NSString stringWithFormat:@"%@typing", baseChatURL];
        //NSLog(@"URL: %@", events);
        NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
        [eventsRequest setHTTPMethod:@"POST"];
        NSString *postString = [@"id=" stringByAppendingString:chatName];
        //NSLog(@"Post Data: %@", postString);
        [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        stoppedTypingConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
    }
}
-(void)sendMessage:(NSString *)message
{
    if (initiated && message != NULL)
    {
        message = [message stringByAddingPercentEscapesUsingEncoding:
                   NSASCIIStringEncoding];
        
        NSString *events =@"/send";
        events = [NSString stringWithFormat:@"%@send",baseChatURL];
        NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
        [eventsRequest setHTTPMethod:@"POST"];
        NSString *postString = [@"id=" stringByAppendingString:chatName];
        postString = [postString stringByAppendingString:@"&msg="];
        postString = [postString stringByAppendingString:message];
        
        [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Post Encoded Data: %@", [postString dataUsingEncoding:NSUTF8StringEncoding]);
        sendConnection = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
    }
}
-(NSString*)getLikes
{
    //    NSString *strLikes =[NSString stringWithFormat:@"[\"%@\"]",txtCommonLikes.text];
    //    return [strLikes stringByReplacingOccurrencesOfString:@"," withString:@"\",\""];
    
    NSString *strLikes =[[@"%5B%22" stringByAppendingString:txtCommonLikes.text] stringByAppendingString:@"%22%5D"];
    //[NSString stringWithFormat:@"%5B%22%@%22%5D",txtCommonLikes.text];
    return [strLikes stringByReplacingOccurrencesOfString:@"," withString:@"%22%2C%22"];
    
    
}
-(void)baseURLDidReceiveData:(NSString *)data
{
    //baseChatURL=BASE_URL;
    [self startChat];
}
-(void)chatBeganWithID:(NSString *)chatID
{
    chatID = [chatID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    chatName = chatID;
    initiated = true;
    connectionON = YES;
    //[self checkEvents];
    
    eventsTimer = [NSTimer scheduledTimerWithTimeInterval:frequency target:self selector:@selector(checkEvents) userInfo:nil repeats: YES];
    
    NSLog(@"Chat start");
}
-(void)checkEvents
{
    if (chatName != nil)
    {
        NSString *events = [NSString stringWithFormat:@"%@events", baseChatURL];
        NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
        [eventsRequest setHTTPMethod:@"POST"];
        NSString *postString = [@"id=" stringByAppendingString:chatName];
        [eventsRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        eventsURL = [[NSURLConnection alloc] initWithRequest:eventsRequest delegate:self];
    }
}
-(void)exit
{
    [eventsTimer invalidate];
    [self disconnectChat];
}
-(void)showLongPressPopup
{
    UIView *viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.baseContentView.frame.size.width-40,80)];
    viewContainer.backgroundColor=[UIColor whiteColor];
    
    
    TTTAttributedLabel *lblCopy=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0,0,viewContainer.frame.size.width,40)];
    NSString *textlblCopy= @"Copy";
    
    lblCopy.textAlignment=NSTextAlignmentCenter;
    lblCopy.backgroundColor=[UIColor whiteColor];
    
    lblCopy.font=[UIFont fontWithName:@"Helvetica" size:16];
    [lblCopy setText:textlblCopy afterInheritingLabelAttributesAndConfiguringWithBlock:
     ^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
         
         NSRange normalRange=NSMakeRange(0,[textlblCopy length]);
         
         [mutableAttributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:
          [NSNumber numberWithInt:kCTUnderlineStyleSingle] range:normalRange];
         
         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BLUE_COLOR_THEME range:normalRange];
         
         
         return mutableAttributedString; }];
    
    
    
    [viewContainer addSubview:lblCopy];
    
    UITapGestureRecognizer *lblCopyTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCopy)];
    [lblCopy addGestureRecognizer:lblCopyTapGestureRecognizer];
    
    //hide spam message
    //    TTTAttributedLabel *lblSpam=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0,lblCopy.frame.origin.y+lblCopy.frame.size.height,viewContainer.frame.size.width,40)];
    //    NSString *textlblSpam= @"Add to Spam";
    //
    //    lblSpam.textAlignment=NSTextAlignmentCenter;
    //    lblSpam.backgroundColor=[UIColor whiteColor];
    //
    //    lblSpam.font=[UIFont fontWithName:@"Helvetica" size:16];
    //    [lblSpam setText:textlblSpam afterInheritingLabelAttributesAndConfiguringWithBlock:
    //     ^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
    //
    //         NSRange normalRange=NSMakeRange(0,[textlblSpam length]);
    //
    //         [mutableAttributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:
    //          [NSNumber numberWithInt:kCTUnderlineStyleSingle] range:normalRange];
    //
    //         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BLUE_COLOR_THEME range:normalRange];
    //
    //
    //         return mutableAttributedString; }];
    //
    //
    //
    //    [viewContainer addSubview:lblSpam];
    //    //    [bottomContainer bringSubviewToFront:footerLbl];
    //    UITapGestureRecognizer *lblIndonesiaTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSpam)];
    //    [lblSpam addGestureRecognizer:lblIndonesiaTapGestureRecognizer];
    
    if(longPressAlertView == nil)
        longPressAlertView=[[CCAlertView alloc] initWithTitle:HEADER_MSGBOX withButtontitle:nil withContentView:viewContainer withDelegate:self];
    
    [longPressAlertView showInView:self];
    
}
-(void)clickCopy
{
    [UIPasteboard generalPasteboard].string=@"";
}
-(void)clickSpam
{
    
}
-(void)ccAlertView:(CCAlertView *)alertView clickedButton:(UIButton *)button
{
    [self saveSettingsClicked];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if(alertView.tag==12)
    //    {
    //        if(buttonIndex==1)
    //        {
    //            [self gotoThisViewController:@"FacebookViewController"];
    //        }
    //        else
    //            [switchFBInterest setOn:FALSE];
    //    }
    if(alertView.tag==22 && buttonIndex==1)
    {
        [self gotoThisViewController:@"TemplateViewController"];
    }
    else if(alertView.tag==32 && buttonIndex==1)
    {
        [self disconnectChat];
    }
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex !=-1 && buttonIndex !=0 && [AppData getAppData].arrayTemplateItems.count>=buttonIndex)
        [self AddChatAndSendMessage:[[AppData getAppData].arrayTemplateItems objectAtIndex:buttonIndex-1]];
}
-(void)clickSettings
{
    [self showSettingsAlertView];
}
-(NSString*)getDisclaimerText
{
    return @"By using the Omegle Web site, and/or related products and/or services ('Omegle', provided by Omegle.com LLC), you agree to the following terms: Do not use Omegle if you are under 13. If you are under 18, use it only with a parent/guardian's permission. Do not transmit nudity, sexually harass anyone, publicize other peoples' private information, make statements that defame or libel anyone, violate intellectual property rights, use automated programs to start chats, or behave in any other inappropriate or illegal way on Omegle. Understand that human behavior is fundamentally uncontrollable, that the people you encounter on Omegle may not behave appropriately, and that they are solely responsible for their own behavior. Use Omegle at your own peril. Disconnect if anyone makes you feel uncomfortable. You may be denied access to Omegle for inappropriate behavior, or for any other reason.\n\n \
    OMEGLE IS PROVIDED AS IS, AND TO THE MAXIMUM EXTENT ALLOWED BY APPLICABLE LAW, IT IS PROVIDED WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED, NOT EVEN A WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. TO THE MAXIMUM EXTENT ALLOWED BY APPLICABLE LAW, THE PROVIDER OF OMEGLE, AND ANY OTHER PERSON OR ENTITY ASSOCIATED WITH OMEGLE'S OPERATION, SHALL NOT BE HELD LIABLE FOR ANY DIRECT OR INDIRECT DAMAGES ARISING FROM THE USE OF OMEGLE, OR ANY OTHER DAMAGES RELATED TO OMEGLE OF ANY KIND WHATSOEVER.\n\n \
    By using Omegle, you accept the practices outlined in Omegle's PRIVACY POLICY and INFORMATION ABOUT THE USE OF COOKIES.";
}
-(int)getRowHeightBaseOnThisText:(NSString*)strText
{
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize =[strText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeCharacterWrap];
   return labelSize.height+5;
}
@end


//if (resp == null || resp.equals("null")) { failCount++; if(event!=null && event==OmegleEvent.waiting && failCount>=WAIT_CONNECT_TIME){ //	System.out.println("Connection timedout, stop common likes"); fireEvent(OmegleEvent.stopCommonLikes,null); failCount=0; }else if (failCount >= AutoOmegleApplication.NORESPONSE_TIMEOUT) { //	System.out.println("Connection timedout, no response from stranger "+AutoOmegleApplication.NORESPONSE_TIMEOUT); fireEvent(OmegleEvent.noresponse, null); omegle.removeSession(this); } return; }else{ failCount=0; }

//Map<String, Object> vars = new HashMap<String, Object>(); vars.put("rcs", "1"); vars.put("firstevents", firstEvents ? "1" : "0"); if(topics!=null){ System.out.println("Topics: "+topics); vars.put("topics", topics); } vars.put("m","1"); if(language!=null){ vars.put("lang",language); }
