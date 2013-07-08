//
//  FileInfoViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"
#import "MBProgressHUD.h"

@interface FileInfoViewController : UIViewController<UIActionSheetDelegate>{
    int _pageIndex;
    MBProgressHUD *_hud;
    IBOutlet UIButton *lastBtn;
    IBOutlet UIButton *nextBtn;
    IBOutlet UIView *navBar; 
}

@property(nonatomic,retain) ConferenceFiles *file;

@property(nonatomic,retain) IBOutlet UIWebView *webView;

@property(nonatomic,retain) IBOutlet UIView *toolBar;


-(IBAction)backBtnClicked:(id)sender;

-(IBAction)lastBtnClicked:(id)sender;//上一页

-(IBAction)nextBtnClicked:(id)sender;//下一页

-(IBAction)homeBtnClicked:(id)sender;//首页

-(IBAction)pageBtnClicked:(id)sender;//跳转页

@end
