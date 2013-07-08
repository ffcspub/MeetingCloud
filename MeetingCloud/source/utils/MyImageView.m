//
//  MyImageView.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(didStartingLoadImage:)]) {
        [_delegate didStartingLoadImage:self];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
    if (_delegate && [_delegate respondsToSelector:@selector(didStartingLoadImage:)]) {
        [_delegate didStartingLoadImage:self];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    if (_delegate && [_delegate respondsToSelector:@selector(myImageView:didFinishWithImage:)]) {
        [_delegate myImageView:self didFinishWithImage:image];
    }
}

@end


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

