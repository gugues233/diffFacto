//
//  CreateItemModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreateItemModel.h"

@implementation CreateItemModel
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name {
    self = [super init];
    if (self) {
        _itemImage = image;
        _itemName = name;
        _isSelected = NO;
    }
    return self;
}
@end
