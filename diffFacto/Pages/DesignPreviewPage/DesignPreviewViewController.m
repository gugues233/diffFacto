//
//  DesignPreviewViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewController.h"
#import "DesignPreviewMainView.h"
#import "DesignPreviewViewModel.h"
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
}

- (void)setupViewModel {
    self.viewModel = [[DesignPreviewViewModel alloc] init];
    self.viewModel.model = self.model;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonDidClick {
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
    UIImage *screenshot = [self.mainView.preview3DView captureScreenshot];
    // 保存到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:screenshot];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存失败" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
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

@end
