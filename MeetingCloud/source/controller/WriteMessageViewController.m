//
//  WriteMessageViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-13.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "WriteMessageViewController.h"
#import "ShareManager.h"
#import "ContactViewController.h"
#import "HttpHelper.h"
#import "UITools.h"
#import <QuartzCore/QuartzCore.h>

@interface WriteMessageViewController (private)
-(void) senderMessageToUserid:(NSString *)touserid;


@end

@implementation WriteMessageViewController

@synthesize context = _context;

-(void) dealloc{
    [_context release];
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
    tv_content.layer.borderWidth = 1;
    tv_content.layer.borderColor = [[UIColor grayColor] CGColor];
    tv_content.layer.cornerRadius = 8;
    tv_content.layer.masksToBounds = YES;
    [tv_content setText:_context];
    // Do any additional setup after loading the view from its nib.
    [ShareManager getInstance].personArray = nil;
}

-(void) viewWillAppear:(BOOL)animated{
    if ([ShareManager getInstance].personArray) {
        NSMutableString *namestr = [NSMutableString string];
        int i = 0;
        int count = [[ShareManager getInstance].personArray count];
        for (UserInfo *info in [ShareManager getInstance].personArray) {
            [namestr appendString:info.name];
            i++;
            if (i < count) {
                [namestr appendString:@","];
            }
        }
        [lb_person setText:namestr];
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

-(IBAction)sendBtnClicked:(id)sender{
    if (tv_content.text && [tv_content.text length]>0) {
        if( [ShareManager getInstance].personArray && [[ShareManager getInstance].personArray count]>0){
            NSMutableString *namestr = [NSMutableString string];
            int i = 0;
            int count = [[ShareManager getInstance].personArray count];
            for (UserInfo *info in [ShareManager getInstance].personArray) {
                [namestr appendString:info.userId];
                i++;
                if (i < count) {
                    [namestr appendString:@","];
                }
            }
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            hud.tag = 111;
            hud.delegate = self;
            [self.view addSubview:hud];
            [hud release];
            [hud showWhileExecuting:@selector(senderMessageToUserid:) onTarget:self withObject:namestr animated:YES];
        }else {
            [UITools easyAlert:@"请添加收件人" cancelButtonTitle:@"确定"];
        }
        
    }else {
        [UITools easyAlert:@"请输入内容" cancelButtonTitle:@"确定"];
    }
    
}

-(IBAction)addPersonBtnClicked:(id)sender{
    ContactViewController  *vlc = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
    vlc.selectMode = YES;
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}


#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error ) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else if(hud.tag == 111){
        [UITools easyAlert:@"发送成功" cancelButtonTitle:@"确定"];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tv_content resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [self sendBtnClicked:nil];
    }
    return YES;
}

@end

@implementation WriteMessageViewController(private)

-(void) senderMessageToUserid:(NSString *)touserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper sendPrivatemessagesFromUserid:[ShareManager getInstance].userInfo.userId toUserids:touserid content:tv_content.text conferenceId:[ShareManager getInstance].conference.conferenceId parentid:@""];
    if (helper.error) {
        _error = [helper.error retain];
    }
    [helper release];
}


@end