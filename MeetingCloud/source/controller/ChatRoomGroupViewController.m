//
//  ChatRoomGroupViewController.m
//  MeetingCloud
//
//  Created by Geory on 13-7-9.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import "ChatRoomGroupViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#import "SVPullToRefresh.h"
#import "TalkmessageGroup.h"
#import "ChatRoomViewController.h"
#import "CreateChatRoomGroupViewController.h"

@interface ChatRoomGroupViewController ()

@end

@implementation ChatRoomGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)queryTalkMessageGroup
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    NSArray *array = [helper getTalkmessageGroupByConferenceId:[ShareManager getInstance].conference.conferenceId pageNum:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:page]]];
    if (helper.error) {
        _error = [helper.error retain];
    } else {
        if (page == 1) {
            [_talkMessageGroupList removeAllObjects];
        }
        [_talkMessageGroupList addObjectsFromArray:array];
        _isLastPage = helper.isLastPage;
    }
}

- (void)reloadTalkMessageGroup
{
    page = 0;
    [self loadTalkMessageGroup];
}

- (void)loadTalkMessageGroup
{
    page++;
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(queryTalkMessageGroup) onTarget:self withObject:nil animated:YES];
}

- (void)svPullToRefresh
{
    __block typeof(self) bself = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [bself reloadTalkMessageGroup];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [bself loadTalkMessageGroup];
    }];
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateAll];
    [self.tableView.pullToRefreshView setTitle:@"松开刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"正在加载" forState:SVPullToRefreshStateLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _talkMessageGroupList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self svPullToRefresh];
    [self reloadTalkMessageGroup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_talkMessageGroupList release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else{
        [self.tableView reloadData];
        if (page == 1) {
            [self.tableView scrollsToTop];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        if (_isLastPage) {
            [self.tableView setShowsInfiniteScrolling:NO];
        } else {
            [self.tableView setShowsInfiniteScrolling:YES];
        }
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_talkMessageGroupList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TALKMESSAGEGROUPCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TALKMESSAGEGROUPCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    TalkmessageGroup *talkmessageGroup = [_talkMessageGroupList objectAtIndex:indexPath.row];
    cell.textLabel.text = talkmessageGroup.groupname;
    cell.detailTextLabel.text = talkmessageGroup.intro;
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkmessageGroup *talkmessageGroup = [_talkMessageGroupList objectAtIndex:indexPath.row];
    NSString *nibName = @"ChatRoomViewController";
    if (IS_SCREEN_4_INCH) {
        nibName = @"ChatRoomViewController_iPhone5";
    }
    ChatRoomViewController *vlc = [[ChatRoomViewController alloc]initWithNibName:nibName bundle:nil];
    vlc.talkmessageGroup = talkmessageGroup;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addGroupClick:(id)sender {
    if ([@"1" isEqualToString:[ShareManager getInstance].userInfo.isCheckinMgr]) {
        CreateChatRoomGroupViewController *vlc = [[[CreateChatRoomGroupViewController alloc] initWithNibName:@"CreateChatRoomGroupViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:vlc animated:YES];
    } else {
        [UITools easyAlert:@"抱歉！您不是管理员，不能创建分组。" cancelButtonTitle:@"确定"];
    }
}

@end
