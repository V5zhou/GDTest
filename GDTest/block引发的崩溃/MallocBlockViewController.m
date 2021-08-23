//
//  MallocBlockViewController.m
//  GDTest
//
//  Created by 心檠 on 2021/8/13.
//

#import "MallocBlockViewController.h"

@interface MallocBlockViewController ()

@property (nonatomic, copy) int (^whatsage)(void);

@end

@implementation MallocBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 3s后离开页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    __weak typeof(self) weakSelf = self;
    self.whatsage = ^{
        return 80;
    };
    // 持续5s的动画
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:5 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithHue:arc4random()%100/100.0 saturation:1 brightness:1 alpha:1];
    } completion:^(BOOL finished) {
        int se = weakSelf.whatsage();
//        int se = self.whatsage();
        NSLog(@"%d", se);
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.class);
}

@end

/**
 @title: 为什么block为nil时，执行会崩溃？
 
 block是一个结构体，执行block其实就是执行block的invoke函数指针。
 当block为nil时，地址为0x0，invoke指针相对偏移为12，也就是0xc
 执行0xc跳转，这是一个无效的地址，会导致EXC_BAD_ACCESS报错
 结合报错为：EXC_BAD_ACCESS (code=1, address=0xc)
 
 参考：https://stackoverflow.com/questions/4145164/why-do-nil-null-blocks-cause-bus-errors-when-run
 */
