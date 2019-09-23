//
//  InterstitialAdManage.h
//  AdmobDome
//
//  Created by shen on 2019/9/23.
//  Copyright © 2019 沈增光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterstitialAdManage : NSObject

//单例模式
+ (InterstitialAdManage *)manager;

-(void)showAd:(UIViewController *)adView;


@end

NS_ASSUME_NONNULL_END
