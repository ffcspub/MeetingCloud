//
//  ShareManager.h
//  MeetingCloud
//
//  Created by songhang he on 12-6-20.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entitys.h"

@interface ShareManager : NSObject

+(ShareManager *) getInstance;

@property(nonatomic,retain) UserInfo *userInfo;
@property(nonatomic,retain) Conference *conference;
@property(nonatomic,retain) NSString *loginId;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,assign) BOOL isRemember;
@property(nonatomic,retain) NSDictionary *faceDic;

@property(nonatomic,retain) NSMutableArray *personArray;

@end
