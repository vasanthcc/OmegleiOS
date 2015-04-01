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
//@synthesize arraySpamItems;
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
   return (NSMutableArray*)[self.userDefaults objectForKey:KEY_SPAM_MSG];
}
-(NSString*)getWelcomeMessage
{
   return (NSString*)[self.userDefaults objectForKey:KEY_WELCOME_MSG];
}
-(NSString*)getFacebookSession
{
    return (NSString*)[self.userDefaults objectForKey:KEY_FACEBOOK_SESSION];
}
-(void)saveSpamMessage:(NSString*)strSpamMessage
{
    NSMutableArray *arrayItems = (NSMutableArray*)[self.userDefaults objectForKey:KEY_SPAM_MSG];
    [arrayItems addObject:strSpamMessage];
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayItems forKey:KEY_SPAM_MSG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)saveWelcomeMessage:(NSString*)strMessage
{
    [[NSUserDefaults standardUserDefaults] setObject:strMessage forKey:KEY_WELCOME_MSG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)saveFacebookSession:(NSString*)strSession
{
    [[NSUserDefaults standardUserDefaults] setObject:strSession forKey:KEY_FACEBOOK_SESSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isWelcomeMessageOn
{
    return [[self.userDefaults objectForKey:ON_OFF_WELCOME_MSG] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isLikesOn
{
    return [[self.userDefaults objectForKey:ON_OFF_LIKES] isEqualToString:@"ON"]?TRUE:FALSE;
}
-(BOOL)isFacebookOn
{
    return [[self.userDefaults objectForKey:ON_OFF_FACEBOOK] isEqualToString:@"ON"]?TRUE:FALSE;
}
@end
