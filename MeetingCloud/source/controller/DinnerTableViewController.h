//
//  DinnerTableViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entitys.h"

@interface DinnerTableViewController : UIViewController{
    IBOutlet UIScrollView *_scrollview;
}

@property(nonatomic,retain) DinnerPlan *dinnerPlan;
@property(nonatomic,retain) IBOutlet UILabel *lb_name;
@property(nonatomic,retain) IBOutlet UIImageView *iv_msgBack;
@property(nonatomic,retain) IBOutlet UILabel *lb_menu;



-(IBAction)backBtnClicked:(id)sender;

@end
