//
//  HttpHelperTest.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-8.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "HttpHelperTest.h"
#import "Entitys.h"
#import "HttpHelper.h"
#import "UITools.h"
#import "Context.h"
#import "ShareManager.h"

#define LOGINID @"13559172318"

@implementation HttpHelperTest

-(void) testGetVersion{
    HttpHelper *helper = [[HttpHelper alloc]init];
    Clientversion *version = [helper getVersion];
    GHAssertNotNil(version,@"getVersion测试失败");
    [helper release];
}

-(void) testGetUIStyles{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *styles = [helper getUIStyles];
    GHAssertNotNil(styles,@"GetUIStyles测试失败");
    [helper release];
}

-(void) testGetAddedConferencesByLoginid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *conferences = [helper getAddedConferencesByLoginid:LOGINID cloudType:CLOUDTYPE_MEETING];
    GHAssertNotNil(conferences,@"GetAddedConferencesByLoginid测试失败");
    for (Conference * conference in conferences) {
        NSLog(@"id:%@,name:%@",conference.conferenceId,conference.name);
    }
    [helper release];
}

/**
 * 获取未加入会议列表
 */
-(void) testGetNoAddedConferencesByLoginid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *conferences = [helper getNoAddedConferencesByLoginid:LOGINID cloudType:CLOUDTYPE_MEETING];
    GHAssertNotNil(conferences,@"GetAddedConferencesByLoginid测试失败");
    for (Conference * conference in conferences) {
        NSLog(@"id:%@,name:%@",conference.conferenceId,conference.name);
    }
    
    [helper release];
}


-(void) testAddUserInfoByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addUserInfoByConferenceId:@"10417" name:@"张儒" loginid:LOGINID sex:@"1" job:@"" city:@"福州" email:@"test@163.com"];
    NSLog(helper.msg);
    GHAssertTrue(helper.resultState,@"AddUserInfoByConferenceId测试失败");
    [helper release];
}

-(void) testGetConferenceByUserInfo{
    HttpHelper *helper = [[HttpHelper alloc]init];
    UserInfo *userInfo = [[UserInfo alloc]init];
    Conference *confernece = [helper getConferenceByUserInfo:userInfo ConferenceId:@"10002" password:@"123" loginid:LOGINID loginType:@"1" cloudType:CLOUDTYPE_MEETING];
     GHAssertNotNil(confernece,@"GetConferenceByUserInfo测试失败");
    NSLog(confernece.name);
    NSLog(confernece.weather);
    NSLog(confernece.weatheraddress);
    NSLog(userInfo.userId);
    NSLog(userInfo.checkincode);
    [helper release];
}

/**
 * 获取登录用户的功能菜单
 */
-(void) testGetModuleConferencesByUserId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getModuleConferencesByUserId:@"10002"];
    GHAssertNotNil(array,@"GetModuleConferencesByUserId测试失败");
    for (ModuleConference *conference in array) {
        NSLog(conference.name);
    }
    [helper release];
}

-(void) testGetAgendasByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getAgendasByConferenceId:@"10002"];
    GHAssertNotNil(array,@"GetModuleConferencesByUserId测试失败");
    for (Agenda *agenda in array) {
        NSLog(agenda.agendWeek);
    }
    [helper release];
}

/**
 * 读取某个议程详细列表 YY-MM-DD
 */
-(void) testGetAgendaInfosByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getAgendaInfosByConferenceId:@"10002" agendDate:@"2012-03-16"];
    GHAssertNotNil(array,@"GetAgendaInfosByConferenceId测试失败");
    for (Agenda *agenda in array) {
        NSLog(agenda.content);
    }
    [helper release];
}

/**
 * 读取你云我云信息列表
 */
-(void) testGetTalkmessagesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getTalkmessagesByConferenceId:@"10002"];
    GHAssertNotNil(array,@"GetTalkmessagesByConferenceId测试失败");
    for (Talkmessage *bean in array) {
        NSLog(bean.messageId);
    }
    [helper release];
}

/**
 * 读取你云我云信息(单个)
 */	
-(void) testGetTalkmessageByConferenceIdd{
    HttpHelper *helper = [[HttpHelper alloc]init];
    Talkmessage *msg = [helper getTalkmessageByConferenceId:@"10002" TalkmessageId:@"16222"];
    GHAssertNotNil(msg,@"GetTalkmessageByConferenceIdAndMessageId测试失败");
    NSLog(msg.content);
    [helper release];
}

/**
 * 你云我云发言接口
 */	
-(void) testAddTalkmessageByUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addTalkmessageByUserid:@"33360" conferenceId:@"10002" imsi:[UITools getImisi] content:@"测试的话" picturename:@"" file:nil];
    GHAssertTrue(helper.resultState,@"AddTalkmessageByUserid测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 你云我云删除接口
 */	
-(void) testDelTalkmessageByUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper delTalkmessageByUserid:@"33360" conferenceId:@"10002" talkmessageId:@"16360" ];
    GHAssertTrue(helper.resultState,@"DelTalkmessageByUserid测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 你云我云编辑接口
 */	
-(void) testEditTalkmessageByUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper editTalkmessageByUserid:@"33360" conferenceId:@"10002" talkmessageId:@"16221" content:@"看到这条说明已经被改掉了" ];
    GHAssertTrue(helper.resultState,@"ditTalkmessageByUserid测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 添加你云我云评论
 */
-(void) testAddTalkcommendByUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addTalkcommendByUserid:@"33360" conferenceId:@"10002" talkmessageId:@"16221" content:@"说明再次回复" ];
    GHAssertTrue(helper.resultState,@"AddTalkcommendByUserid测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 获取你云我云评论
 */
-(void) testGetTalkcommendsByTalkmessageId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getTalkcommendsByTalkmessageId:@"16221"];
    GHAssertNotNil(array,@"GetTalkcommendsByTalkmessageId测试失败");
    for (Talkcomment *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 删除你云我云评论
 */
-(void) testDelTalkcommendByUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper delTalkcommendByUserid:@"33360" conferenceId:@"10002" talkmessageId:@"16221" talkcommentId:@"11800" ];
    GHAssertTrue(helper.resultState,@"DelTalkcommendByUserid测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 查询用餐安排时间列表信息
 */
-(void) testGetDinnerplansByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getDinnerplansByConferenceId:@"10002"];
    GHAssertNotNil(array,@"testGetDinnerplansByConferenceId测试失败");
    for (DinnerPlan *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 查询用餐安排时间列表信息(根据时间）
 */
-(void) testGetDinnerplansByConferenceIdAndDinnerDate{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getDinnerplansByConferenceId:@"10002" dinnerDate:@"2012-03-15"];
    GHAssertNotNil(array,@"GetDinnerplansByConferenceIdAndDinnerDat测试失败");
    for (DinnerPlan *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 查询分桌列表信息
 */
-(void) testGetDinnertablesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getDinnertablesByConferenceId:@"10002" dinnerplanId:@"10480"];
    GHAssertNotNil(array,@"getDinnertablesByConferenceId测试失败");
    for (Dinnertable *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 查询通讯录列表信息
 */
-(void) testGetUserInfosByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getUserInfosByConferenceId:@"10002"];
    GHAssertNotNil(array,@"getUserInfosByConferenceId测试失败");
    for (UserInfo *bean in array) {
        NSLog(@"id:%@,name:%@",bean.userId,bean.name);
    }
    [helper release];
}


/**
 * 查询收件箱信息
 */
-(void) testGetReceivePrivatemessagesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getReceivePrivatemessagesByConferenceId:@"10002" userId:@"33360"];
    GHAssertNotNil(array,@"getReceivePrivatemessagesByConferenceId测试失败");
    for (Privatemessage *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 查询发件箱信息
 */
-(void) testGetSendedPrivatemessagesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getSendedPrivatemessagesByConferenceId:@"10002" userId:@"33360"];
    GHAssertNotNil(array,@"getSendedPrivatemessagesByConferenceId测试失败");
    for (Privatemessage *bean in array) {
        NSLog(bean.content);
    }
    [helper release];
}

/**
 * 发送私信
 */
-(void) testSendPrivatemessagesFromUserid{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper sendPrivatemessagesFromUserid:@"33212" toUserids:@"33360" content:@"测试数据" conferenceId:@"10002" parentid:@""];
    GHAssertTrue(helper.resultState,@"sendPrivatemessagesFromUserid测试失败");
    NSLog(helper.msg);
    [helper release];
    
}

/**
 * 删除私信
 */
-(void) testDelPrivateMessageByPrivatemessageId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper delPrivateMessageByPrivatemessageId:@"12060"];
    GHAssertTrue(helper.resultState,@"delPrivateMessageByPrivatemessageId测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 获取推送信息
 */
-(void) testGetClientPushesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getClientPushesByConferenceId:@"10002" userId:@"33360" type:CLINEPUSHTYPE_PRIVATEMESSAGE];
    GHAssertNotNil(array,@"getReceivePrivatemessagesByConferenceId测试失败");
    for (ClientPush *bean in array) {
        NSLog(bean.pushMsg);
    }
    [helper release];
}

/**
 * 获取共享资料
 */
-(void) testGetConferenceFilesByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    NSArray *array = [helper getConferenceFilesByConferenceId:@"10002" userId:@"33360"];
    GHAssertNotNil(array,@"GetConferenceFilesByConferenceId测试失败");
    for (ConferenceFiles *bean in array) {
        NSLog(@"id:%@,name:%@",bean.fileId,bean.name);
    }
    [helper release];
}

/**
 * 提交建议
 */
-(void) testAddRecommendByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper addRecommendByConferenceId:@"10002" userId:@"33360" content:@"测试意见"];
    GHAssertTrue(helper.resultState,@"addRecommendByConferenceId测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 用户签到
 */
-(void) testUserCheckByUserId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper userCheckByUserId:@"33360" checkincode:@"33095571580354308246"];
    GHAssertTrue(helper.resultState,@"UserCheckByUserId测试失败");
    NSLog(helper.msg);
    [helper release];
}

/**
 * 发送email
 */
-(void) testSendEmailByConferenceId{
    HttpHelper *helper = [[HttpHelper alloc]init];
    [helper sendEmailByConferenceId:@"10002" userId:@"33360" email:@"16927055@qq.com" conferenceFilesId:@"11980"];
    GHAssertTrue(helper.resultState,@"SendEmailByConferenceId测试失败");
    NSLog(helper.msg);
    [helper release];
}

-(void) testDic{
    NSDictionary *dic = [ShareManager getInstance].faceDic;
    for (NSString *key in dic.allKeys) {
        NSLog(@"[dic setValue:@\"%@\" forKey:@\"%@\"];\n",key,[dic objectForKey:key]);
    }
}

@end
