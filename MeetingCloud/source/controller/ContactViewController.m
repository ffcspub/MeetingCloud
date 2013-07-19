//
//  ContactViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-6.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ContactViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "MBProgressHUD.h"
#import "UITools.h"
#import "ContactInfoViewController.h"
#import "FTCoreTextView.h"
#import "SVPullToRefresh.h"

#define CONTACTCELLIDENTIFIER @"CONTACTCELLIDENTIFIER"

@interface ContactViewController (private)

-(void) loadData;

-(void) search;

-(void) indexPinyin;

-(void) reloadSearch;

-(void)reloadDatas;

@end

@implementation ContactViewController

@synthesize tableView = _tableView;
@synthesize tf_search = _tf_search;
@synthesize selectMode;

-(void) dealloc{
    [_tableView release];
    [_datas release];
    [_resultDatas release];
    [_tf_search release];
    [_aIndexDictionary release];
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
    [self reloadSearch];
    // Do any additional setup after loading the view from its nib.
    
    _datas = [[NSMutableArray alloc] init];
    
    __block typeof(self) bself = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [bself loadData];
    }];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [bself reloadDatas];
    }];
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateAll];
    [self.tableView.pullToRefreshView setTitle:@"松开刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"正在加载" forState:SVPullToRefreshStateLoading];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)textFieldChange
{    
    [self search];
    [_tableView reloadData];
}


-(void) viewWillAppear:(BOOL)animated{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self     
                     selector:@selector(textFieldChange)     
                         name:UITextFieldTextDidChangeNotification     
                       object:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo *user = [_resultDatas objectAtIndex:indexPath.row];
    if(selectMode){
        NSMutableArray *array = [ShareManager getInstance].personArray;
        if (!array) {
            array = [NSMutableArray array];
            [ShareManager getInstance].personArray = array;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.accessoryType == UITableViewCellAccessoryNone){
            [array addObject:user];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            [array removeObject:user];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else {
        ContactInfoViewController *vlc = [[ContactInfoViewController alloc]initWithNibName:@"ContactInfoViewController" bundle:nil];
        vlc.userinfo = user;
        [self.navigationController pushViewController:vlc animated:YES];
        [vlc release];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CONTACTCELLIDENTIFIER];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CONTACTCELLIDENTIFIER]autorelease];
        FTCoreTextView *lb_name = [[FTCoreTextView alloc]initWithFrame:CGRectMake(15, 13, 70, 30)];
        [lb_name addStyles:[UITools coreTextStyle]];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.tag = 101;
        [cell addSubview:lb_name];
        [lb_name release];
        
        UILabel *lb_job = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 170, 20)];
        [lb_job setBackgroundColor:[UIColor clearColor]];
        lb_job.tag = 103;
        lb_job.textColor = [UIColor redColor];
        lb_job.font = [UIFont systemFontOfSize:13];
        lb_job.numberOfLines = 3;
        [cell addSubview:lb_job];
        [lb_job release];
        
        FTCoreTextView *lb_company = [[FTCoreTextView alloc]initWithFrame:CGRectMake(180, 0, 100, 44)];
        [lb_company addStyles:[UITools coreTextStyle]];
        //lb_company.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lb_company.tag = 102;
        [cell addSubview:lb_company];
        [lb_company release];
        if(selectMode){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FTCoreTextView *lb_name = (FTCoreTextView *)[cell viewWithTag:101];
    FTCoreTextView *lb_company = (FTCoreTextView *)[cell viewWithTag:102];
    UILabel *lb_job = (UILabel *)[cell viewWithTag:103];
    lb_company.frame = CGRectMake(180, 0, 100, 0);
    UserInfo *user = [_resultDatas objectAtIndex:indexPath.row];
    if (selectMode) {
        if ([[ShareManager getInstance].personArray containsObject:user]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    NSString *str = _tf_search.text;
    NSString *name = user.name;
    NSString *company = user.city;
    NSString *job = user.job;
    if (str) {
        name = [user.name stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"<hightColor>%@</hightColor>",str]];
        company = [user.city stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"<hightColor>%@</hightColor>",str]];
        NSString *pinying = [user.name pinyin];
        NSRange ranger = [pinying rangeOfString:[_tf_search.text lowercaseString]];
        if (ranger.location != NSNotFound){
            NSString *strtemp = [user.name substringWithRange:ranger];
            name = [user.name stringByReplacingOccurrencesOfString:strtemp withString:[NSString stringWithFormat:@"<hightColor>%@</hightColor>",strtemp]];
        }
    }
    if (job && [job length]>0) {
        lb_name.frame = CGRectMake(15, 7, 70, 30);
        lb_job.text = [NSString stringWithFormat:@"(%@)",job];
    }else{
        lb_name.frame = CGRectMake(15, 15, 70, 30);
        lb_job.text = @"";
    }
    lb_name.text = [NSString stringWithFormat:@"<nameStyle>%@</nameStyle>",name];
    if (company && [company length]>0) {
        lb_company.text = [company stringByAppendingTagName:@"companyStyle"];
    }else {
        lb_company.text = @" ";
    }
    [lb_company fitToSuggestedHeight];
    //[lb_company setCenter:CGPointMake(lb_company.center.x, 22 - (44 - lb_company.frame.size.height)/2) ];
    [lb_company setFrame:CGRectMake(180, (50 - lb_company.frame.size.height -10)/2, lb_company.frame.size.width, lb_company.frame.size.height)];
    
    
    return cell;
}

#pragma mark - MBProgressHUDDelegate;
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        [_tableView reloadData];
    }
    
}

#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchBtnClicked:(id)sender{
    [self search];
    [_tf_search resignFirstResponder];
}

-(IBAction)reloadSearchBtnClicked:(id)sender{
    [self reloadSearch];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField   
{          
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.  
    [textField resignFirstResponder];
    [self search];
    [_tableView reloadData];
    return YES; 
} 


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tf_search resignFirstResponder];
}

@end

@implementation ContactViewController(private)

-(void) loadData{
    pageNum++;
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getUserGroupPageByConferenceId:[ShareManager getInstance].conference.conferenceId ContactgroupId:@"1" pageNum:[NSString stringWithFormat:@"%i", pageNum]];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        if (_datas) {
            if (pageNum == 1) {
                [_datas removeAllObjects];
            }
        }
        [_datas addObjectsFromArray:array];
    }
    isLastPage = helper.isLastPage;
    [helper release];
    [self search];
    [_tf_search resignFirstResponder];
    
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView.pullToRefreshView stopAnimating];
    if (isLastPage) {
        [self.tableView setShowsInfiniteScrolling:NO];
    } else {
        [self.tableView setShowsInfiniteScrolling:YES];
    }
}

-(void)reloadDatas{
    pageNum = 0;
    [self loadData];
}


-(void) search{
    if (_resultDatas) {
        [_resultDatas release];
        _resultDatas = nil;
    }
    NSString *str = _tf_search.text;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (UserInfo *userinfo in _datas) {
            if (![@"1" isEqualToString:userinfo.visible]) {
                continue;
            }
            if (!str || [str length] ==0) {
                UserInfo *temp = [userinfo copy];
                [array addObject:temp];
                continue;
            }
            NSString *name = userinfo.name;
            NSRange ranger = [name rangeOfString:str];
            if (ranger.location == NSNotFound) {
                NSString *company = userinfo.city;
                if (company && [company length] > 0) {
                    ranger = [company rangeOfString:str];
                }
            }
            if (ranger.location == NSNotFound) {
                NSString *pinying = [name pinyin];
                ranger = [pinying rangeOfString:[str lowercaseString]];
            }
            if (ranger.location != NSNotFound){
                UserInfo *temp = [userinfo copy];
                [array addObject:temp];
            }
        }
        _resultDatas = array;
    [self.tableView reloadData];
    
    //[self indexPinyin];
}

-(void) indexPinyin{
    if (_aIndexDictionary) {
        [_aIndexDictionary release];
        _aIndexDictionary = nil;
    }
    NSMutableDictionary *aIndexDictionary = [[NSMutableDictionary alloc] init]; 
    NSMutableArray *currentArray;
    NSRange aRange = NSMakeRange(0, 1);
    NSString *firstLetter;
    for(char c = 'A';c<='Z';c++){
        currentArray = [NSMutableArray array];
        [aIndexDictionary setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",c]];
    }
    for (UserInfo *temp in _resultDatas) {
        firstLetter = [temp.name substringWithRange:aRange];
        currentArray = [aIndexDictionary objectForKey:[firstLetter.pinyin uppercaseString]];
        [currentArray addObject:temp];
    }
    _aIndexDictionary = aIndexDictionary;
}

-(void) reloadSearch{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate =  self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(reloadDatas) onTarget:self withObject:nil animated:YES];
}


@end
