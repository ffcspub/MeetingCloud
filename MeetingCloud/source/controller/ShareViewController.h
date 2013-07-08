//
//  ShareViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"
#import "MBProgressHUD.h"

@interface ShareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    NSArray *_fileArray;
    NSError *_error;
    ConferenceFiles *_currentfile;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;


-(IBAction)backBtnclicked:(id)sender;

@end
