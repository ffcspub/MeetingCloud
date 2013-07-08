//
//  ClientPush.h
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
//推送
@interface ClientPush : NSObject
@property(nonatomic,retain) NSString *pushId;//编号
@property(nonatomic,retain) NSString *userId;//用户编号
@property(nonatomic,retain) NSString *conferenceId;//会议编号
@property(nonatomic,retain) NSString *type;//类型： 1-文件，2-公告，3-你云我去被评论，4-收到私信
@property(nonatomic,retain) NSString *pushMsg;//推送的信息
@property(nonatomic,retain) NSString *optId;//被操作的编号，如被回复的私信编号     

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
