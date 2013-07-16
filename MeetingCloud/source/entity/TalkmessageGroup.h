//
//  TalkmessageGroup.h
//  MeetingCloud
//
//  Created by Geory on 13-7-9.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkmessageGroup : NSObject

@property(nonatomic,retain) NSString *groupId;//分组Id
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *creatorName;//创建者名称
@property(nonatomic,retain) NSString *groupname;//组名
@property(nonatomic,retain) NSString *grouptype;//组的类别
@property(nonatomic,retain) NSString *showindex;//显示顺序，从大到小
@property(nonatomic,retain) NSString *status;//讨论组状态，0-删除，1-使用
@property(nonatomic,retain) NSString *intro;//讨论简介内容
@property(nonatomic,retain) NSString *creatorId;//创建者编号
@property(nonatomic,retain) NSString *joinRight;//进入限制：0-所有人可进入，1-组员可进入

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
