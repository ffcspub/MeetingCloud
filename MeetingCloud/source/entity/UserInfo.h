//
//  UserInfo.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户信息
@interface UserInfo : NSObject<NSCopying>

@property(nonatomic,retain) NSString *userId;//编号
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *name;//姓名
@property(nonatomic,retain) NSString *loginid;//账号（一般为手机号)
@property(nonatomic,retain) NSString *sex;//性别(1男  0女）
@property(nonatomic,retain) NSString *job;//职位
@property(nonatomic,retain) NSString *city;//区域
@property(nonatomic,retain) NSString *showmobilephone;//通讯录中是否显示手机号
@property(nonatomic,retain) NSString *createdate;//创建时间
@property(nonatomic,retain) NSString *email;//电子邮件
@property(nonatomic,retain) NSString *conferencename;//会议名称
@property(nonatomic,retain) NSString *docheckin;//是否已签到(0否1是，默认为否)
@property(nonatomic,retain) NSString *checkincode;//签到编码号
@property(nonatomic,retain) NSString *checkintime;//签到时间 
@property(nonatomic,retain) NSString *visible;//通讯录是否可见
@property(nonatomic,retain) NSString *remark;//备注
@property(nonatomic,retain) NSString *roomNo;//房间号
@property(nonatomic,retain) NSString *isCheckinMgr;//是否为管理员


-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
