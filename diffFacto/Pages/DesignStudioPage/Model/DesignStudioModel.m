//
//  DesignStudioModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioModel.h"

@implementation DesignStudioModel
- (instancetype)initWithModelId:(NSString *)modelId previewImage:(UIImage *)previewImage data:(id)data {
    self = [super init];
    if (self) {
        _modelId = modelId;
        _previewImage = previewImage;
        _pointCloudData = data;
        // 随机生成高度（模拟不同长度的点云，实际可根据模型计算）
        _itemHeight = 150 + arc4random()%150;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _createTime = [formatter stringFromDate:[NSDate date]];
    }
    return self;
}
@end
