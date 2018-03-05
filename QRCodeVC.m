//
//  QRCodeVC.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIViewExt.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define result_key @"results"

@interface QRCodeVC()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * _session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
    NSString *_newResult; //扫描到新结果
    NSMutableArray *_mutArr;//扫描结果
    NSMutableDictionary *_mutDic;//存放扫描结果
    
    UILabel *_resultCountLabel; //存放扫描个数
    UILabel *_resultLabel;//存放扫描的最后最新值
}

@end

@implementation QRCodeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.repeatScan = NO;
    _lastResut = YES;
    _isnull = YES;
    _mutArr = [[NSMutableArray alloc]init];
    _mutDic = [[NSMutableDictionary alloc]init];

    //扫描区域
    CGRect areaRect = CGRectMake((screen_width - 218)/2, (screen_height - 218)/2, 218, 218);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:self.view.bounds];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //是否开启闪光灯

    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, screen_height-50, 100, 30)];
    [flashBtn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(statrFlashing:) forControlEvents:UIControlEventTouchUpInside];
    flashBtn.tag = 0;
    [self.view addSubview:flashBtn];
    
    
    //完成扫描结果后返回
    UIButton *finishScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-110, screen_height-50, 100, 30)];
    [finishScanBtn setTitle:@"完成扫描" forState:UIControlStateNormal];
    [finishScanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishScanBtn addTarget:self action:@selector(overScanButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishScanBtn];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, screen_width, 46)];
    topView.backgroundColor = [UIColor colorWithRed:63.0 green:81.0 blue:181.0 alpha:0];
    [self.view addSubview:topView];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(12, 4, 42, 42);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backbutton];
    
    //手动输入
    UIButton *inputBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-100, 4, 100, 42)];
    [inputBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [inputBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputBtn addTarget:self action:@selector(inputBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:inputBtn];
    
    [self performSelectorOnMainThread:@selector(startReading) withObject:nil waitUntilDone:YES];
    
   
 
}

- (void) startReading{
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.y/screen_height, _areaView.x/screen_width, _areaView.height/screen_height, _areaView.width/screen_width);
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    //            要在addOutput之后，否则iOS10会崩溃
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [_session startRunning];
}

//手动输入结果
- (void)inputBtn{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请输入运单号:" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    //    __weak typeof(alertControl) weakAlert = alertControl;
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_mutArr addObject:[alertControl.textFields.firstObject text]];
        [self addResultToLabel:_mutArr.count result:[_mutArr lastObject]];
       
        NSLog(@"点击了确定按钮文本框--%@---%@", [alertControl.textFields.firstObject text],_mutArr);
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    
    // 添加文本框
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
//        [textField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
    
}

//- (void)usernameDidChange:(UITextField *)username
//{
//    NSLog(@"%@", username.text);
//}


//是否开启闪光灯
- (void)statrFlashing:(UIButton *)sender{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.tag == 0) {
                
                sender.tag = 1;
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                sender.tag = 0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"%s",__func__);
    [_session stopRunning];
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result = metadataObj.stringValue;
        
        //        判断是否第一次扫描
        
        if (!_lastResut) {
            if (![_newResult isEqualToString: result]) {
                _newResult = result;
              
                [_mutArr addObject:_newResult];
                [_mutDic setValue:_mutArr forKey:result_key];
             
                [_session startRunning];
                
            } else {
                NSLog(@"单号重复");
                [_session startRunning];
            }
            
        }else{
            //            第一次扫描成功
            _newResult = result;
            [_mutArr addObject:_newResult];
            [_mutDic setValue:_mutArr forKey:result_key];
            
            _lastResut = NO;
            [_session startRunning];
            
        }
         [self addResultToLabel:_mutArr.count result:_newResult];
    }

//    [self savaLocal];
   
}

- (void)addResultToLabel:(NSInteger)count result:(NSString*)result{
   
    NSInteger newCount;
    NSString *newResult;
    if (_isnull) {
        _resultCountLabel.text = @"";
        _resultLabel.text = @"";
        //扫描个数
        _resultCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screen_height-100, 80, 30)];
        _resultCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        _resultCountLabel.textAlignment = NSTextAlignmentCenter;
        _resultCountLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultCountLabel];
        
        //扫描
        _resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, screen_height-100, screen_width-110, 30)];
        _resultLabel.text = result;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultLabel];
        
        _isnull = NO;
    }else{
        
        _resultCountLabel.text = @"";
        _resultLabel.text = @"";
        
        newCount = count;
        newResult = result;
        NSLog(@"扫描个数=====%ld,扫描结果=====%@",newCount,newResult);
        //扫描个数
        _resultCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screen_height-100, 80, 30)];
        _resultCountLabel.text = [NSString stringWithFormat:@"%ld",newCount];
        _resultCountLabel.textAlignment = NSTextAlignmentCenter;
        _resultCountLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultCountLabel];
        
        
        //扫描
        _resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, screen_height-100, screen_width-110, 30)];
        _resultLabel.text = newResult;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultLabel];
        
    }
    
    
    
}
//点击返回按钮回调
-(void)overScanButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate sendOrders:[_mutArr copy]];
    
}



//保存
- (void)savaLocal{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:_mutArr forKey:result_key];
    
    [userData synchronize];
    
}

//点击返回按钮回调
-(void)clickBackButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//     [self.delegate sendOrders:[_mutArr copy]];

}

//- (void)sendData:(void(^)(NSArray *orders))block{
//    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
//    
//    block([userData objectForKey:@"results"]);
//    
//    
//}



@end
