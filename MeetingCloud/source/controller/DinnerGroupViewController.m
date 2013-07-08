//
//  DinnerViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-26.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "DinnerGroupViewController.h"
#import "DinnerTableViewController.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "MBProgressHUD.h"
#import "FTCoreTextView.h"

#import "TTStyledFrame.h"
#import "TTStyledTextLabel.h"
#import "TTStyledText.h"
#import "TTTextStyle.h"
#import "TTDefaultStyleSheet.h"

@interface TextTestStyleSheet :TTDefaultStyleSheet
@end

@implementation TextTestStyleSheet

- (TTStyle*)blueText {
    return [TTTextStyle styleWithColor:[UIColor blueColor] next:nil];
}

- (TTStyle*)redText {
    TTTextStyle *style = [TTTextStyle styleWithColor:[UIColor redColor] next:nil];
    style.font =[UIFont systemFontOfSize:18];
    return style ;
}

@end

static NSString *GROUPCELLIFIER = @"GROUPCELLIFIER";
@implementation DinnerGroupViewController

@synthesize tableView = _tableView;
@synthesize datas = _datas;

-(void) dealloc{
    [_tableView release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
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


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    Dinnertable *dinnerTable = [_datas objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:GROUPCELLIFIER];
    if (!cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GROUPCELLIFIER]autorelease];
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
        
        /*
        FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(15, 55, 290, 22)];
        coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [coreTextView addStyles:[UITools coreTextStyle]];
        coreTextView.tag = 102;
        [cell addSubview:coreTextView];
        [coreTextView release];
         */
        
        [TTStyleSheet setGlobalStyleSheet:[[[TextTestStyleSheet alloc] init]autorelease]];
        
        TTStyledTextLabel *titleLabel2 = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(15, 55, 290, 22)];
        //titleLabel2.textColor=[UIColor grayColor];
        //titleLabel2.highlightedTextColor = [UIColor redColor];
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.tag = 102;
        [cell addSubview:titleLabel2];
        [titleLabel2 release];
         
    }
    
    UILabel *titleLable1 = (UILabel *)[cell viewWithTag:101];
    [titleLable1 setText:[NSString stringWithFormat:@"%@",dinnerTable.name]];
    
    
    TTStyledTextLabel *titleLabel2 = (TTStyledTextLabel *)[cell viewWithTag:102];
    NSString *infoStr = [NSString stringWithFormat:@"%@",dinnerTable.content];
    NSRange range = [infoStr rangeOfString:[ShareManager getInstance].userInfo.name];
    if (range.location != NSNotFound) {
        infoStr = [infoStr stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<span class=\"redText\">%@</span>",[ShareManager getInstance].userInfo.name]];
    }
    TTStyledText *ttext = [TTStyledText textFromXHTML:infoStr lineBreaks:YES URLs:YES];
    ttext.font = [UIFont systemFontOfSize:16];
    ttext.width = 290;
    titleLabel2.text = ttext;
    [titleLabel2 sizeToFit];
    
    /*
    FTCoreTextView *coreTextView = (FTCoreTextView *)[cell viewWithTag:102];
    NSString *infoStr = [NSString stringWithFormat:@"%@",dinnerTable.content];
    coreTextView.text = infoStr;
    [coreTextView fitToSuggestedHeight];
    */
    
    UIImageView *backImageView = (UIImageView *)[cell viewWithTag:103];
    //backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, backImageView.frame.size.width, 42 + titleLabel2.frame.size.height - 22);
    backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, backImageView.frame.size.width, 42 + titleLabel2.frame.size.height - 22);
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Dinnertable *dinnerTable = [_datas objectAtIndex:indexPath.row];
    
    FTCoreTextView *coreTextView = [[[FTCoreTextView alloc] initWithFrame:CGRectMake(15, 55, 290, 22)]autorelease];
    coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [coreTextView addStyles:[UITools coreTextStyle]];
    NSString *infoStr = [NSString stringWithFormat:@"%@",dinnerTable.content];
    
    coreTextView.text = infoStr;

    [coreTextView fitToSuggestedHeight];
    
    return coreTextView.frame.size.height - 22 + 87;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}


#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField   
{          
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.  
    [textField resignFirstResponder];
    [_tableView reloadData];
    return YES; 
} 

@end
