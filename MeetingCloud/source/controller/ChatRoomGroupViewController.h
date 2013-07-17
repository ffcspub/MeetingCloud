//
//  ChatRoomGroupViewController.h
//  MeetingCloud
//
//  Created by Geory on 13-7-9.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ChatRoomGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    int page;
    NSMutableArray *_talkMessageGroupList;
    NSError *_error;
    BOOL _isLastPage;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)addGroupClick:(id)sender;
@end
