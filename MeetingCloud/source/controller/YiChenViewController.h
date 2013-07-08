//
//  YiChenViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiChenViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dateAgendas;
    NSArray *_singAgendas;
    NSInteger selectedIndex;
    NSError *_error;
}

@property(nonatomic,retain) IBOutlet UITableView *tv_left;
@property(nonatomic,retain) IBOutlet UITableView *tv_right;
@property(nonatomic,retain) IBOutlet UILabel *lb_welcome;

-(IBAction)cancelBtnClick:(id)sender;



@end
