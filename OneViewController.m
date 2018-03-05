//
//  OneViewController.m
//  HBuilder-Integrate
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 50, 50)];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)btnclick:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
