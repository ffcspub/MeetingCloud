//
//  Clientversion.m
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Clientversion.h"

@implementation Clientversion

@synthesize versionId;
@synthesize clientname;
@synthesize updatedsc;
@synthesize nversion;
@synthesize sversion;
@synthesize filepath;
@synthesize versionname;


-(void) dealloc{
    [versionId release];
    [clientname release];
    [updatedsc release];
    [nversion release];
    [sversion release];
    [filepath   release];
    [versionname release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Clientversion *version = [[[Clientversion alloc]init]autorelease];
    NSNumber *idtemp = [dic objectForKey:@"id"];
    version.versionId = [idtemp stringValue];
    version.clientname = [dic objectForKey:@"clientname"];
    version.updatedsc = [dic objectForKey:@"remark"];
    NSNumber *nversiontemp = [dic objectForKey:@"nversion"];
    version.nversion = [nversiontemp stringValue];
    NSNumber *sversiontemp = [dic objectForKey:@"sversion"];
    version.sversion = [sversiontemp stringValue];
    version.filepath = [dic objectForKey:@"filepath"];
    version.versionname = [dic objectForKey:@"versionname"];
    return version;
}

@end
