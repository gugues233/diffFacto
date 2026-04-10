//
//  CategoryItemCell.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CreateItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryItemCell : UICollectionViewCell
@property (nonatomic, strong) CreateItemModel *model;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *selectedBorderView; // 选中蓝圈

- (void)playSelectedAnimation;
@end

NS_ASSUME_NONNULL_END
