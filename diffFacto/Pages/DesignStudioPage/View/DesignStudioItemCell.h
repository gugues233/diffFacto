//
//  DesignStudioItemCell.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <UIKit/UIKit.h>
#import "DesignStudioModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioItemCell : UICollectionViewCell
@property (nonatomic, strong) DesignStudioModel *model;
@property (nonatomic, strong) UIImageView *previewImageView;
@end

NS_ASSUME_NONNULL_END
