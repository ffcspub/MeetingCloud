//
//  ChatCell.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-30.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ChatCommentCell.h"
#import "UITools.h"
#import "UIButton+WebCache.h"


@implementation ChatCommentCell

@synthesize comment = _comment;

-(void) dealloc{
    [_comment release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initUI{
    
    UIColor *textColor = [UIColor colorWithRed:0.87 green:0.49 blue:0.24 alpha:1.0];
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
    nameLable.tag = 111;
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.textColor = textColor;
    [self addSubview:nameLable];
    
    UIImageView *msg_top = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myclound_msgbg_top.png"]];
    msg_top.frame = CGRectMake(10, 40, 304, 14);
    [self addSubview:msg_top];
    [msg_top release];
    
    UIView *msg_center = [[UIView alloc]initWithFrame:CGRectMake(10, 54, 304, 20)];
    [msg_center setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myclound_msgbg_center.png"]]];
    //msg_center.contentMode = UIViewContentModeScaleAspectFill;
    msg_center.tag = 1;
    [self addSubview:msg_center];
    [msg_center release];
    
    CGFloat buttomViewy = 74;
    faceView = [[FaceView alloc]initWithFrame:CGRectMake(10, 0, 284, 20)];
    faceView.backgroundColor = [UIColor clearColor];
    [msg_center addSubview:faceView];
    [faceView release];
    
    
    UIView *msg_buttom = [[UIView alloc]initWithFrame:CGRectMake(10, buttomViewy, 304, 31)];
    [msg_buttom setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myclound_msgbg_button.png"]]];
    msg_buttom.tag = 2;
    [self addSubview:msg_buttom];
    [msg_buttom release];
    
    UILabel *lb_time = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 170, 20)];
    lb_time.tag = 10;
    lb_time.textColor = [UIColor grayColor];
    lb_time.backgroundColor = [UIColor clearColor];
    [lb_time setFont:[UIFont systemFontOfSize:14]];
    [msg_buttom addSubview:lb_time];
    [lb_time release];
    
    
}

-(void) setComment:(Talkcomment *)comment{
    if (comment) {
        if (_comment) {
            [_comment release];
            _comment = nil;
        }
        _comment = [comment retain];
        UILabel *lb_name = (UILabel *)[self viewWithTag:111];
        [lb_name setText:comment.userInfo.name];
        UIView *iv_center = (UIView *)[self viewWithTag:1];
        UIView *iv_buttom = (UIView *)[self viewWithTag:2];
        UILabel *lb_time = (UILabel *)[iv_buttom viewWithTag:10];
        [lb_time setText:_comment.createdate];
        faceView.content = _comment.content;
        iv_center.frame = CGRectMake(iv_center.frame.origin.x, iv_center.frame.origin.y, iv_center.frame.size.width, faceView.frame.size.height - 20 + 20);
        iv_buttom.center = CGPointMake(iv_buttom.center.x, 90 + faceView.frame.size.height - 20);
    }
}


+(CGFloat) heightByContent:(NSString *)content{
    return [FaceView heigthWithContent:content size:CGSizeMake(284, 20)] -20 + 105;
}

#pragma mark -MyButtonDelegate
-(void) myImageView:(MyButton *)button didFinishWithImage:(UIImage *)image{
    UIImage *sizeImage = [image scaleToSize:button.frame.size];
    [button setImage:sizeImage forState:UIControlStateNormal];
}

@end
