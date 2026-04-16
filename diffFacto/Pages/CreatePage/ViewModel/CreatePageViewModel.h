//
//  CreatePageViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import "CreateCategoryModel.h"
#import "CreateSelectedItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatePageViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<CreateCategoryModel *> *categoryList; // 所有分类
@property (nonatomic, strong, readonly) NSArray<CreateSelectedItemModel *> *selectedList; // 已选列表
@property (nonatomic, assign, readonly) CGFloat generateProgress; // 生成进度
@property (nonatomic, copy, readonly, nullable) NSString *currentModelId;

- (void)loadCategoryDataWithModelType:(NSString *)modelType completion:(void(^)(BOOL success))completion;
- (void)selectItemAtIndex:(NSInteger)itemIndex categoryIndex:(NSInteger)categoryIndex completion:(void(^)(BOOL success))completion;
- (void)startGenerateCompletion:(void(^)(BOOL success, id _Nullable result))completion progress:(void(^)(CGFloat progress))progressBlock;
- (void)resetAllSelection;
- (void)restoreSelectedItem:(id)item categoryIndex:(NSInteger)cIndex;
// TODO: zxy-需要看看这个result里有什么，暂时保留两个
- (void)addGenerateHistory:(id)result;

- (void)addGenerateHistory:(id)result modelId:(NSString *)modelId;
- (NSMutableArray *)getGenerateHistory; // 获取历史记录
@end

NS_ASSUME_NONNULL_END
