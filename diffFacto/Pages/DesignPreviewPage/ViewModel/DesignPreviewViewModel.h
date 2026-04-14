//
//  DesignPreviewViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <Foundation/Foundation.h>
#import "DesignPreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignPreviewViewModel : NSObject
@property (nonatomic, strong) DesignPreviewModel *model; // 当前预览模型

- (void)shareToWeChat;          // 分享到微信
- (void)saveAsImageWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion;//另存为图片
- (void)deleteModel;            // 删除模型
- (void)togglePublicStatus;     // 切换公开状态
- (NSArray<CreateHistoryModel *> *)getCreateHistory;  // 得到历史记录
@end

NS_ASSUME_NONNULL_END
