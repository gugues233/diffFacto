//
//  DesignStudioItemCell.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "DesignStudioModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioItemCell : UICollectionViewCell
@property (nonatomic, strong) DesignStudioModel *model;
@property (nonatomic, strong) SCNView *scnView; // 3D视图
@end

NS_ASSUME_NONNULL_END
