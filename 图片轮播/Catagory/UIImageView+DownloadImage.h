//
//  UIImageView+DownloadImage.h
//  图片轮播
//
//  Created by Chen on 15/10/21.
//  Copyright © 2015年 Weidong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

/**
 *  异步下载图片
 *
 *  @param url              要下载的图片url
 *  @param placeholderImage 图片未下载或者下载失败时用于替换的图片
 */
- (void)downloadImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

@end
