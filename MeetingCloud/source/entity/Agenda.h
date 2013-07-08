//
//  Agenda.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

//会议议程
@interface Agenda : NSObject

@property(nonatomic,retain) NSString *agendaId;//编号
@property(nonatomic,retain) NSString *name;//议程名称
@property(nonatomic,retain) NSString *starttime;//会议开始时间(包括日期)
@property(nonatomic,retain) NSString *endtime;//会议结束时间(包括日期)
@property(nonatomic,retain) NSString *columndetail;//子项信息，如：主持人：张三，发言人：李四……  
@property(nonatomic,retain) NSString *content;//内容
@property(nonatomic,retain) NSString *createdate;//创建时间
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *agendDate;//议程日期
@property(nonatomic,retain) NSString *agendWeek;//议程日期(对应星期)

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
