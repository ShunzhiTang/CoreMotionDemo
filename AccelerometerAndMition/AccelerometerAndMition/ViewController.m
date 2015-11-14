//
//  ViewController.m
//  AccelerometerAndMition
//
//  Created by Tsz on 15/11/13.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "ViewController.h"

@interface ViewController () <UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ball;

// 计算 速度
@property (nonatomic)CGPoint velocity;

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
    
//    NSLog(@"x: %f, y: %f, z: %f", acceleration.x, acceleration.y, acceleration.z);
    
    //1、实现小球的运动 ，根据手机的位置 把x y 的速度进行叠加
    _velocity.x += acceleration.x;
    _velocity.y += acceleration.y;
    
    
    //2、计算小球的位移
    CGRect ballFrame = self.ball.frame;
    ballFrame.origin.x += _velocity.x;
    ballFrame.origin.y += _velocity.y;
    
    //判断
    if (ballFrame.origin.x <= 0) {
        ballFrame.origin.x = 0;
        _velocity.x -= -0.7;
    }
    
    if (ballFrame.origin.x >= self.view.frame.size.width - ballFrame.size.width) {
        ballFrame.origin.x = self.view.frame.size.width - ballFrame.size.width;
        _velocity.x *= -0.7;
    }
    
    if (ballFrame.origin.y <= 0) {
        ballFrame.origin.y = 0;
        _velocity.y *= -0.7;
    }
    
    if (ballFrame.origin.y >= self.view.frame.size.height - ballFrame.size.height) {
        ballFrame.origin.y = self.view.frame.size.height - ballFrame.size.height;
        _velocity.y *= -0.7;
    }
    
    self.ball.frame = ballFrame;
    
}

@end
