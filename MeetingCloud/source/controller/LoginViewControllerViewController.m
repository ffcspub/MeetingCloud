//
//  LoginViewControllerViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-21.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "LoginViewControllerViewController.h"
#import "MBProgressHUD.h"
#import "HttpHelper.h"
#import "Context.h"
#import "UITools.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "MainViewController.h"
#import "RegiterViewController.h"
#import "BlockAlertView.h"
#import "LeveyPopListView.h"
#import "UIImageView+WebCache.h"


#define HUDTAG_LOGIN 1
#define HUDTAG_MEETING 2
#define HUDTAG_NOADDMEETING 3
#define HUDTAG_PETITION 4
#define HUDTAG_PASSWORD 5

#define PHONE @"18650335172" //135 5917 2318
//#define PHONE @"13559172318"

@interface LoginViewControllerViewController (private)

-(void) leftTextLableWithUITextField:(UITextField *) textField  text:(NSString *)text;
-(void) loadMeetingListData;//加载已加入的会议
-(void) loadNotAddMeetingListData;//加载未加入会议
-(void) petitionMeeting:(Conference *)confernce;//申请加入会议
-(void) pwdByconfernce;//获取密码
-(void) loginConfernce;//登录会议

-(void) loadLoginView;

@end

@implementation LoginViewControllerViewController

@synthesize tf_phone = _tf_phone;
@synthesize btn_meeting = _btn_meeting;
@synthesize tf_password = _tf_password;
@synthesize btn_member = _btn_member;
@synthesize btn_login = _btn_login;
@synthesize btn_password = _btn_password;
@synthesize baseSV = _baseSV;

-(void) dealloc{
    [_tf_phone release];
    [_btn_meeting release];
    [_tf_password release];
    [_btn_login release];
    [_btn_member release];
    [_btn_password release];
    [_meetingList release];
    [_baseSV release];
    [_conference release];
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
    [self leftTextLableWithUITextField:_tf_phone text:@"手机号:"];
    [self leftTextLableWithUITextField:_tf_password text:@"密   码:"];
    //[_tf_phone setText:PHONE];//test
    //[self textFileShowOrHide];
    BOOL ismember = [[ShareManager getInstance]isRemember];
    if (ismember) {
        [_tf_phone setText:[[ShareManager getInstance] loginId]];
        [_tf_password setText:[[ShareManager getInstance] password]];
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_hover_bg.png"] forState:UIControlStateNormal];
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_hover_bg.png"] forState:UIControlStateHighlighted];
        _btn_member.tag = 1;
    }
    [self performSelectorInBackground:@selector(checkVersion) withObject:nil];
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

#pragma mark - Action
-(IBAction)meetingBtnClicked:(id)sender{
    [_tf_phone resignFirstResponder];
    [_tf_password resignFirstResponder];
    if ([_tf_phone.text length] == 0) {
        [UITools easyAlert:@"请输入手机号" cancelButtonTitle:@"确定"];
        return;
    }
    if ([_tf_phone.text length] != 11) {
        [UITools easyAlert:@"手机号输入有误" cancelButtonTitle:@"确定"];
        return;
    }
   
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [hud setTag:HUDTAG_MEETING];
    hud.delegate = self;
    hud.labelText = @"正在获取会议列表，请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadMeetingListData) onTarget:self withObject:nil animated:YES];
}

-(IBAction)loginBtnClicked:(id)sender{
    [_tf_phone resignFirstResponder];
    [_tf_password resignFirstResponder];
    if ([_tf_phone.text length] == 0) {
        [UITools easyAlert:@"请输入手机号" cancelButtonTitle:@"确定"];
        return;
    }
    if ([_tf_phone.text length] != 11) {
        [UITools easyAlert:@"手机号输入有误" cancelButtonTitle:@"确定"];
        return;
    }
    if (!_conference) {
        [UITools easyAlert:@"请选择会议" cancelButtonTitle:@"确定"];
        return;
    }
    if ([_tf_password.text length] == 0){
        [UITools easyAlert:@"请输入密码" cancelButtonTitle:@"确定"];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.tag = HUDTAG_LOGIN;
    hud.labelText = @"登录中，请稍候";
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud showWhileExecuting:@selector(loginConfernce) onTarget:self withObject:nil animated:YES];
    [hud release];
    //getPwdByLoginId
}

-(IBAction)passwordBtnClicked:(id)sender{
    [_tf_phone resignFirstResponder];
    [_tf_password resignFirstResponder];
    if ([_tf_phone.text length] == 0) {
        [UITools easyAlert:@"请输入手机号" cancelButtonTitle:@"确定"];
        return;
    }
    if ([_tf_phone.text length] != 11) {
        [UITools easyAlert:@"手机号输入有误" cancelButtonTitle:@"确定"];
        return;
    }
    if (!_conference) {
        [UITools easyAlert:@"请选择会议" cancelButtonTitle:@"确定"];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [hud setTag:HUDTAG_PASSWORD];
    hud.delegate = self;
    hud.labelText = @"请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(pwdByconfernce) onTarget:self withObject:nil animated:YES];
}

-(IBAction)memberBtnClicked:(id)sender{
    if (_btn_member.tag == 0) {
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_hover_bg.png"] forState:UIControlStateNormal];
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_hover_bg.png"] forState:UIControlStateHighlighted];
        _btn_member.tag = 1;
    }else {
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_bg.png"] forState:UIControlStateNormal];
        [_btn_member setImage:[UIImage imageNamed:@"checkbox_bg.png"] forState:UIControlStateHighlighted];
        _btn_member.tag = 0;
    }
}

-(IBAction)petitionBtnClicked:(id)sender{
    [_tf_phone resignFirstResponder];
    [_tf_password resignFirstResponder];
    if ([_tf_phone.text length] == 0) {
        [UITools easyAlert:@"请输入手机号" cancelButtonTitle:@"确定"];
        return;
    }
    if ([_tf_phone.text length] != 11) {
        [UITools easyAlert:@"手机号输入有误" cancelButtonTitle:@"确定"];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [hud setTag:HUDTAG_NOADDMEETING];
    hud.delegate = self;
    hud.labelText = @"正在获取会议列表，请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadNotAddMeetingListData) onTarget:self withObject:nil animated:YES];
}

-(IBAction)cancelBtnClicked:(id)sender{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqual:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    if([textField.text length]>1){
        if (textField == _tf_phone) {
            if([@"0" isEqualToString: [textField.text substringToIndex:1]]){
                if (range.location >11) {
                    return NO;
                }
            }else {
                if (range.location >10) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
        [hud removeFromSuperViewOnHide];
        hud = nil;
        return;
    }
    if (hud.tag == HUDTAG_MEETING) {
        if (_meetingList && [_meetingList count] >0) {
            NSMutableArray *options = [[NSMutableArray alloc]init];
            for (Conference *conference in _meetingList) {
                [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:conference.name,@"text", nil]];
            }
            LeveyPopListView *listView = [[LeveyPopListView alloc]initWithTitle:@"请选择会议" options:options];
            listView.tag = HUDTAG_MEETING;
            listView.delegate = self;
            [listView showInView:self.view animated:YES];
            [listView release];
        }else {
            [UITools easyAlert:@"对不起，未发现您可以加入的会议" cancelButtonTitle:@"确定"];
        }
    }else if (hud.tag == HUDTAG_NOADDMEETING) {
        if (_meetingList && [_meetingList count] >0) {
            NSMutableArray *options = [[NSMutableArray alloc]init];
            for (Conference *conference in _meetingList) {
                [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:conference.name,@"text", nil]];
            }
            LeveyPopListView *listView = [[LeveyPopListView alloc]initWithTitle:@"请选择要申请加入的会议" options:options];
            listView.tag = HUDTAG_NOADDMEETING;
            listView.delegate = self;
            [listView showInView:self.view animated:YES];
            [listView release];
        }else {
            [UITools easyAlert:@"对不起，未发现您可以申请加入的会议" cancelButtonTitle:@"确定"];
        }
    }else if(hud.tag == HUDTAG_LOGIN){
        if (_btn_member.tag == 1) {
            [[ShareManager getInstance]setIsRemember:YES];
            [[ShareManager getInstance]setPassword:_tf_password.text];
            [[ShareManager getInstance]setLoginId:_tf_phone.text];
        }
        if (_conference.backpic && [_conference.backpic length]>0) {
            UIImageView *view = [[UIImageView alloc]initWithFrame:self.navigationController.view.frame];
            view.tag = 111;
            [view setImageWithURL:[NSURL URLWithString:_conference.backpic]];
            [self.navigationController.view addSubview:view];
            [view release];
            [self performSelector:@selector(loadLoginView) withObject:nil afterDelay:3 ];
        }else {
            MainViewController *vlc = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
            [self.navigationController pushViewController:vlc animated:YES];
            [vlc release];
        } 
    }else if(hud.tag == HUDTAG_PASSWORD){
        [UITools easyAlert:_msg cancelButtonTitle:@"确定"];
        [_msg release];
        _msg = nil;
    }
    [hud removeFromSuperViewOnHide];
    hud = nil;
}

-(IBAction)backbtnClicked:(id)sender{
    [_tf_phone resignFirstResponder];
    [_tf_password resignFirstResponder];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        Conference *conference = [_meetingList objectAtIndex:(buttonIndex - 1)];
        if (actionSheet.tag == HUDTAG_MEETING) {
            if (_conference) {
                [_conference release];
                _conference = nil;
            }
            _conference = [conference retain];
            [_btn_meeting setTitle:[NSString stringWithFormat:@"会   议:  %@",conference.name] forState:UIControlStateNormal];
            [_btn_meeting setTitle:[NSString stringWithFormat:@"会   议:  %@",conference.name] forState:UIControlStateHighlighted];
        }else if (actionSheet.tag == HUDTAG_NOADDMEETING){
            [self petitionMeeting:conference];
        }
    }
}

#pragma mark -LeveyPopListViewDelegate
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    Conference *conference = [_meetingList objectAtIndex:anIndex];
    if (popListView.tag == HUDTAG_MEETING) {
        if (_conference) {
            [_conference release];
            _conference = nil;
        }
        _conference = [conference retain];
        [_btn_meeting setTitle:[NSString stringWithFormat:@"会   议:  %@",conference.name] forState:UIControlStateNormal];
        [_btn_meeting setTitle:[NSString stringWithFormat:@"会   议:  %@",conference.name] forState:UIControlStateHighlighted];
    }else if(popListView.tag == HUDTAG_NOADDMEETING){
        [self petitionMeeting:conference];
    }
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
    [_tf_password resignFirstResponder];
    [_tf_phone resignFirstResponder];
    [UIView commitAnimations];
    
}

/*
 * @DO 显示键盘
 */
- (void)keyboardWillShow{
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationDuration:0.30f];
    [_baseSV setContentOffset:CGPointMake(0, 40) animated:YES];
    [UIView commitAnimations];
}

@end

@implementation LoginViewControllerViewController (private)

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

-(void) loadMeetingListData{
    if (_meetingList) {
        [_meetingList release];
        _meetingList = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getAddedConferencesByLoginid:_tf_phone.text cloudType:CLOUDTYPE_MEETING];
    if (helper.error) {
        _error = [helper.error retain];
    }else if (array) {
        _meetingList = [array retain];
    }
    [helper release];
}

-(void) loadNotAddMeetingListData{
    if (_meetingList) {
        [_meetingList release];
        _meetingList = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getNoAddedConferencesByLoginid:_tf_phone.text cloudType:CLOUDTYPE_MEETING];
    if (helper.error) {
        _error = [helper.error retain];
    }else if (array) {
        NSMutableArray *arraytemp = [NSMutableArray  array];
        for (Conference *conference in array) {
            if ([@"1" isEqualToString:conference.doapplyfor]) {
                [arraytemp addObject:conference];
            }
        }
        _meetingList = [arraytemp retain];
    }
    [helper release];
}

-(void) petitionMeeting:(Conference *)confernce{
    RegiterViewController *vlc = [[RegiterViewController alloc]initWithNibName:@"RegiterViewController" bundle:nil];
    vlc.conference = confernce;
    vlc.phone = _tf_phone.text;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) pwdByconfernce{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper getPwdByLoginId:_tf_phone.text conferenceId:_conference.conferenceId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _msg = [helper.msg retain];
    }
    [helper release];
}


-(void) loginConfernce{
    HttpHelper *helper = [[HttpHelper alloc]init];
    UserInfo *userinfo = [[UserInfo alloc]init];
    Conference *conference = [helper getConferenceByUserInfo:userinfo ConferenceId:_conference.conferenceId password:_tf_password.text loginid:_tf_phone.text loginType:@"1" cloudType:CLOUDTYPE_MEETING];
    
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        [[ShareManager getInstance]setConference:conference];
        [[ShareManager getInstance]setUserInfo:userinfo];
        if (_conference) {
            [_conference release];
            _conference = nil;
        }
        _conference = [conference retain];
    }
    [helper release];
}


-(void) loadLoginView{
    MainViewController *vlc = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
    UIView *view = [self.navigationController.view viewWithTag:111];
    [view removeFromSuperview];
}

#pragma mark -versioncheck

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 111){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_version.filepath]];
        }
    }
}

-(void)showupdatealert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:_version.updatedsc delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"马上升级", nil];
    alert.tag = 111;
    [alert show];
    [alert release];
}

-(void) checkVersion{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    Clientversion *version = [httphelper getVersion];
    if(httphelper.error){
        //_error = [httphelper.error retain];
    }else if(version){
        _version = [version retain];
        if (![CLIENTVERSION isEqualToString: _version.nversion]) {
            [self performSelectorOnMainThread:@selector(showupdatealert) withObject:nil waitUntilDone:NO];
        }
    }
    [httphelper release];
    [pool release];
}

@end
