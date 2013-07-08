//
//  Talkcomment.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

//会议云评论
@interface Talkcomment : NSObject

@property(nonatomic,retain) NSString *commentId;//编号
@property(nonatomic,retain) NSString *tdTalkmessageId;//主贴编号
@property(nonatomic,retain) NSString *tdUserId;//用户编号
@property(nonatomic,retain) NSString *content;//内容
@property(nonatomic,retain) NSString *createdate;//评论时间
@property(nonatomic,retain) NSString *imsi;//手机卡信息(imsi)  
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) UserInfo *userInfo;//用户信息对象

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
