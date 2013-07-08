//
//  ConferenceFiles.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ConferenceFiles.h"
#import "UITools.h"

@implementation ConferenceFiles

@synthesize fileId;
@synthesize name;
@synthesize url;
@synthesize uploadtime;
@synthesize tdConferenceId;
@synthesize conferencename;
@synthesize dodownload;
@synthesize doview;
@synthesize pagesize;
@synthesize filecontenttype;
@synthesize picTypeSuffix;
@synthesize picPath;
@synthesize picTotal;
@synthesize picNamePrefix;
@synthesize doemail;

-(void) dealloc{
    [fileId release];
    [name release];
    [url release];
    [uploadtime release];
    [tdConferenceId release];
    [conferencename release];
    [dodownload release];
    [doview release];
    [pagesize release];
    [filecontenttype release];
    [picTypeSuffix release];
    [picPath release];
    [picTotal release];
    [picNamePrefix release];
    [doemail release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    ConferenceFiles *toolbean = [[[ConferenceFiles alloc]init]autorelease];
    toolbean.fileId= [dic objectToStringForKey:@"id"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.url= [dic objectToStringForKey:@"url"];
    toolbean.uploadtime= [dic objectToStringForKey:@"uploadtime"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.conferencename= [dic objectToStringForKey:@"conferencename"];
    toolbean.dodownload= [dic objectToStringForKey:@"dodownload"];
    toolbean.doview= [dic objectToStringForKey:@"doview"];
    toolbean.pagesize= [dic objectToStringForKey:@"pagesize"];
    toolbean.filecontenttype= [dic objectToStringForKey:@"filecontenttype"];
    toolbean.picPath= [dic objectToStringForKey:@"picPath"];
    toolbean.picTotal= [dic objectToStringForKey:@"picTotal"];
    toolbean.picTypeSuffix= [dic objectToStringForKey:@"picTypeSuffix"];
    toolbean.picNamePrefix =  [dic objectToStringForKey:@"picNamePrefix"];
    toolbean.doemail = [dic objectToStringForKey:@"doemail"];
    return toolbean;
}

@end
