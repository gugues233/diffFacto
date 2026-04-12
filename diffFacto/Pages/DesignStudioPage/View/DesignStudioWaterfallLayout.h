//
//  DesignStudioWaterfallLayout.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <UIKit/UIKit.h>

@protocol DesignStudioWaterfallLayoutDelegate <NSObject>
- (CGFloat)waterfallLayoutHeightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioWaterfallLayout : UICollectionViewLayout
@property (nonatomic, assign) NSInteger columnCount; // 列数（默认2列）
@property (nonatomic, assign) CGFloat columnSpacing; // 列间距
@property (nonatomic, assign) CGFloat rowSpacing;    // 行间距
@property (nonatomic, assign) UIEdgeInsets sectionInset; // 内边距
@property (nonatomic, weak) id<DesignStudioWaterfallLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
