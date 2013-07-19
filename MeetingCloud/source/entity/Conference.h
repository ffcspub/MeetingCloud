//
//  Conference.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_GUIDNAME @"GuideName"   //导游姓名
#define KEY_GUIDENO @"GuideNo"      //导游号码

//会议信息
@interface Conference : NSObject

@property(nonatomic,retain) NSString *conferenceId;//编号
@property(nonatomic,retain) NSString *name;//会议名称
@property(nonatomic,retain) NSString *welcome;//会议欢迎词
@property(nonatomic,retain) NSString *startdate;//会议开始日期
@property(nonatomic,retain) NSString *enddate;//会议结束日期
@property(nonatomic,retain) NSString *tsCitysId;//会议城市编号
@property(nonatomic,retain) NSString *createdate;//创建会议时间
@property(nonatomic,retain) NSString *tdStyleId;//会议云默认样式主题
@property(nonatomic,retain) NSString *weather;//天气预报
@property(nonatomic,retain) NSString *address;//会议具体地点
@property(nonatomic,retain) NSString *keywords;//会议关键字(你云我云中屏蔽这些关键字)
@property(nonatomic,retain) NSString *cityname;//省份名称_城市名称(如：江苏省_南京) 
@property(nonatomic,retain) NSString *notify;//通知公告
@property(nonatomic,retain) NSString *mobilednseg;//登陆会议支持手机号段，如果为空则全部支持
@property(nonatomic,retain) NSString *isopenbook;//是否支持通讯录全部公开(1是0否)
@property(nonatomic,retain) NSString *weatheraddress;//天气预报接口地址（直接调用返回天气预报接口）
@property(nonatomic,retain) NSString *backpic;//背景图片
@property(nonatomic,retain) NSDictionary *cloudCfgMap;//各种云扩展信息
@property(nonatomic,retain) NSString *headimg;//会议头像图片
@property(nonatomic,retain) NSString *doapplyfor;//是否支持申请
@property(nonatomic,retain) NSString *isTalkmessageGrouping;//是否分组你云我云
@property(nonatomic,retain) NSString *checkinType;//签到方式

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
