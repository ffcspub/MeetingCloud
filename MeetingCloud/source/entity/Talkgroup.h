//
//  Talkgroup.h
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Talkgroup : NSObject
@property(nonatomic,retain) NSString *groupId;//编号
@property(nonatomic,retain) NSString *groupname;//组名
@property(nonatomic,retain) NSString *content;//详细内容
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *grouptype;//分组类型标识(预留字段，暂定值都为1)   
@property(nonatomic,retain) NSString *groupUsers;//成员

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
