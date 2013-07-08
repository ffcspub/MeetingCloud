//
//  Style.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

//样式对象
@interface UIStyle : NSObject

@property(nonatomic,retain) NSString *styleId;//编号
@property(nonatomic,retain) NSString *name;//名称
@property(nonatomic,retain) NSString *dirurl;//样式文件目录url

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
