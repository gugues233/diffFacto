//
//  MyDesignViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignViewController.h"
#import "MyDesignMainView.h"
#import "MyDesignViewModel.h"
#import "DesignPreviewModel.h"
#import "DesignPreviewViewController.h"
#import "DesignCompareModel.h"
#import "DesignCompareViewController.h"

@interface MyDesignViewController () <MyDesignMainViewDelegate, MyDesignCollectionViewDelegate>
@property (nonatomic, strong) MyDesignMainView *mainView;
@property (nonatomic, strong) MyDesignViewModel *viewModel;
@end

@implementation MyDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设计";
    // 添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    [self setupViewModel];
    [self setupMainView];
    
    // 👇 右滑关闭
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViewModel {
    self.viewModel = [[MyDesignViewModel alloc] init];
    [self.viewModel loadLocalCacheModels];
}

- (void)setupMainView {
    self.mainView = [[MyDesignMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    self.mainView.collectionView.delegate = self;
    self.mainView.collectionView.modelList = self.viewModel.modelList;
    [self.view addSubview:self.mainView];
}

#pragma mark - MyDesignCollectionViewDelegate
- (void)collectionViewDidLongPressItemAtIndex:(NSInteger)index {
    // 进入长按选择模式
    [self.viewModel enterLongPressMode];
    // 首次长按选中当前项
    [self handleSelectItemAtIndex:index];
}

- (void)collectionViewDidSelectItemAtIndex:(NSInteger)index {
    if (!self.viewModel.isLongPressMode) {
        // 非选择模式：点击放大查看
        [self showPreviewAtIndex:index];
        return;
    }
    
    // 选择模式：处理选中/取消
    [self handleSelectItemAtIndex:index];
}

- (void)handleSelectItemAtIndex:(NSInteger)index {
    BOOL success = [self.viewModel toggleSelectModelAtIndex:index];
    if (!success) {
        // 选择失败：弹出提示
        [self showMaxSelectAlert];
        return;
    }
    
    // 更新UI
    [self.mainView reloadCollectionView];
    // 更新对比按钮显示
    [self.mainView updateCompareButtonVisibility:(self.viewModel.selectedList.count == 2)];
}

- (void)showPreviewAtIndex:(NSInteger)index {
    MyDesignModel *model = self.viewModel.modelList[index];
    DesignPreviewModel *previewModel = [[DesignPreviewModel alloc] initWithModelId:model.modelId data:model.pointCloudData previewImage:model.previewImage];
    previewModel.isMyModel = YES;
    DesignPreviewViewController *previewVC = [[DesignPreviewViewController alloc] initWithModel:previewModel];
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)showMaxSelectAlert {
    if ([self.mainView.delegate respondsToSelector:@selector(showMaxSelectAlert)]) {
        [self.mainView.delegate showMaxSelectAlert];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多可以选择两个模型进行对比" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MyDesignMainViewDelegate
- (void)compareButtonDidClick {
    NSArray *selected = self.viewModel.selectedList;
    
    MyDesignModel *first = selected[0];
    MyDesignModel *second = selected[1];
    
    SCNNode *firstPointCloudNode = [self createPointCloudNode];
    SCNNode *secondPointCloudNode = [self createPointCloudNode];
    
    first.pointCloudData = firstPointCloudNode;
    second.pointCloudData = secondPointCloudNode;
    
    DesignCompareModel *firstCompare = [[DesignCompareModel alloc] initWithModelId:first.modelId data:first.pointCloudData previewImage:first.previewImage];
    DesignCompareModel *secondCompare = [[DesignCompareModel alloc] initWithModelId:second.modelId data:second.pointCloudData previewImage:second.previewImage];
    
    DesignCompareViewController *compareVC = [[DesignCompareViewController alloc] initWithFirstModel:firstCompare secondModel:secondCompare];
    [self.navigationController pushViewController:compareVC animated:YES];
}

- (SCNNode *)createPointCloudNode {
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    for (int i=0; i<2000; i++) {
        SCNSphere *sphere = [SCNSphere sphereWithRadius:0.015];
        SCNNode *node = [SCNNode nodeWithGeometry:sphere];
        node.position = SCNVector3Make(arc4random()%200/100.0 - 1.0, arc4random()%200/100.0 - 1.0, arc4random()%200/100.0 - 1.0);
        node.geometry.firstMaterial.diffuse.contents = [UIColor systemBlueColor];
        [pointCloudNode addChildNode:node];
    }
    return pointCloudNode;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 页面消失时退出选择模式
    [self.viewModel exitLongPressMode];
    [self.mainView updateCompareButtonVisibility:NO];
}

@end
