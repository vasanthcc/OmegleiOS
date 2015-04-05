//
//  AppData.h
//  OSK
//
//  Created by Vasanth Raviachandran on 29/11/13.
//  Copyright (c) 2013 Vasanth Raviachandran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject
@property (strong) NSUserDefaults *userDefaults;
+(AppData*)getAppData;

-(NSMutableArray*)getSpamArray;
-(NSString*)getWelcomeMessage;
-(NSString*)getFacebookSession;
-(NSString*)getCommonLikes;
-(NSMutableArray*)getTemplateItems;

-(void)saveSpamMessage:(NSString*)strSpamMessage;
-(void)saveWelcomeMessage:(NSString*)strWelMessage;
-(void)saveFacebookSession:(NSString*)strSession;
-(void)saveCommonLikes:(NSString*)strLikes;
-(void)saveTemplateItems:(NSMutableArray*)arrayItems;

-(BOOL)isWelcomeMessageOn;
-(BOOL)isLikesOn;
-(BOOL)isFacebookOn;
-(BOOL)isReconnectOn;
@end
