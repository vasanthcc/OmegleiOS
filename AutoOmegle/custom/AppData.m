//
//  AppData.m
//  OSK
//
//  Created by Saranya Sivanandham on 29/11/13.
//  Copyright (c) 2013 Saranya Sivanandham. All rights reserved.
//

#import "AppData.h"
#import "AppMacros.h"
static AppData *appData;
@interface AppData ()
{
    
}
@end
@implementation AppData
@synthesize arrayKeySpamMsg,strWelcomeMsg,strFBSession,strCommonLikes,arrayTemplateItems,boolWelcomeMsg_ON_OFF,boolLikes_ON_OFF,boolFacebook_ON_OFF,boolReconnect_ON_OFF;
+(AppData*)getAppData
{
    if(!appData)
    {
        appData=[[AppData alloc] init];
    }
    return appData;
}
-(id)init
{
    self =[super init];
    if(self)
    {
        if(self.userDefaults == nil)
            self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
-(NSMutableArray*)getSpamArray
{
    return self.arrayKeySpamMsg;
    //return [(NSMutableArray*)[self.userDefaults objectForKey:KEY_SPAM_MSG] mutableCopy];
}
-(NSString*)getWelcomeMessage
{
    return self.strWelcomeMsg;
    //return (NSString*)[self.userDefaults objectForKey:KEY_WELCOME_MSG];
}
-(NSString*)getFacebookSession
{
    return self.strFBSession;
    //return (NSString*)[self.userDefaults objectForKey:KEY_FACEBOOK_SESSION];
}
-(NSString*)getCommonLikes
{
    return self.strCommonLikes;
    //return (NSString*)[self.userDefaults objectForKey:KEY_COMMON_LIKES];
}
-(NSMutableArray*)getTemplateItems
{
    return self.arrayTemplateItems;
    //return (NSMutableArray*)[[self.userDefaults objectForKey:KEY_TEMPLATE_ITEMS] mutableCopy];
}


-(void)saveSpamMessage:(NSString*)strSpamMessage
{
    NSMutableArray *arrayItems = (NSMutableArray*)[self.userDefaults objectForKey:KEY_SPAM_MSG];
    [arrayItems addObject:strSpamMessage];
    
    self.arrayKeySpamMsg = [[NSMutableArray alloc]initWithArray:arrayItems];
    //    [[NSUserDefaults standardUserDefaults] setObject:arrayItems forKey:KEY_SPAM_MSG];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)saveWelcomeMessage:(NSString*)strMessage
{
    self.strWelcomeMsg=strMessage;
    //    [[NSUserDefaults standardUserDefaults] setObject:strMessage forKey:KEY_WELCOME_MSG];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)saveFacebookSession:(NSString*)strSession
{
    self.strFBSession=strSession;
    //    [[NSUserDefaults standardUserDefaults] setObject:strSession forKey:KEY_FACEBOOK_SESSION];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)saveCommonLikes:(NSString*)strLikes
{
    self.strCommonLikes=strLikes;
    //    [[NSUserDefaults standardUserDefaults] setObject:strLikes forKey:KEY_COMMON_LIKES];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)saveTemplateItems:(NSMutableArray*)arrayItems
{
    self.arrayTemplateItems = [[NSMutableArray alloc]initWithArray:arrayItems];
    //    [[NSUserDefaults standardUserDefaults] setObject:arrayItems forKey:KEY_TEMPLATE_ITEMS];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL)isWelcomeMessageOn
{
    return self.boolWelcomeMsg_ON_OFF;
    //return [[self.userDefaults objectForKey:ON_OFF_WELCOME_MSG] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isLikesOn
{
    return self.boolLikes_ON_OFF;
    //return [[self.userDefaults objectForKey:ON_OFF_LIKES] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isFacebookOn
{
    return self.boolFacebook_ON_OFF;
    //return [[self.userDefaults objectForKey:ON_OFF_FACEBOOK] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isReconnectOn
{
    return self.boolReconnect_ON_OFF;
    //return [[self.userDefaults objectForKey:ON_OFF_RECONNECT] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isDoubleTapON
{
    return self.boolDoubleTap_ON_OFF;
}
-(void)synchUserDefaultWithAppDataBeforeExit
{
    [[NSUserDefaults standardUserDefaults] setObject:self.arrayKeySpamMsg forKey:KEY_SPAM_MSG];
    [[NSUserDefaults standardUserDefaults] setObject:self.strWelcomeMsg forKey:KEY_WELCOME_MSG];
    [[NSUserDefaults standardUserDefaults] setObject:self.strFBSession forKey:KEY_FACEBOOK_SESSION];
    [[NSUserDefaults standardUserDefaults] setObject:self.strCommonLikes forKey:KEY_COMMON_LIKES];
    [[NSUserDefaults standardUserDefaults] setObject:self.arrayTemplateItems forKey:KEY_TEMPLATE_ITEMS];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.boolWelcomeMsg_ON_OFF?@"ON":@"OFF" forKey:ON_OFF_WELCOME_MSG];
    [[NSUserDefaults standardUserDefaults] setObject:self.boolLikes_ON_OFF?@"ON":@"OFF" forKey:ON_OFF_LIKES];
    [[NSUserDefaults standardUserDefaults] setObject:self.boolFacebook_ON_OFF?@"ON":@"OFF" forKey:ON_OFF_FACEBOOK];
    [[NSUserDefaults standardUserDefaults] setObject:self.boolReconnect_ON_OFF?@"ON":@"OFF" forKey:ON_OFF_RECONNECT];
    [[NSUserDefaults standardUserDefaults] setObject:self.boolDoubleTap_ON_OFF?@"ON":@"OFF" forKey:ON_OFF_DOUBLETAP];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)synchAppDataWithUserDefaultOnEnter
{
    self.arrayKeySpamMsg=(NSMutableArray*)[self.userDefaults objectForKey:KEY_SPAM_MSG];
    self.strWelcomeMsg=(NSString*)[self.userDefaults objectForKey:KEY_WELCOME_MSG];
    self.strFBSession=(NSString*)[self.userDefaults objectForKey:KEY_FACEBOOK_SESSION];
    self.strCommonLikes=(NSString*)[self.userDefaults objectForKey:KEY_COMMON_LIKES];
    self.arrayTemplateItems=(NSMutableArray*)[[self.userDefaults objectForKey:KEY_TEMPLATE_ITEMS] mutableCopy];
    
    self.boolWelcomeMsg_ON_OFF=[[self.userDefaults objectForKey:ON_OFF_WELCOME_MSG] isEqualToString:@"ON"]?TRUE:FALSE;
    self.boolLikes_ON_OFF=[[self.userDefaults objectForKey:ON_OFF_LIKES] isEqualToString:@"ON"]?TRUE:FALSE;
    self.boolFacebook_ON_OFF=[[self.userDefaults objectForKey:ON_OFF_FACEBOOK] isEqualToString:@"ON"]?TRUE:FALSE;
    self.boolReconnect_ON_OFF=[[self.userDefaults objectForKey:ON_OFF_RECONNECT] isEqualToString:@"ON"]?TRUE:FALSE;
    
}
@end
