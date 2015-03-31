//
//  MenuView.h
//  FBMenuStyleNavigation
//
//  Created by Kishorekumar Kirubakaran on 07/12/13.
//  Copyright (c) 2013 Kishorekumar Kirubakaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property  id delegate;
+(MenuView*) getMenuView;
-(void) selectMenuItem:(NSString*) menuKey;
@end
