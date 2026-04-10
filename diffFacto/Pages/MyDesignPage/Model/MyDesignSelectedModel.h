//
//  MyDesignSelectedModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignSelectedModel : NSObject
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithModelId:(NSString *)modelId index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
