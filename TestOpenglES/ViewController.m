//
//  ViewController.m
//  TestOpenglES
//
//  Created by yulibo on 2019/3/13.
//  Copyright © 2019年 余礼钵. All rights reserved.
//

#import "ViewController.h"
#import "GLShowViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *showButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    showButton.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
    showButton.backgroundColor = UIColor.blueColor;
    [showButton setTitle:@"显示画面" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(onClickShowButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
}

- (void)onClickShowButtonMethod:(UIButton *)sender {
    GLShowViewController *vc = [[GLShowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
