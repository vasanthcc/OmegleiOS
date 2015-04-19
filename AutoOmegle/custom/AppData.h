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

@property (strong) NSMutableArray *arrayKeySpamMsg;
@property (strong) NSString *strWelcomeMsg;
@property (strong) NSString *strFBSession;
@property (strong) NSString *strCommonLikes;
@property (strong) NSMutableArray *arrayTemplateItems;
@property BOOL boolWelcomeMsg_ON_OFF;
@property BOOL boolLikes_ON_OFF;
@property BOOL boolFacebook_ON_OFF;
@property BOOL boolReconnect_ON_OFF;

+(AppData*)getAppData;

-(void)saveDatabaseBeforeExit;
-(void)synchDatabaseOnEnter;

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
