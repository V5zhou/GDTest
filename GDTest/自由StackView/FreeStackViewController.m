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
    self.stackView = [[GDFreeStackView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 0)];
    _stackView.stackLocation = GDFreeStackLocation_bottom;
    _stackView.fadeInOut = YES;
    _stackView.clipsToBounds = YES;
    [self.view addSubview:_stackView];
}

static NSInteger count = 4;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.first) {
        _stackView.views = [self randomViews];
        self.first = NO;
    } else if (arc4random()%8 == 5) {
        _stackView.views = @[];
    } else {
        NSArray *oldViews = _stackView.views;
        NSMutableArray *views = [NSMutableArray array];
        // 取几个旧的
        if (oldViews.count >= 2) {
            [views addObject:oldViews.firstObject];
        }
        // 插入三个新的
        while (views.count < count + arc4random()%3) {
            [views addObject:[self randomView]];
        }
        if (oldViews.count >= 2) {
            [views addObject:oldViews.lastObject];
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
