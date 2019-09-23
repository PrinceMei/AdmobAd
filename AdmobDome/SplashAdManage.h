//
//  SplashAdManage.h
//  AdmobDome
//
//  Created by shen on 2019/9/20.
//  Copyright © 2019 沈增光. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SplashAdManage : NSObject

//单例模式
+ (SplashAdManage *)manager;

-(void)load;

@end

NS_ASSUME_NONNULL_END
