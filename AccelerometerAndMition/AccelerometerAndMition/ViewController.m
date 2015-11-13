//
//  ViewController.m
//  AccelerometerAndMition
//
//  Created by Tsz on 15/11/13.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "ViewController.h"

@interface ViewController () <UIAccelerometerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self accelerometerDemo];
}


#pragma mark  UIAccelerometer 加速计的使用 ，使用真机
/*在iOS4以前：使用UIAccelerometer，用法非常简单（到了iOS5就已经过期）
从iOS4开始：CoreMotion.framework
*/
- (void)accelerometerDemo{
    
    //1、获取单例对象
   UIAccelerometer *accelerometer  = [UIAccelerometer sharedAccelerometer];
    
    //2、设置代理
    accelerometer.delegate = self;
    
    //3、设置采样间隔
    accelerometer.updateInterval = 1/30.0;
    
}

//代理
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    NSLog(@"x: %f, y: %f, z: %f", acceleration.x, acceleration.y, acceleration.z);
}

@end
