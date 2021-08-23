//
//  TransformTestViewController.m
//  GDTest
//
//  Created by 心檠 on 2021/8/16.
//

#import "TransformTestViewController.h"
#import "CGAffineTransformExtension.h"
#import "FlagOriginView.h"
#import "UIBezierPathDraw.h"

@interface TransformTestViewController ()

@end

@implementation TransformTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testConcat];
    [self testCoordinateTranslate];
    [self testBezierPathTransform];
    [self testCGPointTransform];
}

// 测试CGAffineTransformScale与CGAffineTransformConcat关系
- (void)testConcat {
    CGRect rect = CGRectMake(100, 100, 200, 100);
    CGFloat scale = 0.5;
    
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(100, 10);
    transform1 = CGAffineTransformScale(transform1, scale, scale);
    CGRect rect1 = CGRectApplyAffineTransform(rect, transform1);
    
    CGAffineTransform transform2 = CGAffineTransformMakeScale(scale, scale);
    transform2 = CGAffineTransformTranslate(transform2, 100, 10);
    CGRect rect2 = CGRectApplyAffineTransform(rect, transform2);
    
    CGAffineTransform transform3 = CGAffineTransformMakeTranslation(100, 10); // {200， 110， 200， 100}
    transform3 = CGAffineTransformConcat(transform3, CGAffineTransformMakeScale(scale, scale)); // {100， 55， 100， 50}
    CGRect rect3 = CGRectApplyAffineTransform(rect, transform3);
    
    CGAffineTransform transform4 = CGAffineTransformMakeScale(scale, scale); // {50， 50， 100， 50}
    transform4 = CGAffineTransformConcat(transform4, CGAffineTransformMakeTranslation(100, 10)); // {150， 60， 100， 50}
    CGRect rect4 = CGRectApplyAffineTransform(rect, transform4);
    
    NSLog(@"\n%@\n%@\n%@\n%@", NSStringFromCGRect(rect1),NSStringFromCGRect(rect2),NSStringFromCGRect(rect3),NSStringFromCGRect(rect4));
    
    /*
     结论：
     
     1. transform连续操作，不满足交换率。（平移 + 缩放 != 缩放 + 平移）
     2. CGAffineTransformScale(translation, scale) == CGAffineTransformConcat(scale, translation) (concat与之顺序刚好相反)
     3. concat才是符合正常顺序的操作。
     4. concat为后乘，另外一种（CGAffineTransformScale/CGAffineTransformTranslate/CGAffineTransformRotate）为前乘
     
     */
}

// 测试UIView的transform
- (void)testCoordinateTranslate {
    FlagOriginView *view1 = [[FlagOriginView alloc] initWithFrame:CGRectMake(20, 90,  100, 30)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    FlagOriginView *view2 = [[FlagOriginView alloc] initWithFrame:CGRectMake(20, 90,  100, 30)];
    view2.layer.borderColor = [UIColor redColor].CGColor;
    view2.layer.borderWidth = 1;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, 30));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(M_PI_4));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(0.5, 0.5));
    view2.transform = transform;
    [self.view addSubview:view2];
    
    /*
     
     结论：
     1. 未平移前，锚点都是原view中心点
     2. 先平移后缩放 != 先缩放后平移
     3. 平移后，锚点在原中心点不变
     4. 旋转角是顺时针的
     
     */
}

// 测试UIBezierPath的transform
- (void)testBezierPathTransform {
    UIBezierPathDraw *draw = [[UIBezierPathDraw alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    draw.showSubline = YES;
    draw.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(100, -50, 20, 100)];
    
    UIBezierPath *transformed = [UIBezierPath bezierPathWithRect:CGRectMake(100, -50, 20, 100)];
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(80, 0));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(M_PI_4 / 4));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(10/18.0, 10/18.0));
    [transformed applyTransform:transform];
    draw.transformedBezier = transformed;
    
    [self.view addSubview:draw];
    
    /*
     
     结论：
     1. 初始锚点为(0,0)
     2. 先平移后缩放 != 先缩放后平移
     3. 平移后，锚点在原（0，0）不变
     4. 角度为顺时针
    
    */
}

// 测试点的transform
- (void)testCGPointTransform {
    UIBezierPathDraw *draw = [[UIBezierPathDraw alloc] initWithFrame:CGRectMake(100, 310, 200, 200)];
    CGPoint point = CGPointMake(120, 10);
    draw.bezier = [UIBezierPath bezierPathWithArcCenter:point radius:5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(80, 0));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(M_PI_4));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(0.5, 0.5));
    point = CGPointApplyAffineTransform(point, transform);
    draw.transformedBezier = [UIBezierPath bezierPathWithArcCenter:point radius:5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [self.view addSubview:draw];
    
    /*
     
     结论：
     
     1. 初始锚点为(0,0)
     2. 先平移后缩放 != 先缩放后平移
     3. 平移后，锚点在原（0，0）不变
     4. 角度为顺时针
    
    */
}

@end
