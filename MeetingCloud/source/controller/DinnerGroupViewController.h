//
//  DinnerTableViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"

@interface DinnerGroupViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSArray *datas;


-(IBAction)backBtnClicked:(id)sender;

@end
