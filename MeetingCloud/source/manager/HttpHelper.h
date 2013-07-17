//
//  HttpHelper.h
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entitys.h"

@interface HttpHelper : NSObject

@property(nonatomic,retain) NSError *error;
@property(nonatomic,retain) NSString *msg;
@property(nonatomic,assign) BOOL resultState;
@property(nonatomic,assign) BOOL isLastPage;

/**
 * 用户申请加入会议
 */
-(UserInfo *) addUserInfoByConferenceId:(NSString *)conferenceId name:(NSString *)name loginid:(NSString *)loginid sex:(NSString *)sex job:(NSString *)job city:(NSString*)city email:(NSString *)email;

/**
 * 获取登录密码
 */
-(void) getPwdByLoginId:(NSString *)loginId conferenceId:(NSString *)conferenceId;


/**
 * 登录及获取会议
 */
-(Conference *) getConferenceByUserInfo:(UserInfo *)userInfo ConferenceId:(NSString *) conferenceId password:(NSString *)password loginid:(NSString *)loginid loginType:(NSString *)loginType cloudType:(int) cloudType;

/**
 * 获取已加入会议列表
 */
-(NSArray *) getAddedConferencesByLoginid:(NSString *)loginid  cloudType:(int) cloudType;

/**
 * 获取未加入会议列表
 */
-(NSArray *) getNoAddedConferencesByLoginid:(NSString *)loginid  cloudType:(int) cloudType;

/**
 * 获取登录用户的功能菜单
 */
-(NSArray *) getModuleConferencesByUserId:(NSString *)userid;


/**
 * 读取会议议程列表
 */
-(NSArray *) getAgendasByConferenceId:(NSString *) conferencedId;

/**
 * 读取某个议程详细列表 YY-MM-DD
 */
-(NSArray *) getAgendaInfosByConferenceId:(NSString *) conferencedId agendDate:(NSString *)agendDate;

/**
 * 新增你云我云分组
 */
- (void)addTalkmessageGroupByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId groupName:(NSString *)groupName intro:(NSString *)intro;

/**
 * 读取你云我云分组列表
 */
-(NSArray *)getTalkmessageGroupByConferenceId:(NSString *)tdConferenceId pageNum:(NSString *)pageNum;

/**
 * 读取你云我云信息列表
 */
-(NSArray *) getTalkmessagesByConferenceId:(NSString *) conferencedId groupId:(NSString *)groupId pageNum:(NSString *)pageNum;
/**
 * 读取你云我云信息(单个)
 */	
-(Talkmessage *) getTalkmessageByConferenceId:(NSString *) conferencedId TalkmessageId:(NSString *)talkmessageId;

/**
 * 你云我云发言接口
 */	
-(void) addTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageGroupId:(NSString *)talkmessageGroupId imsi:(NSString *)imsi content:(NSString *)content picturename:(NSString *) picturename fileData:(NSData *)fileData;


/**
 * 你云我云删除接口
 */	
-(void) delTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId;


/**
 * 你云我云编辑接口
 */	
-(void) editTalkmessageByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId content:(NSString *) content;


/**
 * 添加你云我云评论
 */
-(void) addTalkcommendByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId content:(NSString *) content; 

/**
 * 获取你云我云评论
 */
-(NSArray *) getTalkcommendsByTalkmessageId:(NSString *)talkmessageId pageNum:(NSString *)pageNum;

/**
 * 删除你云我云评论
 */
-(void) delTalkcommendByUserid:(NSString *)userId conferenceId:(NSString *)conferenceId talkmessageId:(NSString *)talkmessageId talkcommentId:(NSString *)talkcommentId; 

/**
 * 查询用餐安排时间列表信息
 */
-(NSArray *) getDinnerplansByConferenceId:(NSString *) conferenceId;

/**
 * 查询用餐安排时间列表信息(根据时间）
 */
-(NSArray *) getDinnerplansByConferenceId:(NSString *)conferenceId dinnerDate:(NSString *) dinnerDate;

/**
 * 查询分桌列表信息
 */
-(NSArray *) getDinnertablesByConferenceId:(NSString *)conferenceId dinnerplanId:(NSString *)dinnerplanId;

/**
 * 查询通讯录列表信息
 */
-(NSArray *) getUserInfosByConferenceId:(NSString *)conferenceId;


/**
 * 查询收件箱信息
 */
-(NSArray *) getReceivePrivatemessagesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId;

/**
 * 查询发件箱信息
 */
-(NSArray *) getSendedPrivatemessagesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId;

/**
 * 发送私信
 */
-(void) sendPrivatemessagesFromUserid:(NSString *)fromUserid toUserids:(NSString *)touserids content:(NSString *)content  conferenceId:(NSString *)conferenceId parentid:(NSString *) parentid;

/**
 * 删除私信
 */
-(void) delPrivateMessageByPrivatemessageId:(NSString *)privatemessageId;

/**
 * 获取推送信息
 */
-(NSArray *) getClientPushesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId type:(int)type;

/**
 * 获取共享资料
 */
-(NSArray *) getConferenceFilesByConferenceId:(NSString *)conferenceId userId:(NSString *)userId;

/**
 * 提交建议
 */
-(void) addRecommendByConferenceId:(NSString *)conferenceId userId:(NSString *)userId content:(NSString *)content;

/**
 * 获取皮肤列表
 */
-(NSArray *) getUIStyles;

/**
 * 用户签到
 */
-(void) userCheckByUserId:(NSString *)userId checkincode:(NSString *)checkincode;

/**
 * 发送email
 */
-(void) sendEmailByConferenceId:(NSString *)conferenceId userId:(NSString *)userId email:(NSString *)email conferenceFilesId:(NSString *)conferenceFilesId;

/**
 * 获取版本信息
 */
-(Clientversion *) getVersion;

/**
 *获取分组名单信息
 */
-(NSArray *) getTalkGroupByConferenceId:(NSString *)conferenceId;

/**
 * 获取二维码地址
 */
-(NSString *) loadCodeUrl;

/**
 * 签到
 */
-(void) checkCode:(int)scanType content:(NSString  *)content;

@end
