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

#define OFFSET_X 10
#define OFFSET_Y 5
#define ALIGNMENT_LEFT @"LEFT"
#define ALIGNMENT_RIGHT @"RIGHT"

@interface ChatHomeView()
{
    UITableView *tableChat;
    UISwitch *switchWelcomeMessage,*switchCommonLikes;
    UITextField *txtWelcomeMessage,*txtCommonLikes;
    UITextField *txtMsg;
    UIPopoverController *popoverSettings;
    NSMutableArray *arrayChat;
    UIScrollView *contentScrollView;
    CCAlertView *longPressAlertView,*settingsAlertView;
    
    NSString *baseChatURL,*chatName;
    bool initiated;
    
    NSURLConnection *baseURLConnection;
    NSURLConnection *startConnection;
    NSURLConnection *eventsURL;
    NSTimer *eventsTimer;
    NSURLConnection *sendConnection;
    NSURLConnection *disconnectConnection;
    NSURLConnection *robotConnection;
    
    // Typing, BLECH.
    NSURLConnection *startTypingConnection;
    NSURLConnection *stoppedTypingConnection;
    
    int frequency,users;
}
@end
@implementation ChatHomeView

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
    [self setTitle:@"TALK TO STRANGERS"];
    
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
    [tableChat addGestureRecognizer:lpgr];
    
    
    
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [tableChat addGestureRecognizer:doubleTap];
    
    UIButton *btnGetTemplate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetTemplate.frame = CGRectMake(tableChat.frame.origin.x+5, tableChat.frame.size.height+tableChat.frame.origin.y+OFFSET_Y+3, 25, 25);
    [btnGetTemplate addTarget:self
                       action:@selector(clickGetTemplate)
             forControlEvents:UIControlEventTouchUpInside];
    [btnGetTemplate setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [btnGetTemplate setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateSelected];
    [contentScrollView addSubview:btnGetTemplate];
    
    
    txtMsg=[[UITextField alloc] initWithFrame:CGRectMake(btnGetTemplate.frame.origin.x+btnGetTemplate.frame.size.width+5,btnGetTemplate.frame.origin.y-3,contentScrollView.frame.size.width-80, 35)];
    txtMsg.returnKeyType=UIReturnKeySend;
    txtMsg.backgroundColor = [UIColor whiteColor];
    txtMsg.font=[UIFont fontWithName:@"Helvetica" size:13];
    txtMsg.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtMsg.delegate=self;
    txtMsg.borderStyle=UITextBorderStyleRoundedRect;
    txtMsg.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtMsg.placeholder=@"type message";
    [txtMsg addTarget:self action:@selector(doneWithTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    [txtMsg addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [contentScrollView addSubview:txtMsg];
    
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(txtMsg.frame.origin.x+txtMsg.frame.size.width+10, txtMsg.frame.origin.y+3, 25, 25);
    [btnSend addTarget:self
                action:@selector(clickSend)
      forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"icn_send"] forState:UIControlStateNormal];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"icn_send"] forState:UIControlStateSelected];
    [contentScrollView addSubview:btnSend];
    
    [self newChat];
    //[self beginChat];
    [self createPopOverForSettings];
}
-(void)createPopOverForSettings
{
    UIView *viewSettings = [[UIView alloc]initWithFrame:CGRectMake(20, 0,self.baseContentView.frame.size.width-40,300)];
    viewSettings.backgroundColor=[UIColor whiteColor];
    
    switchWelcomeMessage = [[UISwitch alloc]initWithFrame:CGRectMake(10,20,10,10)];
    [switchWelcomeMessage addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [viewSettings addSubview:switchWelcomeMessage];
    
    txtWelcomeMessage=[[UITextField alloc] initWithFrame:CGRectMake(switchWelcomeMessage.frame.origin.x+switchWelcomeMessage.frame.size.width+5,switchWelcomeMessage.frame.origin.y,viewSettings.frame.size.width-80, 30)];
    txtWelcomeMessage.returnKeyType=UIReturnKeyDone;
    txtWelcomeMessage.backgroundColor = [UIColor whiteColor];
    txtWelcomeMessage.layer.borderWidth = 0.5;
    txtWelcomeMessage.layer.borderColor = [[UIColor orangeColor] CGColor];
    txtWelcomeMessage.font=[UIFont fontWithName:@"Helvetica" size:12];
    txtWelcomeMessage.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            txtWelcomeMessage.contentHorizontalAlignment=UIControlContentVerticalAlignmentCenter;
    txtWelcomeMessage.delegate=self;
    txtWelcomeMessage.borderStyle=UITextBorderStyleNone;
    txtWelcomeMessage.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtWelcomeMessage.placeholder=@"   welcome message";
    [txtWelcomeMessage addTarget:self action:@selector(doneWithTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[txtWelcomeMessage addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [viewSettings addSubview:txtWelcomeMessage];
    
    switchCommonLikes = [[UISwitch alloc]initWithFrame:CGRectMake(switchWelcomeMessage.frame.origin.x,switchWelcomeMessage.frame.origin.y+switchWelcomeMessage.frame.size.height+40,10,10)];
    [switchCommonLikes addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [viewSettings addSubview:switchCommonLikes];
    
    txtCommonLikes=[[UITextField alloc] initWithFrame:CGRectMake(switchCommonLikes.frame.origin.x+switchCommonLikes.frame.size.width+5,switchCommonLikes.frame.origin.y,viewSettings.frame.size.width-80, 30)];
    txtCommonLikes.returnKeyType=UIReturnKeyDone;
    txtCommonLikes.backgroundColor = [UIColor whiteColor];
    txtCommonLikes.layer.borderWidth = 0.5;
    txtCommonLikes.layer.borderColor = [[UIColor orangeColor] CGColor];
    txtCommonLikes.font=[UIFont fontWithName:@"Helvetica" size:12];
    txtCommonLikes.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        txtCommonLikes.contentHorizontalAlignment=UIControlContentVerticalAlignmentCenter;
    txtCommonLikes.delegate=self;
    txtCommonLikes.borderStyle=UITextBorderStyleNone;
    txtCommonLikes.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtCommonLikes.placeholder=@"    find strangers with common likes";
    [txtCommonLikes addTarget:self action:@selector(doneWithTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[txtCommonLikes addTarget:self action:@selector(gotFocus) forControlEvents:UIControlEventEditingDidBegin];
    [viewSettings addSubview:txtCommonLikes];
    
    
    
    if(settingsAlertView == nil)
        settingsAlertView=[[CCAlertView alloc] initWithTitle:@"Omegle Chat" withButtontitle:nil withContentView:viewSettings withDelegate:self];
    
    [self showSettingsAlertView];
    
}
-(void)showSettingsAlertView
{
    [settingsAlertView showInView:self];
}
- (void)setState:(id)checkBox
{
    
}
-(void)doneWithTextField
{
    [self addChatMessage:[NSString stringWithFormat:@"%@|%@",txtMsg.text,ALIGNMENT_RIGHT]];
    [self sendMessage:txtMsg.text];
    [txtMsg resignFirstResponder];
    txtMsg.text=@"";
    
    [contentScrollView setContentOffset:CGPointZero animated:YES];
    [tableChat setScrollsToTop:YES];
}
-(void)doDoubleTap
{
    [self clickDoConnect];
}
-(void)gotFocus
{
    [contentScrollView setContentOffset:CGPointMake(contentScrollView.frame.origin.x,(contentScrollView.frame.size.height/2)+20) animated:YES];
}
-(void)clickDoConnect
{
    if(chatName==nil)
        [self startChat];
    else
        [self disconnectChat];
}
-(void)clickSend
{
    [self doneWithTextField];
}
-(void)clickGetTemplate
{
    [self clickDoConnect];
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
        NSLog(@"Selected Item %@",[arrayChat objectAtIndex:indexPath.row]);
        [self showLongPressPopup];
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
    
}

#pragma mark Chat Code
-(void)newChat
{
    frequency = 4;
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
        [self showLiveStatus:@"start chat"];
        [self chatBeganWithID:dat];
    }
    else if (connection == eventsURL)
    {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        //            });
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
        [self newChat];
        [self showLiveStatus:@"stranger disconnected."];
        NSLog(@"Chat Disconnected");
    }
    else {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        //                    });
        [self eventsDidReceiveData:mat];
        
    }
    [self checkEvents];
}

-(void)eventsDidReceiveData:(NSString *)dat
{
    if (![dat isEqualToString:@"null"])
    {
        NSArray *response =[NSJSONSerialization JSONObjectWithData:[dat dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        __block int total = response.count;
        __block int start = 1;
        __block int array = 0;
        
        
        while (total >= start)
        {
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"strangerDisconnected"]) {
                [self showLiveStatus:@"stranger disconnected."];
                [self newChat];
                [eventsTimer invalidate];
                
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"gotMessage"]) {
                NSString *chatMessage = [[response objectAtIndex:array] objectAtIndex:1];
                
                [self addChatMessage:[NSString stringWithFormat:@"%@|%@",chatMessage,ALIGNMENT_LEFT]];
                
                NSLog(@"GOT_MESSAGE: %@", chatMessage);
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"connected"]) {
                [self showLiveStatus:@"stranger connected"];
                NSLog(@"USER_CONNECTED");
                
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"waiting"]) {
                
                [self showLiveStatus:@"waiting..."];
                NSLog(@"WAITING");
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"count"]) {
                
                users = [[[response objectAtIndex:array] objectAtIndex:1] intValue];
                NSLog(@"USER_COUNT: %d", users);
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"typing"]) {
                NSLog(@"USER_TYPING");
                [self showLiveStatus:@"typing..."];
            }
            if ([[[response objectAtIndex: array] objectAtIndex:0] isEqualToString:@"stoppedTyping"]) {
                NSLog(@"STOPPED_TYPING");
                [self showLiveStatus:@"stopped typing..."];
            }
            start++;
            array++;
        }
        
    }
    
    
    
}
-(void)getResponseFromRobot:(NSString *)message {
    
    // LETS DO THIS.
}
-(void)showLiveStatus:(NSString*)strLiveMsg
{
    [self setTitle:strLiveMsg];
}
-(void)addChatMessage:(NSString*)strMessage
{
    //    [arrayChat addObject:strMessage];
    [arrayChat insertObject:strMessage atIndex:0];
    [tableChat reloadData];
    
    NSInteger lastSectionIndex = MAX(0, [tableChat numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [ tableChat numberOfRowsInSection:lastSectionIndex] - 1);
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    
    if([arrayChat count] > 0)
    {
        [tableChat scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    [self showLiveStatus:@"connecting to server"];
    NSURL *url = [NSURL URLWithString:@"http://omegle.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    baseURLConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}
-(void)startChat
{
    [self showLiveStatus:@"looking for strangers"];
    // yay now we actually start the chat.
    NSString *complete = [NSString stringWithFormat:@"%@start",baseChatURL];
    // NSLog(@"connection to: %@, starting chat.", complete);
    NSURL *url = [NSURL URLWithString:complete];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    startConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}
-(void)disconnectChat
{
    [eventsTimer invalidate];
    NSString *events =@"/disconnect";
    events = [NSString stringWithFormat:@"%@disconnect", baseChatURL];
    //NSLog(@"URL: %@", events);
    NSMutableURLRequest *eventsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:events]];
    [eventsRequest setHTTPMethod:@"POST"];
    NSString *postString = [@"id=" stringByAppendingString:chatName];
    //NSLog(@"Post Data: %@", postString);
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
-(void)baseURLDidReceiveData:(NSString *)data
{
    baseChatURL=@"http://omegle.com/";
    [self startChat];
}
-(void)chatBeganWithID:(NSString *)chatID
{
    chatID = [chatID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    chatName = chatID;
    initiated = true;
    [self checkEvents];
    
    //eventsTimer = [NSTimer scheduledTimerWithTimeInterval: self.frequency target:self selector:@selector(checkEvents) userInfo:nil repeats: YES];
    
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
    
    
    TTTAttributedLabel *lblSpam=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0,lblCopy.frame.origin.y+lblCopy.frame.size.height,viewContainer.frame.size.width,40)];
    NSString *textlblSpam= @"Add to Spam";
    
    lblSpam.textAlignment=NSTextAlignmentCenter;
    lblSpam.backgroundColor=[UIColor whiteColor];
    
    lblSpam.font=[UIFont fontWithName:@"Helvetica" size:16];
    [lblSpam setText:textlblSpam afterInheritingLabelAttributesAndConfiguringWithBlock:
     ^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
         
         NSRange normalRange=NSMakeRange(0,[textlblSpam length]);
         
         [mutableAttributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:
          [NSNumber numberWithInt:kCTUnderlineStyleSingle] range:normalRange];
         
         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BLUE_COLOR_THEME range:normalRange];
         
         
         return mutableAttributedString; }];
    
    
    
    [viewContainer addSubview:lblSpam];
    //    [bottomContainer bringSubviewToFront:footerLbl];
    UITapGestureRecognizer *lblIndonesiaTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSpam)];
    [lblSpam addGestureRecognizer:lblIndonesiaTapGestureRecognizer];
    
    if(longPressAlertView == nil)
    longPressAlertView=[[CCAlertView alloc] initWithTitle:@"Omegle Chat" withButtontitle:nil withContentView:viewContainer withDelegate:self];
    
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
    [alertView hideView];
}
@end
