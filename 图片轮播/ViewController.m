//
//  ViewController.m
//  图片轮播
//
//  Created by Chen on 15/10/20.
//  Copyright © 2015年 Weidong Chen. All rights reserved.
//

#import "ViewController.h"
#import "CWDAutoScrollView.h"
#import "UIView+Layout.h"

@interface ViewController ()<CWDAutoScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *imageArray = @[
                            @"http://122.224.218.54:8081/group1/M00/39/1D/wKgD1FYm80CIG8JyAAAatyPMGu8892.jpg?w=640&h=260&c=0&p=0",
                            @"http://122.224.218.54:8081/group1/M00/BD/6B/wKgA1FQJdj3J4Y0mAAF-GAe3cto202.jpg?w=640&h=260&c=0&p=0",
                            @"http://122.224.218.54:8081/group1/M00/4F/3E/wKgA1FVkZi7DlUqAAAE1lipPstU540.jpg?w=640&h=260&c=0&p=0",
                            @"http://122.224.218.54:8081/group1/M00/F7/80/wKgA1FT9B8vZaQsHAADlMGmSYng033.jpg?w=640&h=260&c=0&p=0",
                            @"http://122.224.218.54:8081/group1/M00/2C/4B/wKgA1FTcFBacu_3BAAGrYUt5_1M242.png?w=640&h=260&c=0&p=0"
                            ];

    CWDAutoScrollView *autoScrollView = [[CWDAutoScrollView alloc] init];
    [autoScrollView updateViewWithImageArray:imageArray];
    autoScrollView.viewOriginY = 100;
    autoScrollView.infiniteScrolling = YES;
    [autoScrollView startAutoScrollWithInterval:3.0];
    autoScrollView.autoScrollDelegate = self;
    [self.view addSubview:autoScrollView];

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, 0, autoScrollView.width, 10);
    self.pageControl.centerX = autoScrollView.centerX;
    self.pageControl.centerY = autoScrollView.bottom - 20;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = imageArray.count;
    [self.view addSubview:self.pageControl];
}

- (void)scrollImageClick:(NSInteger)index {
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"第%zd张图点击",index] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)updatePageControlNum:(NSInteger)index {
    self.pageControl.currentPage = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
