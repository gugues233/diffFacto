//
//  DesignPreviewViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewViewModel.h"
#import "CreatePageViewModel.h"
#import <Photos/Photos.h>
#import <SceneKit/SceneKit.h>

@implementation DesignPreviewViewModel
- (void)shareToWeChat {
    // 实际项目：集成微信SDK，调用分享接口
    NSLog(@"分享到微信：%@", self.model.modelId);
    
    // 模拟微信分享功能
    // 1. 检查是否安装了微信
    BOOL isWeChatInstalled = YES; // 模拟已安装
    
    if (isWeChatInstalled) {
        // 2. 准备分享内容
        NSString *title = [NSString stringWithFormat:@"我的3D设计：%@", self.model.modelId];
        NSString *description = @"来看看我用diffFacto创作的3D模型！";
        UIImage *shareImage = self.model.previewImage;
        
        // 3. 调用微信SDK分享
        // 这里应该使用WXApi的sendReq方法
        // 例如：[WXApi sendReq:req];
        
        NSLog(@"✅ 微信分享成功：%@", title);
    } else {
        NSLog(@"⚠️ 未安装微信");
    }
}

- (void)saveAsImageWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    NSLog(@"另存为图片：%@", self.model.modelId);
    
    __weak typeof(self) weakSelf = self;
    
    // 确保在主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1. 检查模型和预览图
        if (!weakSelf.model || !weakSelf.model.previewImage) {
            NSLog(@"⚠️ 模型或预览图片不存在");
            if (completion) {
                completion(NO, [NSError errorWithDomain:@"diffFacto" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"模型或预览图片不存在"}]);
            }
            return;
        }
        
        // 2. 检查相册权限
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            // 请求权限
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [weakSelf saveImageToAlbum:weakSelf.model.previewImage completion:completion];
                } else {
                    NSLog(@"⚠️ 相册权限被拒绝");
                    if (completion) {
                        completion(NO, [NSError errorWithDomain:@"diffFacto" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"相册权限被拒绝"}]);
                    }
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [weakSelf saveImageToAlbum:weakSelf.model.previewImage completion:completion];
        } else {
            NSLog(@"⚠️ 相册权限被拒绝");
            if (completion) {
                completion(NO, [NSError errorWithDomain:@"diffFacto" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"相册权限被拒绝"}]);
            }
        }
    });
}

- (void)saveImageToAlbum:(UIImage *)image completion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 回到主线程弹框（必须）
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"✅ 保存到相册成功");
            } else {
                NSLog(@"⚠️ 保存到相册失败：%@", error.localizedDescription);
            }
            if (completion) {
                completion(success, error);
            }
        });
    }];
}

- (void)deleteModel {
    // 实际项目：删除本地缓存/数据库数据
    NSLog(@"删除模型：%@", self.model.modelId);
    
    // 读取现有的历史记录
    CreatePageViewModel *createViewModel = [[CreatePageViewModel alloc] init];
    NSMutableArray *historyList = [createViewModel getGenerateHistory];
    
    // 找到要删除的模型并从数组中删除
    NSMutableArray *newHistoryList = [NSMutableArray array];
    for (id history in historyList) {
        if ([history respondsToSelector:@selector(modelId)]) {
            NSString *modelId = [history performSelector:@selector(modelId)];
            if (![modelId isEqualToString:self.model.modelId]) {
                [newHistoryList addObject:history];
            }
        }
    }
    
    // 重新保存到本地
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"GenerateHistory.data"];
    [NSKeyedArchiver archiveRootObject:newHistoryList toFile:filePath];
    NSLog(@"✅ 删除成功，更新缓存：%@", filePath);
}

- (void)togglePublicStatus {    
    self.model.isPublic = !self.model.isPublic;    
    // 实际项目：更新后端公开状态    NSLog(@"切换公开状态：%@ -&gt; %@", self.model.modelId, self.model.isPublic ? @"公开" : @"私有");    
    // 当设置为公开时，向后端发送数据    
    if (self.model.isPublic) {        
        [self sendModelDataToBackend];    
    }
}

- (NSArray *)convertSCNNodeToArray:(SCNNode *)node {
    NSMutableArray *pointsArray = [NSMutableArray array];
    
    for (SCNNode *childNode in node.childNodes) {
        if (childNode.geometry) {
            SCNVector3 position = childNode.position;
            NSArray *point = @[@(position.x), @(position.y), @(position.z)];
            [pointsArray addObject:point];
        }
    }
    
    return [pointsArray copy];
}

- (void)sendModelDataToBackend {
    // 准备要发送的数据    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    postData[@"model_type"] = self.model.modelType;
    postData[@"model_id"] = self.model.modelId;
    postData[@"is_public"] = @(self.model.isPublic);    
    postData[@"create_time"] = self.model.createTime;
    // 处理点云数据
    if (self.model.pointCloudData) {
        // 先判断是不是字符串，如果是，直接用
        if ([self.model.pointCloudData isKindOfClass:[NSString class]]) {
            postData[@"point_cloud_data"] = self.model.pointCloudData;
        }
        // 如果是 NSData，再转 base64
        else if ([self.model.pointCloudData isKindOfClass:[NSData class]]) {
            NSString *base64 = [self.model.pointCloudData base64EncodedStringWithOptions:0];
            postData[@"point_cloud_data"] = base64;
        }
        // 如果是 NSArray，转换为 JSON 字符串
        else if ([self.model.pointCloudData isKindOfClass:[NSArray class]]) {
            NSError *jsonError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.model.pointCloudData options:NSJSONWritingPrettyPrinted error:&jsonError];
            if (!jsonError) {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                postData[@"point_cloud_data"] = jsonString;
            }
        }
        // 如果是 SCNNode，先转换为数组再发送
        else if ([self.model.pointCloudData isKindOfClass:[SCNNode class]]) {
            NSArray *pointCloudArray = [self convertSCNNodeToArray:(SCNNode *)self.model.pointCloudData];
            NSError *jsonError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointCloudArray options:NSJSONWritingPrettyPrinted error:&jsonError];
            if (!jsonError) {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                postData[@"point_cloud_data"] = jsonString;
                NSLog(@"✅ SCNNode 转换为数组成功，共 %ld 个点", (long)pointCloudArray.count);
            } else {
                NSLog(@"⚠️ SCNNode 转换为 JSON 失败：%@", jsonError.localizedDescription);
            }
        }
    }
    // 处理使用的样式信息
    if (self.model.createHistoryList && self.model.createHistoryList.count > 0) {
        NSMutableArray *stylesArray = [NSMutableArray array];
        for (CreateHistoryModel *history in self.model.createHistoryList) {
            if (history.selectedItems && history.selectedItems.count > 0) {
                for (id selectedItem in history.selectedItems) {
                    if ([selectedItem respondsToSelector:@selector(categoryName)] &&
                        [selectedItem respondsToSelector:@selector(itemName)]) {
                        NSString *categoryName = [selectedItem performSelector:@selector(categoryName)];
                        NSString *itemName = [selectedItem performSelector:@selector(itemName)];
                        NSDictionary *styleDict = @{@"category": categoryName,
                                                    @"style": itemName
                        };
                        [stylesArray addObject:styleDict];
                    }
                }
            }
        }
        postData[@"styles"] = stylesArray;
    }
    // 转换为JSON数据
    NSError *error = nil;    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:&error];    
    if (error) {        
        NSLog(@"⚠️ JSON序列化失败：%@", error.localizedDescription);        
        if (self.statusUpdateCompletion) {
            dispatch_async(dispatch_get_main_queue(), ^{                
                self.statusUpdateCompletion(NO, [NSString stringWithFormat:@"JSON序列化失败：%@", error.localizedDescription]);            
            });
        }
        return;    
    }
    // 构建请求    
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:6006/api/models/%@/public", self.model.modelId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    
    [request setHTTPMethod:@"POST"];    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];    
    [request setHTTPBody:jsonData];
    // 发送请求    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {        
        if (error) {            
            NSLog(@"⚠️ 发送数据到后端失败：%@", error.localizedDescription);            
            if (self.statusUpdateCompletion) {
                dispatch_async(dispatch_get_main_queue(), ^{                    
                    self.statusUpdateCompletion(NO, [NSString stringWithFormat:@"发送数据到后端失败：%@", error.localizedDescription]);                });
            }
        } else {
            // 处理响应
            if (data) {
                NSError *jsonError = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError) {
                    NSLog(@"⚠️ 解析响应失败：%@", jsonError.localizedDescription);
                    if (self.statusUpdateCompletion) {
                        dispatch_async(dispatch_get_main_queue(), ^{                            
                            self.statusUpdateCompletion(NO, [NSString stringWithFormat:@"解析响应失败：%@", jsonError.localizedDescription]);                        });
                    }
                } else {
                    NSLog(@"✅ 发送数据到后端成功：%@", responseDict);
                    if (self.statusUpdateCompletion) {
                        dispatch_async(dispatch_get_main_queue(), ^{                            
                            self.statusUpdateCompletion(YES, @"已设置为公开");                        
                        });
                    }
                }
            } else {
                if (self.statusUpdateCompletion) {
                    dispatch_async(dispatch_get_main_queue(), ^{                        
                        self.statusUpdateCompletion(NO, @"未收到响应数据");                    
                    });
                }
            }
        }
    }];
    [task resume];
}

- (NSArray<CreateHistoryModel *> *)getCreateHistory {
    return self.model.createHistoryList;
}

@end
