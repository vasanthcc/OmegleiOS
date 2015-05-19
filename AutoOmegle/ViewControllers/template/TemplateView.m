//
//  TemplateView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "TemplateView.h"
#import "AppMacros.h"
#import "CCAlertView.h"
#import "OmegleTextBox.h"
#import "AppData.h"
@interface TemplateView()
{
    UITableView *tableTemplateItems;
    NSMutableArray *arrayTemplateItems;
    CCAlertView *alertAddItems;
    OmegleTextBox *txtItem;
    UILabel *lbl_Msg;
}
@end
@implementation TemplateView
- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithRefresh:NO withSearch:NO andAdd:NO];
        [self createView];
    }
    return self;
}
-(void)createView
{
    [self setTitle:@"Edit Templates"];
    [self setBackgroundColor:[UIColor orangeColor]];
    
    lbl_Msg =[[UILabel alloc] initWithFrame:CGRectMake(30,150,self.contentContainer.frame.size.width-60,80)];
    lbl_Msg.textColor=[UIColor darkGrayColor];
    lbl_Msg.backgroundColor=[UIColor whiteColor];
    lbl_Msg.text=@"No template messages available right now.Kindly create it for sending message from this list at the time of conversation with your stranger";
    lbl_Msg.numberOfLines=0;
    lbl_Msg.font=[UIFont fontWithName:@"Helvetica" size:14];
    lbl_Msg.textAlignment = NSTextAlignmentCenter;
    [self.contentContainer addSubview:lbl_Msg];
    [lbl_Msg setHidden:TRUE];
    
    
    tableTemplateItems = [[UITableView alloc] initWithFrame:CGRectMake(10,10,self.contentContainer.frame.size.width-20,self.contentContainer.frame.size.height-70)];
    tableTemplateItems.backgroundColor = [UIColor whiteColor];
    tableTemplateItems.separatorColor = [UIColor blackColor];
    tableTemplateItems.delegate=self;
    tableTemplateItems.dataSource=self;
    tableTemplateItems.editing=YES;
    tableTemplateItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentContainer addSubview:tableTemplateItems];
    
    UIButton *btnAdd=[UIButton buttonWithType:UIButtonTypeCustom ];
    btnAdd.frame=CGRectMake(self.contentContainer.frame.size.width/3,self.contentContainer.frame.size.height-50,130,40);
    [btnAdd setTitle:@"Add Items" forState:UIControlStateNormal];
    [btnAdd setTitle:@"Add Items" forState:UIControlStateSelected];
    [btnAdd addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnAdd.backgroundColor=[UIColor orangeColor];
    btnAdd.titleLabel.backgroundColor=[UIColor clearColor];
    btnAdd.imageView.backgroundColor=[UIColor clearColor];
    [self.contentContainer addSubview:btnAdd];
    
}
-(void)showing
{
    [super showing];
    
    [self loadTemplateTable];
}
-(void)loadTemplateTable
{
if(arrayTemplateItems == nil)
    arrayTemplateItems = [[NSMutableArray alloc]init];
    
    arrayTemplateItems = [AppData getAppData].arrayTemplateItems;
    
    if(arrayTemplateItems !=nil && [arrayTemplateItems count]!=0)
    {
    [tableTemplateItems reloadData];
        
        [lbl_Msg setHidden:TRUE];
    [tableTemplateItems setHidden:FALSE];
    }
    else
    {
         [lbl_Msg setHidden:FALSE];
        [tableTemplateItems setHidden:TRUE];
    }
    
}
-(void)clickAdd
{
    if(alertAddItems==nil)
    {
    [self showAddPopUp];
    }
    else
    {
    [alertAddItems showInView:self];
    [txtItem becomeFirstResponder];
    }
    
}
-(void)showAddPopUp
{
    UIView *containerPopUp = [[UIView alloc]initWithFrame:CGRectMake(30, 0, self.contentContainer.frame.size.width-60, self.contentContainer.frame.size.height-300)];
    containerPopUp.backgroundColor=[UIColor whiteColor];
    
    txtItem=[[OmegleTextBox alloc] initWithFrame:CGRectMake(10,10,containerPopUp.frame.size.width-20, 30)];
    
    txtItem.returnKeyType=UIReturnKeyDone;
    txtItem.backgroundColor=[UIColor whiteColor];
    txtItem.font=[UIFont fontWithName:@"Helvetica" size:13];
    txtItem.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtItem.delegate=self;
    txtItem.borderStyle=UITextBorderStyleNone;
    txtItem.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [txtItem addTarget:self action:@selector(doneWithTextField) forControlEvents:UIControlEventEditingDidEndOnExit];
    [containerPopUp addSubview:txtItem];
    
    
    UIButton *btnSubmit=[UIButton buttonWithType:UIButtonTypeCustom ];
    btnSubmit.frame=CGRectMake((containerPopUp.frame.size.width/2)+20,
                               txtItem.frame.origin.y+txtItem.frame.size.height+10,
                               (containerPopUp.frame.size.width/2)-40,40);
    [btnSubmit setTitle:@"Add" forState:UIControlStateNormal];
    [btnSubmit setTitle:@"Add" forState:UIControlStateSelected];
    [btnSubmit addTarget:self action:@selector(proceedWithAdd) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnSubmit.backgroundColor=BLUE_COLOR_THEME;
    btnSubmit.titleLabel.backgroundColor=[UIColor clearColor];
    btnSubmit.imageView.backgroundColor=[UIColor clearColor];
    
    [containerPopUp addSubview:btnSubmit];
    
    alertAddItems=[[CCAlertView alloc] initWithTitle:@"Add Item" withButtontitle:nil withContentView:containerPopUp withDelegate:self];

    [alertAddItems showInView:self];
        [txtItem becomeFirstResponder];
}
-(void)doneWithTextField
{
    [txtItem resignFirstResponder];
}
-(void)ccAlertView:(CCAlertView *)alertView clickedButton:(UIButton *)button
{
    [alertView hideView];
}
-(void)proceedWithAdd
{
    if([txtItem.text isEqualToString:@""])
    {
        [self showErrorAlertWithMessage:@"Items should not be empty.Please enter any template message"];
    }
    else
    {
        [lbl_Msg setHidden:TRUE];
        [tableTemplateItems setHidden:FALSE];
        
    [alertAddItems hideView];
    if(arrayTemplateItems ==nil)
        arrayTemplateItems = [[NSMutableArray alloc]init];
    
    [arrayTemplateItems insertObject:txtItem.text atIndex:0];
    [tableTemplateItems reloadData];
    [self doSynchWithDB];
    txtItem.text=@"";
    }
}
-(void)doSynchWithDB
{

//    [[AppData getAppData] saveTemplateItems:arrayTemplateItems];
        if(arrayTemplateItems != nil)
        [AppData getAppData].arrayTemplateItems =[[NSMutableArray alloc] initWithArray:arrayTemplateItems];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    cell.backgroundColor =  [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        cell.frame=CGRectMake(0, 0, tableTemplateItems.frame.size.width, 40);
        cell.backgroundView=nil;
        cell.tag=10;
        cell.selectedBackgroundView=nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor=[UIColor grayColor];
        
        UIView *lineSep=[[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        lineSep.backgroundColor=UIColorFromARGB(0X35FFFFFF);
        [cell addSubview:lineSep];
    }
    
    cell.textLabel.text = [arrayTemplateItems objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines=0;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrayTemplateItems count] > 0)
        return [arrayTemplateItems count];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([arrayTemplateItems count] != 0)
    {
        NSLog(@"indexPath.row : %ld",(long)indexPath.row);
        [arrayTemplateItems removeObjectAtIndex:indexPath.row];
        [tableTemplateItems reloadData];
        [self doSynchWithDB];
        
        if(arrayTemplateItems.count==0)
        {
            [lbl_Msg setHidden:FALSE];
        [tableTemplateItems setHidden:TRUE];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

@end
