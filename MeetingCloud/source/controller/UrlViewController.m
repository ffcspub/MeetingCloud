//
//  UrlViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-18.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "UrlViewController.h"
#import <Foundation/Foundation.h>
#import "ShareManager.h"
#import "UITools.h"

@interface UrlViewController ()

@end

@implementation UrlViewController

@synthesize module = _module;

-(void) dealloc{
    _webView.delegate = nil;
    [_module release];
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
    [titleLable setText:self.title];
    
//    UITapGestureRecognizer* singleRecognizer;  
//    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];  
//    singleRecognizer.delegate = self;
//    singleRecognizer.numberOfTapsRequired = 1; // 单击  
//    [_webView addGestureRecognizer:singleRecognizer];  
//    
//    // 双击的 Recognizer  
//    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowbar)];  
//    doubleRecognizer.numberOfTapsRequired = 2; // 双击  
//    doubleRecognizer.delegate = self;
//    [_webView addGestureRecognizer:doubleRecognizer];  
//    
//    // 关键在这一行，如果双击确定偵測失败才會触发单击  
//    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];  
//    [singleRecognizer release];  
//    [doubleRecognizer release];  
    
    
    [self loadUrl];
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:_webView];
        [_webView addSubview:_hud];
        [_hud release];
    }
    [_hud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud hide:YES afterDelay:0.2];
}

-(void) loadUrl{
    NSString *params = [NSString stringWithFormat:@"&hyyUserId=%@&hyyConfId=%@&hyyImei=%@&time=%@",[ShareManager getInstance].userInfo.userId,[ShareManager getInstance].conference.conferenceId,[UITools getImisi],[UITools myDate:@"yyyyMMddhhmmss" dates:0] ];
    NSString *urlStr = [_module.url stringByAppendingString:params];
    // remove all cached responses
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //    // set an empty cache
    //    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    //    [NSURLCache setSharedURLCache:sharedCache];// remove the cache for a particular request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [_webView loadRequest:request];
}

#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)nextBtnClicked:(id)sender{
    [_webView goForward];
}

-(IBAction)passBtnClicked:(id)sender{
    [_webView goBack];
}

-(IBAction)refreshBtnClicked:(id)sender{
    [_webView reload];
}

-(void)hideOrShowbar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    if (navBar.frame.origin.y  == self.view.frame.size.height) {
        [navBar setFrame:CGRectMake(0.0, self.view.frame.size.height - navBar.frame.size.height, navBar.frame.size.width, navBar.frame.size.height)];
    }else {
         [navBar setFrame:CGRectMake(0.0, self.view.frame.size.height, navBar.frame.size.width, navBar.frame.size.height)];
    }
    [UIView commitAnimations];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}



@end
