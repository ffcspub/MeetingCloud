//
//  CommentViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-16.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController{
    IBOutlet UITextView *_textView;
    NSError *_error;
}

-(IBAction)backBtnClicked:(id)sender;

-(IBAction)submitBtnClicked:(id)sender;


@end
