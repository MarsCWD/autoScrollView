//
//  UIImageView+DownloadImage.m
//  图片轮播
//
//  Created by Chen on 15/10/21.
//  Copyright © 2015年 Weidong Chen. All rights reserved.
//

#import "UIImageView+DownloadImage.h"

@interface UIImageView ()

@end

@implementation UIImageView (DownloadImage)

- (void)downloadImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    self.image = placeholderImage;

    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error) {
                self.image = [UIImage imageWithData:data];
            }
        }];
        [downloadTask resume];
    });
}
@end
