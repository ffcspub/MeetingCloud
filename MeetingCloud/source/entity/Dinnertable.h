//
//  Dinnertable.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dinnertable : NSObject

@property(nonatomic,retain) NSString *tableId;//编号
@property(nonatomic,retain) NSString *name;//桌名
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *tdDinnerplanId;//用餐安排编号
@property(nonatomic,retain) NSString *dinnername;//用餐安排名称
@property(nonatomic,retain) NSString *content;//内容

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
