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

@property (nonatomic, retain) RFTScrollSubjectsView    *scrollSubjectsView;
@property (nonatomic, retain) NSArray                  *scrollSubjects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    _scrollSubjects = [NSArray arrayWithObjects:[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], [UIImage imageNamed:@"3"], nil];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _scrollSubjectsView = [[RFTScrollSubjectsView alloc] initWithFrame:CGRectMake(0, -20, screenBounds.size.width, screenBounds.size.width)];
    _scrollSubjectsView.subjects = _scrollSubjects;
    _scrollSubjectsView.delegate = self;
    [self.view addSubview:_scrollSubjectsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WDScrollSubjectsViewDelegate
- (void)selectedAtSubject:(NSInteger)index
{
    //touch the view
}

@end
