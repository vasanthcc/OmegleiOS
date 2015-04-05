//
//  ChatLogsView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 16/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "ChatLogsView.h"
#import "AppMacros.h"
@interface ChatLogsView()
{
    UISegmentedControl *segmentLogs;
    UITableView *tableSavedLogs;
    NSMutableArray *arraySavedLogs;
    int selectedIndex;
}
@end
@implementation ChatLogsView
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
    
    segmentLogs = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Saved Logs",@"Public Logs",nil]];
    segmentLogs.frame = CGRectMake(0,5,self.contentContainer.frame.size.width,40);
    [segmentLogs setSelectedSegmentIndex:0];
    [segmentLogs setBackgroundColor:[UIColor whiteColor]];
    [segmentLogs addTarget:self action:@selector(changeTab) forControlEvents: UIControlEventValueChanged];
    [self.contentContainer addSubview:segmentLogs];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor grayColor]}forState:UIControlStateNormal];
    
    selectedIndex = -1;
    
    tableSavedLogs=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.contentContainer.frame.size.width,self.contentContainer.frame.size.height-segmentLogs.frame.size.height-5)];
    tableSavedLogs.backgroundColor=[UIColor whiteColor];
    tableSavedLogs.dataSource=self;
    tableSavedLogs.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableSavedLogs.delegate=self;
    [self.contentContainer addSubview:tableSavedLogs];

    [self changeTab];
}
-(void)changeTab
{
    //[[[segmentBuySell subviews] objectAtIndex:0] setTintColor:nil];
    //[[[segmentBuySell subviews] objectAtIndex:1] setTintColor:nil];
    if(arraySavedLogs == nil)
        arraySavedLogs = [[NSMutableArray alloc]initWithObjects:@"remya",@"raju",@"US",@"canada",@"had fun", nil];
    
    
    if(segmentLogs.selectedSegmentIndex == 0)
    {
    //arraySavedLogs =
    }
    else
    {
    //arraySavedLogs =
    }
    
    [tableSavedLogs reloadData];
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
        
        UILabel *lbl_Header =[[UILabel alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width-40,50)];
        lbl_Header.textColor=[UIColor blackColor];
        lbl_Header.backgroundColor=[UIColor whiteColor];
        lbl_Header.font=[UIFont fontWithName:@"Helvetica" size:15];
        lbl_Header.textAlignment = NSTextAlignmentCenter;
        lbl_Header.tag=1;
        [cell addSubview:lbl_Header];
        
        UIImageView *imageDetailArrow=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-40,2, 40,30)];
        imageDetailArrow.image=[UIImage imageNamed:@"downarrow"];
        imageDetailArrow.contentMode=UIViewContentModeCenter;
        imageDetailArrow.clipsToBounds=YES;
        imageDetailArrow.tag=3;
        [cell addSubview:imageDetailArrow];
        
    }
    
//    if(indexPath.row%2==0)
//        cell.backgroundColor=[UIColor whiteColor];
//    else
        cell.backgroundColor=[UIColor orangeColor];
    
    ((UILabel *)[cell viewWithTag:1]).text=[arraySavedLogs objectAtIndex:indexPath.row];
    
    
    return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == selectedIndex)
    {
        return 250;
    }
    else
        return 50;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arraySavedLogs !=nil)
        return arraySavedLogs.count;
    else
        return 0;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = [indexPath row]==selectedIndex?-1:[indexPath row];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
@end