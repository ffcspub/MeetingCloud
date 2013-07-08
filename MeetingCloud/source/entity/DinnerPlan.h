//
//  ModuleConference.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
//用餐安排
@interface DinnerPlan : NSObject

@property(nonatomic,retain) NSString *planId;//编号
@property(nonatomic,retain) NSString *name;//名称(如：早餐)
@property(nonatomic,retain) NSString *starttime;//会议开始时间(包括日期) 
@property(nonatomic,retain) NSString *endtime;//会议结束时间(包括日期)
@property(nonatomic,retain) NSString *columndetail;//子项信息，如：主持人：张三，发言人：李四……
@property(nonatomic,retain) NSString *content;//内容
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *dinnerDate;//用餐日期
@property(nonatomic,retain) NSString *dinnerWeek;//用餐星期
@property(nonatomic,retain) NSString *menus; //菜单

@property(nonatomic,retain) NSArray *dinnerTables;//分桌名单

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
