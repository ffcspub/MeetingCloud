//
//  MessageMoreViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-13.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "MessageMoreViewController.h"
#import "WriteMessageViewController.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "ShareManager.h"

@interface MessageMoreViewController (private)

-(void) messageDelete;

@end

@implementation MessageMoreViewController

@synthesize msgArray = _msgArray;
@synthesize currentIndex = _currentIndex;

-(void) dealloc{
    [_msgArray release];
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

    [self upUI];
    // Do any additional setup after loading the view from its nib.
}

-(void) upUI{
    Privatemessage *_message = [_msgArray objectAtIndex:_currentIndex];
    [lb_name setText:_message.userInfo.name];
    [lb_time setText:_message.createdate];
    [faceView setContent:_message.content];
    if ((faceView.frame.size.height +  faceView.frame.origin.y)>self.view.frame.size.height ) {
        [scrollerView setContentSize:CGSizeMake(scrollerView.frame.size.width, faceView.frame.size.height +  faceView.frame.origin.y - 45)];
    }
    if (_currentIndex == 0 ) {
        [btn_last setEnabled:NO];
    }else {
        [btn_last setEnabled:YES];
    }
    
    if (_currentIndex == [_msgArray count]-1 ) {
        [btn_next setEnabled:NO];
    }else {
        [btn_next setEnabled:YES];
    }
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
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)latterNextClicked:(id)sender{
    if (_currentIndex < [_msgArray count]-1) {
        _currentIndex ++ ;
    }
    [self upUI];
}

-(IBAction)latterLastClicked:(id)sender{
    if (_currentIndex > 0) {
        _currentIndex -- ;
    }

     [self upUI];
}

-(IBAction)latterReSendClicked:(id)sender{
    WriteMessageViewController *vlc = [[WriteMessageViewController alloc]initWithNibName:@"WriteMessageViewController" bundle:nil];
    Privatemessage *_message = [_msgArray objectAtIndex:_currentIndex];
    vlc.context = _message.content;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(IBAction)latterDeleteClicked:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定要删除吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
    }

#pragma  mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate = self;
        [self.view addSubview:hud];
        [hud release];
        [hud showWhileExecuting:@selector(messageDelete) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        if ([_msgArray count] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if(_currentIndex > ([_msgArray count]-1)){
            _currentIndex = [_msgArray count]-1;
            [self upUI];
        }
    }
}

@end

@implementation MessageMoreViewController(private)


-(void) messageDelete{
    Privatemessage *_message = [_msgArray objectAtIndex:_currentIndex];
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper delPrivateMessageByPrivatemessageId:_message.messageId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        [_msgArray delete:_message];
    }
    [helper release];
}

@end
