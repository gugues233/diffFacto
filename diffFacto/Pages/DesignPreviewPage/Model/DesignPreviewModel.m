//
//  DesignPreviewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewModel.h"
#import "CreatePageViewModel.h"

@implementation DesignPreviewModel
- (instancetype)initWithModelId:(NSString *)modelId data:(id)data previewImage:(UIImage *)previewImage modelType:(NSString *)modelType{
    self = [super init];
    if (self) {
        _modelType = modelType;
        _modelId = modelId;
        _pointCloudData = data;
        _previewImage = previewImage;
        _isPublic = NO;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _createTime = [formatter stringFromDate:[NSDate date]];
        
        // 从缓存加载历史记录
        CreatePageViewModel *viewModel = [[CreatePageViewModel alloc] init];
        _createHistoryList = [viewModel getGenerateHistory];
    }
    return self;
}
@end
