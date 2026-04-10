//
//  CreateSelectedItemModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateSelectedItemModel : NSObject
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) NSInteger categoryIndex; // 分类顺序（用于排序）

- (instancetype)initWithCategory:(NSString *)category image:(UIImage *)image index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
