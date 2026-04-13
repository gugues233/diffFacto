//
//  CreateSelectedItemModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateSelectedItemModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *itemName;       // 选中的item名称
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) NSInteger categoryIndex; // 分类顺序（用于排序）
@property (nonatomic, assign) NSInteger itemIndex;     // 选中的item在分类中的索引

- (instancetype)initWithCategory:(NSString *)category itemName:(NSString *)itemName image:(UIImage *)image categoryIndex:(NSInteger)categoryIndex itemIndex:(NSInteger)itemIndex;
@end

NS_ASSUME_NONNULL_END
