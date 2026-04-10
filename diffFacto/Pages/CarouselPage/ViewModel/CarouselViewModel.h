//
//  CarouselViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface CarouselViewModel : NSObject
@property (nonatomic, strong) NSArray<GoodsModel *> *dataArray;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)loadDataSource;
- (GoodsModel *)modelAtIndex:(NSInteger)index;
@end
