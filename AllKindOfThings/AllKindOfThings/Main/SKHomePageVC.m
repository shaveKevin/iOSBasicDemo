//
//  ViewController.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKHomePageVC.h"
#import <Masonry/Masonry.h>

static NSString *const cellIdentifier = @"cellIdentifier";

@interface SKHomePageVC ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
/**
 *  @brief Description
 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SKHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}


- (void)initData {
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;

    [self addCellText:@"多线程" class:@"SKThreadDeadLockVC"];
    [self addCellText:@"Runtime" class:@"SKRuntimeVC"];
    [self addCellText:@"Runloop" class:@"SKRunloopVC"];
    [self addCellText:@"Block" class:@"SKBlockVC"];
    [self addCellText:@"KVC&KVO" class:@"SKKVCKVOVC"];
    [self addCellText:@"Delegate" class:@"SKDelegateVC"];
    [self addCellText:@"属性" class:@"SKPropertyVC"];
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addCellText:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
    return _tableView;
}



@end
