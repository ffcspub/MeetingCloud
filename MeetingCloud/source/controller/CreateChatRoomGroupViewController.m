//
//  CreateChatRoomGroupViewController.m
//  MeetingCloud
//
//  Created by Geory on 13-7-17.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import "CreateChatRoomGroupViewController.h"
#import "UITools.h"
#import "HttpHelper.h"
#import "ShareManager.h"

@interface CreateChatRoomGroupViewController ()

@end

@implementation CreateChatRoomGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *backImage = [[UIImage imageNamed:@"input_bg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_iv_back setImage:backImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tf_name release];
    [_tv_context release];
    [_iv_back release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTf_name:nil];
    [self setTv_context:nil];
    [self setIv_back:nil];
    [super viewDidUnload];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendClick:(id)sender {
    if ([_tf_name.text length] == 0) {
        [UITools easyAlert:@"请输入分组名称" cancelButtonTitle:@"确定"];
        return;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    if ([_tv_context.text length] == 0) {
        [helper addTalkmessageGroupByUserid:[ShareManager getInstance].userInfo.userId conferenceId:[ShareManager getInstance].conference.conferenceId groupName:_tf_name.text intro:nil];
    } else {
        [helper addTalkmessageGroupByUserid:[ShareManager getInstance].userInfo.userId conferenceId:[ShareManager getInstance].conference.conferenceId groupName:_tf_name.text intro:_tv_context.text];
    }
    if (helper.error) {
        [UITools easyAlert:[UITools getErrorMsg:helper.error] cancelButtonTitle:@"确定"];
    } else {
        [UITools easyAlert:@"创建成功" cancelButtonTitle:@"确定"];
    }
}

- (IBAction)backgroundClick:(id)sender {
    [_tv_context resignFirstResponder];
    [_tf_name resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -180, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

@end
