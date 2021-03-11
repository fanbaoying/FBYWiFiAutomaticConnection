//
//  ViewController.m
//  FBYWiFiAutomaticConnection
//
//  Created by fanbaoying on 2019/3/5.
//  Copyright © 2019年 fby. All rights reserved.
//

#import "ViewController.h"

#import <NetworkExtension/NetworkExtension.h>
#import "SpeedController.h"
#import "NSString+NormalMethod.h"
#import "SignalView.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@property(strong, nonatomic)UITextField *wifiName;
@property(strong, nonatomic)UITextField *wifiPassword;

@property(strong,nonatomic)UIView *addWiFiView;
@property(strong,nonatomic)UIView *WiFiListView;
@property(strong,nonatomic)UIView *WiFiSpeedView;

@property(strong,nonatomic)UIButton *addWiFiBtn;
@property(strong,nonatomic)UIButton *WiFiListBtn;
@property(strong,nonatomic)UIButton *WiFiSpeedBtn;

@property(strong,nonatomic)UITextView *WiFiListTextView;

//表盘view
@property (nonatomic,strong) UIView * dialView;
@property (nonatomic,strong) UIImageView * diaImageView;
//指针imageView
@property (nonatomic,strong) UIImageView * pointImageView;

//参数view
@property (nonatomic,strong) UIView * parameterView;

@property (nonatomic,strong) CALayer * pointLayer;
//信号强度
@property (nonatomic,assign) float signalStrength;
//信号强度label
@property (nonatomic,strong) UILabel * signalStrengthLabel;
//上行速度label
@property (nonatomic,strong) UILabel * upstreamSpeedLabel;
//上行速度
@property (nonatomic,assign) float upstreamSpeed;
//下行速度label
@property (nonatomic,strong) UILabel * downstreamSpeedLabel;
//上传开始时间
@property (nonatomic,strong) NSDate * uploadStartTime;
//网络情况label
@property (nonatomic,strong) UILabel * internetLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [self addwifi];
    [self WiFiList];
    [self WiFiSpeed];
    
    [self.WiFiSpeedView addSubview:self.dialView];
    [self.WiFiSpeedView addSubview:self.parameterView];
    
    self.signalStrength = 0;
    self.upstreamSpeed = 0;
    
}
- (void)addwifi {
    
    self.addWiFiView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 90)];
    [self.view addSubview:_addWiFiView];
    
    self.wifiName = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2-30, 40)];
    self.wifiName.backgroundColor = [UIColor whiteColor];
    self.wifiName.placeholder = @"请输入Wi-Fi名称";
    [self.addWiFiView addSubview:_wifiName];
    
    self.wifiPassword = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, 0, SCREEN_WIDTH/2-30, 40)];
    self.wifiPassword.backgroundColor = [UIColor whiteColor];
    self.wifiPassword.placeholder = @"请输入Wi-Fi密码";
    [self.addWiFiView addSubview:_wifiPassword];
    
    self.addWiFiBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 50, SCREEN_WIDTH-160, 40)];
    [self.addWiFiBtn addTarget:self action:@selector(addWiFiBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.addWiFiBtn setTitle:@"加入wifi" forState:0];
    self.addWiFiBtn.backgroundColor = [UIColor colorWithRed:177/255.0 green:216/255.0 blue:92/255.0 alpha:1];
    [self.addWiFiView addSubview:_addWiFiBtn];
}

- (void)WiFiList {
    self.WiFiListView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT/3-20)];
    [self.view addSubview:_WiFiListView];
    
    self.WiFiListBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-160, 40)];
    [self.WiFiListBtn addTarget:self action:@selector(WiFiListBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.WiFiListBtn setTitle:@"wifi列表" forState:0];
    self.WiFiListBtn.backgroundColor = [UIColor colorWithRed:177/255.0 green:216/255.0 blue:92/255.0 alpha:1];
    [self.WiFiListView addSubview:_WiFiListBtn];
//    e5e5e5
    self.WiFiListTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 45, SCREEN_WIDTH-20, SCREEN_HEIGHT/3-60)];
    self.WiFiListTextView.backgroundColor = [UIColor whiteColor];
    [self.WiFiListView addSubview:_WiFiListTextView];
    
}

- (void)WiFiSpeed {
    self.WiFiSpeedView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3 + 120, SCREEN_WIDTH, SCREEN_HEIGHT*2/3 - 120)];
    [self.view addSubview:_WiFiSpeedView];
    
    self.WiFiSpeedBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH-160, 40)];
    [self.WiFiSpeedBtn addTarget:self action:@selector(WiFiSpeedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.WiFiSpeedBtn setTitle:@"开始测速" forState:0];
    self.WiFiSpeedBtn.backgroundColor = [UIColor colorWithRed:177/255.0 green:216/255.0 blue:92/255.0 alpha:1];
    [self.WiFiSpeedView addSubview:_WiFiSpeedBtn];
}

-(UIView *)dialView{
    
    if (!_dialView) {
        
        _dialView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 136)];
        
        UIImageView * firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.tiff"]];
        firstImageView.frame = CGRectMake((CGRectGetWidth(_dialView.frame) - 240) / 2, 0, 240, 136);
        [_dialView addSubview:firstImageView];
        self.diaImageView = firstImageView;
        
        UIImageView * secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer.tiff"]];
        secondImageView.frame = CGRectMake(firstImageView.center.x - 72, CGRectGetMaxY(firstImageView.frame) - 24, 81, 18);
        [_dialView addSubview:secondImageView];
        self.pointImageView = secondImageView;
        /*
         设置锚点（以视图上的哪一点为旋转中心，（0，0）是左下角，（1，1）是右上角，（0.5，0.5）是中心）
         (0.5,roate)就是指针底部圆的圆心位置，我们旋转就是按照这个位置在旋转
         */
        CGRect oldFrame = secondImageView.frame;
        secondImageView.layer.anchorPoint = CGPointMake(0.9, 0.5);
        secondImageView.frame = oldFrame;
    }
    return _dialView;
}

//开始测速的响应
-(void)WiFiSpeedBtn:(UIButton *)sender {
    
    //获取信号强度
    [SpeedController getSignalStrength:^(float signalStrength) {
        
        self.signalStrength = signalStrength;
        //旋转最大值
        float maxSignalStrength = 172.0 / 180.0;
        if (self.signalStrength >= maxSignalStrength) {
            
            [self updateWeightx:maxSignalStrength];
        }
        else{
            
            [self updateWeightx:self.signalStrength];
        }
        
        NSUInteger signal = self.signalStrength * 100;
        NSString * signalStrengthStr = [[NSString alloc] initWithFormat:@"%ld%@",signal,@"%"];
        self.signalStrengthLabel.text = signalStrengthStr;
    }];
    
    //获取上行下行速度
    [[SpeedController sharedManager] getDownstreamSpeedAndUpstreamSpeed:^(float downstreamSpeed, float upstreamSpeed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.upstreamSpeed = upstreamSpeed;
            self.downstreamSpeedLabel.text = [[NSString alloc] initWithFormat:@"%.2f MB/S",downstreamSpeed];
            self.upstreamSpeedLabel.text = [[NSString alloc] initWithFormat:@"%.2f MB/S",upstreamSpeed];
        });
    }];
}

- (void)WiFiListBtn:(UIButton *)sender {
    self.WiFiListTextView.text = @"";
    [[NEHotspotConfigurationManager sharedManager] getConfiguredSSIDsWithCompletionHandler:^(NSArray<NSString *> * array) {
        for (NSString * str in array) {
            self.WiFiListTextView.text = [NSString stringWithFormat:@"%@\n%@",self.WiFiListTextView.text,str];
            NSLog(@"加入过的WiFi：%@",str);
        }
    }];
}

- (void)addWiFiBtn:(UIButton *)sender {
    if (@available(iOS 11.0, *)) {
//        Wi-Fi无密码
//        NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:@"Deli_L1050ADNW_1B0000"];
//        Wi-Fi有密码
        if ([self.wifiName.text isEqual:@""] && [self.wifiPassword.text isEqual:@""]) {
            [self message:@"请输入Wi-Fi名称或密码"];
            return;
        }
        NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc]initWithSSID:_wifiName.text passphrase:_wifiPassword.text isWEP:NO];
        // 开始连接 (调用此方法后系统会自动弹窗确认)
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            NSLog(@"%@",error);
            if (error && error.code != 13 && error.code != 7) {
                [self message:@"加入失败"];
            }else if(error.code ==7){//error code = 7 ：用户点击了弹框取消按钮
                NSLog(@"已取消");
                [self message:@"已取消"];
            }else{// error code = 13 ：已连接
                [self message:@"已连接"];
                NSLog(@"已连接");
            }

        }];
        
    } else {
        // iOS11以下版本逻辑
    }

}

-(UIView *)parameterView{
    
    if (!_parameterView) {
        
        _parameterView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dialView.frame) + 10, SCREEN_WIDTH, 140)];
        
        NSString * forthStr = @"摄像机网络环境检测";
        float forthWidth = [NSString textWidthWithText:forthStr font:[UIFont boldSystemFontOfSize:18.0] inHeight:22.0];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, forthWidth, 22.0)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = forthStr;
        [_parameterView addSubview:titleLabel];
        
        float width = [SignalView viewWidthWithStr:@"信号强度"];
        
        //间隔宽度
        float interval = (SCREEN_WIDTH - width * 3) / 4;
        
        
        SignalView * signalView = [[SignalView alloc] initWithFrame:CGRectMake(interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 44) andImageName:@"signal_def.tiff" andTitle:@"信号强度" andData:@"0"];
        [_parameterView addSubview:signalView];
        self.signalStrengthLabel = signalView.dataLabel;
        
        SignalView * upstreamSpeedView = [[SignalView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(signalView.frame) + interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 44) andImageName:@"Upload_def.tiff" andTitle:@"上行速度" andData:@"0 MB/S"];
        [_parameterView addSubview:upstreamSpeedView];
        self.upstreamSpeedLabel = upstreamSpeedView.dataLabel;
        
        SignalView * downstreamSpeedView = [[SignalView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(upstreamSpeedView.frame) + interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 44) andImageName:@"download_def.tiff" andTitle:@"下行速度" andData:@"0 MB/S"];
        [_parameterView addSubview:downstreamSpeedView];
        self.downstreamSpeedLabel = downstreamSpeedView.dataLabel;
        
    }
    return _parameterView;
}

//旋转指针
- (void)updateWeightx:(CGFloat)weight {
    CGFloat angle = M_PI * weight;
    
    [UIView animateWithDuration:2 animations:^{
        self.pointImageView.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.5];
}
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
