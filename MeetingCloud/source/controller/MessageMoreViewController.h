//
//  MessageMoreViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-13.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "Entitys.h"
#import "MBProgressHUD.h"

@interface MessageMoreViewController : UIViewController<MBProgressHUDDelegate>{
    IBOutlet FaceView *faceView;
    IBOutlet UIScrollView *scrollerView;
    IBOutlet UILabel *lb_name;
    IBOutlet UILabel *lb_time;
    IBOutlet UIButton *btn_next;
    IBOutlet UIButton *btn_last;
    NSError *_error;
}

@property(nonatomic,retain) NSArray *msgArray;
@property(nonatomic,assign) int currentIndex;

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)latterNextClicked:(id)sender;
-(IBAction)latterLastClicked:(id)sender;
-(IBAction)latterReSendClicked:(id)sender;
-(IBAction)latterDeleteClicked:(id)sender;

@end
