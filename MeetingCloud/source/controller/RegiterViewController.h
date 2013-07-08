//
//  RegiterViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"

@interface RegiterViewController : UIViewController<UITextFieldDelegate>{
    NSError *_error;
    NSString *_msg;
}

@property(nonatomic,retain) IBOutlet UIScrollView *baseSV;
@property(nonatomic,retain) IBOutlet UITextField *tf_name;
@property(nonatomic,retain) IBOutlet UITextField *tf_job;
@property(nonatomic,retain) IBOutlet UITextField *tf_city;
@property(nonatomic,retain) IBOutlet UITextField *tf_email;

@property(nonatomic,retain) IBOutlet UIButton *btn_man;
@property(nonatomic,retain) IBOutlet UIButton *btn_woman;

@property(nonatomic,retain) Conference *conference; 
@property(nonatomic,retain) NSString *phone;

-(IBAction)sexBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)submitBtnClicked:(id)sender;
-(IBAction)emptybtnClicked:(id)sender;

@end
