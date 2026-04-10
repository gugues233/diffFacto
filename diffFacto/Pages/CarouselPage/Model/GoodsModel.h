//
//  GoodsModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

+ (NSArray<GoodsModel *> *)demoData;
@end
