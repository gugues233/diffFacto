//
//  CategoryScrollView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CreateCategoryModel.h"

@protocol CategoryScrollViewDelegate <NSObject>
- (void)categoryItemDidSelect:(NSInteger)itemIndex categoryIndex:(NSInteger)categoryIndex fromView:(UIView *)fromView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CategoryScrollView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<CreateCategoryModel *> *categoryList;
@property (nonatomic, weak) id<CategoryScrollViewDelegate> delegate;
@property (nonatomic, strong) UILabel *currentCategoryLabel; // 当前分类名

- (void)reloadData; // 重新加载数据
@end

NS_ASSUME_NONNULL_END
