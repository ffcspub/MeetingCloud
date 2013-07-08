//
//  Clientversion.h
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
//版本信息
@interface Clientversion : NSObject

@property(nonatomic,retain) NSString *versionId;//编号
@property(nonatomic,retain) NSString *clientname;//别名
@property(nonatomic,retain) NSString *updatedsc;//更新描述
@property(nonatomic,retain) NSString *nversion;//当前版本
@property(nonatomic,retain) NSString *sversion;//强制升级版本
@property(nonatomic,retain) NSString *filepath;//升级路径
@property(nonatomic,retain) NSString *versionname;//版本名称

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
