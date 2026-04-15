//
//  CarouselViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "CarouselViewController.h"
#import "VCarouselView.h"
#import "CarouselViewModel.h"
#import "CreatePageViewController.h"

@interface CarouselViewController () <VCarouselViewDelegate>
@property (nonatomic, strong) VCarouselView *carouselView;
@property (nonatomic, strong) CarouselViewModel *viewModel;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    // ViewModel
    self.viewModel = [[CarouselViewModel alloc] init];
    [self.viewModel loadDataSource];
    
    // View
    self.carouselView = [[VCarouselView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 140, self.view.frame.size.width, 280)];
    self.carouselView.dataArray = self.viewModel.dataArray;
    self.carouselView.delegate = self;
    [self.view addSubview:self.carouselView];
    
    // 下一步按钮
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height - 130, self.view.frame.size.width - 80, 60)];
    self.nextButton.backgroundColor = [UIColor systemBlueColor];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.clipsToBounds = YES;
    [self.nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    // 👇 右滑关闭
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)carouselDidSelectIndex:(NSInteger)index {
    self.viewModel.currentIndex = index;
    NSLog(@"当前选中：%@", self.viewModel.dataArray[index].title);
}

- (void)onNext {
    NSString *selectedTitle = self.viewModel.dataArray[self.carouselView.currentIndex].title;
    NSLog(@"点击下一步 → 选中：%@", selectedTitle);
    
    NSString *modelType = @"chair";
    if ([selectedTitle isEqualToString:@"椅子"]) {
        modelType = @"chair";
    } else if ([selectedTitle isEqualToString:@"飞机"]) {
        modelType = @"airplane";
    } else if ([selectedTitle isEqualToString:@"台灯"]) {
        modelType = @"lamp";
    } else if ([selectedTitle isEqualToString:@"汽车"]) {
        modelType = @"car";
    }
    
    CreatePageViewController *vc = [[CreatePageViewController alloc] initWithModelType:modelType history:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
