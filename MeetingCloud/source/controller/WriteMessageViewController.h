//
//  WriteMessageViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-13.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WriteMessageViewController : UIViewController<MBProgressHUDDelegate>{
    IBOutlet UILabel *lb_person;
    IBOutlet UITextView *tv_content;
    NSError *_error;
    NSString *msg;
}

@property(nonatomic,retain) NSString *context;

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)sendBtnClicked:(id)sender;
-(IBAction)addPersonBtnClicked:(id)sender;


@end
