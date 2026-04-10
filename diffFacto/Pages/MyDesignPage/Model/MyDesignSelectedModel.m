//
//  MyDesignSelectedModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignSelectedModel.h"

@implementation MyDesignSelectedModel
- (instancetype)initWithModelId:(NSString *)modelId index:(NSInteger)index {
    self = [super init];
    if (self) {
        _modelId = modelId;
        _index = index;
    }
    return self;
}
@end
