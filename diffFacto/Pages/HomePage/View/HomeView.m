//
//  HomeView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "HomeView.h"
#import "GlassButton.h"

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupButtons];
        [self addGestureRecognizers];
    }
    return self;
}

- (void)setupButtons {
    // 1. 新的创作按钮
    self.CreateBtn = [[GlassButton alloc] initWithTitle:@"新的创作"];
    self.CreateBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.CreateBtn addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.CreateBtn];
    
    // 2. 我的设计按钮
    self.myDesignBtn = [[GlassButton alloc] initWithTitle:@"我的设计"];
    self.myDesignBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.myDesignBtn addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.myDesignBtn];
    
    // AutoLayout 布局（适配所有屏幕）
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = screenW - 40;
    CGFloat btnH = 60;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.CreateBtn.topAnchor constraintEqualToAnchor:self.topAnchor constant:80],
        [self.CreateBtn.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.CreateBtn.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [self.CreateBtn.heightAnchor constraintEqualToConstant:btnH],
        
        [self.myDesignBtn.topAnchor constraintEqualToAnchor:self.CreateBtn.bottomAnchor constant:30],
        [self.myDesignBtn.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.myDesignBtn.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [self.myDesignBtn.heightAnchor constraintEqualToConstant:btnH]
    ]];
}

- (void)addGestureRecognizers {
    // 支持左右滑动切换（对应你草图的“可左右滑动”）
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
}

- (void)swipeHandle:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        // 左滑：选中第二个按钮
        [self updateButtonSelectedAtIndex:1];
        if (self.buttonClickBlock) self.buttonClickBlock(1);
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        // 右滑：选中第一个按钮
        [self updateButtonSelectedAtIndex:0];
        if (self.buttonClickBlock) self.buttonClickBlock(0);
    }
}

- (void)btn1Click {
    [self updateButtonSelectedAtIndex:0];
    if (self.buttonClickBlock) self.buttonClickBlock(0);
}

- (void)btn2Click {
    [self updateButtonSelectedAtIndex:1];
    if (self.buttonClickBlock) self.buttonClickBlock(1);
}

// 更新按钮选中状态
- (void)updateButtonSelectedAtIndex:(NSInteger)index {
    self.CreateBtn.isSelected = (index == 0);
    self.myDesignBtn.isSelected = (index == 1);
}

@end
