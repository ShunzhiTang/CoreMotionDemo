//
//  ViewController.m
//  AccelerometerAndMition
//  Created by Tsz on 15/11/13.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () <UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ball;

// 计算 速度
@property (nonatomic)CGPoint velocity;

//运动管理器
@property (nonatomic , strong) CMMotionManager *motionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、加速计实现小球运动
//    [self accelerometerDemo];

    //2、磁力计的实现 和测试
//    [self magneticDemo];
    
   
}

//触频
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self pushGrou];
    
    [self pullAccelerometer];
}



#pragma mark 陀螺仪


// 在有需要的时候，再主动去采集数据
- (void)pullGrou{
    //1、创建运动管理器
    self.motionManager = [CMMotionManager alloc];
    
    if (![self.motionManager isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
        return;
    }
    
    //开始采样
    [self.motionManager startGyroUpdates];
//    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
//        
//        CMRotationRate rotationRate = gyroData.rotationRate;
//        NSLog(@"%f",rotationRate.x);
//    }];
}

//实时采集所有数据（采集频率高）
- (void)pushGrou{
    
    //1. 创建运动管理器
    self.motionManager = [CMMotionManager new];
    
    //2. 判断是否可用
    if (![self.motionManager isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
        return;
    }
    
    //3、设置采样间隔
    self.motionManager.gyroUpdateInterval = 1;
    
    //4、 开始采样
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        CMRotationRate rotationRate = gyroData.rotationRate;
        NSLog(@"%f",rotationRate.x);
    }];
}


#pragma mark: 从iOS4开始：CoreMotion.framework
- (void)pushAcceleromater{
    
    //1. 创建运动管理器
    self.motionManager = [CMMotionManager new];
    
    //2. 判断是否可用
    if (![self.motionManager isAccelerometerAvailable]) {
        NSLog(@"加速计不可用");
        return;
    }
    
    //3. 设置采样间隔
    self.motionManager.accelerometerUpdateInterval = 1;
    
    //4. 开始采样
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) return;
        
        CMAcceleration acceleraion = accelerometerData.acceleration;
//        NSLog(@"%f, %f, %f", acceleraion.x, acceleraion.y, acceleraion.z);
        NSLog(@"%@",accelerometerData);
    }];

}

- (void)pullAccelerometer{
    //1. 创建运动管理器
    self.motionManager = [CMMotionManager new];
    
    //2. 判断是否可用
    if (![self.motionManager isAccelerometerAvailable]) {
        NSLog(@"加速计不可用");
        return;
    }
    
    //3. . 开始采样
    [self.motionManager startAccelerometerUpdates];
}


#pragma mark:运动管理器实现 磁力计
- (void)magneticDemo{
    //1、创建运动管理器
    self.motionManager = [[CMMotionManager alloc] init];
    
    //2、判断是否可用
    if (![self.motionManager isMagnetometerAvailable]) {
        NSLog(@"磁力计 不可用");
        return;
    }
    
    //3、设置 采样 间隔
    self.motionManager.magnetometerUpdateInterval = 1;
    
    //4、开始采样
    [self.motionManager  startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        CMMagneticField  magneticFileld = magnetometerData.magneticField;
        NSLog(@"%f, %f, %f", magneticFileld.x, magneticFileld.y, magneticFileld.z);
        
    }];
}


#pragma mark: 实现摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇一摇");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
     NSLog(@"%s",__func__);
}


#pragma mark  UIAccelerometer 加速计的使用 ，使用真机 ，实现小球的运动

/*在iOS4以前：使用UIAccelerometer，用法非常简单（到了iOS5就已经过期）

*/
- (void)accelerometerDemo{
    
    //1、获取单例对象
   UIAccelerometer *accelerometer  = [UIAccelerometer sharedAccelerometer];
    
    //2、设置代理
    accelerometer.delegate = self;
    
    //3、设置采样间隔
    accelerometer.updateInterval = 1/30.0;
    
}

#pragma mark: 加速计的代理方法
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
