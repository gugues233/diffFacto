//
//  DesignCompareViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignCompareViewController.h"
#import "DesignCompareMainView.h"
#import "DesignCompareViewModel.h"

@interface DesignCompareViewController () <DesignCompareMainViewDelegate>
@property (nonatomic, strong) DesignCompareMainView *mainView;
@property (nonatomic, strong) DesignCompareViewModel *viewModel;
@property (nonatomic, strong) DesignCompareModel *firstModel;
@property (nonatomic, strong) DesignCompareModel *secondModel;
@end

@implementation DesignCompareViewController

- (instancetype)initWithFirstModel:(DesignCompareModel *)firstModel secondModel:(DesignCompareModel *)secondModel {
    self = [super init];
    if (self) {
        _firstModel = firstModel;
        _secondModel = secondModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setupViewModel];
    [self setupMainView];
}

- (void)setupViewModel {
    self.viewModel = [[DesignCompareViewModel alloc] init];
    self.viewModel.firstModel = self.firstModel;
    self.viewModel.secondModel = self.secondModel;
}

- (void)setupMainView {
    self.mainView = [[DesignCompareMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    
    [self.mainView loadFirstModelData:self.firstModel.pointCloudData secondModelData:self.secondModel.pointCloudData];
    [self.view addSubview:self.mainView];
}

#pragma mark - DesignCompareMainViewDelegate
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
