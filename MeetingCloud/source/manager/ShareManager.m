//
//  ShareManager.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-20.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ShareManager.h"

#define LOGINID @"LOGINID"
#define PASSWORD @"PASSWORD"
#define REMEMBER @"REMEMBER"

static ShareManager *managerSingleton;

@implementation ShareManager

@synthesize userInfo = _userInfo;
@synthesize conference = _conference;
@synthesize isRemember = _isRemember;
@synthesize faceDic = _faceDic;
@synthesize personArray = _personArray;

-(void) dealloc{
    [_userInfo release];
    [_conference release];
    [_faceDic release];
    [_personArray release];
    [super dealloc];
}

-(void) initDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"f0" forKey:@"[/微笑]"];
    [dic setValue:@"f1" forKey:@"[/撇嘴]"];
    [dic setValue:@"f2" forKey:@"[/色]"];
    [dic setValue:@"f3" forKey:@"[/发呆]"];
    [dic setValue:@"f4" forKey:@"[/得意]"];
    [dic setValue:@"f5" forKey:@"[/流泪]"];
    [dic setValue:@"f6" forKey:@"[/害羞]"];
    [dic setValue:@"f7" forKey:@"[/闭嘴]"];
    [dic setValue:@"f8" forKey:@"[/睡]"];
    [dic setValue:@"f9" forKey:@"[/大哭]"];
    [dic setValue:@"f10" forKey:@"[/尴尬]"];
    [dic setValue:@"f11" forKey:@"[/发怒]"];
    [dic setValue:@"f12" forKey:@"[/调皮]"];
    [dic setValue:@"f13" forKey:@"[/呲牙]"];
    [dic setValue:@"f14" forKey:@"[/惊讶]"];
    [dic setValue:@"f15" forKey:@"[/难过]"];
    [dic setValue:@"f16" forKey:@"[/酷]"];
    [dic setValue:@"f17" forKey:@"[/冷汗]"];
    [dic setValue:@"f18" forKey:@"[/抓狂]"];
    [dic setValue:@"f19" forKey:@"[/吐]"];
    [dic setValue:@"f20" forKey:@"[/偷笑]"];
    [dic setValue:@"f21" forKey:@"[/可爱]"];
    [dic setValue:@"f22" forKey:@"[/白眼]"];
    [dic setValue:@"f23" forKey:@"[/傲慢]"];
    [dic setValue:@"f24" forKey:@"[/饥饿]"];
    [dic setValue:@"f25" forKey:@"[/困]"];
    [dic setValue:@"f26" forKey:@"[/惊恐]"];
    [dic setValue:@"f27" forKey:@"[/流汗]"];
    [dic setValue:@"f28" forKey:@"[/憨笑]"];
    [dic setValue:@"f29" forKey:@"[/大兵]"];
    [dic setValue:@"f30" forKey:@"[/奋斗]"];
    [dic setValue:@"f31" forKey:@"[/咒骂]"];
    [dic setValue:@"f32" forKey:@"[/疑问]"];
    [dic setValue:@"f33" forKey:@"[/嘘]"];
    [dic setValue:@"f34" forKey:@"[/晕]"];
    [dic setValue:@"f35" forKey:@"[/折磨]"];
    [dic setValue:@"f36" forKey:@"[/衰]"];
    [dic setValue:@"f37" forKey:@"[/骷髅]"];
    [dic setValue:@"f38" forKey:@"[/敲打]"];
    [dic setValue:@"f39" forKey:@"[/再见]"];
    [dic setValue:@"f40" forKey:@"[/擦汗]"];
    [dic setValue:@"f41" forKey:@"[/抠鼻]"];
    [dic setValue:@"f42" forKey:@"[/鼓掌]"];
    [dic setValue:@"f43" forKey:@"[/糗大了]"];
    [dic setValue:@"f44" forKey:@"[/坏笑]"];
    [dic setValue:@"f45" forKey:@"[/左哼哼]"];
    [dic setValue:@"f46" forKey:@"[/右哼哼]"];
    [dic setValue:@"f47" forKey:@"[/哈欠]"];
    [dic setValue:@"f48" forKey:@"[/鄙视]"];
    [dic setValue:@"f49" forKey:@"[/委屈]"];
    [dic setValue:@"f50" forKey:@"[/快哭了]"];
    [dic setValue:@"f51" forKey:@"[/阴险]"];
    [dic setValue:@"f52" forKey:@"[/亲亲]"];
    [dic setValue:@"f53" forKey:@"[/吓]"];
    [dic setValue:@"f54" forKey:@"[/可怜]"];
    [dic setValue:@"f55" forKey:@"[/菜刀]"];
    [dic setValue:@"f56" forKey:@"[/西瓜]"];
    [dic setValue:@"f57" forKey:@"[/啤酒]"];
    [dic setValue:@"f58" forKey:@"[/篮球]"];
    [dic setValue:@"f59" forKey:@"[/乒乓]"];
    [dic setValue:@"f60" forKey:@"[/咖啡]"];
    [dic setValue:@"f61" forKey:@"[/饭]"];
    [dic setValue:@"f62" forKey:@"[/猪头]"];
    [dic setValue:@"f63" forKey:@"[/玫瑰]"];
    [dic setValue:@"f64" forKey:@"[/凋谢]"];
    [dic setValue:@"f65" forKey:@"[/示爱]"];
    [dic setValue:@"f66" forKey:@"[/爱心]"];
    [dic setValue:@"f67" forKey:@"[/心碎]"];
    [dic setValue:@"f68" forKey:@"[/蛋糕]"];
    [dic setValue:@"f69" forKey:@"[/闪电]"];
    [dic setValue:@"f70" forKey:@"[/炸弹]"];
    [dic setValue:@"f71" forKey:@"[/刀]"];
    [dic setValue:@"f72" forKey:@"[/足球]"];
    [dic setValue:@"f73" forKey:@"[/瓢虫]"];
    [dic setValue:@"f74" forKey:@"[/便便]"];
    [dic setValue:@"f75" forKey:@"[/月亮]"];
    [dic setValue:@"f76" forKey:@"[/太阳]"];
    [dic setValue:@"f77" forKey:@"[/礼物]"];
    [dic setValue:@"f78" forKey:@"[/拥抱]"];
    [dic setValue:@"f79" forKey:@"[/强]"];
    [dic setValue:@"f80" forKey:@"[/弱]"];
    [dic setValue:@"f81" forKey:@"[/握手]"];
    [dic setValue:@"f82" forKey:@"[/胜利]"];
    [dic setValue:@"f83" forKey:@"[/抱拳]"];
    [dic setValue:@"f84" forKey:@"[/勾引]"];
    [dic setValue:@"f85" forKey:@"[/拳头]"];
    [dic setValue:@"f86" forKey:@"[/差劲]"];
    [dic setValue:@"f87" forKey:@"[/爱你]"];
    [dic setValue:@"f88" forKey:@"[/NO]"];
    [dic setValue:@"f89" forKey:@"[/OK]"];
    [dic setValue:@"f90" forKey:@"[/爱情]"];
    [dic setValue:@"f91" forKey:@"[/飞吻]"];
    [dic setValue:@"f92" forKey:@"[/跳跳]"];
    [dic setValue:@"f93" forKey:@"[/发抖]"];
    [dic setValue:@"f94" forKey:@"[/怄火]"];
    [dic setValue:@"f95" forKey:@"[/转圈]"];
    [dic setValue:@"f96" forKey:@"[/磕头]"];
    [dic setValue:@"f97" forKey:@"[/回头]"];
    [dic setValue:@"f98" forKey:@"[/跳绳]"];
    [dic setValue:@"f99" forKey:@"[/挥手]"];
    [dic setValue:@"f100" forKey:@"[/激动]"];
    [dic setValue:@"f101" forKey:@"[/街舞]"];
    [dic setValue:@"f102" forKey:@"[/献吻]"];
    [dic setValue:@"f103" forKey:@"[/左太极]"];
    [dic setValue:@"f104" forKey:@"[/右太极]"];
    _faceDic = dic;
}

+(ShareManager *) getInstance{
    if (managerSingleton == nil) {
        managerSingleton = [[super alloc] init];
        [managerSingleton initDic];
    }
    return managerSingleton;
}

-(NSString *) password{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
}

-(NSString *) loginId{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LOGINID];
}

-(BOOL) isRemember{
    return [[NSUserDefaults standardUserDefaults] boolForKey:REMEMBER];
}

-(NSString *) getPassword{
    return [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
}

-(void) setLoginId:(NSString *)loginId{
    [[NSUserDefaults standardUserDefaults]setValue:loginId forKey:LOGINID];
}

-(void) setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults]setValue:password forKey:PASSWORD];
}

-(void) setIsRemember:(BOOL)isRemember{
    [[NSUserDefaults standardUserDefaults]setBool:isRemember forKey:REMEMBER];
}

-(void) setConference:(Conference *)conference{
    if (_conference) {
        [_conference release];
        _conference = nil;
    }
    _conference = [conference retain];
}

-(void) setUserInfo:(UserInfo *)userInfo{
    if(_userInfo){
        [_userInfo release];
        _userInfo = nil;
    }
    _userInfo = [userInfo retain];
}

@end
