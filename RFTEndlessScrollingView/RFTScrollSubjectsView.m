//
//  RFTScrollSubjectsView.m
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/9.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import "RFTScrollSubjectsView.h"
#import "RFTEndlessScrollView.h"

@interface RFTScrollSubjectsView ()<RFTEndlessScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) RFTEndlessScrollView *scrollView;
@property (nonatomic, strong) NSArray<UIImageView *> *imageViewArray;

@end

@implementation RFTScrollSubjectsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    self.scrollView.delegate = nil;
}

#pragma mark - Getter & Setter

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGRect pageControlRect = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 20);
        _pageControl = [[UIPageControl alloc] initWithFrame:pageControlRect];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
        [self insertSubview:_pageControl aboveSubview:self.scrollView];
    }
    return _pageControl;
}

- (void)setSubjects:(NSArray *)subjects {
    if (!subjects) {
        subjects = [NSArray array];
    }
    
    _subjects = subjects;
    [self setupImageViewArray];
    
    self.pageControl.numberOfPages = _subjects.count;
    self.pageControl.currentPage = 0;
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    self.scrollView.dataSource = self.imageViewArray;
    self.scrollView.numberOfPages = self.subjects.count;
    [self.scrollView setPage:0 animated:NO];
    [self.scrollView resetAutoPlay]; // 自动播放
}

- (RFTEndlessScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[RFTEndlessScrollView alloc] initWithFrame:self.bounds];
        _scrollView.controlDelegate = self;
        [self insertSubview:_scrollView belowSubview:self.pageControl];
    }
    return _scrollView;
}

#pragma mark - Private Method

- (void)setupImageViewArray {
    if (_subjects.count == 0) {
        self.imageViewArray = @[];
        return;
    }
    
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (UIImage *image in self.subjects) {
        [muArray addObject:[self imageViewWithImage:image]];
    }
    self.imageViewArray = [muArray mutableCopy];
}

- (UIImageView *)imageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView setImage:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedImageView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tap];
    
    return imageView;
}

- (void)didSelectedImageView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedAtSubject:)]) {
        [self.delegate selectedAtSubject:self.pageControl.currentPage];
    }
}

#pragma mark - RFTEndlessScrollView Delegate

- (void)endlessScrollView:(RFTEndlessScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex {
    self.pageControl.currentPage = currentPageIndex;
}

@end
