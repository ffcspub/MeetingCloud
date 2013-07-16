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
#import "TalkmessageGroup.h"

@interface ChatRoomViewController : UIViewController<PageGirdViewDataSource,MBProgressHUDDelegate,ChatCellDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,ChatCellMenuDelegate>{
    NSError *_error;
    NSArray *_talkMessageList;
    BOOL needReload_flag;
    UIImagePickerController* _picker;
    NSData *_imageData;
    ChatCell *_currentCell;
    int page;
    BOOL _isLastPage;
}

@property(nonatomic,retain) IBOutlet UIScrollView *baseSV;
@property(nonatomic,retain) IBOutlet UITextField *textField;

@property(nonatomic,retain) IBOutlet PageGirdView *pageGirdView;
@property(nonatomic,retain) IBOutlet UITableView *tableView;

@property(nonatomic,assign) BOOL firstEnter;

@property(nonatomic,retain) TalkmessageGroup *talkmessageGroup;

-(IBAction)backBtnClicked:(id)sender;

-(IBAction)faceBtnClicked:(id)sender;

-(IBAction)sendBtnClicked:(id)sender;

-(IBAction)referceBtnClicked:(id)sender;

-(IBAction)photoLibraryBtnClicked:(id)sender;

-(IBAction)cameraBtnClicked:(id)sender;

@end
