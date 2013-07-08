//
//  Talkmessage.h
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
//你云我云
@interface Talkmessage : NSObject
@property(nonatomic,retain) NSString *messageId;//编号
@property(nonatomic,retain) NSString *tdUserId;//用户编号
@property(nonatomic,retain) NSString *content;//内容
@property(nonatomic,retain) NSString *createdate;//发表时间  
@property(nonatomic,retain) NSString *imsi;//手机卡信息(imsi)
@property(nonatomic,retain) NSString *picturename;//图片名(图片规则：用户id_当前毫秒数)
@property(nonatomic,retain) NSString *picturenameThum;//图片缩略图名(thum_图片名)
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *commentcount;//评论次数
@property(nonatomic,retain) NSString *clickcount;//查看次数
@property(nonatomic,retain) UserInfo *userInfo;//用户信息对象

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
