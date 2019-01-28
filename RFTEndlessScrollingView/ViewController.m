//
//  ViewController.m
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/8.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import "ViewController.h"
#import "RFTScrollSubjectsView.h"

@interface ViewController ()<RFTScrollSubjectsViewDelegate>

@property (nonatomic, strong) RFTScrollSubjectsView    *scrollSubjectsView;
@property (nonatomic, strong) NSArray                  *scrollSubjects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollSubjects = @[[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"]];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _scrollSubjectsView = [[RFTScrollSubjectsView alloc] initWithFrame:CGRectMake(0, -20, screenBounds.size.width, screenBounds.size.width)];
    _scrollSubjectsView.subjects = _scrollSubjects;
    _scrollSubjectsView.delegate = self;
    [self.view addSubview:_scrollSubjectsView];
}

#pragma mark - RFTScrollSubjectsView Delegate

- (void)selectedAtSubject:(NSInteger)index {
    //touch the view
}

@end
