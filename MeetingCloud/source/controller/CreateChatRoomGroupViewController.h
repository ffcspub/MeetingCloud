//
//  CreateChatRoomGroupViewController.h
//  MeetingCloud
//
//  Created by Geory on 13-7-17.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateChatRoomGroupViewController : UIViewController<UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextField *tf_name;
@property (retain, nonatomic) IBOutlet UITextView *tv_context;
@property (retain, nonatomic) IBOutlet UIImageView *iv_back;

- (IBAction)backClick:(id)sender;
- (IBAction)sendClick:(id)sender;
- (IBAction)backgroundClick:(id)sender;
@end
