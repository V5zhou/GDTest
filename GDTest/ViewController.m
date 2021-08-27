//
//  ViewController.m
//  GDTest
//
//  Created by 心檠 on 2021/8/11.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
            @{@"key": @"FreeStackViewController", @"desc": @"自由StackView"},
            @{@"key": @"MallocBlockViewController", @"desc": @"MallocBlock崩溃问题"},
            @{@"key": @"TransformTestViewController", @"desc": @"Transform扩展测试"},
            @{@"key": @"ImagePerformanceTestVC", @"desc": @"图片性能测试"},
        ];
    }
    return _dataSource;
}

// MARK: tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GDTestCell"];
    cell.textLabel.text = self.dataSource[indexPath.row][@"desc"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataSource[indexPath.row][@"key"];
    UIViewController *vc = [NSClassFromString(key) new];
    vc.title = key;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
