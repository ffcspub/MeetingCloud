//
//  CommentViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-16.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "CommentViewController.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "MBProgressHUD.h"
#import "ShareManager.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentViewController (private)

-(void) sendRecomment;

@end

@implementation CommentViewController

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
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.layer.cornerRadius = 8;
    _textView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -Action

-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitBtnClicked:(id)sender{
    if ([_textView.text length]==0) {
        [UITools easyAlert:@"请输入反馈内容" cancelButtonTitle:@"确定"];
    }else {
        [_textView resignFirstResponder];
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(sendRecomment) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark -MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        [UITools easyAlert:@"提交成功" cancelButtonTitle:@"确定"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [self submitBtnClicked:nil];
    }
    return YES;
}

@end

@implementation CommentViewController(private)

-(void) sendRecomment{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addRecommendByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId content:_textView.text];
    if (helper.error) {
        _error = [ helper.error retain];
    }
    [helper release];
}


@end
