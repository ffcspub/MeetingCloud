//
//  ConferenceBackpic.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

//会议云背景图片
@interface ConferenceBackpic : NSObject

@property(nonatomic,retain) NSString *picId;//编号
@property(nonatomic,retain) NSString *picpath;//图片路径
@property(nonatomic,retain) NSString *pictype;//图片类型
@property(nonatomic,retain) NSString *conferenceid;//会议编号

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
