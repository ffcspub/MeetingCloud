//
//  ContactViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-6.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController{
    NSMutableArray *_datas;
    NSArray *_resultDatas;
    NSError *_error;
    NSDictionary *_aIndexDictionary;
    int pageNum;
    int numPerPage;
    BOOL isLastPage;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UITextField *tf_search;
@property(nonatomic,assign) BOOL selectMode;


-(IBAction)backBtnClicked:(id)sender;
-(IBAction)searchBtnClicked:(id)sender;
-(IBAction)reloadSearchBtnClicked:(id)sender;

@end
