//
//  CarouselViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "CarouselViewModel.h"

@implementation CarouselViewModel
- (void)loadDataSource {
    self.dataArray = [GoodsModel demoData];
}

- (GoodsModel *)modelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.dataArray.count) return nil;
    return self.dataArray[index];
}
@end
