//
//  CGAffineTransformExtension.h
//  GDTest
//
//  Created by 心檠 on 2021/8/16.
//

#ifndef CGAffineTransformExtension_h
#define CGAffineTransformExtension_h

static inline CGAffineTransform CGAffineTransformScalePlus(CGAffineTransform transform, CGFloat scaleX, CGFloat scaleY, CGPoint anchor) {
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(-anchor.x, -anchor.y));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(scaleX, scaleY));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(anchor.x, anchor.y));
    return transform;
}

static inline CGAffineTransform CGAffineTransformRotationPlus(CGAffineTransform transform, CGFloat angle, CGPoint anchor) {
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(-anchor.x, -anchor.y));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(anchor.x, anchor.y));
    return transform;
}

// MARK: 以下为错误transform，得不到预期结果。使用CGAffineTransformConcat才可以
static inline CGAffineTransform CGAffineTransformScalePlusError(CGAffineTransform transform, CGFloat scaleX, CGFloat scaleY, CGPoint anchor) {
    transform = CGAffineTransformTranslate(transform, -anchor.x, -anchor.y);
    transform = CGAffineTransformScale(transform, scaleX, scaleY);
    transform = CGAffineTransformTranslate(transform, anchor.x, anchor.y);
    return transform;
}

#endif /* CGAffineTransformExtension_h */
