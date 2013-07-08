//
//  DinnerViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "DinnerViewController.h"
#import "DinnerTableViewController.h"
#import "DinnerGroupViewController.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "MBProgressHUD.h"

static NSString *LEFTCELLIDENTIFIER = @"LEFTCELLIDENTIFIER";
static NSString *RIGHTCELLIDENTIFIER = @"RIGHTCELLIDENTIFIER";

#define TAG_FIRST 1
#define TAG_DATEDinner 2
#define TAG_DinnerINDEX 3
#define TAG_MODULE 4

@interface DinnerViewController (private)

-(void) loadDateDinner;

-(void) loadDinnerByIndex;

-(void) firstLoad;

-(void) welcomeLableAction;

-(void)loadDinnerTable:(id)sender;

-(void) loadDinnerTableView:(DinnerPlan *) plan;

@end

@implementation DinnerViewController

@synthesize tv_left = _tv_left;
@synthesize tv_right = _tv_right;
@synthesize lb_welcome = _lb_welcome;

-(void) dealloc{
    [_dateDinner release];
    [_singDinner release];
    [_tv_left release];
    [_tv_right release];
    [_lb_welcome release];
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
    Conference *confernce = [ShareManager getInstance].conference;
    NSString *welcome = [[[confernce.welcome stringByReplacingOccurrencesOfString:@"@@" withString:[[ShareManager getInstance]userInfo].name] stringByReplacingOccurrencesOfString:@"##" withString:confernce.name]stringByReplacingOccurrencesOfString:@"%%" withString:[[ShareManager getInstance]userInfo].job];

      
    CGSize size = [welcome sizeWithFont:_lb_welcome.font];
    [_lb_welcome setText:welcome];
    _lb_welcome.frame = CGRectMake(_lb_welcome.frame.origin.x, _lb_welcome.frame.origin.y, size.width, _lb_welcome.frame.size.height);
    if ([_lb_welcome.text length] >20) {
        [self welcomeLableAction];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    hud.tag = TAG_FIRST;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(firstLoad) onTarget:self withObject:nil animated:YES];
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

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        if (hud.tag == TAG_FIRST) {
            [_tv_left reloadData];
            [_tv_right reloadData];
        }
        if (hud.tag == TAG_DinnerINDEX) {
            [_tv_right reloadData];
            [_tv_right scrollsToTop];
        }
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tv_left) {
        return [_dateDinner count];
    }else {
        return [_singDinner count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    
    if (tableView == _tv_left) {
        DinnerPlan *dinnerPlan = [_dateDinner objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:LEFTCELLIDENTIFIER];
        if (!cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LEFTCELLIDENTIFIER];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_bg_hover.png"]];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 59, 22)];
            titleLabel.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.tag = 101;
            [cell addSubview:titleLabel];
            [titleLabel release];
            
            UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 37, 59, 22)];
            titleLabel1.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
            titleLabel1.backgroundColor = [UIColor clearColor];
            titleLabel1.tag = 102;
            [cell addSubview:titleLabel1];
            [titleLabel1 release];
        }
        
        NSString *dateStr = [UITools fromFormat:@"yyyy-MM-dd" toFormat:@"MM-dd" dateStr:dinnerPlan.dinnerDate];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
        titleLabel.text = dateStr;
        UILabel *titleLabel1 = (UILabel *)[cell viewWithTag:102];
        titleLabel1.text = dinnerPlan.dinnerWeek;
        if (indexPath.row == selectedIndex) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_bg_hover.png"]];
            titleLabel.textColor = [UIColor colorWithRed:0.55 green:0.22 blue:0.4 alpha:1.0];
            titleLabel1.textColor = [UIColor colorWithRed:0.55 green:0.22 blue:0.4 alpha:1.0];
        }else {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_bg.png"]];
            titleLabel.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
            titleLabel1.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
        }
    }
    if (tableView == _tv_right) {
        DinnerPlan *dinnerPlan = [_singDinner objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:RIGHTCELLIDENTIFIER];
        if (!cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RIGHTCELLIDENTIFIER];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 250, 22)];
            titleLabel1.textColor=[UIColor grayColor];
            titleLabel1.backgroundColor = [UIColor clearColor];
            titleLabel1.tag = 101;
            [cell addSubview:titleLabel1];
            [titleLabel1 release];
            
            UIImageView *msg_top = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_top.png"]];
            msg_top.frame = CGRectMake(10, 40, msg_top.frame.size.width, msg_top.frame.size.height);
            msg_top.tag = 201;
            [cell addSubview:msg_top];
            [msg_top release];
            
            UIImageView *msg_center = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_center.png"]];
            msg_center.tag = 202;
            //msg_center.contentMode = UIViewContentModeScaleAspectFill;
            msg_center.frame = CGRectMake(10, 40 + msg_top.frame.size.height, msg_center.frame.size.width, 29);
            [cell addSubview:msg_center];
            [msg_center release];
            
            UIView *msg_buttom = [[UIView alloc]initWithFrame:CGRectMake(10, 40 + msg_top.frame.size.height + msg_center.frame.size.height, 243, 29)];
            [msg_buttom setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"meal_msg_button.png"]]];
            msg_buttom.tag = 203;
            [cell addSubview:msg_buttom];
            [msg_buttom release];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(170, 2, 60, 30)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
            [button setImage:[UIImage imageNamed:@"cookbook_icron.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.84 green:0.45 blue:0.21 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button setTitle:@"菜谱" forState:UIControlStateNormal];
            [msg_buttom addSubview:button];
            [button addTarget:self action:@selector(loadDinnerTable:) forControlEvents:UIControlEventTouchUpInside];
            [button release];
            
            UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(40, 2, 160, 30)];
            [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
            [button1 setImage:[UIImage imageNamed:@"cookbook_icron.png"] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor colorWithRed:0.84 green:0.45 blue:0.21 alpha:1.0] forState:UIControlStateNormal];
            [button1.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button1 setTitle:@"分桌名单" forState:UIControlStateNormal];
            [msg_buttom addSubview:button1];
            [button1 addTarget:self action:@selector(loadMyTable:) forControlEvents:UIControlEventTouchUpInside];
            [button1 release];
            
            UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 57, 230, 22)];
            titleLabel2.textColor=[UIColor grayColor];
            titleLabel2.backgroundColor = [UIColor clearColor];
            titleLabel2.tag = 102;
            [cell addSubview:titleLabel2];
            [titleLabel2 release];
        }
        
        UILabel *titleLable1 = (UILabel *)[cell viewWithTag:101];
        UILabel *titleLabel2 = (UILabel *)[cell viewWithTag:102];
        [titleLable1 setText:dinnerPlan.name];
        
        NSString *infoStr = [NSString stringWithFormat:@"%@",dinnerPlan.content];
        
        [titleLabel2 setText:infoStr];
        [titleLabel2 reSizeMake];
        
        UIImageView *msg_center = (UIImageView *)[cell viewWithTag:202];
        msg_center.frame = CGRectMake(msg_center.frame.origin.x, msg_center.frame.origin.y, msg_center.frame.size.width, titleLabel2.frame.size.height - 22 + 29);
        UIView *msg_buttom = (UIView *)[cell viewWithTag:203];
        msg_buttom.frame = CGRectMake(msg_buttom.frame.origin.x, 84 + titleLabel2.frame.size.height - 22, msg_buttom.frame.size.width, msg_buttom.frame.size.height);
        UIButton *button = [msg_buttom.subviews objectAtIndex:[msg_buttom.subviews count] - 2];
        button.tag = indexPath.row;
        if (!dinnerPlan.menus || [dinnerPlan.menus length]==0) {
            [button setHidden:YES];
        }else{
            [button setHidden:NO];
        }
        UIButton *button1 = [msg_buttom.subviews lastObject];
        button1.tag = indexPath.row;
        if (!dinnerPlan.dinnerTables) {
            [button1 setHidden:YES];
        }else{
            [button1 setHidden:NO];
        }
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tv_left) {
        return 67.0;
    }
    DinnerPlan *plan = [_singDinner objectAtIndex:indexPath.row];
    NSString *infoStr = [NSString stringWithFormat:@"%@",plan.content];
    CGSize titleSize = [infoStr sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(230,1000) lineBreakMode:UILineBreakModeWordWrap];
    return titleSize.height + 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tv_left) {
        selectedIndex = indexPath.row;
        [tableView reloadData];
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.tag = TAG_DinnerINDEX;
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(loadDinnerByIndex) onTarget:self withObject:nil animated:YES];
    }
    
}



#pragma mark -Action
-(IBAction)cancelBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation DinnerViewController(private)

-(void) firstLoad{
    [self loadDateDinner];
    if (!_error && _dateDinner && [_dateDinner count]>0) {
        [self loadDinnerByIndex];
    }
}

-(void) loadDateDinner{
    if (_dateDinner) {
        [_dateDinner release];
        _dateDinner = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getDinnerplansByConferenceId:[[ShareManager getInstance]conference].conferenceId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _dateDinner = [array retain];
    }
    [helper release];
}

-(void) loadDinnerByIndex{
    if (_singDinner) {
        [_singDinner release];
        _singDinner = nil;
    }
    DinnerPlan *dinnerPlan = [_dateDinner objectAtIndex:selectedIndex];
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getDinnerplansByConferenceId:[[ShareManager getInstance]conference].conferenceId dinnerDate:dinnerPlan.dinnerDate];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _singDinner = [array retain];
        for (DinnerPlan *plan in array) {
            HttpHelper *helper1 = [[HttpHelper alloc]init];
            NSArray *array1 =[helper1 getDinnertablesByConferenceId:[[ShareManager getInstance]conference].conferenceId dinnerplanId:plan.planId];
            if (array1 && [array1 count]>0) {
                plan.dinnerTables = array1;
            }
            [helper1 release];
            helper1 = nil;
        }
    }
    [helper release];
}

-(void)welcomeLableAction{
    CGRect frame = _lb_welcome.frame;
	frame.origin.x = 300;
	_lb_welcome.frame = frame;
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:8.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationRepeatCount:999999];
	frame = _lb_welcome.frame;
	frame.origin.x = -frame.size.width;
	_lb_welcome.frame = frame;
	[UIView commitAnimations];
}

-(void)loadDinnerTable:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    DinnerPlan *plan = [_singDinner objectAtIndex:index];
    DinnerTableViewController *vlc = [[DinnerTableViewController alloc]initWithNibName:@"DinnerTableViewController" bundle:nil];
    vlc.dinnerPlan = plan;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void)loadMyTable:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    DinnerPlan *plan = [_singDinner objectAtIndex:index];
    NSArray *dinnerTables = plan.dinnerTables;
    DinnerGroupViewController *vlc = [[DinnerGroupViewController alloc]initWithNibName:@"DinnerGroupViewController" bundle:nil];
    vlc.datas = dinnerTables;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}


@end