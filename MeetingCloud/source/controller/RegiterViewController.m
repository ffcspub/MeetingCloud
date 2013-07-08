//
//  RegiterViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "RegiterViewController.h"
#import "MBProgressHUD.h"
#import "HttpHelper.h"
#import "UITools.h"

@interface RegiterViewController (private)

-(void) leftTextLableWithUITextField:(UITextField *) textField  text:(NSString *)text;

-(void) petitionMeeting;

@end

@implementation RegiterViewController
@synthesize tf_name = _tf_name;
@synthesize tf_job = _tf_job;
@synthesize tf_city = _tf_city;
@synthesize tf_email = _tf_email;
@synthesize btn_man = _btn_man;
@synthesize btn_woman = _btn_woman;
@synthesize conference = _conference;
@synthesize phone = _phone;
@synthesize baseSV = _baseSV;

-(void) dealloc{
    [_tf_name release];
    [_tf_job release];
    [_tf_city release];
    [_tf_email release];
    [_btn_woman release];
    [_btn_man release];
    [_conference release];
    [_phone release];
    [_baseSV release];
    [super dealloc];
}

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
    [self leftTextLableWithUITextField:_tf_name text:@"姓  名:"];
    [self leftTextLableWithUITextField:_tf_job text:@"职  位:"];
    [self leftTextLableWithUITextField:_tf_city text:@"城  市:"];
    [self leftTextLableWithUITextField:_tf_email text:@"邮  件:"];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [self textFileShowOrHide];
}

-(void) viewDidDisappear:(BOOL)animated{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self
                            name:UIKeyboardWillHideNotification
                          object:nil];
    
    [notification removeObserver:self
                            name:UIKeyboardWillShowNotification
                          object:nil];
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
-(IBAction)sexBtnClicked:(id)sender{
    if (sender == _btn_man) {
        if (_btn_man.tag == 1) {
            [_btn_man setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateNormal];
            [_btn_man setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateHighlighted];
            _btn_man.tag = 0;  
        }else {
            if (_btn_woman.tag == 1) {
                [_btn_woman setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateNormal];
                [_btn_woman setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateHighlighted];
                _btn_woman.tag = 0; 
            }
            [_btn_man setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [_btn_man setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateHighlighted];
            _btn_man.tag = 1; 
        }
        
    }
    
    if (sender == _btn_woman) {
        if (_btn_woman.tag == 1) {
            [_btn_woman setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateNormal];
            [_btn_woman setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateHighlighted];
            _btn_woman.tag = 0;  
        }else {
            if (_btn_man.tag == 1) {
                [_btn_man setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateNormal];
                [_btn_man setImage:[UIImage imageNamed:@"radio-none.png"] forState:UIControlStateHighlighted];
                _btn_man.tag = 0; 
            }
            [_btn_woman setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [_btn_woman setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateHighlighted];
            _btn_woman.tag = 1; 
        }
        
    }
}

-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitBtnClicked:(id)sender{
    if ([_tf_name.text length]==0) {
        [UITools easyAlert:@"请输入姓名" cancelButtonTitle:@"确定"];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = @"正在申请加入，请稍候...";
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(petitionMeeting) onTarget:self withObject:nil animated:YES];
}

-(IBAction)emptybtnClicked:(id)sender{
    [_tf_name resignFirstResponder];
    [_tf_job resignFirstResponder];
    [_tf_email resignFirstResponder];
    [_tf_city resignFirstResponder];
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
        [UITools easyAlert:_msg cancelButtonTitle:@"确定"];
        [_msg release];
        _msg = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _tf_job || textField == _tf_city || textField == _tf_email) {
        [_baseSV setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    return YES;
}


#pragma mark -KEYBORAD
- (void)textFileShowOrHide {
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self     
                     selector:@selector(keyboardWillShow)     
                         name:UIKeyboardWillShowNotification     
                       object:nil];
    
    [notification addObserver:self     
                     selector:@selector(keyboardWillHide)     
                         name:UIKeyboardWillHideNotification     
                       object:nil];
}

/*
 * @DO 隐藏键盘
 */
- (void)keyboardWillHide {
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationDuration:0.30f];
    [_baseSV setContentOffset:CGPointMake(0, 0) animated:YES];//_baseSV为ScrollerView
    [_tf_name resignFirstResponder];
    [_tf_job resignFirstResponder];
    [_tf_email resignFirstResponder];
    [_tf_city resignFirstResponder];
    [UIView commitAnimations];
    
}

/*
 * @DO 显示键盘
 */
- (void)keyboardWillShow{
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationDuration:0.30f];
    if (_tf_job.isFirstResponder || _tf_email.isFirstResponder || _tf_city.isFirstResponder) {
        [_baseSV setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    [UIView commitAnimations];
}


@end

@implementation RegiterViewController (private)

-(void) leftTextLableWithUITextField:(UITextField *) textField  text:(NSString *)text{
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    [leftview setBackgroundColor:[UIColor clearColor]];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 60)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setFont:[UIFont systemFontOfSize:17]];
    [lable setTextColor:[UIColor blackColor]];
    [lable setText:text];
    [leftview addSubview:lable];
    [lable release];
    textField.leftView = leftview;
    [leftview release];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void) petitionMeeting{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSString *sex = @"";
    if (_btn_man.tag == 1) {
        sex = @"0";
    }else if(_btn_woman.tag == 1){
        sex = @"1";
    }
    NSString *job = _tf_job.text;
    if (!job) {
        job = @"";
    }
    NSString *name = _tf_name.text;
    NSString *city = _tf_city.text;
    if (!city) {
        city = @"";
    }
    NSString *email = _tf_email.text;
    if (!email) {
        email = @"";
    }
    [helper addUserInfoByConferenceId:_conference.conferenceId name:name loginid:_phone sex:sex job:job city:city email:email];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _msg = [helper.msg retain];
    }
    [helper release];
    
}

@end
