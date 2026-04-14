//
//  DesignPreviewViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewModel.h"
#import "CreatePageViewModel.h"

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
