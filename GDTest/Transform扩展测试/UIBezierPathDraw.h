//
//  UIBezierPathDraw.h
//  GDTest
//
//  Created by 心檠 on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPathDraw : UIView

@property (nonatomic, strong) UIBezierPath *bezier;
@property (nonatomic, strong) UIBezierPath *transformedBezier;

@property (nonatomic, assign) BOOL showSubline;

@end

NS_ASSUME_NONNULL_END
