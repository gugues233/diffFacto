//
//  DesignPreviewViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewModel.h"

@implementation DesignPreviewViewModel
- (void)shareToWeChat {
    // 实际项目：集成微信SDK，调用分享接口
    NSLog(@"分享到微信：%@", self.model.modelId);
}

- (void)saveAsImage {
    // 实际项目：截取3D视图，保存到相册
    NSLog(@"另存为图片：%@", self.model.modelId);
}

- (void)deleteModel {
    // 实际项目：删除本地缓存/数据库数据
    NSLog(@"删除模型：%@", self.model.modelId);
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
