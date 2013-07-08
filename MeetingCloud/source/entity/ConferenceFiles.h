//
//  ConferenceFiles.h
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConferenceFiles : NSObject
@property(nonatomic,retain) NSString *fileId;//编号
@property(nonatomic,retain) NSString *name;//文件显示名称
@property(nonatomic,retain) NSString *url;//文件路径
@property(nonatomic,retain) NSString *uploadtime;//上传时间 
@property(nonatomic,retain) NSString *tdConferenceId;//会议编号
@property(nonatomic,retain) NSString *conferencename;//会议名称
@property(nonatomic,retain) NSString *dodownload;//是否下载(0=否，1=是)
@property(nonatomic,retain) NSString *doview;//是否预览(0=否，1=是)
@property(nonatomic,retain) NSString *pagesize;//总页数
@property(nonatomic,retain) NSString *filecontenttype;//文件类型content-type  
@property(nonatomic,retain) NSString *picTypeSuffix;//预览图片后缀
@property(nonatomic,retain) NSString *picPath;//预览图片路径
@property(nonatomic,retain) NSString *picTotal;//图片总数
@property(nonatomic,retain) NSString *picNamePrefix;//图片名称前缀
@property(nonatomic,retain) NSString *doemail;//是否发送邮件  0:不发送  1:发送

-(NSObject *) dic2Object:(NSDictionary *)dic;

@end
