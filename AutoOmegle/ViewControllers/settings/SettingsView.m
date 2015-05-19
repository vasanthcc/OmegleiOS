//
//  SettingsView.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 16/03/15.
//  Copyright (c) 2015 cc. All rights reserved.
//

#import "SettingsView.h"
#import "AppMacros.h"
@interface SettingsView()
{
    UISwitch *switchScreenON,*switchDoubleTapON,*switchConfirmationON;//switchDisconnectByRules
    
    UISwitch *switchMessageWithCondition;
}
@end
@implementation SettingsView
- (id)initWithFrame:(CGRect)frame withHeader:(BOOL)hasHeader withMenu:(BOOL)hasMenu
{
    self = [super initWithFrame:frame withHeader:hasHeader withMenu:hasMenu];
    if (self)
    {
        [self showHeaderWithRefresh:NO withSearch:NO andAdd:NO];
        [self setTitle:@"SETTINGS"];
        [self createView];
        
    }
    return self;
}
-(void)createView
{
    int lblWidth=self.contentContainer.frame.size.width-75;

    
    
//    switchDisconnectByRules = [[UISwitch alloc]initWithFrame:CGRectMake(10,20,10,10)];
//    [switchDisconnectByRules addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
//    [self.contentContainer addSubview:switchDisconnectByRules];
//    
//    UILabel *lbl_DisconnectByRules =[[UILabel alloc] initWithFrame:CGRectMake(switchDisconnectByRules.frame.origin.x+switchDisconnectByRules.frame.size.width+5,switchDisconnectByRules.frame.origin.y-5,lblWidth, 40)];
//    lbl_DisconnectByRules.textColor=[UIColor blackColor];
//    lbl_DisconnectByRules.backgroundColor=[UIColor whiteColor];
//    lbl_DisconnectByRules.font=[UIFont fontWithName:@"Helvetica" size:13];
//    lbl_DisconnectByRules.text=@"Disconnect by rules";
//    lbl_DisconnectByRules.numberOfLines=0;
//    lbl_DisconnectByRules.textAlignment = NSTextAlignmentLeft;
//    [self.contentContainer addSubview:lbl_DisconnectByRules];
    
    switchScreenON = [[UISwitch alloc]initWithFrame:CGRectMake(10,20,10,10)];
    [switchScreenON addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [self.contentContainer addSubview:switchScreenON];
    
    UILabel *lbl_ScreenON =[[UILabel alloc] initWithFrame:CGRectMake(switchScreenON.frame.origin.x+switchScreenON.frame.size.width+5,switchScreenON.frame.origin.y-5,lblWidth, 40)];
    lbl_ScreenON.textColor=[UIColor blackColor];
    lbl_ScreenON.backgroundColor=[UIColor whiteColor];
    lbl_ScreenON.font=[UIFont fontWithName:@"Helvetica" size:13];
    lbl_ScreenON.text=@"Screen always ON";
    lbl_ScreenON.numberOfLines=0;
    lbl_ScreenON.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_ScreenON];
    
    switchDoubleTapON = [[UISwitch alloc]initWithFrame:CGRectMake(switchScreenON.frame.origin.x,switchScreenON.frame.origin.y+switchScreenON.frame.size.height+40,10,10)];
    [switchDoubleTapON addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [self.contentContainer addSubview:switchDoubleTapON];
    
    UILabel *lbl_DoubleTapON =[[UILabel alloc] initWithFrame:CGRectMake(switchDoubleTapON.frame.origin.x+switchDoubleTapON.frame.size.width+5,switchDoubleTapON.frame.origin.y-5,lblWidth, 40)];
    lbl_DoubleTapON.textColor=[UIColor blackColor];
    lbl_DoubleTapON.backgroundColor=[UIColor whiteColor];
    lbl_DoubleTapON.font=[UIFont fontWithName:@"Helvetica" size:13];
    lbl_DoubleTapON.text=@"Double tap to connect and Reconnect";
    lbl_DoubleTapON.numberOfLines=0;
    lbl_DoubleTapON.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_DoubleTapON];
    
    switchConfirmationON = [[UISwitch alloc]initWithFrame:CGRectMake(switchDoubleTapON.frame.origin.x,switchDoubleTapON.frame.origin.y+switchDoubleTapON.frame.size.height+40,10,10)];
    [switchConfirmationON addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [self.contentContainer addSubview:switchConfirmationON];
    
    UILabel *lbl_Confirmation =[[UILabel alloc] initWithFrame:CGRectMake(switchConfirmationON.frame.origin.x+switchConfirmationON.frame.size.width+5,switchConfirmationON.frame.origin.y-5,lblWidth, 40)];
    lbl_Confirmation.textColor=[UIColor blackColor];
    lbl_Confirmation.backgroundColor=[UIColor whiteColor];
    lbl_Confirmation.font=[UIFont fontWithName:@"Helvetica" size:13];
    lbl_Confirmation.text=@"Confirmation message before disconnect the stranger";
    lbl_Confirmation.numberOfLines=0;
    lbl_Confirmation.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_Confirmation];
    
    switchMessageWithCondition = [[UISwitch alloc]initWithFrame:CGRectMake(switchConfirmationON.frame.origin.x,switchConfirmationON.frame.origin.y+switchConfirmationON.frame.size.height+40,10,10)];
    [switchMessageWithCondition addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [self.contentContainer addSubview:switchMessageWithCondition];
    
    UILabel *lbl_MsgCondition =[[UILabel alloc] initWithFrame:CGRectMake(switchMessageWithCondition.frame.origin.x+switchMessageWithCondition.frame.size.width+5,switchMessageWithCondition.frame.origin.y-5,lblWidth, 40)];
    lbl_MsgCondition.textColor=[UIColor blackColor];
    lbl_MsgCondition.backgroundColor=[UIColor whiteColor];
    lbl_MsgCondition.font=[UIFont fontWithName:@"Helvetica" size:13];
    lbl_MsgCondition.text=@"Disconnect message if greater then (Integer) length and contains (string)";
    lbl_MsgCondition.numberOfLines=0;
    lbl_MsgCondition.textAlignment = NSTextAlignmentLeft;
    [self.contentContainer addSubview:lbl_MsgCondition];
    
    UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.headerContainer.frame.size.width-105, self.headerContainer.frame.size.height-35, 100, 30)];
//    saveBtn.backgroundColor=[UIColor orangeColor];
//    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
//    [saveBtn setTitle:@"SAVE" forState:UIControlStateSelected];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveBtn.layer.borderColor=UIColorFromRGB(0x3A3D41).CGColor;
//    saveBtn.layer.borderWidth=1;
//    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    [saveBtn addTarget:self action:@selector(saveSettingsClicked) forControlEvents:UIControlEventTouchUpInside];

    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    [saveBtn setTitle:@"SAVE" forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveSettingsClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    saveBtn.backgroundColor=[UIColor orangeColor];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    saveBtn.titleLabel.backgroundColor=[UIColor clearColor];
    saveBtn.imageView.backgroundColor=[UIColor clearColor];
        [self.headerContainer addSubview:saveBtn];

}
- (void)setState:(id)checkBox
{
    
}
-(void)saveSettingsClicked
{
  if(switchScreenON.isOn)
    {
        
    }
    else if(switchDoubleTapON.isOn)
    {
        
    }
    else if(switchConfirmationON.isOn)
    {
        
    }
    else if(switchMessageWithCondition.isOn)
    {
        
    }
}
@end
