//
//  ChatCell.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-30.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ChatCell.h"
#import "UITools.h"
#import "UIButton+WebCache.h"


@interface ChatCell (private)
-(void) imageBtnClicked:(id)sender;
-(void) commentBtnClicked:(id)sender;
@end

@implementation ChatCell

@synthesize message = _message;
@synthesize delegate = _delegate;

-(void) dealloc{
    [_message release];
    _delegate = nil;
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
    if (![CHATCELL_IMAGE isEqualToString: self.reuseIdentifier] ) {
        faceView = [[FaceView alloc]initWithFrame:CGRectMake(10, 0, 284, 20)];
        faceView.backgroundColor = [UIColor clearColor];
        [msg_center addSubview:faceView];
        [faceView release];
    }else {
        buttomViewy = 164;
        msg_center.frame = CGRectMake(10, 54, 304, 110);
        btn_image = [[MyButton alloc]initWithFrame:CGRectMake(10, 0, 150, 100)];
        btn_image.delegate = self;
        btn_image.contentMode = UIViewContentModeScaleToFill;
        [btn_image addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [msg_center addSubview:btn_image];
        [btn_image release];
    }
    
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
    
    UILabel *lb_see = [[UILabel alloc]initWithFrame:CGRectMake(195, 5, 30, 20)];
    lb_see.textColor = [UIColor grayColor];
    lb_see.backgroundColor = [UIColor clearColor];
    [lb_see setFont:[UIFont systemFontOfSize:14]];
    lb_see.text = @"查看";
    [msg_buttom addSubview:lb_see];
    [lb_see release];
    
    UILabel *lb_seecount = [[UILabel alloc]initWithFrame:CGRectMake(225, 5, 20, 20)];
    lb_seecount.tag = 11;
    lb_seecount.textColor = textColor;
    lb_seecount.backgroundColor = [UIColor clearColor];
    [lb_seecount setFont:[UIFont systemFontOfSize:14]];
    [msg_buttom addSubview:lb_seecount];
    [lb_seecount release];
    
    UILabel *lb_comment = [[UILabel alloc]initWithFrame:CGRectMake(246, 5, 30, 20)];
    lb_comment.textColor = [UIColor grayColor];
    lb_comment.backgroundColor = [UIColor clearColor];
    [lb_comment setFont:[UIFont systemFontOfSize:14]];
    lb_comment.text = @"评论";
    [msg_buttom addSubview:lb_comment];
    [lb_comment release];
    
    UILabel *lb_commentcount = [[UILabel alloc]initWithFrame:CGRectMake(275, 5, 30, 20)];
    lb_commentcount.tag = 12;
    lb_commentcount.textColor = textColor;
    lb_commentcount.backgroundColor = [UIColor clearColor];
    [lb_commentcount setFont:[UIFont systemFontOfSize:14]];
    [msg_buttom addSubview:lb_commentcount];
    [lb_commentcount release];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(240, 5, 60, 20)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [msg_buttom addSubview:btn];
    [btn release];
    [btn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setMessage:(Talkmessage *)message{
    if (message) {
        if (_message) {
            [_message release];
            _message = nil;
        }
        _message = [message retain];
        UILabel *lb_name = (UILabel *)[self viewWithTag:111];
        [lb_name setText:message.userInfo.name];
        UIView *iv_center = (UIView *)[self viewWithTag:1];
        UIView *iv_buttom = (UIView *)[self viewWithTag:2];
        UILabel *lb_time = (UILabel *)[iv_buttom viewWithTag:10];
        [lb_time setText:message.createdate];
        UILabel *lb_seecount = (UILabel *)[iv_buttom viewWithTag:11];
        [lb_seecount setText:message.clickcount];
        UILabel *lb_commentcount = (UILabel *)[iv_buttom viewWithTag:12];
        [lb_commentcount setText:message.commentcount];
        if (![CHATCELL_IMAGE isEqualToString: self.reuseIdentifier]){
            faceView.content = message.content;
            iv_center.frame = CGRectMake(iv_center.frame.origin.x, iv_center.frame.origin.y, iv_center.frame.size.width, faceView.frame.size.height - 20 + 20);
            iv_buttom.center = CGPointMake(iv_buttom.center.x, 90 + faceView.frame.size.height - 20);
            self.userInteractionEnabled = YES;
            longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
            //    longPressGestureRecognizer.numberOfTouchesRequired = 2;
            longPressGestureRecognizer.minimumPressDuration = 1.0;
            [self addGestureRecognizer:longPressGestureRecognizer];
        }else {
            [btn_image setImageWithURL:[NSURL URLWithString:message.picturenameThum]];
        }
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

#pragma mark -Action
-(void) imageBtnClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
    }
}


-(void) commentBtnClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(commentClicked:)]) {
        [_delegate commentClicked:self];
    }
}

#pragma mark - Copy

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)paramSender
{
    if ([paramSender isEqual:longPressGestureRecognizer]) {
        if (paramSender.numberOfTouchesRequired == 1) {
//            CGPoint touchPoint = [paramSender locationOfTouch:0 inView:paramSender.view];
//            CGRect rect = CGRectMake(touchPoint.x, touchPoint.y, 60, 30);
//            float screenHeight = [UIScreen mainScreen].bounds.size.height;
//            float screenWidth = [UIScreen mainScreen].bounds.size.width / 2;
//            float cellHeight = self.frame.origin.y;
//            int pointRadio = cellHeight / screenHeight;
//            float pointHeight = cellHeight - (screenHeight * pointRadio);
//            CGRect rect = CGRectMake(screenWidth, pointHeight, 60, 30);
//            NSValue *aRect = [NSValue valueWithCGRect:rect];
            [_menuDelegate performSelector:@selector(showMenu:) withObject:self];
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cut:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)cut:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:_message.content];
}

@end
