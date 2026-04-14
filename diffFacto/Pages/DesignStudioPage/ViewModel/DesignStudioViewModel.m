//
//  DesignStudioViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioViewModel.h"

@implementation DesignStudioViewModel
- (void)loadInitialDataWithCompletion:(void(^)(BOOL success))completion {
    // 从后端请求数据
    [self fetchModelsFromBackendWithCompletion:^(BOOL success, NSArray<DesignStudioModel *> *models) {
        if (success) {
            _modelList = models;
        } else {
            // 如果请求失败，使用默认数据
            _modelList = [self getDefaultModels];
        }
        _isRefreshing = NO;
        if (completion) completion(YES);
    }];
}

- (void)refreshNewDataCompletion:(void(^)(BOOL success))completion {
    _isRefreshing = YES;
    // 从后端请求新数据
    [self fetchModelsFromBackendWithCompletion:^(BOOL success, NSArray<DesignStudioModel *> *models) {
        if (success) {
            _modelList = models;
            if (completion) completion(YES);
        } else {
            if (completion) completion(NO);
        }
        _isRefreshing = NO;
    }];
}

- (void)fetchModelsFromBackendWithCompletion:(void(^)(BOOL success, NSArray<DesignStudioModel *> *models))completion {
    // 构建请求
    NSString *urlString = @"http://localhost:6006/api/models/public";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"⚠️ 请求模型列表失败：%@", error.localizedDescription);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, nil);
                });
            }
            return;
        }
        
        // 处理响应
        if (data) {
            NSError *jsonError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSLog(@"⚠️ 解析响应失败：%@", jsonError.localizedDescription);
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NO, nil);
                    });
                }
                return;
            }
            
            // 解析模型数据
            NSArray *modelsArray = responseDict[@"data"];
            NSMutableArray *models = [NSMutableArray array];
            
            for (NSDictionary *modelDict in modelsArray) {
                NSString *modelId = modelDict[@"model_id"];
                id pointCloudData = modelDict[@"point_cloud_data"];
                
                // 使用默认图片作为预览图
                UIImage *previewImage = [UIImage imageNamed:@"studio_preview_0"];
                
                DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:modelId previewImage:previewImage data:pointCloudData];
                [models addObject:model];
            }
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, [models copy]);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, nil);
                });
            }
        }
    }];
    [task resume];
}

- (NSArray<DesignStudioModel *> *)getDefaultModels {
    // 生成默认数据，当网络请求失败时使用
    NSMutableArray *models = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        UIImage *preview = [UIImage imageNamed:[NSString stringWithFormat:@"studio_preview_%d", i]];
        DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:[NSString stringWithFormat:@"studio_%d", i] previewImage:preview data:nil];
        [models addObject:model];
    }
    return [models copy];
}

@end
