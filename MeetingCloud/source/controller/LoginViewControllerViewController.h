//
//  LoginViewControllerViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-21.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "Conference.h"
#import "LeveyPopListView.h"
#import "Entitys.h"

@interface LoginViewControllerViewController : UIViewController<MBProgressHUDDelegate,UIActionSheetDelegate,UIScrollViewDelegate,LeveyPopListViewDelegate>{
    NSArray *_meetingList;
    NSError *_error;
    NSString *_msg;
    Conference *_conference;
    Clientversion *_version;
}

@property(nonatomic,retain) IBOutlet UIScrollView *baseSV;
@property(nonatomic,retain) IBOutlet UITextField *tf_phone;
@property(nonatomic,retain) IBOutlet UITextField *tf_password;
@property(nonatomic,retain) IBOutlet UIButton *btn_meeting;
@property(nonatomic,retain) IBOutlet UIButton *btn_member;
@property(nonatomic,retain) IBOutlet UIButton *btn_login;
@property(nonatomic,retain) IBOutlet UIButton *btn_petition;
@property(nonatomic,retain) IBOutlet UIButton *btn_password;

-(IBAction)loginBtnClicked:(id)sender;
-(IBAction)passwordBtnClicked:(id)sender;
-(IBAction)meetingBtnClicked:(id)sender;
-(IBAction)memberBtnClicked:(id)sender;
-(IBAction)backbtnClicked:(id)sender;
-(IBAction)petitionBtnClicked:(id)sender;
-(IBAction)cancelBtnClicked:(id)sender;

@end
