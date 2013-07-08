//
//  YiChenViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "YiChenViewController.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "MBProgressHUD.h"

static NSString *LEFTCELLIDENTIFIER = @"LEFTCELLIDENTIFIER";
static NSString *RIGHTCELLIDENTIFIER = @"RIGHTCELLIDENTIFIER";

#define TAG_FIRST 1
#define TAG_DATEAGENDAS 2
#define TAG_AGENDASINDEX 3

@interface YiChenViewController (private)

-(void) loadDateAgendas;

-(void) loadAgendasByIndex;

-(void) firstLoad;

-(void) welcomeLableAction;

@end

@implementation YiChenViewController

@synthesize tv_left = _tv_left;
@synthesize tv_right = _tv_right;
@synthesize lb_welcome = _lb_welcome;

-(void) dealloc{
    [_dateAgendas release];
    [_singAgendas release];
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
    NSString *welcome = [ShareManager getInstance].conference.welcome;
    if (welcome) {
        NSString *welcomeString = [[[welcome stringByReplacingOccurrencesOfString:@"@@" withString:[[ShareManager getInstance]userInfo].name] stringByReplacingOccurrencesOfString:@"##" withString:[ShareManager getInstance].conference.name]stringByReplacingOccurrencesOfString:@"%%" withString:[[ShareManager getInstance]userInfo].job];
        
        CGSize size = [welcomeString sizeWithFont:_lb_welcome.font];
        _lb_welcome.text = welcomeString;
        _lb_welcome.frame = CGRectMake(_lb_welcome.frame.origin.x, _lb_welcome.frame.origin.y, size.width, _lb_welcome.frame.size.height);
        welcome = welcomeString;
    }else {
        welcome = [NSString stringWithFormat:@"欢迎参加%@",[ShareManager getInstance].conference.name ];
    }
    [_lb_welcome setText:welcome];
    
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
        if (hud.tag == TAG_AGENDASINDEX) {
            [_tv_right reloadData];
            [_tv_right scrollsToTop];
        }
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tv_left) {
        return [_dateAgendas count];
    }else {
        return [_singAgendas count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    
    if (tableView == _tv_left) {
        Agenda *agenda = [_dateAgendas objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:LEFTCELLIDENTIFIER];
        if (!cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LEFTCELLIDENTIFIER];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_bg_hover.png"]];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 59, 22)];
            titleLabel.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
            titleLabel.backgroundColor = [UIColor clearColor];
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
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
        
        NSString *dateStr = [UITools fromFormat:@"yyyy-MM-dd" toFormat:@"MM-dd" dateStr:agenda.agendDate];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
        titleLabel.text = dateStr;
        UILabel *titleLabel1 = (UILabel *)[cell viewWithTag:102];
        titleLabel1.text = agenda.agendWeek;
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
        Agenda *agenda = [_singAgendas objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:RIGHTCELLIDENTIFIER];
        if (!cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RIGHTCELLIDENTIFIER];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UILabel *nameLale =  [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 250, 22)];
            nameLale.textColor=[UIColor colorWithRed:0.55 green:0.22 blue:0.4 alpha:1.0];
            [nameLale setFont:[UIFont systemFontOfSize:15]];
            nameLale.backgroundColor = [UIColor clearColor];
            nameLale.tag = 100;
            [cell addSubview:nameLale];
            [nameLale release];
            
            UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 42, 250, 22)];
            titleLabel1.textColor=[UIColor colorWithRed:0.55 green:0.22 blue:0.4 alpha:1.0];
            [titleLabel1 setFont:[UIFont systemFontOfSize:15]];
            titleLabel1.backgroundColor = [UIColor clearColor];
            titleLabel1.tag = 101;
            [cell addSubview:titleLabel1];
            [titleLabel1 release];
            
            float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];  
            UIImage *contentLableBackImage = nil;
            if (iosVersion >= 5.0)  
            {
                contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 20)];
            }else {
                contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10];
            }
            
            UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 66, 243, 42)];
            backImageView.tag = 103;
            [backImageView setImage:contentLableBackImage];
            
            [cell addSubview:backImageView];
            UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 77, 230, 22)];
            titleLabel2.textColor=[UIColor grayColor];
            titleLabel2.backgroundColor = [UIColor clearColor];
            titleLabel2.tag = 102;
            [titleLabel2 setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:titleLabel2];
            [titleLabel2 release];
        }
        UILabel *nameLable = (UILabel *)[cell viewWithTag:100];
        UILabel *titleLable1 = (UILabel *)[cell viewWithTag:101];
        UILabel *titleLabel2 = (UILabel *)[cell viewWithTag:102];
        UIImageView *backImageView = (UIImageView *)[cell viewWithTag:103];
        [nameLable setText:[NSString stringWithFormat:@"议程:%@",agenda.name]];
        [nameLable reSizeMake];
        if (nameLable.frame.size.height <= 22) {
            titleLable1.frame = CGRectMake(12, 42, 250, 22);
            titleLabel2.frame = CGRectMake(12, 77, 230, 22);
            backImageView.frame = CGRectMake(8, 66, 243, 42);
        }else{
            titleLable1.frame = CGRectMake(12, 42 + nameLable.frame.size.height - 22, 250, 22);
            titleLabel2.frame = CGRectMake(12, 77 + nameLable.frame.size.height - 22, 230, 22);
            backImageView.frame = CGRectMake(8, 66 + nameLable.frame.size.height - 22, 243, 42);
        }
        NSString *fromdateStr = [UITools fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm" dateStr:agenda.starttime];
         NSString *enddateStr = [UITools fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm" dateStr:agenda.endtime];
        [titleLable1 setText:[NSString stringWithFormat:@"时间:%@ - %@",fromdateStr,enddateStr ]];
        NSString *infoStr = [NSString stringWithFormat:@"%@",agenda.content];
        
        [titleLabel2 setText:infoStr];
        [titleLabel2 reSizeMake];
        if (titleLabel2.frame.size.height == 0 ) {
            titleLabel2.frame = CGRectMake(titleLabel2.frame.origin.x, titleLabel2.frame.origin.y, titleLabel2.frame.size.width, 22);
        }
        
        backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, backImageView.frame.size.width, 42 + titleLabel2.frame.size.height - 22);
        
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tv_left) {
        return 67.0;
    }
    Agenda *agenda = [_singAgendas objectAtIndex:indexPath.row];
    NSString *infoStr = [NSString stringWithFormat:@"%@\n",agenda.content];

    CGFloat nameSubHeight = 0;
    CGSize nameSize = [agenda.name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(250,1000) lineBreakMode:UILineBreakModeWordWrap];
    if (nameSize.height > 22) {
        nameSubHeight = nameSize.height - 22;
    }
    CGSize titleSize = [infoStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(230,1000) lineBreakMode:UILineBreakModeWordWrap];
    return titleSize.height + 90 + nameSubHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tv_left) {
        selectedIndex = indexPath.row;
        [tableView reloadData];
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.tag = TAG_AGENDASINDEX;
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(loadAgendasByIndex) onTarget:self withObject:nil animated:YES];
    }

}



#pragma mark -Action
-(IBAction)cancelBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation YiChenViewController(private)

-(void) firstLoad{
    [self loadDateAgendas];
    if (!_error && _dateAgendas && [_dateAgendas count]>0) {
         [self loadAgendasByIndex];
    }
}
     
-(void) loadDateAgendas{
    if (_dateAgendas) {
        [_dateAgendas release];
        _dateAgendas = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getAgendasByConferenceId:[[ShareManager getInstance]conference].conferenceId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _dateAgendas = [array retain];
    }
    [helper release];
}

-(void) loadAgendasByIndex{
    if (_singAgendas) {
        [_singAgendas release];
        _singAgendas = nil;
    }
    Agenda *agenda = [_dateAgendas objectAtIndex:selectedIndex];
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getAgendaInfosByConferenceId:[[ShareManager getInstance]conference].conferenceId agendDate:agenda.agendDate];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _singAgendas = [array retain];
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


@end