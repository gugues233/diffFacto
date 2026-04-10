//
//  MyDesignItemCell.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "MyDesignModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignItemCell : UICollectionViewCell
@property (nonatomic, strong) MyDesignModel *model;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UIView *selectedBorderView; // 选中蓝圈

- (void)updateSelectedState;
@end

NS_ASSUME_NONNULL_END
