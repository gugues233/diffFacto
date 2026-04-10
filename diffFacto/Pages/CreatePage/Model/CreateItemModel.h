//
//  CreateItemModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateItemModel : NSObject
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, strong) UIImage *itemImage; // 选项图片
@property (nonatomic, assign) BOOL isSelected;   // 是否选中

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
