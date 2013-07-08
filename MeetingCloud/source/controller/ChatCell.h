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

#define CHATCELL_IMAGE @"CHATCELL_IMAGE"
#define CHATCELL_CONTENT @"CHATCELL_CONTENT"
#define CHATCELL_IMAGE_HEIGHT 195

@protocol ChatCellDelegate;

@interface ChatCell : UITableViewCell{
    FaceView *faceView;
    MyButton *btn_image;
}

@property(nonatomic,retain) Talkmessage *message;
@property(nonatomic,assign) id<ChatCellDelegate> delegate;

+(CGFloat) heightByContent:(NSString *)content;

@end

@protocol ChatCellDelegate <NSObject>

-(void) imageClicked:(ChatCell *)cell;

-(void) commentClicked:(ChatCell *)cell;

@end