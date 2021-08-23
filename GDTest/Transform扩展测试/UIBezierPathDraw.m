//
//  UIBezierPathDraw.m
//  GDTest
//
//  Created by 心檠 on 2021/8/18.
//

#import "UIBezierPathDraw.h"

@implementation UIBezierPathDraw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    
    if (_showSubline) {
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, 0.5);
        [[UIColor lightGrayColor] setStroke];
        CGFloat x = 10;
        while (x < rect.size.width) {
            CGContextMoveToPoint(ctx, 0, x);
            CGContextAddLineToPoint(ctx, rect.size.width, x);
            
            CGContextMoveToPoint(ctx, x, 0);
            CGContextAddLineToPoint(ctx, x, rect.size.height);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGContextAddArc(ctx, 0, 0, x, 0, M_PI * 2, YES);
            CGContextDrawPath(ctx, kCGPathStroke);
            x += 10;
        }
        CGContextRestoreGState(ctx);
    }
    
    CGContextSaveGState(ctx);
    [[UIColor redColor] setStroke];
    CGContextAddPath(ctx, self.bezier.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    [[UIColor greenColor] setStroke];
    CGContextAddPath(ctx, self.transformedBezier.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}

@end
