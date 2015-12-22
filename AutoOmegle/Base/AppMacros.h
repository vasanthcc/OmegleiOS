//
//  AppMacros.h
//  OSK
//
//  Created by Vasanth Ravichandran on 19/01/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#ifndef CC_AppMacros_h
#define CC_AppMacros_h

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

#pragma Colors
#define BLUE_COLOR_THEME UIColorFromRGB(0x288AFF)
#define RED_COLOR_THEME UIColorFromRGB(0xE92834)
#define GREEN_COLOR_THEME UIColorFromRGB(0x158B04)

#pragma  mark Common Size Keys
#define SCREEN_FRAME [[UIScreen mainScreen] bounds]
#define iOS7orAbove ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define StatusBarHeight 20
#define StatusBarOffset 25
#define HEADER_HEIGHT 40

#define HEADER_MSGBOX @"AUTO OMEGLE"

#pragma FONT
#define FONT_Helvetica @"Helvetica"
#define FONT_STATUS @"Avenir"
#define FONT_STATUS_BOLD @"Avenir-Bold"
#define FONT_MARION @"Marion"
#pragma Common Keys
#define KEY_SPAM_MSG @"keyspammessage"
#define KEY_WELCOME_MSG @"keywelcomemessage"
#define KEY_FACEBOOK_SESSION @"keyfacebooksession"
#define KEY_COMMON_LIKES @"keycommonlikes"
#define KEY_TEMPLATE_ITEMS @"keytemplateitems"

#define ON_OFF_WELCOME_MSG @"welcomeMsgOnOFF"
#define ON_OFF_LIKES @"likesOnOFF"
#define ON_OFF_FACEBOOK @"facebookOnOFF"
#define ON_OFF_RECONNECT @"reconnectOnOFF"
#define ON_OFF_DOUBLETAP @"doubletapOnOFF"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromARGB(argbValue) [UIColor \
colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((argbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(argbValue & 0xFF))/255.0 \
alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

#define isViewInScreen(v) CGRectContainsRect([[Screen getCurrentScreenBounds] mainScreen] bounds], v.frame)

#define RGBFromUIColor(color) FloatsToHex(CGColorGetComponents([color CGColor]))

#define InvertColor(color) UIColorFromARGB(FloatsToHex(Invert(CGColorGetComponents([color CGColor]))))

#endif
