//
//  UserInfo.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "UserInfo.h"
#import "UITools.h"

@implementation UserInfo

@synthesize userId;
@synthesize tdConferenceId;
@synthesize name;
@synthesize loginid;
@synthesize sex;
@synthesize job;
@synthesize city;
@synthesize showmobilephone;
@synthesize createdate;
@synthesize email;
@synthesize conferencename;
@synthesize docheckin;
@synthesize checkincode;
@synthesize checkintime;
@synthesize visible;
@synthesize remark;
@synthesize roomNo;
@synthesize isCheckinMgr;


-(void) dealloc{
    [userId release];
    [tdConferenceId release];
    [name release];
    [loginid release];
    [sex release];
    [job release];
    [city release];
    [showmobilephone release];
    [createdate release];
    [email release];
    [conferencename release];
    [docheckin release];
    [checkincode release];
    [checkintime release];
    [visible release];
    [remark release];
    [roomNo release];
    [isCheckinMgr release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    UserInfo *toolbean = [[[UserInfo alloc]init]autorelease];
    toolbean.userId = [dic objectToStringForKey:@"id"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.loginid= [dic objectToStringForKey:@"loginid"];
    toolbean.sex= [dic objectToStringForKey:@"sex"];
    toolbean.job= [dic objectToStringForKey:@"job"];
    if (!toolbean.job) {
        toolbean.job = @"";
    }
    toolbean.city= [dic objectToStringForKey:@"city"];
    toolbean.showmobilephone= [dic objectToStringForKey:@"showmobilephone"];
    toolbean.createdate= [dic objectToStringForKey:@"createdate"];
    toolbean.email= [dic objectToStringForKey:@"email"];
    toolbean.conferencename= [dic objectToStringForKey:@"conferencename"];
    toolbean.docheckin= [dic objectToStringForKey:@"docheckin"];
    toolbean.checkincode= [dic objectToStringForKey:@"checkincode"];
    toolbean.checkintime= [dic objectToStringForKey:@"checkintime"];
    toolbean.visible= [dic objectToStringForKey:@"visible"];
    toolbean.remark = [dic objectToStringForKey:@"remark"];
    toolbean.roomNo = [dic objectToStringForKey:@"roomnum"];
    toolbean.isCheckinMgr = [dic objectToStringForKey:@"isCheckinMgr"];
    return toolbean;
}


- (id)copyWithZone:(NSZone *)zone{
    UserInfo *info = [[[UserInfo alloc]init]autorelease];
    info.userId= self.userId;
    info.tdConferenceId= self.tdConferenceId;
    info.name= self.name;
    info.loginid= self.loginid;
    info.sex= self.sex;
    info.job= self.job;
    info.city= self.city;
    info.showmobilephone= self.showmobilephone;
    info.createdate= self.createdate;
    info.email= self.email;
    info.conferencename= self.conferencename;
    info.docheckin= self.docheckin;
    info.checkincode= self.checkincode;
    info.checkintime= self.checkintime;
    info.visible= self.visible;
    info.roomNo = self.roomNo;
    info.remark = self.remark;
    info.isCheckinMgr = self.isCheckinMgr;
    return info;
}

- (BOOL)isEqual:(id)object{
    if ([object class] == self.class) {
        UserInfo *info = (UserInfo *)object;
        return [info.userId isEqual:self.userId];
    }
    return NO;
}

@end
