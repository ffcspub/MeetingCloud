//
//  Privatemessage.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

//私信
@interface Privatemessage : NSObject

@property(nonatomic,retain) NSString *messageId;//编号
@property(nonatomic,retain) NSString *fromuserid;//发信人编号   
@property(nonatomic,retain) NSString *touserid;//收信人编号
@property(nonatomic,retain) NSString *content;//内容
@property(nonatomic,retain) NSString *createdate;//发信时间
@property(nonatomic,retain) NSString *imsi;//手机卡信息(imsi)
@property(nonatomic,retain) NSString *picturename;//图片名(图片规则：用户id_当前毫秒数)
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号   
@property(nonatomic,retain) NSString *parentid;//父信息编号(如果是直接发送，则为0)
@property(nonatomic,retain) UserInfo *userInfo;//用户信息对象

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
