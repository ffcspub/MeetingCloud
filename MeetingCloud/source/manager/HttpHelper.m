//
//  HttpHelper.m
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "HttpHelper.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Context.h"
#import "UITools.h"
#import "GDataXMLNode.h"
#import "ShareManager.h"
#import "TalkmessageGroup.h"

@interface HttpHelper(Private)

-(NSString *) getServerUrlByKey:(NSString *) key;

-(NSArray *) httpQuerylistByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean;

-(NSArray *) httpQuerylistByUrlkey:(NSString *)urlkey postDicsIncludePage:(NSDictionary *)postdics toolsBean:(NSObject *) toolsBean;

-(NSObject *) httpQuerySingleByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean;

-(NSDictionary *) dicFromResponseString:(NSString *)responseString;
-(NSArray *) arrayFromResponseString:(NSString *)responseString keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean;
-(NSArray *) arrayFromResponseStringIncludePage:(NSString *)responseString toolsBean:(NSObject *) toolsBean;
-(NSObject *) objectFromResponseString:(NSString *)responseString keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean;
-(NSString *) resonseStringByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics;
-(NSString *) resonseStringByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics file:(NSString *)file filekey:(NSString *)filekey;
-(NSDictionary *) dicByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics;
-(NSDictionary *) dicByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics  picturename:(NSString *)picturename fileData:(NSData *)fileData filekey:(NSString *)filekey;

-(NSDictionary *) dicByUrl:(NSString *)url postDics:(NSDictionary *)postdics;

-(NSString *) resonseStringByUrl:(NSString *)url postDics:(NSDictionary *)postdics;

@end


@implementation HttpHelper
@synthesize error = _error,resultState=_resultState,msg = _msg,isLastPage = _isLastPage;

-(void) dealloc{
    [_error release];
    [_msg release];
    [super dealloc];
}

/**
 * 用户申请加入会议
 */
-(UserInfo *) addUserInfoByConferenceId:(NSString *)conferenceId name:(NSString *)name loginid:(NSString *)loginid sex:(NSString *)sex job:(NSString *)job city:(NSString*)city email:(NSString *)email{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"tdConferenceId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:loginid forKey:@"loginid"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:job forKey:@"job"];
    [dic setObject:city forKey:@"city"];
    [dic setObject:email forKey:@"email"];
    UserInfo *userInfo = [[[UserInfo alloc]init]autorelease];
    return (UserInfo *)[self httpQuerySingleByUrlkey:URL_USER_ADD postDics:dic keyName:@"userInfo" toolsBean:userInfo];
}

/**
 * 获取登录密码
 */
-(void) getPwdByLoginId:(NSString *)loginId conferenceId:(NSString *)conferenceId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:loginId forKey:@"loginid"];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [self dicByUrlkey:URL_USER_PWD postDics:dic];
}

/**
 * 登录及获取会议
 */
-(Conference *) getConferenceByUserInfo:(UserInfo *)userInfo ConferenceId:(NSString *) conferenceId password:(NSString *)password loginid:(NSString *)loginid loginType:(NSString *)loginType cloudType:(int) cloudType{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:loginid forKey:@"loginid"];
    [dic setObject:@"3" forKey:@"pictype"];
    [dic setObject:loginType forKey:@"loginType"];
    [dic setObject:[NSString stringWithFormat:@"%d",cloudType] forKey:@"cloudType"];
    NSDictionary *responseDic = [self dicByUrlkey:URL_USER_LOGIN postDics:dic];
    if (responseDic && _resultState) {
        NSDictionary *userinfoDic = [responseDic objectForKey:@"userInfo"];
        if (userinfoDic) {
            UserInfo *usertemp = (UserInfo *)[userInfo dic2Object:userinfoDic];
            userInfo.userId = usertemp.userId;
            userInfo.city = usertemp.city;
            userInfo.loginid = usertemp.loginid;
            userInfo.name = usertemp.name;
            userInfo.checkincode = usertemp.checkincode;
            userInfo.checkintime = usertemp.checkintime;
            userInfo.sex = usertemp.sex;
            userInfo.job = usertemp.job;
            userInfo.isCheckinMgr = usertemp.isCheckinMgr;
        }
        NSDictionary *conferenceDic = [responseDic objectForKey:@"conference"];
        if(conferenceDic){
            Conference *temp = [[[Conference alloc]init ]autorelease ]; 
            Conference *conference = (Conference *)[temp dic2Object:conferenceDic];
            return conference;
        }
    }
    return nil;
}

/**
 * 获取已加入会议列表
 */
-(NSArray *) getAddedConferencesByLoginid:(NSString *)loginid  cloudType:(int) cloudType{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:loginid forKey:@"loginid"];
    [dic setObject:[NSString stringWithFormat:@"%d",cloudType] forKey:@"cloudType"];
    Conference *conference = [[[Conference alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_CONFERENCES_LOGINGET postDics:dic keyName:@"conferences" toolsBean:conference];
}

/**
 * 获取未加入会议列表
 */
-(NSArray *) getNoAddedConferencesByLoginid:(NSString *)loginid  cloudType:(int) cloudType{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:loginid forKey:@"loginid"];
    [dic setObject:[NSString stringWithFormat:@"%d",cloudType] forKey:@"cloudType"];
    Conference *conference = [[[Conference alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_CONFERENCES_GET postDics:dic keyName:@"conferences" toolsBean:conference];
}

/**
 * 获取登录用户的功能菜单
 */
-(NSArray *) getModuleConferencesByUserId:(NSString *)userid{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userid forKey:@"userId"];
    ModuleConference *conference = [[[ModuleConference alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_MODULE_GET postDics:dic keyName:@"moduleConferences" toolsBean:conference];
}

/**
 * 读取会议议程列表
 */
-(NSArray *) getAgendasByConferenceId:(NSString *) conferencedId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferencedId forKey:@"conferenceId"];
    Agenda *toolbean = [[[Agenda alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_AGENDAS_GET postDics:dic keyName:@"agendas" toolsBean:toolbean];
}

/**
 * 读取某个议程详细列表 YY-MM-DD
 */
-(NSArray *) getAgendaInfosByConferenceId:(NSString *) conferencedId agendDate:(NSString *)agendDate{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferencedId forKey:@"conferenceId"];
    [dic setObject:agendDate forKey:@"agendDate"];
    Agenda *toolbean = [[[Agenda alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_AGENDAINFOS_GET postDics:dic keyName:@"agendas" toolsBean:toolbean];
}

/**
 * 新增你云我云分组
 */
- (void)addTalkmessageGroupByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId groupName:(NSString *)groupName intro:(NSString *)intro
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:groupName forKey:@"groupName"];
    if (intro) {
        [dic setObject:intro forKey:@"intro"];
    }
    [self dicByUrlkey:URL_TALKMESSAGEGROUP_ADD postDics:dic];
}

/**
 * 读取你云我云分组列表
 */
-(NSArray *)getTalkmessageGroupByConferenceId:(NSString *)tdConferenceId pageNum:(NSString *)pageNum
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:tdConferenceId forKey:@"tdConferenceId"];
    [dic setObject:pageNum forKey:@"pageNum"];
    TalkmessageGroup *toolbean = [[[TalkmessageGroup alloc] init] autorelease];
    return [self httpQuerylistByUrlkey:URL_TALKMESSAGEGROUP_GET postDicsIncludePage:dic toolsBean:toolbean];
}

/**
 * 读取你云我云分页信息列表
 */
-(NSArray *) getTalkmessagesByConferenceId:(NSString *) conferencedId groupId:(NSString *)groupId pageNum:(NSString *)pageNum
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferencedId forKey:@"tdConferenceId"];
    if (groupId) {
        [dic setObject:groupId forKey:@"tmGroupId"];
    }
    [dic setObject:pageNum forKey:@"pageNum"];
    Talkmessage *toolbean = [[[Talkmessage alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_TALKMESSAGESPAGE_GET postDicsIncludePage:dic toolsBean:toolbean];
}

/**
 * 读取你云我云信息(单个)
 */	
-(Talkmessage *) getTalkmessageByConferenceId:(NSString *) conferencedId TalkmessageId:(NSString *)talkmessageId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferencedId forKey:@"conferenceId"];
    [dic setObject:talkmessageId forKey:@"talkmessageId"];
    Talkmessage *toolbean = [[[Talkmessage alloc]init]autorelease];
    return (Talkmessage *)[self httpQuerySingleByUrlkey:URL_TALKMESSAGE_GET postDics:dic keyName:@"talkmessage" toolsBean:toolbean];
}


/**
 * 你云我云发言接口
 */	
-(void) addTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageGroupId:(NSString *)talkmessageGroupId imsi:(NSString *)imsi content:(NSString *)content picturename:(NSString *) picturename fileData:(NSData *)fileData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"tdUserId"];
    [dic setObject:conferenceId forKey:@"tdConferenceId"];
    if (talkmessageGroupId) {
        [dic setObject:talkmessageGroupId forKey:@"talkmessageGroupId"];
    }
    [dic setObject:imsi forKey:@"imsi"];
    [dic setObject:content forKey:@"content"];
    [self dicByUrlkey:URL_TALKMESSAGES_ADD postDics:dic picturename:picturename fileData:fileData filekey:@"fileItem"];
}

/**
 * 你云我云删除接口
 */	
-(void) delTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:talkmessageId forKey:@"talkmessageId"];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [self dicByUrlkey:URL_TALKMESSAGE_DEL postDics:dic];
}

/**
 * 你云我云编辑接口
 */	
-(void) editTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId content:(NSString *) content{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:talkmessageId forKey:@"talkmessageId"];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:content forKey:@"content"];
    [self dicByUrlkey:URL_TALKMESSAGE_EDIT postDics:dic];
}

/**
 * 添加你云我云评论
 */
-(void) addTalkcommendByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId content:(NSString *) content{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"tdUserId"];
    [dic setObject:talkmessageId forKey:@"tdTalkmessageId"];
    [dic setObject:conferenceId forKey:@"tdConferenceId"];
    [dic setObject:content forKey:@"content"];
    [self dicByUrlkey:URL_TALKCOMMENT_ADD postDics:dic];
}

/**
 * 获取你云我云评论
 */
-(NSArray *) getTalkcommendsByTalkmessageId:(NSString *)talkmessageId pageNum:(NSString *)pageNum{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:talkmessageId forKey:@"tdTalkmessageId"];
    [dic setObject:pageNum forKey:@"pageNum"];
    Talkcomment *toolbean = [[[Talkcomment alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_TALKCOMMENTS_GET postDicsIncludePage:dic toolsBean:toolbean];
}

/**
 * 删除你云我云评论
 */
-(void) delTalkcommendByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId talkcommentId:(NSString *)talkcommentId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:talkcommentId forKey:@"talkcomentId"];
    [dic setObject:talkmessageId forKey:@"talkmessageId"];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [self dicByUrlkey:URL_TALKCOMMENT_DEL postDics:dic];
}

/**
 * 查询用餐安排时间列表信息
 */
-(NSArray *) getDinnerplansByConferenceId:(NSString *) conferenceId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    DinnerPlan *toolbean = [[[DinnerPlan alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_DINNERPLANS_GET postDics:dic keyName:@"dinnerplans" toolsBean:toolbean];
}

/**
 * 查询用餐安排时间列表信息(根据时间）
 */
-(NSArray *) getDinnerplansByConferenceId:(NSString *)conferenceId dinnerDate:(NSString *) dinnerDate{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:dinnerDate forKey:@"dinnerDate"];
    DinnerPlan *toolbean = [[[DinnerPlan alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_DINNERPLANSINFOS_GET postDics:dic keyName:@"dinnerplans" toolsBean:toolbean];
}

/**
 * 查询分桌列表信息
 */
-(NSArray *) getDinnertablesByConferenceId:(NSString *)conferenceId dinnerplanId:(NSString *)dinnerplanId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:dinnerplanId forKey:@"dinnerplanId"];
    Dinnertable *toolbean = [[[Dinnertable alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_DINNERTABLES_GET postDics:dic keyName:@"dinnertables" toolsBean:toolbean];

}

/**
 * 查询通讯录列表信息
 */
-(NSArray *) getUserInfosByConferenceId:(NSString *)conferenceId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    UserInfo *toolbean = [[[UserInfo alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_USERINFOS_GET postDics:dic keyName:@"userInfos" toolsBean:toolbean];
}

/**
 * 查询收件箱信息
 */
-(NSArray *) getReceivePrivatemessagesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:userId forKey:@"userId"];
    Privatemessage *toolbean = [[[Privatemessage alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_PRIVATEMESSAGE_GETRECEIVE postDics:dic keyName:@"privatemessages" toolsBean:toolbean];
}

/**
 * 查询发件箱信息
 */
-(NSArray *) getSendedPrivatemessagesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:userId forKey:@"userId"];
    Privatemessage *toolbean = [[[Privatemessage alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_PRIVATEMESSAGE_GETSEND postDics:dic keyName:@"privatemessages" toolsBean:toolbean];
}

/**
 * 发送私信
 */
-(void) sendPrivatemessagesFromUserid:(NSString *)fromuserid toUserids:(NSString *)touserids content:(NSString *)content  conferenceId:(NSString *)conferenceId parentid:(NSString *) parentid{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"tdConferenceId"];
    [dic setObject:fromuserid forKey:@"fromuserid"];
    [dic setObject:touserids forKey:@"touserids"];
    [dic setObject:content forKey:@"content"];
    if (!parentid ||[parentid length]==0) {
        parentid = @"0";
    }
    [dic setObject:parentid forKey:@"parentid"];
    [self dicByUrlkey:URL_PRIVATEMESSAGE_ADD postDics:dic];
}

/**
 * 删除私信
 */
-(void) delPrivateMessageByPrivatemessageId:(NSString *)privatemessageId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:privatemessageId forKey:@"privatemessageId"];
    [self dicByUrlkey:URL_PRIVATEMESSAGE_DEL postDics:dic];
}

/**
 * 获取推送信息
 */
-(NSArray *) getClientPushesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId type:(int)type{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    ClientPush *toolbean = [[[ClientPush alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_CLIENTPUSHS_GET postDics:dic keyName:@"clientPushs" toolsBean:toolbean];
}

/**
 * 获取共享资料
 */
-(NSArray *) getConferenceFilesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:userId forKey:@"userId"];
    ConferenceFiles *toolbean = [[[ConferenceFiles alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_CONFERENCEFILES_GET postDics:dic keyName:@"conferenceFiles" toolsBean:toolbean];
}


/**
 * 提交建议
 */
-(void) addRecommendByConferenceId:(NSString *)conferenceId userId:(NSString *)userId content:(NSString *)content{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:content forKey:@"content"];
    [self dicByUrlkey:URL_RECOMMEND_ADD postDics:dic];
}

/**
 * 获取皮肤列表
 */
-(NSArray *) getUIStyles{
    UIStyle *toolbean = [[[UIStyle alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_UISTYLES_GET postDics:nil keyName:@"styles" toolsBean:toolbean];
}

/**
 * 用户签到
 */
-(void) userCheckByUserId:(NSString *)userId checkincode:(NSString *)checkincode{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:checkincode forKey:@"checkincode"];
    [self dicByUrlkey:URL_USER_CHECK postDics:dic];
}


/**
 * 发送email
 */
-(void) sendEmailByConferenceId:(NSString *)conferenceId userId:(NSString *)userId email:(NSString *)email conferenceFilesId:(NSString *)conferenceFilesId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"tdConferenceId"];
    [dic setObject:userId forKey:@"tdUserId"];
    [dic setObject:email forKey:@"email"];
    [dic setObject:conferenceFilesId forKey:@"tdConferenceFilesId"];
    [self dicByUrlkey:URL_EMAIL_SEND postDics:dic];
}

/**
 * 获取版本信息
 */
-(Clientversion *) getVersion{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VERSION_FJTC_HYY forKey:@"appKey"];
    Clientversion *toolbean = [[[Clientversion alloc]init]autorelease];
    return (Clientversion *) [self httpQuerySingleByUrlkey:URL_VERSION_GET postDics:dic keyName:@"clientversion" toolsBean:toolbean];
}

/**
 *获取分组名单信息
 */
-(NSArray *) getTalkGroupByConferenceId:(NSString *)conferenceId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:conferenceId forKey:@"conferenceId"];
    Talkgroup *toolbean = [[[Talkgroup alloc]init]autorelease];
    return [self httpQuerylistByUrlkey:URL_TALKGROUP_GET postDics:dic keyName:@"talkgroups" toolsBean:toolbean];
}

/**
 * 获取二维码地址
 */
-(NSString *) loadCodeUrl{
    NSDictionary *dic = [UITools loadDictionary:URLFILENAME];
    NSString *url = [dic objectForKey:URL_LOADCODE];
    NSString *realUrl= [NSString stringWithFormat:url,[ShareManager getInstance].conference.conferenceId,[ShareManager getInstance].userInfo.userId,[UITools getImisi]];
    NSDictionary *responseDic = [self dicByUrl:realUrl postDics:nil];
    NSString *msg = [responseDic objectForKey:@"desc"];
    NSString *imgUrl = nil;
    if (!_error) {
        NSString *succes = [responseDic objectForKey:@"result"];
        if ([@"succ" isEqualToString:succes]) {
            _error = nil;
            imgUrl = [responseDic objectForKey:@"url"];
        }else{
            _error = [[NSError alloc]initWithDomain:ERROR_MYTYPE code:1 userInfo:[NSDictionary dictionaryWithObject:msg forKey:ERROR_MESSAGE]];
        }
    }
    return imgUrl;
}

/**
 * 签到
 */
-(void) checkCode:(int)scanType content:(NSString  *)content{
    NSDictionary *dic = [UITools loadDictionary:URLFILENAME];
    NSString *url = [dic objectForKey:URL_CHECKCODE];
    NSString *postContent = nil;
    if (scanType == 1) {
         postContent = [NSString stringWithFormat:@"%@;%@",[ShareManager getInstance].conference.conferenceId,content];
    }else if(scanType == 2){
        postContent = content;
    }
    NSString *realUrl= [NSString stringWithFormat:url,scanType,postContent];
    NSDictionary *responseDic = [self dicByUrl:realUrl postDics:nil];
    NSString *msg = [responseDic objectForKey:@"desc"];
    if (!_error) {
        NSString *succes = [responseDic objectForKey:@"result"];
        if ([@"succ" isEqualToString:succes]) {
            _error = nil;
        }else{
            _error = [[NSError alloc]initWithDomain:ERROR_MYTYPE code:1 userInfo:[NSDictionary dictionaryWithObject:msg forKey:ERROR_MESSAGE]];
        }
    }
    
}

@end

@implementation HttpHelper(Private)

-(NSDictionary *) dicFromResponseString:(NSString *)responseString{
    NSDictionary *dictionary = [responseString JSONValue];
    if(dictionary){
        NSString *returnCode = [dictionary objectForKey:@"returnCode"];
        if (returnCode) {
            if([@"1" isEqualToString:returnCode]){
                _resultState = YES;
                self.msg = [dictionary objectForKey:@"msg"];
                NSDictionary *page = [dictionary objectForKey:@"page"];
                if (page) {
                    NSNumber *isLastPage = [page objectForKey:@"isLastPage"];
                    if (isLastPage.intValue == 1) {
                        _isLastPage = YES;
                    } else {
                        _isLastPage = NO;
                    }
                }
            }else{
                _error = [[NSError alloc]initWithDomain:ERROR_MYTYPE code:1 userInfo:[NSDictionary dictionaryWithObject:[dictionary objectForKey:@"msg"] forKey:ERROR_MESSAGE]];
            }
        }
    }else{
        _error = [[NSError alloc]initWithDomain:ERROR_MYTYPE code:1 userInfo:[NSDictionary dictionaryWithObject:MSG_ERROR_SERVER forKey:ERROR_MESSAGE]];
    }
    return dictionary;
}

-(NSArray *) arrayFromResponseString:(NSString *)responseString keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean{
    NSMutableArray *beans = [NSMutableArray array];
    NSDictionary *dictionary = [self dicFromResponseString:responseString];
    if(dictionary && _resultState){
        if(keyName){
            NSArray *array = [dictionary objectForKey:keyName];
            if(array && [array count]>0){
                for (NSDictionary *dic in array) {
                    if([toolsBean respondsToSelector:@selector(dic2Object:)]){
                        NSObject *bean = [toolsBean performSelector:@selector(dic2Object:) withObject:dic];
                        [beans addObject:bean]; 
                    }
                }
            }  
        }
    }
    return beans;
}

-(NSArray *) arrayFromResponseStringIncludePage:(NSString *)responseString toolsBean:(NSObject *) toolsBean{
    NSMutableArray *beans = [NSMutableArray array];
    NSDictionary *dictionary = [self dicFromResponseString:responseString];
    NSDictionary *data = [dictionary objectForKey:@"page"];
    if(data && _resultState){
        NSArray *array = [data objectForKey:@"result"];
        if(array && [array count]>0){
            for (NSDictionary *dic in array) {
                if([toolsBean respondsToSelector:@selector(dic2Object:)]){
                    NSObject *bean = [toolsBean performSelector:@selector(dic2Object:) withObject:dic];
                    [beans addObject:bean];
                }
            }
        }
    }
    return beans;
}

-(NSObject *) objectFromResponseString:(NSString *)responseString keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean{
    NSObject * bean = nil;
    NSDictionary *dictionary = [self dicFromResponseString:responseString];
    if(dictionary && _resultState){
        if(keyName){
            NSDictionary * dic = [dictionary objectForKey:keyName];
            if(dic && [toolsBean respondsToSelector:@selector(dic2Object:)]){
                bean = [toolsBean performSelector:@selector(dic2Object:) withObject:dic];
            }
        }
    }
    return bean;
}


-(NSString *) resonseStringByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics picturename:(NSString *)picturename fileData:(NSData *)fileData filekey:(NSString *)filekey{
    NSString *responseString = nil;
    NSString *url = [self getServerUrlByKey:urlkey];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    if (postdics) {
        NSArray *keys = [postdics allKeys];
        for (NSString *mkey in keys) {
            NSObject *value = [postdics objectForKey:mkey];
            [request addPostValue:value forKey:mkey];
        }
    }
    if (fileData) {
        [request
         addData:fileData withFileName:picturename andContentType:@"image/jpeg" forKey:filekey];
    }
    [request startSynchronous];
    if([request error]){
        self.error = [request error];
    }else{
        responseString = [request responseString];
    }
    return responseString;
}

-(NSString *) resonseStringByUrl:(NSString *)url postDics:(NSDictionary *)postdics{
    NSString *responseString = nil;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    if (postdics) {
        NSArray *keys = [postdics allKeys];
        for (NSString *mkey in keys) {
            NSObject *value = [postdics objectForKey:mkey];
            [request addPostValue:value forKey:mkey];
        }
    }
    [request startSynchronous];
    if([request error]){
        self.error = [request error];
    }else{
        responseString = [request responseString];
        NSLog(responseString);
    }
    return responseString;
}

-(NSString *) resonseStringByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics{
    NSString *responseString = nil;
    NSString *url = [self getServerUrlByKey:urlkey];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    if (postdics) {
        NSArray *keys = [postdics allKeys];
        for (NSString *mkey in keys) {
            NSObject *value = [postdics objectForKey:mkey];
            [request addPostValue:value forKey:mkey];
        }
    }
    [request startSynchronous];
    if([request error]){
        self.error = [request error];
    }else{
        responseString = [request responseString];
        NSLog(responseString);
    }
    return responseString;
}

-(NSDictionary *) dicByUrl:(NSString *)url postDics:(NSDictionary *)postdics{
    NSString *responseString = [self resonseStringByUrl:url postDics:postdics];
    if (responseString) {
        return [self dicFromResponseString:responseString];
    }
    return  nil;
}
                                 
-(NSDictionary *) dicByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics{
    NSString *responseString = [self resonseStringByUrlkey:urlkey postDics:postdics];
    if (responseString) {
        return [self dicFromResponseString:responseString];
    }
    return  nil;
}

-(NSDictionary *) dicByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics  picturename:(NSString *)picturename fileData:(NSData *)fileData filekey:(NSString *)filekey{
    NSString *responseString = [self resonseStringByUrlkey:urlkey postDics:postdics picturename:picturename fileData:fileData filekey:filekey];
    if (responseString) {
        return [self dicFromResponseString:responseString];
    }
    return  nil;
}

-(NSArray *) httpQuerylistByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean{
    NSArray *beans = nil;
    NSString *responseString = [self resonseStringByUrlkey:urlkey postDics:postdics];
    if (responseString) {
        beans = [self arrayFromResponseString:responseString keyName:keyName toolsBean:toolsBean];
    }
    return beans;   
}

-(NSArray *) httpQuerylistByUrlkey:(NSString *)urlkey postDicsIncludePage:(NSDictionary *)postdics toolsBean:(NSObject *) toolsBean{
    NSArray *beans = nil;
    NSString *responseString = [self resonseStringByUrlkey:urlkey postDics:postdics];
    NSLog(@"getTalkmessage responseString == %@",responseString);
    if (responseString) {
        beans = [self arrayFromResponseStringIncludePage:responseString toolsBean:toolsBean];
    }
    return beans;
}

-(NSObject *) httpQuerySingleByUrlkey:(NSString *)urlkey postDics:(NSDictionary *)postdics keyName:(NSString *)keyName toolsBean:(NSObject *) toolsBean{
    NSObject *bean = nil;
    NSString *responseString = [self resonseStringByUrlkey:urlkey postDics:postdics];
    if (responseString) {
        bean = [self objectFromResponseString:responseString keyName:keyName toolsBean:toolsBean];
    }
    return bean;
}

-(NSString *) getServerUrlByKey:(NSString *) key{
    NSDictionary *dic = [UITools loadDictionary:URLFILENAME];
    NSString *serverurl = [dic objectForKey:TEST_URL];
    NSString *methodUrl = [dic objectForKey:key];
    return [NSString stringWithFormat:serverurl,methodUrl];
}





@end



