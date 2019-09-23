//
//  ViewController.m
//  AdmobDome
//
//  Created by 沈增光 on 2017/10/30.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "ViewController.h"
#import "InterstitialAdManage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = self.view.center;
    [button setTitle:@"点击弹广告" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:button.bounds.size.width/2]; //设置矩形四个圆角半径
    [button.layer setBorderWidth:4.0];
    button.layer.borderColor=[UIColor redColor].CGColor;
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
   
}
//点击方法 弹出插屏广告
-(void)buttonClicked{
//    弹出插屏广告的方法
    [[InterstitialAdManage manager] showAd:self];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
