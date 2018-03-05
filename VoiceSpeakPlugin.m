//
//  LocationPlugin.m
//  HBuilder-Hello
//
//  Created by admin on 16/9/26.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "VoiceSpeakPlugin.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"
// 扩展插件中需要引入需要的系统库
#import <LocalAuthentication/LocalAuthentication.h>

#import <AVFoundation/AVFoundation.h>

@interface VoiceSpeakPlugin()<AVAudioPlayerDelegate>
{
    AVSpeechSynthesizer *_synth;//语音合成器
    AVSpeechUtterance *_utterance; //语音播报
    AVSpeechSynthesisVoice *_voice;//播报声音
    
    AVAudioPlayer *_avAudioPlay;//播放音频的类，播放本地音乐

    
}
@end

@implementation VoiceSpeakPlugin

/*
 * WebApp启动时触发
 * 需要在PandoraApi.bundle/feature.plist/注册插件里添加autostart值为true，global项的值设置为true
 */
- (void) onAppStarted:(NSDictionary*)options{
    
    NSLog(@"5+ WebApp启动时触发");
    
}

// 监听基座事件事件
// 应用退出时触发
- (void) onAppTerminate{
    //
    NSLog(@"APPDelegate applicationWillTerminate 事件触发时触发");
}

// 应用进入后台时触发
- (void) onAppEnterBackground{
    
    NSLog(@"APPDelegate applicationDidEnterBackground 事件触发时触发");
}

// 应用进入前天时触发
- (void) onAppEnterForeground{
    //
    NSLog(@"APPDelegate applicationWillEnterForeground 事件触发时触发");
}

//语音报读功能
//- (void)voiceSpeakFuction:(PGMethod*)commands{
//    
//    if (commands) {
//        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
//        NSString *cbId = [commands.arguments objectAtIndex:0];
//         // 用户的参数会在第二个参数传回
//        NSString *agStr = [commands.arguments objectAtIndex:1]; //传回所要报读的文字内容
//        NSLog(@"%@",agStr);
//        [self speechContentStr:agStr];//调用语音报读
//
//        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK];
//        [self toCallback:cbId withReslut:[result toJSONString]];
//
//    }
//
//}

//实现报读功能
- (void)speechContentStr:(NSString*)str{
    NSLog(@"star");
    _utterance = [AVSpeechUtterance speechUtteranceWithString:str]; //语音播报
    _utterance.pitchMultiplier = 0.8; //音高
    
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //英式发音
    //    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
    
    _utterance.voice = _voice;
    
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    
    _synth = [[AVSpeechSynthesizer alloc]init]; //语音合成器
    [_synth speakUtterance:_utterance]; //说话
    NSLog(@"end");
}

//本地音乐播放

- (void)avAudioPlayFuction:(PGMethod*)commands{
    
    if (commands) {
        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
        NSString *cbId = [commands.arguments objectAtIndex:0];
        // 用户的参数会在第二个参数传回
        NSString *agStr = [commands.arguments objectAtIndex:1];
        NSLog(@"%@",agStr);
        if ([agStr isEqualToString:@"#"]) {
          
            NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_success" ofType:@"wav"];
            NSURL *url = [NSURL fileURLWithPath:path];
            _avAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _avAudioPlay.delegate = self;
            [_avAudioPlay play];
        } else if ([agStr isEqualToString:@"*"]){
         
            NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_failed" ofType:@"wav"];
            NSURL *url = [NSURL fileURLWithPath:path];
            _avAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _avAudioPlay.delegate = self;
            [_avAudioPlay play];
        }else{
             [self speechContentStr:agStr];//调用语音报读
        }
        
        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK];
        [self toCallback:cbId withReslut:[result toJSONString]];
        
    }
    
    
    
}

//- (void)avAudioPlayFuction:(PGMethod*)commands{
//    
//    if (commands) {
//        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
//        NSString *cbId = [commands.arguments objectAtIndex:0];
//        // 用户的参数会在第二个参数传回
//        NSString *agStr = [commands.arguments objectAtIndex:1];
//        NSLog(@"%@",agStr);
//        if ([agStr isEqualToString:@"#"]) {
//            _scan_success = @"scan_success.wav";
//        } else if ([agStr isEqualToString:@"*"]){
//            _scan_failed = @"scan_failed.wav";
//        }
//        NSArray *arr = [agStr componentsSeparatedByString:@"."];
//        NSLog(@"%@",arr);
//
//        NSString *path = [[NSBundle mainBundle] pathForResource:arr[0] ofType:arr[1]];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        _avAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//        _avAudioPlay.delegate = self;
//        [_avAudioPlay play];
//
//        
//        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK];
//        [self toCallback:cbId withReslut:[result toJSONString]];
//
//    }
//
//    
//   
//}


@end
