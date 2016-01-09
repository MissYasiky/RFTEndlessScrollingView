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

@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) RFTEndlessScrollView *scrollView;

@end

@implementation RFTScrollSubjectsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

- (void) dealloc
{
    self.scrollView.delegate = nil;
}

- (UIPageControl *) pageControl
{
    CGRect bounds = self.bounds;
    CGRect pageControlRect = CGRectMake(0, bounds.size.height - 30, bounds.size.width, 20);
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:pageControlRect];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
    }
    
    return _pageControl;
}

- (UIImageView *) imageViewAtIndex:(NSUInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    
    if (index >= self.subjects.count) {
        return nil;
    }
    UIImage *image = [self.subjects objectAtIndex:index];
    [imageView setImage:image];
//    [imageView setImage:[UIImage imageNamed:@"homedefpic"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedImageView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tap];
    
    return imageView;
}

- (void) setSubjects:(NSArray *)subjects
{
    if (!subjects) {
        subjects = [NSArray array];
    }
    
    _subjects = subjects;
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        [_scrollView.timer_autoPlay invalidate];
        _scrollView.timer_autoPlay = nil;
        _scrollView.dataSource = nil;
        _scrollView.controlDelegate = nil;
        _scrollView = nil;
    }
    
    _scrollView = [[RFTEndlessScrollView alloc] initWithFrame:self.bounds];
    _scrollView.controlDelegate = self;
    
    __block RFTScrollSubjectsView *weakSelf = self;
    self.scrollView.dataSource = ^UIImageView*(NSInteger index) {
        return [weakSelf imageViewAtIndex:index];
    };
    
    [self addSubview:self.scrollView];
    
    self.pageControl.numberOfPages = (int)_subjects.count;
    _pageControl.currentPage = 0;
    [self insertSubview:_pageControl aboveSubview:self.scrollView];
    
    self.scrollView.numberOfPages = _subjects.count;
    [self.scrollView setPage:0 animated:NO];
    [self.scrollView resetAutoPlay];// 自动播放
}

/*
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if (_delegate && [_delegate respondsToSelector:@selector(selectedAtSubject:)]) {
 [_delegate selectedAtSubject:self.pageControl.currentPage];
 }
 }
 */

- (void) didSelectedImageView
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAtSubject:)]) {
        [_delegate selectedAtSubject:self.pageControl.currentPage];
    }
}

- (void)endlessScrollView:(RFTEndlessScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex
{
    self.pageControl.currentPage = (int)currentPageIndex;
}

@end
