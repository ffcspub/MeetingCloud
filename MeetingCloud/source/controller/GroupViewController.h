//
//  DinnerTableViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"

@interface GroupViewController : UIViewController<UITextFieldDelegate>{
    NSError *_error;
    NSArray *_datas;
    NSArray *_resultDatas;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UITextField *tf_search;


-(IBAction)backBtnClicked:(id)sender;
-(IBAction)searchBtnClicked:(id)sender;

@end
