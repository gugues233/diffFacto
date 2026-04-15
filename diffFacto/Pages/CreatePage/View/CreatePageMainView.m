//
//  CreatePageMainView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreatePageMainView.h"
#import "CategoryItemCell.h"

@implementation CreatePageMainView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 1. 顶部分类滑动栏
    self.categoryScrollView = [[CategoryScrollView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width, 130)];
    self.categoryScrollView.delegate = self;
    [self addSubview:self.categoryScrollView];
    
    // 2. 左侧已选列表
    CGFloat previewX = 100;
    CGFloat previewW = self.bounds.size.width - previewX - 20;
    CGFloat previewH = self.bounds.size.height - 200;
    self.selectedView = [[SelectedItemView alloc] initWithFrame:CGRectMake(10, 165, 80, previewH)];
    [self addSubview:self.selectedView];
    
    // 3. 中间3D预览区
    self.previewView = [[Preview3DView alloc] initWithFrame:CGRectMake(previewX, 165, previewW, previewH)];
    self.previewView.layer.borderColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.previewView.layer.borderWidth = 1;
    self.previewView.layer.cornerRadius = 12;
    [self addSubview:self.previewView];
    
    // 4. 生成按钮
    self.generateButton = [[UIButton alloc] initWithFrame:CGRectMake(previewX + previewW - 120, 165 + previewH - 50, 100, 40)];
    [self.generateButton setTitle:@"生成" forState:UIControlStateNormal];
    [self.generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.generateButton.backgroundColor = [UIColor systemBlueColor];
    self.generateButton.layer.cornerRadius = 8;
    [self.generateButton addTarget:self action:@selector(generateClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.generateButton];
}

- (void)generateClick {
    if ([self.delegate respondsToSelector:@selector(generateButtonDidClick)]) {
        [self.delegate generateButtonDidClick];
    }
}

#pragma mark - CategoryScrollViewDelegate
- (void)categoryItemDidSelect:(NSInteger)itemIndex categoryIndex:(NSInteger)categoryIndex fromView:(UIView *)fromView {
    // 计算点击位置
    CGPoint fromPoint = [fromView convertPoint:fromView.center toView:self];
    // 通知控制器更新数据，然后执行动画
    if ([self.delegate respondsToSelector:@selector(categoryItemDidSelect:categoryIndex:fromView:)]) {
        // 这里通过代理回调控制器，控制器更新ViewModel后，再调用updateSelectedList和动画
    }
}

- (void)updateSelectedList:(NSArray *)selectedList {
    self.selectedView.selectedList = selectedList;
}

- (void)addItemAnimationFromView:(UIView *)fromView {
    CGPoint fromPoint = [fromView convertPoint:fromView.center toView:self];
    UIImage *image = ((CategoryItemCell *)fromView).model.itemImage;
    [self.selectedView addItemWithImage:image fromPoint:fromPoint completion:nil];
}

- (void)updateGenerateProgress:(CGFloat)progress {
    [self.previewView startGenerateProgress:progress];
}

- (void)show3DResult:(id)result {
    [self.previewView show3DPointCloud:result];
}
@end
