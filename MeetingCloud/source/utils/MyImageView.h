//
//  MyImageView.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@protocol MyImageViewDelegate ;

@interface MyImageView :UIImageView <SDWebImageManagerDelegate>

@property(nonatomic,assign) id<MyImageViewDelegate> delegate;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)cancelCurrentImageLoad;

@end

@protocol MyImageViewDelegate <NSObject>

-(void) didStartingLoadImage:(MyImageView *)imageView;
-(void) myImageView:(MyImageView *)imageView didFinishWithImage:(UIImage *)image;

@end
