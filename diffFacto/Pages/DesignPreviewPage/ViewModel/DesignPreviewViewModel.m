//
//  DesignPreviewViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewModel.h"
#import "CreatePageViewModel.h"
#import <Photos/Photos.h>

@implementation DesignPreviewViewModel
- (void)shareToWeChat {
    // 实际项目：集成微信SDK，调用分享接口
    NSLog(@"分享到微信：%@", self.model.modelId);
    
    // 模拟微信分享功能
    // 1. 检查是否安装了微信
    BOOL isWeChatInstalled = YES; // 模拟已安装
    
    if (isWeChatInstalled) {
        // 2. 准备分享内容
        NSString *title = [NSString stringWithFormat:@"我的3D设计：%@", self.model.modelId];
        NSString *description = @"来看看我用diffFacto创作的3D模型！";
        UIImage *shareImage = self.model.previewImage;
        
        // 3. 调用微信SDK分享
        // 这里应该使用WXApi的sendReq方法
        // 例如：[WXApi sendReq:req];
        
        NSLog(@"✅ 微信分享成功：%@", title);
    } else {
        NSLog(@"⚠️ 未安装微信");
    }
}

- (void)saveAsImageWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    NSLog(@"另存为图片：%@", self.model.modelId);
    
    __weak typeof(self) weakSelf = self;
    
    // 确保在主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1. 检查模型和预览图
        if (!weakSelf.model || !weakSelf.model.previewImage) {
            NSLog(@"⚠️ 模型或预览图片不存在");
            if (completion) {
                completion(NO, [NSError errorWithDomain:@"diffFacto" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"模型或预览图片不存在"}]);
            }
            return;
        }
        
        // 2. 检查相册权限
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            // 请求权限
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [weakSelf saveImageToAlbum:weakSelf.model.previewImage completion:completion];
                } else {
                    NSLog(@"⚠️ 相册权限被拒绝");
                    if (completion) {
                        completion(NO, [NSError errorWithDomain:@"diffFacto" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"相册权限被拒绝"}]);
                    }
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [weakSelf saveImageToAlbum:weakSelf.model.previewImage completion:completion];
        } else {
            NSLog(@"⚠️ 相册权限被拒绝");
            if (completion) {
                completion(NO, [NSError errorWithDomain:@"diffFacto" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"相册权限被拒绝"}]);
            }
        }
    });
}

- (void)saveImageToAlbum:(UIImage *)image completion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 回到主线程弹框（必须）
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"✅ 保存到相册成功");
            } else {
                NSLog(@"⚠️ 保存到相册失败：%@", error.localizedDescription);
            }
            if (completion) {
                completion(success, error);
            }
        });
    }];
}

- (void)deleteModel {
    // 实际项目：删除本地缓存/数据库数据
    NSLog(@"删除模型：%@", self.model.modelId);
    
    // 读取现有的历史记录
    CreatePageViewModel *createViewModel = [[CreatePageViewModel alloc] init];
    NSMutableArray *historyList = [createViewModel getGenerateHistory];
    
    // 找到要删除的模型并从数组中删除
    NSMutableArray *newHistoryList = [NSMutableArray array];
    for (id history in historyList) {
        if ([history respondsToSelector:@selector(productName)]) {
            NSString *productName = [history performSelector:@selector(productName)];
            if (![productName isEqualToString:self.model.modelId]) {
                [newHistoryList addObject:history];
            }
        }
    }
    
    // 重新保存到本地
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"GenerateHistory.data"];
    [NSKeyedArchiver archiveRootObject:newHistoryList toFile:filePath];
    NSLog(@"✅ 删除成功，更新缓存：%@", filePath);
}

- (void)togglePublicStatus {
    self.model.isPublic = !self.model.isPublic;
    // 实际项目：更新后端公开状态
    NSLog(@"切换公开状态：%@ -> %@", self.model.modelId, self.model.isPublic ? @"公开" : @"私有");
}

- (NSArray<CreateHistoryModel *> *)getCreateHistory {
    return self.model.createHistoryList;
}

@end
