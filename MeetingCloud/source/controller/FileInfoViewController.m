//
//  FileInfoViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "FileInfoViewController.h"

@interface FileInfoViewController (private)

-(NSString *) getUrlByIndex:(NSInteger)index;

-(void) loadUrl;

@end

@implementation FileInfoViewController

@synthesize webView = _webView;
@synthesize toolBar = _toolBar;
@synthesize file = _file;

-(void) dealloc{
    [_webView release];
    [_toolBar release];
    [_file release];
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
    
    UITapGestureRecognizer* singleRecognizer;  
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];  
    singleRecognizer.delegate = self;
    singleRecognizer.numberOfTapsRequired = 1; // 单击  
    [_webView addGestureRecognizer:singleRecognizer];  
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowbar)];  
    doubleRecognizer.numberOfTapsRequired = 2; // 双击  
    doubleRecognizer.delegate = self;
    [_webView addGestureRecognizer:doubleRecognizer];  
    
    // 关键在这一行，如果双击确定偵測失败才會触发单击  
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];  
    [singleRecognizer release];  
    [doubleRecognizer release];  

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

#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)lastBtnClicked:(id)sender{
    if (_pageIndex >0) {
        _pageIndex --;
        [self loadUrl];
    }
}

-(IBAction)nextBtnClicked:(id)sender{
    if (_pageIndex < ([_file.picTotal intValue]-1)) {
        _pageIndex ++;
        [self loadUrl];
    }
}

-(IBAction)homeBtnClicked:(id)sender{
    _pageIndex = 0;
    [self loadUrl];
}

-(IBAction)pageBtnClicked:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"目录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int i=1; i<=[_file.picTotal intValue]; i++) {
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"第%d页",i]];
    }
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        _pageIndex = (buttonIndex-1);
        [self loadUrl];
    }
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

@implementation FileInfoViewController(private)

-(NSString *) getUrlByIndex:(NSInteger)index{
    NSMutableString *url = [NSMutableString string];
    if (_file) {
        [url appendString:_file.picPath];
        [url appendString:_file.picNamePrefix];
        [url appendFormat:@"%d.",index];
        [url appendString:_file.picTypeSuffix];
    }
    return url;
}

-(void) loadUrl{
    NSString *urlStr = [self getUrlByIndex:_pageIndex];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    if (_pageIndex == ([_file.picTotal intValue]-1)) {
        [nextBtn setEnabled:NO];
    }else {
        [nextBtn setEnabled:YES];
    }
    if (_pageIndex == 0) {
        [lastBtn setEnabled:NO];
    }else {
        [lastBtn setEnabled:YES];
    }
}

@end
