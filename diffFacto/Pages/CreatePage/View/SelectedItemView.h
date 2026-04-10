//
//  SelectedItemView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CreateSelectedItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedItemView : UIView
@property (nonatomic, strong) NSArray<CreateSelectedItemModel *> *selectedList;
- (void)addItemWithImage:(UIImage *)image fromPoint:(CGPoint)fromPoint completion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
