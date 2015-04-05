//
//  StatisticsView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 03/04/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "StatisticsView.h"
#import "AppMacros.h"
@interface StatisticsView()
{
    UITableView *tableStatistics;
    NSMutableArray *arrayStatistics;
}
@end
@implementation StatisticsView
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
    [self setTitle:@"Current Statistics"];
    
    tableStatistics=[[UITableView alloc] initWithFrame:CGRectMake(0,20,self.contentContainer.frame.size.width,self.contentContainer.frame.size.height-60)];
    tableStatistics.backgroundColor=[UIColor whiteColor];
    tableStatistics.dataSource=self;
    tableStatistics.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableStatistics.delegate=self;
    [self.contentContainer addSubview:tableStatistics];
    
    UIButton *sendBtn=[[UIButton alloc] initWithFrame:CGRectMake((self.contentContainer.frame.size.width/3), self.contentContainer.frame.size.height-45, 150, 40)];
    sendBtn.backgroundColor=BLUE_COLOR_THEME;
    [sendBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [sendBtn setTitle:@"Reset" forState:UIControlStateSelected];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.layer.borderColor=UIColorFromRGB(0x3A3D41).CGColor;
    sendBtn.layer.borderWidth=1;
    [sendBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [sendBtn addTarget:self action:@selector(clickReset) forControlEvents:UIControlEventTouchUpInside];
    [self.contentContainer addSubview:sendBtn];
    
    [self loadStatistics];
}
-(void)clickReset
{
    UIAlertView *resetAlert=[[UIAlertView alloc] initWithTitle:@"RHB OSK" message:@"Statistics count will not be undone.It will start from zero.Do you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    resetAlert.tag = 32;
    
    resetAlert.delegate=self;
    
    [resetAlert show];
}
-(void)loadStatistics
{
    if(arrayStatistics==nil)
        arrayStatistics = [[NSMutableArray alloc]init];
    
//   arrayStatistics=
    [tableStatistics reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==32 && buttonIndex==1)
    {
        //save reset values
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        cell.backgroundView=nil;
        cell.selectedBackgroundView=nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds=YES;
        
        self.clipsToBounds = YES;
        
        UILabel *lbl_Key =[[UILabel alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width/2,50)];
        lbl_Key.textColor=[UIColor blackColor];
        lbl_Key.backgroundColor=[UIColor whiteColor];
        lbl_Key.font=[UIFont fontWithName:@"Helvetica" size:15];
        lbl_Key.textAlignment = NSTextAlignmentCenter;
        lbl_Key.tag=1;
        [cell addSubview:lbl_Key];
        
        UILabel *lbl_Val =[[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2,0,tableView.frame.size.width/2,50)];
        lbl_Val.textColor=[UIColor blackColor];
        lbl_Val.backgroundColor=[UIColor whiteColor];
        lbl_Val.font=[UIFont fontWithName:@"Helvetica" size:15];
        lbl_Val.textAlignment = NSTextAlignmentCenter;
        lbl_Val.tag=2;
        [cell addSubview:lbl_Val];
    }
    
    //    if(indexPath.row%2==0)
    //        cell.backgroundColor=[UIColor whiteColor];
    //    else
    cell.backgroundColor=[UIColor orangeColor];
    
    ((UILabel *)[cell viewWithTag:1]).text=@"key";
        ((UILabel *)[cell viewWithTag:2]).text=@"key";
    
    
    return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrayStatistics !=nil)
        return arrayStatistics.count;
    else
        return 0;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
