//
//  CWDAutoScrollView.m
//  图片轮播
//
//  Created by Chen on 15/10/21.
//  Copyright © 2015年 Weidong Chen. All rights reserved.
//

#import "CWDAutoScrollView.h"
#import "UIView+Layout.h"
#import "UIImageView+DownloadImage.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface CWDAutoScrollView ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation CWDAutoScrollView

- (instancetype)init
{
    [self initData];
    return [self initWithScrollViewFrame:CGRectMake(_viewOriginX, _viewOriginY, _viewWidth, _viewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithScrollViewFrame:frame];
}

- (instancetype)initWithScrollViewFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollsToTop = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

/**
 *  初始化一些参数
 */
- (void)initData {
    _viewOriginX = 0;
    _viewOriginY = 0;
    _viewWidth = ScreenWidth;
    _viewHeight = 150;
}

- (void)updateViewWithImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    if (imageArray.count == 0) {
        return;
    }

    NSMutableArray *mutableArr = imageArray.mutableCopy;
    if (self.isInfiniteScrolling) {
        id firstObj = imageArray.firstObject;
        id lastObj = imageArray.lastObject;

        [mutableArr insertObject:lastObj atIndex:0];
        [mutableArr addObject:firstObj];
    }
    self.dataArray = mutableArr.copy;

    [self setupUI];

    [self resetScrollViewIndex];
}

//初始化UI
- (void)setupUI {
    for (int i = 0; i < self.dataArray.count; i ++) {
        if (![self.dataArray[i] isKindOfClass:[NSString class]]) {
            return;
        }

        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        imageV.contentMode = UIViewContentModeRedraw;
        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:@"placeholderImage"];
        [self addSubview:imageV];

        NSString *imgUrl = self.dataArray[i];
        if (imgUrl && imgUrl.length > 0) {
            [imageV downloadImageWithUrl:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [imageV addGestureRecognizer:tapGesture];
    }

    self.contentSize = CGSizeMake(self.dataArray.count * self.width, 0);
}

/**
 *  如果是无限滚动，则一开始默认滚动到第二张图
 */
- (void)resetScrollViewIndex {
    NSUInteger startIndex = 0;
    if (self.isInfiniteScrolling) {
        startIndex = 1;
    }

    [self setContentOffset:CGPointMake(startIndex * self.width, 0) animated:NO];
}

/**
 *  scrollView上的图片点击
 */
- (void)clickImage {
    if ([self.autoScrollDelegate respondsToSelector:@selector(scrollImageClick:)]) {
        NSInteger index = self.contentOffset.x / self.width;
        [self.autoScrollDelegate scrollImageClick:index];
    }
}

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    self.interval = interval;
    [self startAutoScroll];
}

/**
 *  开始自动滚动
 */
- (void)startAutoScroll {
    if (self.scrollTimer || self.interval == 0 || !self.isInfiniteScrolling) {
        return;
    }

    self.scrollTimer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(doScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSDefaultRunLoopMode];
}

- (void)doScroll {
    //每次滚动偏移在原来基础上加self.width
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.width, 0) animated:YES];
}

/**
 *  计时器销毁，停止自动滚动
 */
- (void)stopAutoScroll {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)makeInfiniteScrolling {
    NSInteger currentPage = (self.contentOffset.x + self.width / 2.0) / self.width;

    if (currentPage == self.dataArray.count - 1) {
        currentPage = 0;
        [self setContentOffset:CGPointMake(self.width, 0) animated:NO];
    } else if (currentPage == 0) {
        currentPage = self.dataArray.count - 3;
        [self setContentOffset:CGPointMake(self.width * (self.dataArray.count - 2), 0) animated:NO];
    } else {
        currentPage -- ;
    }

    //该方法可用于更新pageControl
    if ([self.autoScrollDelegate respondsToSelector:@selector(updatePageControlNum:)]) {
        [self.autoScrollDelegate updatePageControlNum:currentPage];
    }
}

#pragma mark - scrollView delegate
//当开始拖拽是，停止倒计时用以停止自动滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isInfiniteScrolling) {
        [self stopAutoScroll];
    }
}

//结束拖拽是，开始倒计时用以开启自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isInfiniteScrolling) {
        [self startAutoScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isInfiniteScrolling) {
        [self makeInfiniteScrolling];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isInfiniteScrolling) {
        [self makeInfiniteScrolling];
    }
}

#pragma mark - setter
- (void)setViewOriginX:(CGFloat)viewOriginX {
    _viewOriginX = viewOriginX;
    self.left = viewOriginX;
}

- (void)setViewOriginY:(CGFloat)viewOriginY {
    _viewOriginY = viewOriginY;
    self.top = viewOriginY;
}

- (void)setViewHeight:(CGFloat)viewHeight {
    _viewHeight = viewHeight;
    self.height = viewHeight;
}

- (void)setViewWidth:(CGFloat)viewWidth {
    _viewWidth = viewWidth;
    self.width = viewWidth;
}

- (void)setInfiniteScrolling:(BOOL)infiniteScrolling {
    _infiniteScrolling = infiniteScrolling;
    [self updateViewWithImageArray:self.imageArray];
}

@end
