//
//  ChatCell.h
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FaceView : UIView {
    NSMutableArray *data;
}

@property(nonatomic,retain)NSString *content;

@property(nonatomic,assign) BOOL noResizeable;//是否改变大小

+(CGFloat) heigthWithContent:(NSString *)content size:(CGSize)size;

@end
