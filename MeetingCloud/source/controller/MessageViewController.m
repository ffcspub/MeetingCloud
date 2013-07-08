//
//  MessageViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "MessageViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#import "Entitys.h"
#import "FaceView.h"
#import "MessageMoreViewController.h"
#import "WriteMessageViewController.h"

@interface MessageViewController (private)

-(void) loadDatas;

@end

@implementation MessageViewController


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
    [self btn_inboxClicked:nil];
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
#pragma mark - UITableViewDelegate/UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageMoreViewController *vlc = [[MessageMoreViewController alloc]initWithNibName:@"MessageMoreViewController" bundle:nil];
    vlc.currentIndex = indexPath.row;
    vlc.msgArray = _datas;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *textColor = [UIColor colorWithRed:0.87 green:0.49 blue:0.24 alpha:1.0];
    static NSString *MSGCELLIDENTIFIER = @"MSGCELLIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSGCELLIDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MSGCELLIDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        [nameLable setTextColor:textColor];
        [nameLable setBackgroundColor:[UIColor clearColor]];
        nameLable.tag = 10;
        nameLable.font = [UIFont boldSystemFontOfSize:17];
        [cell addSubview:nameLable];
        [nameLable release];
        
        UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 120, 20)];
        [timeLable setTextColor:[UIColor grayColor]];
        [timeLable setBackgroundColor:[UIColor clearColor]];
        [timeLable setFont:[UIFont systemFontOfSize:13]];
        timeLable.tag = 11;
        [cell addSubview:timeLable];
        [timeLable release];
        
        FaceView *contentLable = [[FaceView alloc]initWithFrame:CGRectMake(10, 35, 280, 20)];
        [contentLable setBackgroundColor:[UIColor clearColor]];
        contentLable.noResizeable = YES;
        contentLable.tag = 12;
        [cell addSubview:contentLable];
        [contentLable release];
        
    }
    
    UILabel *nameLable = (UILabel *)[cell viewWithTag:10];
    UILabel *timeLable = (UILabel *)[cell viewWithTag:11];
    FaceView *contentLable = (FaceView *)[cell viewWithTag:12];
    
    Privatemessage *message = [_datas objectAtIndex:indexPath.row];
    [nameLable setText:message.userInfo.name];
    [timeLable setText:[UITools fromFormat:@"yyyy-MM-dd hh:mm:ss" toFormat:@"yyyy-MM-dd hh:mm" dateStr:message.createdate]];
    [contentLable setContent:message.content];
    return cell;
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        [_tableView reloadData];
    }
}

#pragma mark -Action
-(IBAction) backBtnClicked:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction) btn_inboxClicked:(id)sender{
    if (index != 1) {
        [btn_inbox setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg_hover.png"] forState:UIControlStateNormal];
        [btn_inbox setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg.png"] forState:UIControlStateHighlighted];
        [btn_inbox setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_inbox setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        
        [btn_sender setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg_hover.png"] forState:UIControlStateHighlighted];
        [btn_sender setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg.png"] forState:UIControlStateNormal];
        [btn_sender setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn_sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        index = 1;
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(loadDatas) onTarget:self withObject:nil animated:YES];
    }
    
}

-(IBAction) btn_senderClicked:(id)sender{
    if (index != 2) {
        [btn_sender setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg_hover.png"] forState:UIControlStateNormal];
        [btn_sender setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg.png"] forState:UIControlStateHighlighted];
        [btn_sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_sender setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        
        [btn_inbox setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg_hover.png"] forState:UIControlStateHighlighted];
        [btn_inbox setBackgroundImage:[UIImage imageNamed:@"latter_nav_bg.png"] forState:UIControlStateNormal];
        [btn_inbox setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn_inbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        index = 2;
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(loadDatas) onTarget:self withObject:nil animated:YES];
    }
}

-(IBAction) btn_writerClicked:(id)sender{
    WriteMessageViewController *vlc = [[WriteMessageViewController alloc]initWithNibName:@"WriteMessageViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}


@end

@implementation MessageViewController(private)

-(void) loadDatas{
    if (_datas) {
        [_datas release];
        _datas = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    
    if (index == 1) {
        NSArray *array = [helper getReceivePrivatemessagesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId];
        if (helper.error) {
            _error = [helper.error retain];
        }else {
            _datas = [array retain];
        }
    }else if (index == 2) {
        NSArray *array = [helper getSendedPrivatemessagesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId];
        if (helper.error) {
            _error = [helper.error retain];
        }else {
            _datas = [array retain];
        }
    }
    [helper release];
}

@end
