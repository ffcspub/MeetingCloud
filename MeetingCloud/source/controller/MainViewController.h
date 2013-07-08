//
//  MainViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-19.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageGirdView.h"
#import "MBProgressHUD.h"
#import "Entitys.h"

@interface MainViewController : UIViewController<PageGirdViewDelegate,PageGirdViewDataSource,MBProgressHUDDelegate>{
    NSError *_error;
    NSArray *_modules;
    NSMutableArray *_notifiyes;
    BOOL threadFlag;
    Clientversion *_version;
}

@property(nonatomic,retain) IBOutlet PageGirdView *pageGirdView;
@property(nonatomic,retain) IBOutlet UILabel *weatherLable;
@property(nonatomic,retain) IBOutlet UILabel *notifyLable;
@property(nonatomic,retain) IBOutlet UILabel *nameLable;
@property(nonatomic,retain) IBOutlet UILabel *dateLable;
@property(nonatomic,retain) IBOutlet UILabel *addressLable;
@property(nonatomic,retain) IBOutlet UIImageView *faceImageView;

-(IBAction)backBtnClicked:(id)sender;

@end
