//
//  GDFreeStackView.h
//  GDTest
//
//  Created by 心檠 on 2021/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GDFreeStackLocation) {
    GDFreeStackLocation_top = 0,
    GDFreeStackLocation_bottom,
};

@interface GDFreeStackAnimation : NSObject

@property (nonatomic, copy) void (^beforeAnimation)(void);
@property (nonatomic, copy) CGFloat (^animation)(void);
@property (nonatomic, copy) void (^afterAnimation)(void);

@end

@interface GDFreeStackView : UIView

/// 停留区域
@property (nonatomic, assign) GDFreeStackLocation stackLocation;

/// 渐隐渐现（opcity，离开1-0，新增0-1）
@property (nonatomic, assign) BOOL fadeInOut;

/// 需要展示的views
@property (nonatomic, strong) NSArray<UIView *> *views;

/// 获取解析后动画节点
/// 拿到动画节点后，可以自定义动画
- (GDFreeStackAnimation *)parsedAnimation;

/// 刷新界面
/// 使用默认动画刷新界面，如果想自定义动画，可以拿parsedAnimation自定义动画
- (void)reloadAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
