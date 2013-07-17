//
//  Conference.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Conference.h"
#import "UITools.h"

@implementation Conference

@synthesize conferenceId;
@synthesize name;
@synthesize welcome;
@synthesize startdate;
@synthesize enddate;
@synthesize tsCitysId;
@synthesize createdate;
@synthesize tdStyleId;
@synthesize weather ;
@synthesize address;
@synthesize keywords;
@synthesize cityname;
@synthesize notify;
@synthesize mobilednseg;
@synthesize isopenbook;
@synthesize weatheraddress;
@synthesize backpic;
@synthesize cloudCfgMap;
@synthesize headimg;
@synthesize doapplyfor;
@synthesize isTalkmessageGrouping;


-(void) dealloc{
    [conferenceId release];
    [name release];
    [welcome release];
    [startdate release];
    [enddate release];
    [tsCitysId release];
    [createdate release];
    [tdStyleId release];
    [weather  release];
    [address release];
    [keywords release];
    [cityname release];
    [notify release];
    [mobilednseg release];
    [isopenbook release];
    [weatheraddress release];
    [backpic release];
    [cloudCfgMap release];
    [headimg release];
    [doapplyfor release];
    [isTalkmessageGrouping release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Conference *toolbean = [[[Conference alloc] init]autorelease];
    toolbean.conferenceId = [dic objectToStringForKey:@"id"];
    toolbean.name = [dic objectToStringForKey:@"name"];
    toolbean.welcome = [dic objectToStringForKey:@"welcome"];
    toolbean.startdate = [dic objectToStringForKey:@"startdate"];
    toolbean.enddate = [dic objectToStringForKey:@"enddate"];
    toolbean.tsCitysId = [dic objectToStringForKey:@"tsCitysId"];
    toolbean.createdate = [dic objectToStringForKey:@"createdate"];
    toolbean.tdStyleId = [dic objectToStringForKey:@"tdStyleId"];
    toolbean.weather  = [dic objectToStringForKey:@"weather"];
    toolbean.address = [dic objectToStringForKey:@"address"];
    toolbean.keywords = [dic objectToStringForKey:@"keywords"];
    toolbean.cityname = [dic objectToStringForKey:@"cityname"];
    toolbean.notify = [dic objectToStringForKey:@"notify"];
    toolbean.mobilednseg = [dic objectToStringForKey:@"mobilednseg"];
    toolbean.isopenbook = [dic objectToStringForKey:@"isopenbook"];
    toolbean.weatheraddress = [dic objectToStringForKey:@"weatheraddress"];
    toolbean.backpic = [dic objectToStringForKey:@"backpic"];
    toolbean.cloudCfgMap = [dic objectForKey:@"cloudCfgMap"];
    toolbean.headimg = [dic objectToStringForKey:@"headimg"];
    toolbean.doapplyfor = [dic objectToStringForKey:@"doapplyfor"];
    toolbean.isTalkmessageGrouping = [dic objectToStringForKey:@"isTalkmessageGrouping"];
    return toolbean;
}


@end
