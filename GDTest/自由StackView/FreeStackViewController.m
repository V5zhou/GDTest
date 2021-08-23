//
//  FreeStackViewController.m
//  GDTest
//
//  Created by 心檠 on 2021/8/11.
//

#import "FreeStackViewController.h"
#import "GDFreeStackView.h"

@interface FreeStackViewController ()

@property (nonatomic, strong) GDFreeStackView *stackView;
@property (nonatomic, assign) BOOL first;

@end

@implementation FreeStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.first = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.stackView = [[GDFreeStackView alloc] initWithFrame:CGRectMake(30, 140, 300, 0)];
//    _stackView.stackLocation = GDFreeStackLocation_bottom;
    _stackView.backgroundColor = [UIColor lightGrayColor];
    _stackView.fadeInOut = YES;
    _stackView.clipsToBounds = YES;
    [self.view addSubview:_stackView];
}

static NSInteger count = 4;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.first) {
        _stackView.views = [self randomViews];
        self.first = NO;
    } else {
        NSArray *oldViews = _stackView.views;
        NSMutableArray *views = [NSMutableArray array];
        // 取几个旧的
        [views addObject:oldViews.lastObject];
        while (views.count < count/2) {
            NSInteger idx = arc4random() % oldViews.count;
            if (![views containsObject:oldViews[idx]]) {
                [views addObject:oldViews[idx]];
            }
        }
        // 插入三个新的
        while (views.count < count + arc4random()%3) {
            NSInteger idx = arc4random() % views.count;
            [views insertObject:[self randomView] atIndex:idx];
        }
        _stackView.views = views;
    }
    
    GDFreeStackAnimation *animation = _stackView.parsedAnimation;
    animation.beforeAnimation();
    [UIView animateWithDuration:0.35 animations:^{
        CGFloat height = animation.animation();
    } completion:^(BOOL finished) {
        animation.afterAnimation();
    }];
}

- (NSArray *)randomViews {
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [views addObject:[self randomView]];
    }
    return views.copy;
}

- (UIView *)randomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 0, (arc4random()%5 + 1) * 30)];
    view.backgroundColor = [UIColor colorWithHue:arc4random()%255/255.0 saturation:1 brightness:1 alpha:1];
    return view;
}

@end
