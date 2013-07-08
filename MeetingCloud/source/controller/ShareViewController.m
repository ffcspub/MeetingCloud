//
//  ShareViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ShareViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#import "FileInfoViewController.h"

#define HUDTAG_EMAIL 111

@interface ShareViewController (private)

-(void) loadDatas;

-(void) sendEmail:(NSString *)email;

@end

@implementation ShareViewController

@synthesize tableView = _tableView;

-(void) dealloc{
    [_tableView release];
    [_fileArray release];
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
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadDatas) onTarget:self withObject:nil animated:YES];
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


-(IBAction)backBtnclicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) inputEmail{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"邮件发送提醒" message:@"您好！该资料将发送到以下邮箱地址，请确认（若邮箱地址显示为空，请您填写要接收的邮箱地址）。\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22.0, 120.0, 240.0, 30.0)]; 
    [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setPlaceholder:@"邮箱地址"];
    textField.tag = 101;
    [alertView addSubview:textField];
    [textField release];
    //[alertView setTransform:CGAffineTransformMakeTranslation(0.0, -100.0)];  //可以调整弹出框在屏幕上的位置
    [alertView show];
    [alertView release];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    
    if (![@"1" isEqualToString: _currentfile.doview]) {
        if(buttonIndex == 0){
            [self inputEmail];
        }
    }else {
        if(buttonIndex == 0){
            FileInfoViewController *vlc = [[FileInfoViewController alloc]initWithNibName:@"FileInfoViewController" bundle:nil];
            vlc.file = _currentfile;
            [self.navigationController pushViewController:vlc animated:YES];
            [vlc release];
        }else if(buttonIndex == 1 && [@"1" isEqualToString: _currentfile.doemail]){
            [self inputEmail];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = (UITextField *)[alertView viewWithTag:101];
        if (textField.text) {
            if (![textField.text isValidateEmail]) {
                [UITools easyAlert:@"邮箱格式不正确" cancelButtonTitle:@"确定"];
            }else {
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                hud.tag = HUDTAG_EMAIL;
                hud.delegate = self;
                [self.view addSubview:hud];
                [hud release];
                [hud showWhileExecuting:@selector(sendEmail:) onTarget:self withObject:textField.text animated:YES];
            }
        }else {
            [UITools easyAlert:@"请输入邮箱地址" cancelButtonTitle:@"确定"];
        }
        
    }
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if(_error){
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        if (hud.tag == HUDTAG_EMAIL) {
            [UITools easyAlert:@"邮件发送成功" cancelButtonTitle:@"确定"];
        }else {
            [_tableView reloadData];
        }
    }
    [hud removeFromSuperViewOnHide];
    hud = nil;
}

#pragma mark -UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fileArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentfile) {
        [_currentfile release];
        _currentfile = nil;
    }
    ConferenceFiles *file = [_fileArray objectAtIndex:indexPath.row];
    _currentfile = [file retain];
    if ([@"1" isEqualToString: file.doview]) {
        if ([@"1" isEqualToString:file.doemail]) {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看全文",@"转发邮件", nil];
            [sheet showInView:self.view];
            [sheet release];
        }else{
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看全文", nil];
            [sheet showInView:self.view];
            [sheet release];
        }
        
    }else {
        if ([@"1" isEqualToString:file.doemail]) {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"转发邮件", nil];
            [sheet showInView:self.view];
            [sheet release];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SHARECELLIDENTIFIER = @"SHARECELLIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHARECELLIDENTIFIER];
    if(!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SHARECELLIDENTIFIER]autorelease];
        cell.textLabel.numberOfLines = 2;
    }
    ConferenceFiles *file = (ConferenceFiles *)[_fileArray objectAtIndex:indexPath.row];
    //获取文件名
    NSRange splitRange = [file.url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *filetype = [file.url substringFromIndex:splitRange.location];
    if ([@".doc" isEqualToString: [filetype lowercaseString]] || [@".docx" isEqualToString: [filetype lowercaseString]]) {
        [cell.imageView setImage:[UIImage imageNamed:@"share_list_icron_one.png"]];
    }else if ([@".rar" isEqualToString: [filetype lowercaseString]]) {
        [cell.imageView setImage:[UIImage imageNamed:@"share_list_icron_four.png"]];
    }else if ([@".ppt" isEqualToString: [filetype lowercaseString]] ) {
        [cell.imageView setImage:[UIImage imageNamed:@"share_list_icron_two.png"]];
    }else if ([@".pdf" isEqualToString: [filetype lowercaseString]]) {
        [cell.imageView setImage:[UIImage imageNamed:@"pdf.png"]];
    }
    cell.textLabel.text = file.name;
    return cell;
}

@end

@implementation ShareViewController(private)

-(void) loadDatas{
    if (_fileArray) {
        [_fileArray release];
        _fileArray = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getConferenceFilesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _fileArray = [array retain];
    }
    [helper release];
}

-(void) sendEmail:(NSString *)email{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper sendEmailByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId email:email conferenceFilesId:_currentfile.fileId];
    if (helper.error) {
        _error = [helper.error retain];
    }
    [helper release];
}

@end
