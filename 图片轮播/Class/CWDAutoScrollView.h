//
//  CWDAutoScrollView.h
//  图片轮播
//
//  Created by Chen on 15/10/21.
//  Copyright © 2015年 Weidong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWDAutoScrollViewDelegate <NSObject>

@optional
- (void)scrollImageClick:(NSInteger)index;
- (void)updatePageControlNum:(NSInteger)index;

@end

@interface CWDAutoScrollView : UIScrollView

/**
 *  view的X坐标，默认为0
 */
@property (nonatomic, assign) CGFloat viewOriginX;

/**
 *  view的Y坐标，默认为0
 */
@property (nonatomic, assign) CGFloat viewOriginY;

/**
 *  view的宽度，默认为屏幕宽度
 */
@property (nonatomic, assign) CGFloat viewWidth;

/**
 *  view的高度，默认为300px
 */
@property (nonatomic, assign) CGFloat viewHeight;

/**
 *  是否无限滚动，默认为NO
 */
@property (nonatomic, getter=isInfiniteScrolling) BOOL infiniteScrolling;

/**
 *  代理
 */
@property (nonatomic, weak) id<CWDAutoScrollViewDelegate> autoScrollDelegate;

/**
 *  数据更新
 *
 *  @param imageArray 存储图片url字符串的数组
 */
- (void)updateViewWithImageArray:(NSArray *)imageArray;

/**
 *  设置自动滚动的时间间隔
 *
 *  @param interval 时间间隔
 */
- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;
@end
