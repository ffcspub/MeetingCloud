//
//  ChatCell.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-30.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "Entitys.h"
#import "MyButton.h"

#define CHATCOMMENTCELL @"CHATCOMMENTCELL"

@interface ChatCommentCell : UITableViewCell{
    FaceView *faceView;
}

@property(nonatomic,retain) Talkcomment *comment;

@end
