//
//  MenuView.m
//  FBMenuStyleNavigation
//
//  Created by Kishorekumar Kirubakaran on 07/12/13.
//  Copyright (c) 2013 Kishorekumar Kirubakaran. All rights reserved.
//

#import "MenuView.h"
#import "CCBaseViewController.h"
#import "MenuList.h"
#import "CCBaseView.h"
#import "AppMacros.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
static MenuView *menuView;

@interface MenuView ()
{
    UITableView *menuTable;
}
@property (strong) NSMutableArray * items;
@property UIButton* mail;
@property UIButton* message;
@property UIView* content;

@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(MenuView*) getMenuView
{
    if(!menuView)
    {
        menuView=[[MenuView alloc] init];
        menuView.backgroundColor=[UIColor whiteColor];//UIColorFromRGB(0x741421);
        menuView.autoresizesSubviews=YES;
        
    }
    return menuView;
}


- (id)init
{
    self = [super init];
    if (self) {
        CGRect frame= [[UIScreen  mainScreen] bounds];
        
        UIView *menuImgContainer=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,HEADER_HEIGHT+(iOS7orAbove?20:0))];
        menuImgContainer.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        menuImgContainer.backgroundColor=[UIColor orangeColor];
        
        [self addSubview:menuImgContainer];
        
        UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(10,8,140,HEADER_HEIGHT+(iOS7orAbove?20:0))];
        lblHeader.text=@"AUTO OMEGLE";
        lblHeader.backgroundColor=[UIColor clearColor];
        lblHeader.textColor=[UIColor whiteColor];
        lblHeader.textAlignment = NSTextAlignmentLeft;
        lblHeader.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        [menuImgContainer addSubview:lblHeader];
        
        
        CGFloat y=lblHeader.frame.size.height+lblHeader.frame.origin.y;
        
        menuTable=[[UITableView alloc] initWithFrame:CGRectMake(0,y,self.frame.size.width,frame.size.height-y-20) style:UITableViewStylePlain];
        menuTable.delegate=self;
        menuTable.dataSource=self;
        menuTable.backgroundColor=[UIColor clearColor];
        menuTable.separatorColor=[UIColor blackColor];//UIColorFromRGB(0x7C2328);
        menuTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        menuTable.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        //menuTable.scrollEnabled=NO;
        
        [self addSubview:menuTable];
        
        self.items=[[NSMutableArray alloc] init];
        [self createInputForTable];
        
        
    }
    return self;
}
-(void) createInputForTable
{
    
    MenuList *mainMenuList=[[MenuList alloc] init];
    mainMenuList.menuItems=[[NSMutableArray alloc] initWithObjects:@"Chat",@"Edit Templates",@"Settings",@"Boring",@"Statistics",@"Chat Logs",@"Share to Friends",@"Issues/Suggestions",nil];
    
    mainMenuList.menuImages=[[NSMutableArray alloc] initWithObjects:@"chatting",@"edittemplate",@"chatsettings",@"boring",@"statistics",@"chatlogs",@"sharing",@"mailing",nil];
    
    mainMenuList.viewControllers=[[NSMutableArray alloc] initWithObjects:@"ChatHomeViewController",@"TemplateViewController",@"SettingsViewController",@"BoringViewController",@"StatisticsViewController",@"ChatLogsViewController",@"ShareViewController",@"SuggestionViewController",nil];
    
    mainMenuList.title=@"MainMenu";
    
    mainMenuList.viewKeys=[[NSMutableArray alloc] initWithObjects:@"ChatHomeView",@"TemplateView",@"SettingsView",@"BoringView",@"StatisticsView",@"ChatLogsView",@"ShareView",@"SuggestionView",nil];
    
    [self.items addObject:mainMenuList];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}


-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[(MenuList*)[self.items objectAtIndex:section] menuItems] count];
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section!=0)
    {
        MenuList *menuList=[self.items objectAtIndex:section];
        
        UILabel *sectionHeaderLbl=[[UILabel alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,40)];
        sectionHeaderLbl.text=[NSString stringWithFormat:@" %@",menuList.title];
        sectionHeaderLbl.backgroundColor=ORANGE_COLOR_THEME;//UIColorFromRGB(0x222222);
        sectionHeaderLbl.textColor=[UIColor whiteColor];
        sectionHeaderLbl.font=[UIFont fontWithName:@"Helvetica" size:14];
        
        return sectionHeaderLbl;
    }
    return  nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section!=0)
    {
        return 50;
    }
    return 0;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GHMenuCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *selectedBgView=[[UIView alloc] init];
        selectedBgView.backgroundColor=BLUE_COLOR_THEME;
        cell.selectedBackgroundView=selectedBgView;
        
        selectedBgView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        selectedBgView.layer.shadowOffset = CGSizeMake(-5.0f, 0.0f);
        selectedBgView.layer.shadowOpacity = 0.4;
        selectedBgView.layer.shadowRadius = 5.0f;
        selectedBgView.clipsToBounds = NO;
        selectedBgView.layer.masksToBounds = NO;
        
        cell.selectedTextColor=[UIColor whiteColor];
        
    }
    
    MenuList *menuList=[self.items objectAtIndex:indexPath.section];
	cell.textLabel.text =[NSString stringWithFormat:@"%@",menuList.menuItems[indexPath.row]];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.imageView.image=[UIImage imageNamed:menuList.menuImages[indexPath.row]];
    
    
   [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
    
}
-(void) reloadMenu
{
    [self.items removeAllObjects];
    [self createInputForTable];
    [menuTable reloadData];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *baseController=(BaseViewController*)self.delegate;
    [(CCBaseView*)baseController.view showOrHideMenuView];
    
    [self performSelector:@selector(navigateToView:) withObject:indexPath afterDelay:0.5];
    
}

-(void) navigateToView:(NSIndexPath *) indexPath
{
    MenuList *menuList=[self.items objectAtIndex:indexPath.section];
    NSString *strSelectedController = menuList.viewControllers[indexPath.row];
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:menuList.viewKeys[indexPath.row]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    CCBaseViewController *baseController=(CCBaseViewController*)self.delegate;
    
    CCBaseViewController *controllerToNavigate=[baseController isPresentInNavigationStack:strSelectedController];
    
    if(!controllerToNavigate)
    {
        controllerToNavigate=[[NSClassFromString(strSelectedController) alloc] init];
        controllerToNavigate.screenID=menuList.viewKeys[indexPath.row];
        controllerToNavigate.navigationType=NAVIGATION_MENU;
        [((CCBaseViewController*)self.delegate).navigationController pushViewController:controllerToNavigate animated:NO];
    }
    else
    {
        [controllerToNavigate clearData];
        controllerToNavigate.screenID=menuList.viewKeys[indexPath.row];
        controllerToNavigate.navigationType=NAVIGATION_MENU;
        
        if([[[baseController navigationController] topViewController] isEqual:controllerToNavigate])
        {
            [controllerToNavigate viewWillAppear:NO];
            
        }
        [((CCBaseViewController*)self.delegate).navigationController popToViewController:controllerToNavigate animated:NO];
    }
}

-(void) selectMenuItem:(NSString*) menuKey
{
    NSIndexPath *indexPath;
    for (MenuList* list in self.items) {
        if([list.viewKeys indexOfObject:menuKey]!=NSNotFound)
        {
            indexPath=[NSIndexPath indexPathForRow:[list.viewKeys indexOfObject:menuKey]
                                         inSection:[self.items indexOfObject:list]];
            
        }
    }
    if(indexPath)
        [menuTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

-(void)showErrorAlert:(NSString *) message buttonTitle:(NSString *) btnTitle
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:HEADER_MSGBOX message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles: nil];
    [alertView show];
    
}




@end
