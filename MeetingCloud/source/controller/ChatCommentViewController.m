//
//  ChatCommentViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ChatCommentViewController.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#import "ChatCommentCell.h"
#import "UIButton+WebCache.h"
#import "MWPhotoBrowser.h"

#define kImageScaleRate 0.3
#define kImageCompressRate 0.5

@interface ChatCommentViewController (private)
-(void) btnClickedByFace:(id)sender;
-(void) sendMessage;
-(void) sendPhotos;
-(void) queryTalkComment;
-(void) loadMessage;
@end

@implementation ChatCommentViewController

@synthesize baseSV = _baseSV;
@synthesize textField = _textField;
@synthesize pageGirdView = _pageGirdView;
@synthesize tableView = _tableView;
@synthesize message = _message;

-(void) dealloc{
    [_baseSV release];
    [_textField release];
    [_pageGirdView release];
    [_tableView release];
    [_imageData release];
    [_message release];
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
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadMessage) onTarget:self withObject:nil animated:YES];
    //[_tableView launchRefreshing];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [self textFileShowOrHide];
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
    hud.labelText = @"请稍候...";
    [self.view addSubview:hud];
    [hud release];
    [hud showWhileExecuting:@selector(loadMessage) onTarget:self withObject:nil animated:YES];
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
    UIImage *cmpImg = [self scaleImage:image toScale:kImageScaleRate];//縮圖
    NSData *blobImage = UIImageJPEGRepresentation(cmpImg, kImageCompressRate);//圖片壓縮為NSData
    
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"回复";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (!_talkCommentList) {
        return 0;
    }
    return [_talkCommentList count];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_message.picturenameThum && [_message.picturenameThum length]>0) {
            return CHATCELL_IMAGE_HEIGHT + 20;
        }else {
            CGFloat height = [ChatCell heightByContent:_message.content];
            return height + 20;
        }
    }
    Talkcomment *talkcomment=[_talkCommentList objectAtIndex:indexPath.row];
    CGFloat height = [ChatCell heightByContent:talkcomment.content];
    return height + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *chatCell = nil;
    if (indexPath.section == 0) {
        if (!_message.picturenameThum || [_message.picturenameThum length]==0) {
            chatCell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_CONTENT];
            if (chatCell==nil) 
            {
                chatCell=[[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHATCELL_CONTENT]autorelease];
                chatCell.delegate = self;
            }
        }else {
            chatCell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_IMAGE];
            if (chatCell==nil) 
            {
                chatCell=[[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHATCELL_IMAGE]autorelease];
                chatCell.delegate = self;
            }
            
        }
        [chatCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [chatCell setNeedsDisplay];
        chatCell.message = _message;
        return chatCell;
    }
    ChatCommentCell *cell = nil;
    Talkcomment *comment=[_talkCommentList objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:CHATCOMMENTCELL];
    if (cell==nil) 
    {
        cell=[[[ChatCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHATCOMMENTCELL]autorelease];
    }
    
       
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setNeedsDisplay];
    cell.comment = comment;
    
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

@implementation ChatCommentViewController(private)

-(void) btnClickedByFace:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    NSString *faceString = [[[ShareManager getInstance].faceDic allKeys]objectAtIndex:tag];
    _textField.text = [_textField.text stringByAppendingString:faceString];
}

-(void) sendMessage{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addTalkcommendByUserid:[ShareManager getInstance].userInfo.userId conferenceId:[ShareManager getInstance].conference.conferenceId  talkmessageId:_message.messageId content:_textField.text];
    [_imageData release];
    _imageData = nil;
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        [self loadMessage];
    }
    [helper release];
    _textField.text = nil;
}


-(void) queryTalkComment{
    needReload_flag = YES;
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array =  [helper getTalkcommendsByTalkmessageId:_message.messageId];
    if (helper.error) {
        _error = [helper.error retain];
    }else {
        if (_talkCommentList) {
            [_talkCommentList release];
            _talkCommentList = nil;
        }
        _talkCommentList = [array retain];
    }
}

-(void) loadMessage{
    HttpHelper *helper = [[HttpHelper alloc]init];
    Talkmessage *message = [helper getTalkmessageByConferenceId:[ShareManager getInstance].conference.conferenceId TalkmessageId:_message.messageId];
    if (helper.error) {
        _error = [helper.error retain];
    }
    else {
        if (_message) {
            [_message release];
            _message = nil;
        }
        _message = [message retain];
        [self queryTalkComment];
    }
    [helper release];
}

@end
