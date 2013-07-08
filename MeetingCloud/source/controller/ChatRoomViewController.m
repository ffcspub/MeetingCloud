//
//  ChatRoomViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#import "ChatCell.h"
#import "UIButton+WebCache.h"
#import "MWPhotoBrowser.h"
#import "ChatCommentViewController.h"

#define kImageScaleRate 0.3
#define kImageCompressRate 0.5

@interface ChatRoomViewController (private)
-(void) btnClickedByFace:(id)sender;
-(void) sendMessage;
-(void) sendPhotos;
-(void) queryTalkMessages;
@end

@implementation ChatRoomViewController

@synthesize baseSV = _baseSV;
@synthesize textField = _textField;
@synthesize pageGirdView = _pageGirdView;
@synthesize tableView = _tableView;

-(void) dealloc{
    [_baseSV release];
    [_textField release];
    [_pageGirdView release];
    [_tableView release];
    [_imageData release];
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
    _pageGirdView.widthInsert = 9.0;
    _pageGirdView.heightInsert = 10.0;
    [_pageGirdView reloadData];
    //[_tableView launchRefreshing];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [self textFileShowOrHide];
}

-(void) viewWillAppear:(BOOL)animated{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(queryTalkMessages) onTarget:self withObject:nil animated:YES];
}


-(void) viewDidDisappear:(BOOL)animated{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self
                            name:UIKeyboardWillHideNotification
                          object:nil];
    
    [notification removeObserver:self
                            name:UIKeyboardWillShowNotification
                          object:nil];
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

-(IBAction)faceBtnClicked:(id)sender{
    if ([_textField isFirstResponder] || _baseSV.contentOffset.y == 0) {
        [_textField resignFirstResponder];
        [UIView beginAnimations:@"keyboardWillShow" context:nil];
        [UIView setAnimationDuration:0.30f];
        [_baseSV setContentOffset:CGPointMake(0, 190) animated:YES];
        [UIView commitAnimations];
        
    }else{
        [_textField becomeFirstResponder];
    }
}

-(IBAction)sendBtnClicked:(id)sender{
    [self keyboardWillHide];
    NSString *message=[_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([message length]<1) {
		return;
	}
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"正在发送中，请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(sendMessage) onTarget:self withObject:nil animated:YES];
}

-(IBAction)referceBtnClicked:(id)sender{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"正在发送中，请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(queryTalkMessages) onTarget:self withObject:nil animated:YES];
}

-(IBAction)photoLibraryBtnClicked:(id)sender{
    [self keyboardWillHide];
    _picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.delegate = self;
    [self.navigationController presentModalViewController:_picker animated:YES];
}

-(IBAction)cameraBtnClicked:(id)sender{
    _picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.delegate =self;
    [self.navigationController presentModalViewController:_picker animated:YES];
}

#pragma mark -UIImagePickerControllerDelegate

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//
    
    //UIImage *cmpImg = [self scaleImage:image toScale:kImageScaleRate];//縮圖
    NSData *blobImage = UIImageJPEGRepresentation(image, kImageCompressRate);//圖片壓縮為NSData

    [self dismissModalViewControllerAnimated:YES];
    [_picker release];
    _picker = nil;
    _imageData = [blobImage retain];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(sendPhotos) onTarget:self withObject:nil animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
    [_picker release];
    _picker = nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_talkMessageList count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Talkmessage *talkmessage=[_talkMessageList objectAtIndex:indexPath.row];
    if (talkmessage.picturenameThum && [talkmessage.picturenameThum length]>0) {
        return CHATCELL_IMAGE_HEIGHT;
    }else {
        CGFloat height = [ChatCell heightByContent:talkmessage.content];
        return height + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = nil;
    Talkmessage *talkmessage=[_talkMessageList objectAtIndex:indexPath.row];
    if (!talkmessage.picturenameThum || [talkmessage.picturenameThum length]==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_CONTENT];
        if (cell==nil) 
        {
            cell=[[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHATCELL_CONTENT]autorelease];
            cell.delegate = self;
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_IMAGE];
        if (cell==nil) 
        {
            cell=[[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHATCELL_IMAGE]autorelease];
            cell.delegate = self;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setNeedsDisplay];
    cell.message = talkmessage;
    cell.tag = indexPath.row;
    /*
    ChatCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
	if (cell==nil) 
    {
		cell=[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	//必须写cell setNeedsDisplay 避免cell重用的时候数据显示混乱。
	[cell setNeedsDisplay];
    
	Talkmessage *talkmessage=[_talkMessageList objectAtIndex:indexPath.row];
    cell.content=talkmessage.content;
   */
	return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nibName = @"ChatCommentViewController";
    if (IS_SCREEN_4_INCH) {
        nibName = @"ChatCommentViewController_iPhone5";
    }
    Talkmessage *talkmessage=[_talkMessageList objectAtIndex:indexPath.row];
    ChatCommentViewController *vlc = [[ChatCommentViewController alloc]initWithNibName:nibName bundle:nil];
    [vlc setMessage:talkmessage];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
}


#pragma mark -ChatCellDelegate
-(void) imageClicked:(ChatCell *)cell{
    _currentCell = cell;
    if (cell.message) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [browser release];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:nc animated:YES];
        [nc release];
 
        /*
        ImageViewController *vlc = [[ImageViewController alloc]initWithNibName:@"ImageViewController" bundle:nil];
        vlc.message = cell.message;
        [self.navigationController pushViewController:vlc animated:YES];
        [vlc release];
         */
    }
}

-(void) commentClicked:(ChatCell *)cell{
    
    Talkmessage *message = cell.message;
    ChatCommentViewController *vlc = [[ChatCommentViewController alloc]initWithNibName:@"ChatCommentViewController" bundle:nil];
    [vlc setMessage:message];
    [self.navigationController pushViewController:vlc animated:YES];
    [vlc release];
    
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
   return [MWPhoto photoWithURL:[NSURL URLWithString:_currentCell.message.picturename]];
}

#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else{
        [_tableView reloadData];
        if (_talkMessageList && [_talkMessageList count]>0) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO]; 
        }
        needReload_flag = NO;
    }
    
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_baseSV setContentOffset:CGPointMake(0, 250) animated:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqual:string]) {
        [textField resignFirstResponder];
        [self sendBtnClicked:nil];
        return NO;
    }
    return YES;
}


#pragma mark -KEYBORAD
- (void)textFileShowOrHide {
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self     
                     selector:@selector(keyboardWillShow)     
                         name:UIKeyboardWillShowNotification     
                       object:nil];
    
    /*[notification addObserver:self     
                     selector:@selector(keyboardWillHide)     
                         name:UIKeyboardWillHideNotification     
                       object:nil];
     */
}

/*
 * @DO 隐藏键盘
 */
- (void)keyboardWillHide {
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationDuration:0.30f];
    [_baseSV setContentOffset:CGPointMake(0, 0) animated:YES];//_baseSV为ScrollerView
    [_textField resignFirstResponder];
    [UIView commitAnimations];
    
}

/*
 * @DO 显示键盘
 */
- (void)keyboardWillShow{
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationDuration:0.30f];
    [_baseSV setContentOffset:CGPointMake(0, 250) animated:YES];
    [UIView commitAnimations];
}


#pragma mark -PageGirdViewDataSource
// 有多少组件
- (int)numberViewOfPageGirdView:(PageGirdView *)pageGirdView{
    return [[ShareManager getInstance].faceDic.allKeys count];
}

// 每个组件的视图
- (UIView *)viewWithIndex:(int)index pageGirdView:(PageGirdView *)pageGirdView{
    NSString *imageName = [[ShareManager getInstance].faceDic.allValues objectAtIndex:index];
    UIButton *btn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)]autorelease];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]] forState:UIControlStateNormal];
    btn.tag = index;
    [btn addTarget:self action:@selector(btnClickedByFace:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(PageGirdViewInsertStyle) insertStyleOfPageGirdView:(PageGirdView *)pageGirdView{
    return PageGirdViewInsertStyle_Same;
}

-(PageGirdViewCompantViewStyle) pageGirdViewCompantViewStyle:(PageGirdView *)pageGirdView{
    return PageGirdViewCompantViewStyle_Same;
}

@end

@implementation ChatRoomViewController(private)

-(void) btnClickedByFace:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    NSString *faceString = [[[ShareManager getInstance].faceDic allKeys]objectAtIndex:tag];
    _textField.text = [_textField.text stringByAppendingString:faceString];
}

-(void) sendMessage{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addTalkmessageByUserid:[ShareManager getInstance].userInfo.userId conferenceId:[ShareManager getInstance].conference.conferenceId imsi:[UITools getImisi] content:_textField.text picturename:@"" fileData:nil];
    [_imageData release];
    _imageData = nil;
    if (helper.error) {
        _error = [helper.error retain];
    }else {
       NSArray *array =  [helper getTalkmessagesByConferenceId:[ShareManager getInstance].conference.conferenceId];
        if (helper.error) {
            _error = [helper.error retain];
            needReload_flag = NO;
        }else {
            needReload_flag = YES;
            if (_talkMessageList) {
                [_talkMessageList release];
                _talkMessageList = nil;
            }
            _talkMessageList = [array retain];
            _textField.text = nil;
        }
    }
    [helper release];
}

-(void) sendPhotos{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSString *picturename = [NSString stringWithFormat:@"%@.png",[UITools myDate:@"yyyyMMddHHmmssmi" dates:0]];
    [helper addTalkmessageByUserid:[ShareManager getInstance].userInfo.userId conferenceId:[ShareManager getInstance].conference.conferenceId imsi:[UITools getImisi] content:@"" picturename:picturename fileData:_imageData];
    [_imageData release];
    _imageData = nil;
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        NSArray *array =  [helper getTalkmessagesByConferenceId:[ShareManager getInstance].conference.conferenceId];
        if (helper.error) {
            _error = [helper.error retain];
            needReload_flag = NO;
        }else {
            if (_talkMessageList) {
                [_talkMessageList release];
                _talkMessageList = nil;
            }
            _talkMessageList = [array retain];
            //_textField.text = nil;
        }
    }
    [helper release];
}

-(void) queryTalkMessages{
    needReload_flag = YES;
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array =  [helper getTalkmessagesByConferenceId:[ShareManager getInstance].conference.conferenceId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        if (_talkMessageList) {
            [_talkMessageList release];
            _talkMessageList = nil;
        }
        _talkMessageList = [array retain];
    }
}

@end
