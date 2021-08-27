//
//  GDFreeStackView.m
//  GDTest
//
//  Created by 心檠 on 2021/8/11.
//

#import "GDFreeStackView.h"

@implementation GDFreeStackAnimation

@end

@interface GDFreeStackView ()

@property (nonatomic, assign) BOOL dirty;
@property (nonatomic, strong) GDFreeStackAnimation *animation;
@property (nonatomic, strong) NSArray<UIView *> *previousViews;

@end

@implementation GDFreeStackView

- (void)setViews:(NSArray<UIView *> *)views {
    _views = [views copy];
    _dirty = YES;
    // 检查传入值
    NSAssert([NSSet setWithArray:views].count == views.count, @"数据中存在重复视图，请检查!");
}

- (GDFreeStackAnimation *)parsedAnimation {
    if (!_dirty) {
        return _animation;
    }
    __weak typeof(self) weakSelf = self;
    // a && b
    NSMutableSet *publicSet = [NSMutableSet setWithArray:_views];
    [publicSet intersectSet:[NSSet setWithArray:_previousViews]];
    // a - b
    NSMutableSet *addSet = [NSMutableSet setWithArray:_views];
    [addSet minusSet:[NSSet setWithArray:_previousViews]];
    // b - a
    NSMutableSet *subSet = [NSMutableSet setWithArray:_previousViews];
    [subSet minusSet:[NSSet setWithArray:_views]];
    // a + b
    NSMutableSet *totalSet = [NSMutableSet setWithArray:_previousViews];
    [totalSet unionSet:[NSSet setWithArray:_views]];

    GDFreeStackAnimation *animation = [GDFreeStackAnimation new];
    animation.beforeAnimation = ^{
        __weak typeof(weakSelf) self = weakSelf;
        // 给新增的元素放到屏幕外
        CGFloat y = CGRectGetHeight(self.frame);
        for (UIView *view in self.views) { // 为什么不直接使用set，保持传入views次序
            if ([addSet containsObject:view]) {
                if (self.fadeInOut) {
                    view.alpha = 0;
                }
                [view layoutIfNeeded];
                CGFloat x = 0;
                CGFloat width = self.frame.size.width;
                CGFloat height = view.frame.size.height;
                view.frame = CGRectMake(x, y, width, height);
                [self addSubview:view];
                [self sendSubviewToBack:view];
                y += height;
            }
        }
    };
    
    animation.animation = ^{
        __weak typeof(weakSelf) self = weakSelf;
        CGFloat y = 0;
        for (UIView *view in self.views) {
            view.alpha = 1;
            CGFloat x = 0;
            CGFloat width = self.frame.size.width;
            CGFloat height = view.frame.size.height;
            view.frame = CGRectMake(x, y, width, height);
            y += height;
        }
        // 更新视图高度
        [self resetHeight:y];
        
        // 将要移除的元素移到屏謩外
        CGFloat overY = y;
        NSArray<UIView *> *sortedWillRemovedViews = [self sortedViews:[subSet allObjects]];
        for (UIView *view in sortedWillRemovedViews) {
            if (self.fadeInOut) {
                view.alpha = 0;
            }
            CGFloat x = 0;
            CGFloat width = self.frame.size.width;
            CGFloat height = view.frame.size.height;
            view.frame = CGRectMake(x, overY, width, height);
            [self sendSubviewToBack:view];
            overY += height;
        }
        return y;
    };
    
    animation.afterAnimation = ^{
        for (UIView *view in subSet) {
            [view removeFromSuperview];
        }
    };
    _dirty = NO;
    _animation = animation;
    _previousViews = _views;
    return animation;
}

// 根据y排列views
- (NSArray<UIView *> *)sortedViews:(NSArray<UIView *> *)views {
    NSArray<UIView *> *sorted = [views sortedArrayUsingComparator:^NSComparisonResult(UIView * _Nonnull obj1, UIView * _Nonnull obj2) {
        return obj1.frame.origin.y > obj2.frame.origin.y;
    }];
    return sorted;
}

- (void)reloadAnimated:(BOOL)animated {
    if (_dirty) {
        [self parsedAnimation];
    }
    if (animated) {
        GDFreeStackAnimation *animation = _animation;
        animation.beforeAnimation();
        [UIView animateWithDuration:0.35 animations:^{
            animation.animation();
        } completion:^(BOOL finished) {
            animation.afterAnimation();
        }];
    } else {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        CGFloat y = 0;
        for (UIView *view in self.views) {
            [view layoutIfNeeded];
            CGFloat x = 0;
            CGFloat width = self.frame.size.width;
            CGFloat height = view.frame.size.height;
            view.frame = CGRectMake(x, y, width, height);
            y += height;
            [self addSubview:view];
            [self resetHeight:y];
        }
    }
}
    
- (void)resetHeight:(CGFloat)height {
    switch (_stackLocation) {
        case GDFreeStackLocation_top: {
            CGRect frame = self.frame;
            frame.size.height = height;
            self.frame = frame;
        }
            break;
        case GDFreeStackLocation_bottom: {
            CGRect frame = self.frame;
            CGFloat y = CGRectGetMaxY(frame) - height;
            frame.origin.y = y;
            frame.size.height = height;
            self.frame = frame;
        }
            break;
        default:
            break;
    }
}

@end
