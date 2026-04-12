//
//  DesignStudioViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioViewController.h"
#import "DesignStudioMainView.h"
#import "DesignStudioViewModel.h"
// 导入你之前实现的3D预览页
#import "DesignPreviewViewController.h"
#import "DesignPreviewModel.h"

@interface DesignStudioViewController () <DesignStudioMainViewDelegate>
@property (nonatomic, strong) DesignStudioMainView *mainView;
@property (nonatomic, strong) DesignStudioViewModel *viewModel;
@end

@implementation DesignStudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设计室";
    [self setupViewModel];
    [self setupMainView];
}

- (void)setupViewModel {
    self.viewModel = [[DesignStudioViewModel alloc] init];
    [self.viewModel loadInitialData];
}

- (void)setupMainView {
    self.mainView = [[DesignStudioMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    self.mainView.modelList = self.viewModel.modelList;
    [self.view addSubview:self.mainView];
}

#pragma mark - DesignStudioMainViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    // 点击放大：跳转到3D预览页
    DesignStudioModel *model = self.viewModel.modelList[index];
    DesignPreviewModel *previewModel = [[DesignPreviewModel alloc] initWithModelId:model.modelId data:model.pointCloudData previewImage:model.previewImage];
    previewModel.isMyModel = NO;
    DesignPreviewViewController *previewVC = [[DesignPreviewViewController alloc] initWithModel:previewModel];
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)didPullToRefresh {
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.viewModel refreshNewDataCompletion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.mainView endRefreshing];
        if (success) {
            strongSelf.mainView.modelList = strongSelf.viewModel.modelList;
            [strongSelf.mainView reloadData];
        }
    }];
}

@end
