//
//  DesignCompareModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignCompareModel.h"

@implementation DesignCompareModel
- (instancetype)initWithModelId:(NSString *)modelId data:(id)data previewImage:(UIImage *)previewImage {
    self = [super init];
    if (self) {
        _modelId = modelId;
        _pointCloudData = data;
        _previewImage = previewImage;
    }
    return self;
}
@end
