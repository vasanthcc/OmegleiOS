//
//  OSKBaseView.h
//  OSK
//
//  Created by Vasanth Ravichandran on 12/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "BaseView.h"


@interface CCBaseView : BaseView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIActivityIndicatorView *loadingView;
    UILabel *lbl;
}

@property (strong) UIView *headerContainer;
@property (strong) UIView *contentContainer;


- (id)initWithFrame:(CGRect)frame withHeader:(BOOL) hasHeader withMenu:(BOOL) hasMenu;
-(void) setTitle :(NSString *) title;
-(void) asyncBusy;
-(void) refresh;
-(void) reloadData:(BOOL) alwaysFetchFromServer;
-(void) addBtnClicked;
-(void) searchBtnClicked;
-(void) backBtnClicked:(BOOL) animated;
-(void) showToast:(NSString*) message;
-(void) showing;
-(void) showOrHideMenuView;
-(void) showHeaderWithRefresh:(BOOL) hasRefresh withSearch:(BOOL) hasSearch andAdd:(BOOL) hasAdd;
-(void) showHeaderWithRefresh:(BOOL) hasRefresh withSearch:(BOOL) hasSearch andAdd:(BOOL) hasAdd allowsBack:(BOOL) hasBack;
-(void) logOutRequest;
-(void) setMenuViewIdentifier:(NSString*)identifier;
-(void)gotoThisViewController:(NSString*)strViewController;
-(void) createMenu;
-(void) hideMenu;
@end
