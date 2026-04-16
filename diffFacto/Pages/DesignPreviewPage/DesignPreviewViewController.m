//
//  DesignPreviewViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewController.h"
#import "DesignPreviewMainView.h"
#import "DesignPreviewViewModel.h"
#import "CreatePageViewController.h"
#import <Photos/Photos.h>

@interface DesignPreviewViewController () <DesignPreviewMainViewDelegate, MoreActionMenuViewDelegate>
@property (nonatomic, strong) DesignPreviewMainView *mainView;
@property (nonatomic, strong) DesignPreviewViewModel *viewModel;
@property (nonatomic, strong) DesignPreviewModel *model;
@end

@implementation DesignPreviewViewController

- (instancetype)initWithModel:(DesignPreviewModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setupViewModel];
    [self setupMainView];

    __weak typeof(self) weakSelf = self;
    self.mainView.applyButtonBlock = ^{
        [weakSelf applyButtonClick];
    };

    if (self.model.isMyModel) {
        [self.mainView showMyModelUI];
    } else {
        [self.mainView showOtherModelUI];
    }
    
    // 调试：检查按钮状态
    NSLog(@"📋 按钮状态 - backButton: %@, applyButton: %@, moreButton: %@", 
          self.mainView.backButton.hidden ? @"hidden" : @"visible",
          self.mainView.applyButton.hidden ? @"hidden" : @"visible",
          self.mainView.moreButton.hidden ? @"hidden" : @"visible");
    
    NSLog(@"📋 按钮 userInteractionEnabled - backButton: %@, applyButton: %@, moreButton: %@", 
          self.mainView.backButton.userInteractionEnabled ? @"YES" : @"NO",
          self.mainView.applyButton.userInteractionEnabled ? @"YES" : @"NO",
          self.mainView.moreButton.userInteractionEnabled ? @"YES" : @"NO");
    
    // 添加触摸事件监听
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.view];
    NSLog(@"📋 点击位置: (%f, %f)", point.x, point.y);
    
    // 检查是否点击到按钮
    if (CGRectContainsPoint(self.mainView.backButton.frame, point)) {
        NSLog(@"📋 点击到 backButton");
        [self backButtonDidClick];
    } else if (CGRectContainsPoint(self.mainView.applyButton.frame, point)) {
        NSLog(@"📋 点击到 applyButton");
        [self applyButtonClick];
    } else if (CGRectContainsPoint(self.mainView.moreButton.frame, point)) {
        NSLog(@"📋 点击到 moreButton");
        [self moreButtonDidClick];
    } else {
        NSLog(@"📋 点击到其他位置");
    }
}

- (void)setupViewModel {
    self.viewModel = [[DesignPreviewViewModel alloc] init];
    self.viewModel.model = self.model;

    // 设置状态更新回调
    __weak typeof(self) weakSelf = self;
    self.viewModel.statusUpdateCompletion = ^(BOOL success, NSString *message) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf showAlertWithTitle:success ? @"成功" : @"失败" message:message];
        }
    };
}

- (void)setupMainView {
    self.mainView = [[DesignPreviewMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    self.mainView.actionMenuView.delegate = self;
    [self.mainView loadPointCloudData:self.model.pointCloudData];
    [self.mainView updatePublicStatus:self.model.isPublic];
    [self.view addSubview:self.mainView];
}

#pragma mark - DesignPreviewMainViewDelegate
- (void)backButtonDidClick {
    NSLog(@"📋 backButtonDidClick 被调用");
    [self.navigationController popViewControllerAnimated:YES];
}

// TODO: zxy-现在在遍历，看之后能不能只传递xxx
- (void)applyButtonClick {
    NSLog(@"📋 applyButtonClick 被调用");
    NSArray *historyList = [self.viewModel getCreateHistory];
    CreateHistoryModel *matchedHistory = nil;
    for (CreateHistoryModel *history in historyList) {
        if ([history.modelId isEqualToString:self.model.modelId]) {
            matchedHistory = history;
            break;
        }
    }
    CreatePageViewController *vc = [[CreatePageViewController alloc] initWithModelType:self.model.modelType history:matchedHistory ? @[matchedHistory] : nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)moreButtonDidClick {
    NSLog(@"📋 moreButtonDidClick 被调用");
    // 菜单由视图内部处理
}

#pragma mark - MoreActionMenuViewDelegate
- (void)moreActionDidSelect:(MoreActionType)type {
    switch (type) {
        case MoreActionTypeShareWeChat:
            [self shareToWeChat];
            break;
        case MoreActionTypeSaveImage:
            [self saveAsImage];
            break;
        case MoreActionTypeDelete:
            [self showDeleteAlert];
            break;
        case MoreActionTypeTogglePublic:
            [self togglePublicStatus];
            break;
        default:
            break;
    }
}

- (void)shareToWeChat {
    [self.viewModel shareToWeChat];
    // 实际项目：集成微信SDK，调用分享接口
}

- (void)saveAsImage {
    [self.viewModel saveAsImageWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self showAlertWithTitle:@"成功" message:@"图片已成功保存到相册"];
        } else {
            [self showAlertWithTitle:@"失败" message:error.localizedDescription];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDeleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后将无法恢复，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel deleteModel];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)togglePublicStatus {
    [self.viewModel togglePublicStatus];
    [self.mainView updatePublicStatus:self.model.isPublic];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复导航栏
    self.navigationController.navigationBar.hidden = NO;
    // 隐藏菜单，避免阻挡按钮
    [self.mainView.actionMenuView dismissMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 确保导航栏隐藏
    self.navigationController.navigationBar.hidden = YES;
    // 隐藏菜单
    [self.mainView.actionMenuView dismissMenu];
    
    // 调试：检查按钮状态
    NSLog(@"📋 viewWillAppear - 按钮状态");
    NSLog(@"📋 按钮状态 - backButton: %@, applyButton: %@, moreButton: %@", 
          self.mainView.backButton.hidden ? @"hidden" : @"visible",
          self.mainView.applyButton.hidden ? @"hidden" : @"visible",
          self.mainView.moreButton.hidden ? @"hidden" : @"visible");
}

@end
