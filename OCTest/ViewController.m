//
//  ViewController.m
//  OCTest
//
//  Created by lili on 2020/4/27.
//  Copyright © 2020 LILI. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  1、  iOS中url的特殊字符的转换
    NSString *urlString=[NSString stringWithFormat:@"http://www.baidu.com/?param=%@",@"中文http://dd.com"];
    
    urlString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    
    NSMutableCharacterSet *charset = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [charset removeCharactersInString:@"?:;/=&"];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:charset];
    
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSLog(@"%@",urlString);
    
//  2、 获取系统音量并实时监测音量变化
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    CGFloat volume =  [[AVAudioSession sharedInstance] outputVolume];
    NSLog(@"系统音量%f",volume);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeDidChangeNoti:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

-(void)systemVolumeDidChangeNoti:(NSNotification* )notifi{
    NSString * style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
       CGFloat value = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
       if ([style isEqualToString:@"Ringtone"]) {
           NSLog(@"铃声改变");
       }else if ([style isEqualToString:@"Audio/Video"]){
           NSLog(@"音量改变 当前值:%f",value);
       }
   
}

@end
