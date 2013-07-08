//
//  ContactInfoViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-10.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface ContactInfoViewController : UIViewController{
    UIWebView *phoneCallWebView;
    IBOutlet UILabel *lb_city;
    IBOutlet UILabel *lb_remark;
    IBOutlet UILabel *lb_roomNo;
}

@property(nonatomic,retain) UserInfo *userinfo;

@property(nonatomic,retain) IBOutlet UILabel *lb_name;

@property(nonatomic,retain) IBOutlet UILabel *lb_phone;

@property(nonatomic,retain) IBOutlet UILabel *lb_job;

@property(nonatomic,retain) IBOutlet UILabel *lb_sex;




-(IBAction)phoneBtnClicked:(id)sender;

-(IBAction)msgBtnClicked:(id)sender;

-(IBAction)privateMsgBtnClicked:(id)sender;

-(IBAction)addPersonBtnClicked:(id)sender;

-(IBAction)backBtnClicked:(id)sender;

@end
