//
//  MainViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-19.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "MainViewController.h"
#import "TitleButton.h"
#import "Entitys.h"
#import "ShareManager.h"
#import "YiChenViewController.h"
#import "DinnerViewController.h"
#import "ChatRoomGroupViewController.h"
#import "ChatRoomViewController.h"
#import "GroupViewController.h"
#import "ContactViewController.h"
#import "ShareViewController.h"
#import "UserCheckViewController.h"
#import "MessageViewController.h"
#import "CommentViewController.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "ModuleConference.h"
#import "MyButton.h"
#import "UrlViewController.h"
#import "BWStatusBarOverlay.h"
#import "UserCheckCodeViewController.h"

@interface MainViewController (private)

-(void) loadAgendaView;//进入会议议程

-(void) loadDinnerView;//进入用餐安排

-(void) loadChatRoomView;//进入你云我云

-(void) loadGroupView;//进入分组名单

-(void) loadContactView;//进入通讯录

-(void) loadShareView;//进入共享资料

-(void) loadCheckView;//进入签到页面

-(void) loadMessagView;//进入私信

-(void) loadCommentView;//建议

-(void) loadUrlView:(id)sender;

-(void) loadModels;

-(void) loadNotifys;

-(void) checkVersion;

@end

@implementation MainViewController

@synthesize pageGirdView = _pageGirdView;
@synthesize weatherLable = _weatherLable;
@synthesize notifyLable = _notifyLable;
@synthesize nameLable = _nameLable;
@synthesize dateLable = _dateLable;
@synthesize addressLable = _addressLable;
@synthesize faceImageView = _faceImageView;


-(void) dealloc{
    threadFlag = YES;
    [_pageGirdView release];
    [_weatherLable release];
    [_notifyLable release];
    [_nameLable release];
    [_dateLable release];
    [_addressLable release];
    [_faceImageView release];
    [_modules release];
    [_version release];
    _modules = nil;
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

-(void)weatherLableAction{
    CGRect frame = _weatherLable.frame;
	frame.origin.x = 320;
	_weatherLable.frame = frame;
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:8.8f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	
	[UIView setAnimationDelegate:self];  
	[UIView setAnimationRepeatAutoreverses:NO];	 
	[UIView setAnimationRepeatCount:999999]; 
	frame = _weatherLable.frame;
	frame.origin.x = -frame.size.width;
	_weatherLable.frame = frame;
	[UIView commitAnimations]; 
}

-(void)notifyLableAction{
    if ([_notifyLable.text length]<15) {
        return;
    }
    CGRect frame = _notifyLable.frame;
	frame.origin.x = 320;
	_notifyLable.frame = frame;
	[UIView beginAnimations:@"notifyAnimation" context:NULL];
	[UIView setAnimationDuration:8.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationRepeatCount:999999];
	frame = _notifyLable.frame;
	frame.origin.x = -frame.size.width;
	_notifyLable.frame = frame;
	[UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageGirdView.widthInsert = 20;
    _pageGirdView.heightInsert = 40;
    
    Conference *confernce = [[ShareManager getInstance]conference];
    
    NSString *welcomeString = [[[confernce.welcome stringByReplacingOccurrencesOfString:@"@@" withString:[[ShareManager getInstance]userInfo].name] stringByReplacingOccurrencesOfString:@"##" withString:confernce.name]stringByReplacingOccurrencesOfString:@"%%" withString:[[ShareManager getInstance]userInfo].job];
    
    CGSize size = [welcomeString sizeWithFont:self.notifyLable.font];
    self.notifyLable.text = welcomeString;
    self.notifyLable.frame = CGRectMake(_notifyLable.frame.origin.x, _notifyLable.frame.origin.y, size.width, _notifyLable.frame.size.height);
    self.dateLable.text = [NSString stringWithFormat:@"%@至%@",[UITools fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy-MM-dd" dateStr:confernce.startdate],[UITools fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy-MM-dd" dateStr:confernce.enddate]];
    self.addressLable.text = confernce.address;
    self.weatherLable.text = confernce.weather;
    self.nameLable.text = confernce.name;
    if ([@"0" isEqualToString:[ShareManager getInstance].userInfo.sex] ) {
        [_faceImageView setImage:[UIImage imageNamed:@"icon-female.png"]];
    }else if ([@"1" isEqualToString:[ShareManager getInstance].userInfo.sex] ){
        [_faceImageView setImage:[UIImage imageNamed:@"msg_icron.png"]];
    }else {
        [_faceImageView setImage:[UIImage imageNamed:@"icon-none.png"]];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadModels) onTarget:self withObject:nil animated:YES];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelectorInBackground:@selector(loadNotifys) withObject:nil];
    [self performSelectorInBackground:@selector(loadNotifys1) withObject:nil];
    [self performSelectorInBackground:@selector(loadNotifys2) withObject:nil];
    [self performSelectorInBackground:@selector(loadNotifys3) withObject:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [self weatherLableAction];
    [self notifyLableAction];
}

-(void) viewWillUnload{
    NSLog(@"111");
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

#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        [self.pageGirdView reloadData];
        if (![@"1" isEqualToString: _version.nversion]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:_version.updatedsc delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"马上升级", nil];
            alert.tag = 111;
            [alert show];
            [alert release];
        }
    }
    [hud removeFromSuperViewOnHide];
    hud = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 111){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_version.filepath]];
        }
    }
}

#pragma mark - PageGirdViewDataSource
- (int)numberViewOfPageGirdView:(PageGirdView *)pageGirdView{
    if (!_modules) {
        return 0;
    }
    return _modules.count;
}

// 每个组件的视图
- (UIView *)viewWithIndex:(int)index pageGirdView:(PageGirdView *)pageGirdView{
    TitleButton *btn = [[[TitleButton alloc]initWithFrame:CGRectMake(0, 0, 58, 58)]autorelease];
    ModuleConference *module = nil;
    module = [_modules objectAtIndex:index];
    int functionId = [module.functionid intValue];
    NSString  *iconName = module.icon;
    
    NSLog(@"%d:%@",functionId,module.name);
    switch (functionId) {
        case 1:
            [btn setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
            [btn setTitle:@"首页" forState:UIControlStateNormal];
            break;
        case 2:
            [btn setBackgroundImage:[UIImage imageNamed:@"meeting.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadAgendaView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 4:
            [btn setBackgroundImage:[UIImage imageNamed:@"meal.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadDinnerView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 5:
            [btn setBackgroundImage:[UIImage imageNamed:@"you_clound.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadChatRoomView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            [btn setBackgroundImage:[UIImage imageNamed:@"group.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadGroupView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 6:
            [btn setBackgroundImage:[UIImage imageNamed:@"contacts.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadContactView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 7:
            [btn setBackgroundImage:[UIImage imageNamed:@"letter.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadMessagView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 8:
            [btn setBackgroundImage:[UIImage imageNamed:@"sharing.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadShareView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 10:
            [btn setBackgroundImage:[UIImage imageNamed:@"checkin.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadCheckView) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 9:
            [btn setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
            [btn setTitle:module.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loadCommentView) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            [btn setTitle:module.name forState:UIControlStateNormal];
            btn.tag = index;
            [btn addTarget:self action:@selector(loadUrlView:) forControlEvents:UIControlEventTouchUpInside];
            break;
    }
    if (iconName) {
        NSString *name = [[iconName stringByReplacingOccurrencesOfString:@"user/" withString:@""]
                          stringByReplacingOccurrencesOfString:@".gif" withString:@""];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"pic%@.png",name]] forState:UIControlStateNormal];
    }else {
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"pic0.png"]] forState:UIControlStateNormal];
    }
    
    return btn;
}

-(PageGirdViewInsertStyle) insertStyleOfPageGirdView:(PageGirdView *)pageGirdView{
    return PageGirdViewInsertStyle_Same;
}

-(PageGirdViewCompantViewStyle) pageGirdViewCompantViewStyle:(PageGirdView *)pageGirdView{
    return PageGirdViewCompantViewStyle_Same;
}

-(UIImage *) imageWithPageControllerStateNormal{
   return [UIImage imageNamed:@"shlow_hover.png"];
   // return [UIImage imageNamed:@"pc_blue.png"];
}

-(UIImage *) imageWithPageControllerStateHightlighted{
    return  [UIImage imageNamed:@"shlow_on.png"];
    //return  [UIImage imageNamed:@"pc_red.png"];
}


-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES]; 
}

@end

@implementation  MainViewController (private)

-(void) loadAgendaView{
    YiChenViewController *vlc = [[YiChenViewController alloc]initWithNibName:@"YiChenViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadDinnerView{
    DinnerViewController *vlc = [[DinnerViewController alloc]initWithNibName:@"DinnerViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadChatRoomView{
//    NSString *nibName = @"ChatRoomViewController";
//    if (IS_SCREEN_4_INCH) {
//        nibName = @"ChatRoomViewController_iPhone5";
//    }
//    ChatRoomViewController *vlc = [[ChatRoomViewController alloc]initWithNibName:nibName bundle:nil];
//    [self.navigationController pushViewController:vlc animated:YES];
//    [vlc release];
    ChatRoomGroupViewController *vlc = [[[ChatRoomGroupViewController alloc] initWithNibName:@"ChatRoomGroupViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:vlc animated:YES];
}

-(void) loadGroupView{
    GroupViewController *vlc = [[GroupViewController alloc]initWithNibName:@"GroupViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadContactView{
    ContactViewController *vlc = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadShareView{
    ShareViewController *vlc = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadCheckView{
    if([@"1" isEqualToString:[ShareManager getInstance].userInfo.isCheckinMgr]){
        UserCheckViewController *vlc = [[UserCheckViewController alloc]initWithNibName:@"UserCheckViewController" bundle:nil];
        [self.navigationController pushViewController:vlc animated:YES];
        [vlc release];
    }else{
        UserCheckCodeViewController *vlc = [[UserCheckCodeViewController alloc]initWithNibName:@"UserCheckCodeViewController" bundle:nil];
        [self.navigationController pushViewController:vlc animated:YES];
        [vlc release];
    }
}

-(void) loadMessagView{
    MessageViewController *vlc = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadCommentView{
    CommentViewController *vlc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}

-(void) loadUrlView:(id)sender{
    UIButton *btn = (UIButton *) sender;
    int tag = btn.tag;
    ModuleConference *module = [_modules objectAtIndex:tag];
    if ([@"0" isEqualToString: module.functionid] || [@"99" isEqualToString: module.functionid]) {
        UrlViewController *vlc = [[UrlViewController alloc]initWithNibName:@"UrlViewController" bundle:nil];
        vlc.title = module.name;
        vlc.module = module;
        [self.navigationController pushViewController:vlc animated:YES];
        [vlc release];
    }
}

-(void) loadModels{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    NSArray *array = [httphelper getModuleConferencesByUserId:[ShareManager getInstance].userInfo.userId];
    if(httphelper.error){
        _error = [httphelper.error retain];
    }else if(array){
        _modules = [array retain];
        Clientversion *version = [httphelper getVersion];
        if(httphelper.error){
            _error = [httphelper.error retain];
        }else if(version){
            _version = [version retain];
        }
    }
    [httphelper release];
   // [self loadNotifys];
}

-(void) showNotifies{
    if (_notifiyes && [_notifiyes count]>0) {
        ClientPush *push = [_notifiyes objectAtIndex:0];
        NSString *string = push.pushMsg;
        [BWStatusBarOverlay showSuccessWithMessage:string duration:4 animated:YES];
        [_notifiyes removeObject:push];
        [self performSelector:@selector(showNotifies) withObject:nil afterDelay:4];
    }
}

-(void) loadNotifys{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        HttpHelper *httphelper = [[HttpHelper alloc]init];
    while (!threadFlag) {
        NSArray *array = [httphelper getClientPushesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId type:2];
        if (!httphelper.error) {
            @synchronized(_notifiyes){
                if (!_notifiyes) {
                    _notifiyes = [[NSMutableArray alloc]initWithArray:array];
                }
                [_notifiyes addObjectsFromArray:array];
            }
            [self performSelectorOnMainThread:@selector(showNotifies) withObject:nil waitUntilDone:NO];
        }
        sleep(30);
    }
    [httphelper release];
    [pool release];
}

-(void) loadNotifys1{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    while (!threadFlag) {
        NSArray *array = [httphelper getClientPushesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId type:1];
        if (!httphelper.error) {
            @synchronized(_notifiyes){
                if (!_notifiyes) {
                    _notifiyes = [[NSMutableArray alloc]initWithArray:array];
                }
                [_notifiyes addObjectsFromArray:array];
            }
            [self performSelectorOnMainThread:@selector(showNotifies) withObject:nil waitUntilDone:NO];
        }
        sleep(30);
    }
    [httphelper release];
    [pool release];
}

-(void) loadNotifys2{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    while (!threadFlag) {
        NSArray *array = [httphelper getClientPushesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId type:3];
        if (!httphelper.error) {
            @synchronized(_notifiyes){
                if (!_notifiyes) {
                    _notifiyes = [[NSMutableArray alloc]initWithArray:array];
                }
                [_notifiyes addObjectsFromArray:array];
            }
            [self performSelectorOnMainThread:@selector(showNotifies) withObject:nil waitUntilDone:NO];
        }
        sleep(30);
    }
    [httphelper release];
    [pool release];
}

-(void) loadNotifys3{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    while (!threadFlag) {
        NSArray *array = [httphelper getClientPushesByConferenceId:[ShareManager getInstance].conference.conferenceId userId:[ShareManager getInstance].userInfo.userId type:4];
        if (!httphelper.error) {
            @synchronized(_notifiyes){
                if (!_notifiyes) {
                    _notifiyes = [[NSMutableArray alloc]initWithArray:array];
                }
                [_notifiyes addObjectsFromArray:array];
            }
            [self performSelectorOnMainThread:@selector(showNotifies) withObject:nil waitUntilDone:NO];
        }
        sleep(30);
    }
    [httphelper release];
    [pool release];
}

-(void) checkVersion{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    Clientversion *version = [httphelper getVersion];
    if(httphelper.error){
        _error = [httphelper.error retain];
    }else if(version){
        _version = [version retain];
    }
    [httphelper release];
}

@end
