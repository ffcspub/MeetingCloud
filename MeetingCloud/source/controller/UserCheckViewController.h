//
//  UserCheckViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZXingWidgetController.h"

@interface UserCheckViewController : UIViewController<MBProgressHUDDelegate,ZXingDelegate>{
    IBOutlet UITextField *tf_code;
    NSString *_msg;
    NSError *_error;
}

@property(nonatomic,assign)int scanType;//是否为二维码扫描  1:手动   2:二维码

-(IBAction)backBtnClicked:(id)sender;

-(IBAction)scanBtnClicked:(id)sender;

-(IBAction)submitClicked:(id)sender;

@end
