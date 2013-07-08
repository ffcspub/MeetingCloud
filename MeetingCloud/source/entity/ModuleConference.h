//
//  ModuleConference.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

//会议云模块菜单
@interface ModuleConference : NSObject

@property(nonatomic,retain) NSString *moduleId;//编号
@property(nonatomic,retain) NSString *name;//名称   
@property(nonatomic,retain) NSString *icon;//图标
@property(nonatomic,retain) NSString *iconName;//图标对应的名称
@property(nonatomic,retain) NSString *url;//url(如果为添加的静态页面，url直接可以访问)
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *functionid;//功能id，如果为静态页面，则为0
@property(nonatomic,retain) NSString *englishname;//英文菜单 

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
