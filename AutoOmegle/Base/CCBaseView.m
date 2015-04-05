//
//  CCBaseView.m
//  CC
//
//  Created by Vasanth Ravichandran on 12/12/14.
//  Copyright (c) 2014 Vasanth Ravichandran. All rights reserved.
//

#import "CCBaseView.h"
#import "CCBaseViewController.h"
#import "MenuView.h"
#import "AppMacros.h"
#import "AppDelegate.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

#define IMG_REFRESH @"refresh"
#define IMG_SEARCH @"search"
#define IMG_ADD @"add"
#define IMG_BACK @"back"
#define IMG_MENU @"menu"

#define SCREEN_FRAME [[UIScreen mainScreen] bounds]
#define iOS7orAbove ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define StatusBarHeight 20
#define HEADER_HEIGHT 40


@interface CCBaseView ()
{
    MenuView *menuView;
    UIButton *refreshBtn;
    UIButton *searchBtn;
    UIButton *addBtn;
    UIButton *backBtn;
    UIButton *menuBtn;
    BOOL showMenu;
    NSString *menuViewIdentifier;
        NSMutableDictionary *dictSector,*dictBroker;
}
@property UIButton* mail;
@property UIButton* message;
@property UIButton* facebookBtn;
@end


@implementation CCBaseView

@synthesize headerContainer,contentContainer;

-(id) initWithFrame:(CGRect)frame
{
    self=[self initWithFrame:frame withHeader:NO withMenu:NO];
    return self;
}

- (id)initWithFrame:(CGRect)frame withHeader:(BOOL) hasHeader withMenu:(BOOL) hasMenu
{
    self = [super initWithFrame:frame];
    if (self) {
        if(CGRectEqualToRect(frame, SCREEN_FRAME))
        {
            self.baseContentView.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height-(iOS7orAbove?0:20));
        }
        else
        {
            self.baseContentView.frame=frame;
        }
        self.baseContentView.clipsToBounds=YES;
        
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [self.baseContentView addSubview:loadingView];
        
        
        if(hasHeader)
        {
            UIImage *menuImg=[UIImage imageNamed:IMG_MENU];
            UIImage *back_Img=[UIImage imageNamed:IMG_BACK];
            
            headerContainer=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.baseContentView.frame.size.width,HEADER_HEIGHT+(iOS7orAbove?20:0))];
            headerContainer.backgroundColor=BLUE_COLOR_THEME;
            headerContainer.layer.shadowColor=[UIColor blackColor].CGColor;
            headerContainer.layer.shadowOffset=CGSizeMake(0, 5);
            headerContainer.layer.shadowRadius=5;
            headerContainer.layer.shadowOpacity=0.3;
            headerContainer.clipsToBounds=NO;
            headerContainer.layer.masksToBounds=NO;
            [self.baseContentView addSubview:headerContainer];
            
            
            
            lbl=[[UILabel alloc] initWithFrame:CGRectMake(menuImg.size.width+20,(iOS7orAbove?StatusBarHeight:0),headerContainer.frame.size.width-menuImg.size.width-20,headerContainer.frame.size.height-((iOS7orAbove?StatusBarHeight:0)))];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.textColor=[UIColor whiteColor];
            lbl.textAlignment=NSTextAlignmentLeft;
            lbl.font=[UIFont fontWithName:@"Helvetica" size:15];
            [headerContainer addSubview:lbl];
            
            
            
            [headerContainer addSubview:loadingView];
            loadingView.center=CGPointMake(headerContainer.frame.size.width-30,(headerContainer.frame.size.height+(iOS7orAbove?20:0))/2);
            loadingView.transform = CGAffineTransformIdentity;
            
            if(hasMenu)
                [self createMenu];

            
            contentContainer=[[UIView alloc] initWithFrame:CGRectMake(0, headerContainer.frame.size.height, self.baseContentView.frame.size.width, self.baseContentView.frame.size.height-headerContainer.frame.size.height)];
            contentContainer.backgroundColor=[UIColor whiteColor];
            [self.baseContentView addSubview:contentContainer];
            
            [self.baseContentView bringSubviewToFront:headerContainer];
            [self.baseContentView sendSubviewToBack:contentContainer];
            
        }
        
    }
    return self;
}
#pragma mark showing & hiding
-(void)showing
{
    // [self clearMemory];
    [super showing];
    NAVIGATION_SCENARIOS navigationType=[(CCBaseViewController*)self.viewControllerDelegate navigationType] ;
    if([self respondsToSelector:@selector(reloadData:)]&& ((navigationType!=NAVIGATION_BACK) && navigationType!=NAVIGATION_APPBECOMEACTIVE))
    {
        [self reloadData:NO];
        
    }
    if(showMenu && navigationType!=NAVIGATION_APPBECOMEACTIVE)
        [self setMenuView];
    
}
-(void) setMenuViewIdentifier:(NSString *)menuViewIdentifierToSet
{
    menuViewIdentifier=menuViewIdentifierToSet;
    if(showMenu)
    {
        [self setMenuView];
        
    }
}
-(void) hideMenu
{
    showMenu=FALSE;
    [menuBtn removeFromSuperview];
}
-(void) hiding
{
    [super hiding];
    [(CCBaseViewController*)self.viewControllerDelegate setNavigationType:NAVIGATION_BACK];
}
#pragma  mark  Menu & Header Helper Methods

-(void) setTitle :(NSString *) title
{
    lbl.text=title;
}
-(void) createMenu
{
    UIImage *menuImg=[UIImage imageNamed:IMG_MENU];
    menuBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,(iOS7orAbove?StatusBarHeight:0),menuImg.size.width,lbl.frame.size.height)] ;
    
    menuBtn.showsTouchWhenHighlighted=YES;
    [menuBtn setBackgroundImage:menuImg forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:menuImg forState:UIControlStateSelected];
    
    [menuBtn addTarget:self action:@selector(selectedMenu) forControlEvents:UIControlEventTouchUpInside];
    [headerContainer addSubview:menuBtn];
    showMenu=YES;
    
}
-(void) setMenuView
{
    
    menuView=[MenuView getMenuView];

    
    menuView.frame=CGRectMake(-self.frame.size.width/2,0,self.frame.size.width/2,self.frame.size.height);

    [self addSubview: menuView];
    
    [self sendSubviewToBack:menuView];
    menuView.delegate=[self getViewControllerToNavigate];
    if(menuViewIdentifier)
    {
        [menuView selectMenuItem:menuViewIdentifier];
    }
    else
        [menuView selectMenuItem:NSStringFromClass([self class])];
    
    
}


-(void) selectedMenu
{
    
    [self showOrHideMenuView];
    
}

-(void) showHeaderWithRefresh:(BOOL) hasRefresh withSearch:(BOOL) hasSearch andAdd:(BOOL) hasAdd
{
    [self showHeaderWithRefresh:hasRefresh withSearch:hasSearch andAdd:hasAdd allowsBack:NO];
}

-(void) showHeaderWithRefresh:(BOOL) hasRefresh withSearch:(BOOL) hasSearch andAdd:(BOOL) hasAdd allowsBack:(BOOL) hasBack
{
    CGFloat x=self.frame.size.width;
    CGFloat y=(iOS7orAbove? StatusBarHeight: 0);
    if(hasRefresh)
    {
        UIImage *refresh_Img=[UIImage imageNamed:IMG_REFRESH];
        x=self.frame.size.width-(refresh_Img.size.width+5);
        if(!refreshBtn)
        {
            refreshBtn=[[UIButton alloc] initWithFrame:CGRectMake(x,(iOS7orAbove? StatusBarHeight: 0)+(HEADER_HEIGHT-30)/2, refresh_Img.size.width,30)];
            [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            
            refreshBtn.showsTouchWhenHighlighted=YES;
            [refreshBtn setBackgroundImage:refresh_Img forState:UIControlStateNormal];
            [refreshBtn setBackgroundImage:refresh_Img forState:UIControlStateSelected];
            
            [headerContainer addSubview: refreshBtn];
        }
        else
        {
            refreshBtn.frame=CGRectMake(x,(iOS7orAbove? StatusBarHeight: 0)+(HEADER_HEIGHT-30)/2, refresh_Img.size.width,30) ;
        }
        
    }
    if(hasSearch)
    {
        
        UIImage *info_Src=[UIImage imageNamed:IMG_SEARCH];
        x-=info_Src.size.width+5;
        if(!searchBtn)
        {
            searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, info_Src.size.width, headerContainer.frame.size.height-y)];
            [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            menuBtn.showsTouchWhenHighlighted=YES;
            [searchBtn setBackgroundImage:info_Src forState:UIControlStateNormal];
            [searchBtn setBackgroundImage:info_Src forState:UIControlStateSelected];
            [headerContainer addSubview: searchBtn];
        }
        else
        {
            searchBtn.frame=CGRectMake(x, y, info_Src.size.width, headerContainer.frame.size.height-y);
        }
        
    }
    if(hasAdd)
    {
        UIImage *add_Img=[UIImage imageNamed:IMG_ADD];
        x-=add_Img.size.width+5;
        if(!addBtn)
        {
            addBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, add_Img.size.width, headerContainer.frame.size.height-y)];
            [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];

            addBtn.showsTouchWhenHighlighted=YES;
            [addBtn setBackgroundImage:add_Img forState:UIControlStateNormal];
            [addBtn setBackgroundImage:add_Img forState:UIControlStateSelected];
            [headerContainer addSubview: addBtn];
        }
        else
        {
            addBtn.frame=CGRectMake(x, y, add_Img.size.width, headerContainer.frame.size.height-y);
        }
    }
    
    if(hasBack & !backBtn)
    {
        UIImage *back_Img=[UIImage imageNamed:IMG_BACK];
        backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, y, back_Img.size.width, headerContainer.frame.size.height-y)];
        [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        backBtn.backgroundColor=[UIColor clearColor];
        
        backBtn.showsTouchWhenHighlighted=YES;
        [backBtn setBackgroundImage:back_Img forState:UIControlStateNormal];
        [backBtn setBackgroundImage:back_Img forState:UIControlStateSelected];
        
        [headerContainer addSubview: backBtn];
        if(showMenu)
        {
            menuBtn.frame=CGRectMake(backBtn.frame.size.width+backBtn.frame.origin.x+5, y, menuBtn.frame.size.width, menuBtn.frame.size.height);
        }
        
    }
    
    
    refreshBtn.hidden=!hasRefresh;
    addBtn.hidden=!hasAdd;
    searchBtn.hidden=!hasSearch;
    backBtn.hidden=!hasBack;
    loadingView.center=CGPointMake(x-15,(headerContainer.frame.size.height+(iOS7orAbove?20:0))/2);
}


-(void) backBtnClicked
{
    [self backBtnClicked:YES];
}

-(void) backBtnClicked:(BOOL)animated
{
    [[(CCBaseViewController*)self.viewControllerDelegate navigationController] popViewControllerAnimated:animated];
    
}

-(void)decideOnShowOrHideMenu:(UISwipeGestureRecognizer*)gesture
{
    if( gesture.direction==UISwipeGestureRecognizerDirectionRight)
    {
        if(menuView.frame.origin.x!=0)
            [self showOrHideMenuView];
        
    }
    else if(gesture.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        if(menuView.frame.origin.x==0)
            [self showOrHideMenuView];
    }
}

-(void) showOrHideMenuView
{
    if(iOS7orAbove)
    {
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [self changeMenuFrame];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self changeMenuFrame];
        }];
    }
}
-(void) changeMenuFrame
{
    if(menuView.frame.origin.x!=0)
    {
        menuView.frame=CGRectMake(0, 0,self.frame.size.width*2/3,self.frame.size.height);
        self.baseContentView.frame=CGRectMake(self.frame.size.width*2/3, self.baseContentView.frame.origin.y, self.frame.size.width, self.frame.size.height);
        contentContainer.userInteractionEnabled=NO;
    }
    else
    {
        menuView.frame=CGRectMake(-self.frame.size.width/2, 0,self.frame.size.width/2,self.frame.size.height);
        self.baseContentView.frame=CGRectMake(0, self.baseContentView.frame.origin.y, self.frame.size.width, self.frame.size.height);
        contentContainer.userInteractionEnabled=YES;
    }
    
}

#pragma mark Loading related methods

-(void) asyncBusy
{
    [loadingView startAnimating];
}
-(void) ready
{
    [refreshBtn.layer removeAllAnimations];
    if(loadingView.isAnimating)
    {
        [loadingView stopAnimating];
    }
    else
        [super ready];
}

#pragma mark info, add & refresh

-(void) refresh
{
    [self reloadData:NO];
}
-(void) searchBtnClicked
{
    
}
-(void) addBtnClicked
{
    
}
-(void)gotoThisViewController:(NSString*)strViewController
{
    CCBaseViewController *controllerToNavigate=[(CCBaseViewController*)self.viewControllerDelegate isPresentInNavigationStack:strViewController];
    
    if(!controllerToNavigate)
    {
        controllerToNavigate=[[NSClassFromString(strViewController) alloc] init];
        controllerToNavigate.navigationType=NAVIGATION_OTHERSCREEN;
        
        [((CCBaseViewController*)self.viewControllerDelegate).navigationController pushViewController:controllerToNavigate animated:NO];
    }
    else
    {
        [controllerToNavigate clearData];
        controllerToNavigate.navigationType=NAVIGATION_OTHERSCREEN;
        [((CCBaseViewController*)self.viewControllerDelegate).navigationController popToViewController:controllerToNavigate animated:NO];
    }
}
-(CCBaseViewController *)getViewControllerToNavigate
{
    if([self respondsToSelector:@selector(getAssociatedMainController)])
    {
        return [self performSelector:@selector(getAssociatedMainController) withObject:nil];
    }
    return self.viewControllerDelegate;
}

@end
