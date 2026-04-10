//
//  HomeModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "HomeModel.h"

@implementation HomeModel

- (instancetype)initWithTitle:(NSString *)title jumpVCName:(NSString *)vcName {
    self = [super init];
    if (self) {
        _title = title;
        _jumpVCName = vcName;
        _isSelected = NO;
    }
    return self;
}

@end
