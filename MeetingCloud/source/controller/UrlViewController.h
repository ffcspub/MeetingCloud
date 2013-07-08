//
//  UrlViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-18.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleConference.h"
#import "MBProgressHUD.h"

@interface UrlViewController : UIViewController<MBProgressHUDDelegate>{
    MBProgressHUD *_hud;
    IBOutlet UIWebView *_webView;
    IBOutlet UILabel *titleLable;
    IBOutlet UIView *navBar;
}


@property(nonatomic,retain) ModuleConference *module;

-(IBAction)backBtnClicked:(id)sender;

-(IBAction)nextBtnClicked:(id)sender;

-(IBAction)passBtnClicked:(id)sender;

-(IBAction)refreshBtnClicked:(id)sender;

@end
