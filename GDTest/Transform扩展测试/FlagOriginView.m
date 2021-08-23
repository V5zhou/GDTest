//
//  FlagOriginView.m
//  GDTest
//
//  Created by 心檠 on 2021/8/18.
//

#import "FlagOriginView.h"

@implementation FlagOriginView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setFill];
    CGContextAddEllipseInRect(ctx, CGRectMake(-10, -10, 20, 20));
    CGContextFillPath(ctx);
}

@end
