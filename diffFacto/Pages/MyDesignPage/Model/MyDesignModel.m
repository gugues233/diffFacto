//
//  MyDesignModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignModel.h"

@implementation MyDesignModel
- (instancetype)initWithModelId:(NSString *)modelId previewImage:(UIImage *)previewImage data:(id)data {
    self = [super init];
    if (self) {
        _modelId = modelId;
        _previewImage = previewImage;
        _pointCloudData = data;
        _isSelected = NO;
        // 自动生成当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _createTime = [formatter stringFromDate:[NSDate date]];
    }
    return self;
}
@end
