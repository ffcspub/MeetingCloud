//
//  MessageViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    NSError *_error;
    NSArray * _datas;
    int index;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *btn_inbox;
    IBOutlet UIButton *btn_sender;
}

-(IBAction) backBtnClicked:(id) sender;
-(IBAction) btn_inboxClicked:(id)sender;
-(IBAction) btn_senderClicked:(id)sender;
-(IBAction) btn_writerClicked:(id)sender;

@end
