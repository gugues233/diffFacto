//
//  GoodsModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "GoodsModel.h"

@implementation GoodsModel
+ (NSArray<GoodsModel *> *)demoData {
    return @[
        [self modelWithTitle:@"椅子"],
        [self modelWithTitle:@"飞机"],
        [self modelWithTitle:@"台灯"],
        [self modelWithTitle:@"汽车"],
    ];
}

+ (instancetype)modelWithTitle:(NSString *)title {
    GoodsModel *m = [[GoodsModel alloc] init];
    m.title = title;
    return m;
}
@end
