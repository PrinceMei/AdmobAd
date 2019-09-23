//
//  SplashAdManage.m
//  AdmobDome
//
//  Created by shen on 2019/9/20.
//  Copyright © 2019 沈增光. All rights reserved.
//

#import "SplashAdManage.h"
@import GoogleMobileAds;

#define AdMob_CID @"ca-app-pub-3940256099942544/4411468910"

@interface SplashAdManage()<GADInterstitialDelegate>{
    
    UIViewController *AdViewController;
}
@property (nonatomic, strong) UIWindow* window;

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

static SplashAdManage *manager = nil;

@implementation SplashAdManage

+ (SplashAdManage *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SplashAdManage alloc] init];
    });
    return manager;
}
//在load 方法中，启动监听，可以做到无注入
-(void)load{
    
    ///如果是没啥经验的开发，请不要在初始化的代码里面做别的事，防止对主线程的卡顿，和 其他情况
    ///应用启动, 首次开屏广告
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
        [self show];
        [self CheakAd];
    }];
    ///进入后台
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
    ///后台启动,二次开屏广告
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self show];
        [self CheakAd];
    }];
    
}


-(void)CheakAd{//这一部分的逻辑大家根据自身需求定制
    [self setInterstitial];
}


//初始化插页广告
- (void)setInterstitial {
    self.interstitial = [self createNewInterstitial];
}
//这个部分是因为多次调用 所以封装成一个方法
- (GADInterstitial *)createNewInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:AdMob_CID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}


- (void)show{
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AdViewController = [UIViewController new];
    window.rootViewController = AdViewController;
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    ///广告布局
    [self setupSubviews:window];
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}

- (void)hide{
    ///来个渐显动画
    [UIView animateWithDuration:0.1 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
    }];
}

///初始化显示的视图， 可以挪到具
- (void)setupSubviews:(UIWindow*)window{
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    //和启动图一样，给用户造成错觉
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"ADImage.png"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    [window addSubview:imageView];
}

#pragma mark -GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{//接收到插屏广告
    //    判断是否请求到admob广告 请求到就展示
    if ([self.interstitial isReady]) {
        
        [self.interstitial presentFromRootViewController:AdViewController];
        
    }else{
        //        请求失败
        NSLog(@"not ready~~~~");
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{//插屏广告请求失败
    [self hide];
}

/**********************/
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    //插屏广告即将开始
    NSLog(@"插屏广告即将开始");
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad{
    //插屏广告失败
    NSLog(@"插屏广告失败");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    //插屏广告即将消失
    NSLog(@"插屏广告即将消失");
    [self hide];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    //插屏广告已经消失
    NSLog(@"插屏广告已经消失");
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    //插屏广告即将离开APP
    NSLog(@"插屏广告即将离开APP");
}


@end
