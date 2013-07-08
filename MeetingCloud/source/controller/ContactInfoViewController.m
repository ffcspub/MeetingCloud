//
//  ContactInfoViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-10.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ContactInfoViewController.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "UITools.h"
#import "MBProgressHUD.h"
#import "MessageViewController.h"
#import "WriteMessageViewController.h"
#import "ShareManager.h"

@interface ContactInfoViewController (private)

-(void) addPersonByFirstName:(NSString *)firstName lastName:(NSString *)lastName phone:(NSString *)phone;

- (void) dialPhoneNumber:(NSString *)aPhoneNumber;

@end

@implementation ContactInfoViewController

@synthesize userinfo = _userinfo;
@synthesize lb_name = _lb_name;
@synthesize lb_job = _lb_job;
@synthesize lb_phone = _lb_phone;
@synthesize lb_sex = _lb_sex;

-(void) dealloc{
    [_userinfo release];
    [_lb_name release];
    [_lb_job release];
    [_lb_phone release];
    [_lb_sex release];
    [phoneCallWebView release];
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
    [_lb_job setText:_userinfo.job];
    [_lb_name setText:_userinfo.name];
    if([@"0" isEqualToString: _userinfo.showmobilephone]){
        [_lb_phone setText:@""];
    } else {
        [_lb_phone setText:_userinfo.loginid];
    }
   
    if ([@"1" isEqualToString:_userinfo.sex]) {
        [_lb_sex setText:@"男"];
    }else if([@"0" isEqualToString:_userinfo.sex]) {
        [_lb_sex setText:@"女"];
    }else {
         [_lb_sex setText:@""];
    }
    
    [lb_city setText:_userinfo.city];
    [lb_remark setText:_userinfo.remark];
    [lb_roomNo setText:_userinfo.roomNo];
    
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
-(IBAction)phoneBtnClicked:(id)sender{
    if ([@"0" isEqualToString: _userinfo.showmobilephone]) {
        return;
    }
    [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:[NSString stringWithFormat:@"telprompt://%@",_userinfo.loginid]]];
    //[self dialPhoneNumber:_userinfo.loginid];
}

-(IBAction)msgBtnClicked:(id)sender{
    if([@"0" isEqualToString: _userinfo.showmobilephone])
        return;
    [self sendSMS];   
}

-(IBAction)privateMsgBtnClicked:(id)sender{
    if ([ShareManager getInstance].personArray) {
        [[ShareManager getInstance].personArray removeAllObjects];
        [[ShareManager getInstance].personArray addObject:_userinfo];
    }else {
        [ShareManager getInstance].personArray = [NSMutableArray arrayWithObject:_userinfo];
    }
  
    WriteMessageViewController *vlc = [[WriteMessageViewController alloc]initWithNibName:@"WriteMessageViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(IBAction)addPersonBtnClicked:(id)sender{
    if([@"0" isEqualToString: _userinfo.showmobilephone])
        return;
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud release];
    hud.delegate = self;
    [hud showWhileExecuting:@selector(addPerson) onTarget:self withObject:nil animated:YES];
}

-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addPerson{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ){
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"ios6.0及以上系统限制通讯录权限，请进[设置]-[隐私]-[通讯录]允许企业总机访问通讯录"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
    }
    if ([_userinfo.name length]>1) {
        NSRange aRange = NSMakeRange(0, 1);
        NSRange sRange = NSMakeRange(1,[_userinfo.name length]-1);
        NSString *firstLetter = [_userinfo.name substringWithRange:sRange];
        NSString *lastLetter = [_userinfo.name substringWithRange:aRange];
        [self addPersonByFirstName:firstLetter lastName:lastLetter phone:_userinfo.loginid];
    }
}

- (void)sendSMS {
    if ([@"0" isEqualToString: _userinfo.showmobilephone]) {
        return;
    }
	BOOL canSendSMS = [MFMessageComposeViewController canSendText];
	NSLog(@"can send SMS [%d]", canSendSMS);	
	if (canSendSMS) {
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.navigationBar.tintColor = [UIColor blackColor];
		picker.recipients = [NSArray arrayWithObject:_userinfo.loginid];
		[self presentModalViewController:picker animated:YES];
		[picker release];		
	}else {
        [UITools easyAlert:@"对不起，您的设备无法发送短信" cancelButtonTitle:@"确定"];
    }
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    [UITools easyAlert:@"添加联系人成功" cancelButtonTitle:@"确定"];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			break;
		case MessageComposeResultFailed:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];	
}



@end

@implementation ContactInfoViewController(private)

-(void) addPersonByFirstName:(NSString *)firstName lastName:(NSString *)lastName phone:(NSString *)phone{

    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){//ios6.0
        tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    } else {
        tmpAddressBook = ABAddressBookCreate();
    }
        //取得本地通信录名柄
        //创建一条联系人记录
        ABRecordRef tmpRecord = ABPersonCreate();
        CFErrorRef error; 
        BOOL tmpSuccess = NO;
        //Nickname
        /*
        CFStringRef tmpNickname = CFSTR("Sparky");
        tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonNicknameProperty, tmpNickname, &error);
        CFRelease(tmpNickname);
         */
        //First name
        CFStringRef tmpFirstName = (CFStringRef)firstName;
        tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonFirstNameProperty, tmpFirstName, &error);
        //CFRelease(tmpFirstName);
        //Last name
        CFStringRef tmpLastName = (CFStringRef)lastName;
        tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonLastNameProperty, tmpLastName, &error);
        //CFRelease(tmpLastName);
        //phone number
        CFTypeRef tmpPhones = (CFStringRef)phone;
        ABMutableMultiValueRef tmpMutableMultiPhones = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, tmpPhones, kABPersonPhoneMobileLabel, NULL);
        tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonPhoneProperty, tmpMutableMultiPhones, &error);
        //CFRelease(tmpPhones);
        //保存记录
        tmpSuccess = ABAddressBookAddRecord(tmpAddressBook, tmpRecord, &error);
        CFRelease(tmpRecord);
        //保存数据库
        tmpSuccess = ABAddressBookSave(tmpAddressBook, &error);
        CFRelease(tmpAddressBook);
}



- (void) dialPhoneNumber:(NSString *)aPhoneNumber  
{  
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}  


@end
