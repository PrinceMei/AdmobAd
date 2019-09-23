//
//  InterstitialAdManage.m
//  AdmobDome
//
//  Created by shen on 2019/9/23.
//  Copyright © 2019 沈增光. All rights reserved.
//

#import "InterstitialAdManage.h"
@import GoogleMobileAds;


/*
 AppDelegate里别忘了设置APP_admobID
 */

/*
 关于admobSDK 在pods文件里Podfile里的pod 'Firebase/AdMob'通过终端获取最新SDK
 */

#define AdMob_CID @"ca-app-pub-3940256099942544/4411468910"
/*
 这里的代理记得设置<GADInterstitialDelegate>  不然就不会走下面代码的代理方法 展示失败就不会再次请求了
 */
@interface InterstitialAdManage()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@property(nonatomic, strong) UIViewController *adView;
@end

static InterstitialAdManage *manager = nil;

@implementation InterstitialAdManage


+ (InterstitialAdManage *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[InterstitialAdManage alloc] init];
    });
    return manager;
}

-(void)showAd:(UIViewController *)adView{
    self.adView = adView;
    
    [self setInterstitial];
}



/*********************************************************************************************
 主要代码
 *********************************************************************************************/

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

#pragma mark - GADInterstitialDelegate -admob广告代理
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    //    判断是否请求到admob广告 请求到就展示
    if ([self.interstitial isReady]) {
        
        [self.interstitial presentFromRootViewController:self.adView];

    }else{
        //        请求失败
        NSLog(@"not ready~~~~");
    }
}
//分配失败重新分配   这个方法比较重要  因为官方文档说了setInterstitial是一次性的  请求成功只能展示一次 当展示第二次的时候就需要重新调用才能达到展示效果  你APP里的问题也有可能是这个原因  当插屏没有展示的时候 会再次请求展示  知道展示成功为止
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    //    再次请求展示
    [self setInterstitial];
}
/*********************************************************************************************
 主要代码
 *********************************************************************************************/
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
