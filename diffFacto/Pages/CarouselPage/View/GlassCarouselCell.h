//
//  GlassCarouselCell.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GlassCarouselCell : UICollectionViewCell
@property (nonatomic, strong) GoodsModel *model;
@property (nonatomic, assign) CGFloat scale;
@end
