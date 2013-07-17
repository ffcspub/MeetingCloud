//
//  ChatRoomViewController.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-28.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageGirdView.h"
#import "MBProgressHUD.h"
#import "ChatCell.h"

@interface ChatCommentViewController : UIViewController<PageGirdViewDataSource,MBProgressHUDDelegate,ChatCellDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSError *_error;
    NSMutableArray *_talkCommentList;
    BOOL needReload_flag;
    UIImagePickerController* _picker;
    NSData *_imageData;
    ChatCell *_currentCell;
    int page;
    BOOL isLastPage;
}

@property(nonatomic,retain) Talkmessage *message;

@property(nonatomic,retain) IBOutlet UIScrollView *baseSV;
@property(nonatomic,retain) IBOutlet UITextField *textField;

@property(nonatomic,retain) IBOutlet PageGirdView *pageGirdView;
@property(nonatomic,retain) IBOutlet UITableView *tableView;


-(IBAction)backBtnClicked:(id)sender;

-(IBAction)faceBtnClicked:(id)sender;

-(IBAction)sendBtnClicked:(id)sender;

-(IBAction)referceBtnClicked:(id)sender;

-(IBAction)photoLibraryBtnClicked:(id)sender;

-(IBAction)cameraBtnClicked:(id)sender;

@end
