//
//  DinnerViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "GroupViewController.h"
#import "DinnerTableViewController.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "MBProgressHUD.h"
#import "FTCoreTextView.h"

static NSString *GROUPCELLIFIER = @"GROUPCELLIFIER";


@interface GroupViewController (private)

-(void) loadData;

-(void) search;

@end

@implementation GroupViewController

@synthesize tableView = _tableView;
@synthesize tf_search = _tf_search;

-(void) dealloc{
    [_tableView release];
    [_tf_search release];
    [_resultDatas release];
    [_datas release];
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

- (void)textFieldChange
{    
    [self search];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
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
        [_tableView reloadData];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    Talkgroup *group = [_resultDatas objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:GROUPCELLIFIER];
    if (!cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GROUPCELLIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 250, 22)];
        titleLabel1.textColor=[UIColor colorWithRed:0.85 green:0.42 blue:0.16 alpha:1.0];
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.tag = 101;
        [cell addSubview:titleLabel1];
        [titleLabel1 release];
        
        float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];  
        UIImage *contentLableBackImage = nil;
        if (iosVersion >= 5.0)  
        {  
            contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10)];
        }else {
            contentLableBackImage = [[UIImage imageNamed:@"msg_backgroud.png"]stretchableImageWithLeftCapWidth:30 topCapHeight:10];
        }
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 300, 42)];
        backImageView.tag = 103;
        [backImageView setImage:contentLableBackImage];
        
        [cell addSubview:backImageView];
        
        FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(15, 55, 290, 22)];
        coreTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [coreTextView addStyles:[UITools coreTextStyle]];
        coreTextView.tag = 102;
        [cell addSubview:coreTextView];
        [coreTextView release];
        /*
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 290, 22)];
        titleLabel2.textColor=[UIColor grayColor];
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.tag = 102;
        [cell addSubview:titleLabel2];
        [titleLabel2 release];
         */
    }
    
    UILabel *titleLable1 = (UILabel *)[cell viewWithTag:101];
    [titleLable1 setText:[NSString stringWithFormat:@"%@",group.groupname]];
    
    /*
    UILabel *titleLabel2 = (UILabel *)[cell viewWithTag:102];
    NSString *infoStr = [NSString stringWithFormat:@"%@",group.content];
    
    [titleLabel2 setText:[NSString stringWithFormat:@"%@\n成员：%@",infoStr,group.groupUsers]];
    [titleLabel2 reSizeMake];
     */
    FTCoreTextView *coreTextView = (FTCoreTextView *)[cell viewWithTag:102];
    NSString *infoStr = [NSString stringWithFormat:@"%@",group.content];
   
    if (!group.groupUsers || [group.groupUsers length]==0) {
    }else {
        infoStr = [NSString stringWithFormat:@"%@\n成员：%@",infoStr,group.groupUsers];
    }
    NSString *strtemp = [infoStr stringByReplacingOccurrencesOfString:_tf_search.text withString:[NSString stringWithFormat:@"<hightColor>%@</hightColor>",_tf_search.text]];
    
    coreTextView.text = strtemp;
    
    [coreTextView fitToSuggestedHeight];
    
    UIImageView *backImageView = (UIImageView *)[cell viewWithTag:103];
    //backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, backImageView.frame.size.width, 42 + titleLabel2.frame.size.height - 22);
    backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, backImageView.frame.size.width, 42 + coreTextView.frame.size.height - 22);
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Talkgroup *group = [_resultDatas objectAtIndex:indexPath.row];
    
    FTCoreTextView *coreTextView = [[[FTCoreTextView alloc] initWithFrame:CGRectMake(15, 55, 290, 22)]autorelease];
    coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [coreTextView addStyles:[UITools coreTextStyle]];
    NSString *infoStr = [NSString stringWithFormat:@"%@",group.content];
    
    if (!group.groupUsers || [group.groupUsers length]==0) {
    }else {
        infoStr = [NSString stringWithFormat:@"%@\n成员：%@",infoStr,group.groupUsers];
    }
    NSString *strtemp = [infoStr stringByReplacingOccurrencesOfString:_tf_search.text withString:[NSString stringWithFormat:@"<hightColor>%@</hightColor>",_tf_search.text]];
    
    coreTextView.text = strtemp;

    [coreTextView fitToSuggestedHeight];
    
    return coreTextView.frame.size.height - 22 + 87;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}


#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchBtnClicked:(id)sender{
    [self search];
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

@implementation GroupViewController(private)

-(void) loadData{
    if (_datas) {
        [_datas release];
        _datas = nil;
    }
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getTalkGroupByConferenceId:[ShareManager getInstance].conference.conferenceId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        _datas = [array retain];
    }
    [helper release];
    [self search];
}

-(void) search{
    if (_resultDatas) {
        [_resultDatas release];
        _resultDatas = nil;
    }
    NSString *str = _tf_search.text;
    if (!str || [str length] ==0) {
        _resultDatas = [_datas retain];
        return;
    }
     NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Talkgroup *grouptemp in _datas) {
        Talkgroup *group = [grouptemp copy];
        NSString *content = group.content;
        NSRange range = [content rangeOfString:str];
        if (range.location != NSNotFound) {
            [array addObject:group];
            continue;
        }else if(group.groupUsers){
            NSRange range = [group.groupUsers rangeOfString:str];
            if (range.location != NSNotFound) {
                [array addObject:group];
                continue;
            }
        }
    }
    _resultDatas = array;
}



@end