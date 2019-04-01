//
//  GLShowViewController.m
//  TestOpenglES
//
//  Created by yulibo on 2019/3/27.
//  Copyright © 2019年 余礼钵. All rights reserved.
//

#import "GLShowViewController.h"
#import "TestGLView.h"

@interface GLShowViewController ()
@property(nonatomic, strong) TestGLView *testGLView;
@end

@implementation GLShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemMethod:)];
    
    _testGLView = [[TestGLView alloc] initWithFrame:self.view.bounds];
    _testGLView.center = CGPointMake(self.view.frame.size.width/2.0, CGRectGetHeight(self.view.frame)/2.0);
    [self.view addSubview:_testGLView];
    [_testGLView createContext];
    [_testGLView render];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)leftBarButtonItemMethod:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
