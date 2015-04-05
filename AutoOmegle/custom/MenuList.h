//
//  MenuList.h
//  FBMenuStyleNavigation
//
//  Created by Kishorekumar Kirubakaran on 07/12/13.
//  Copyright (c) 2013 Kishorekumar Kirubakaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuList : NSObject

@property (nonatomic,retain) NSMutableArray* menuItems;
@property (nonatomic,retain) NSMutableArray* menuImages;
@property (nonatomic,retain) NSMutableArray* viewControllers;
@property (nonatomic,retain) NSMutableArray* viewKeys;
@property (nonatomic,retain) NSString * title;

@end
