//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 维奕 on 2017/8/21.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "Persion.h"

@interface ViewController ()

@property(strong,nonatomic)Persion *persion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self demo1];//RAC创建
    
    [self demo2];//链式
    
    [self demo3];//KVO
   
    [self demo4];//按钮
    
    [self demo5];//输入框
    
    [self demo6];//通知
    
    [self demo7];
    
}

-(void)demo7{
    
    //按钮  addTarget
    __weak typeof(self)__weakSelf=self;
    [[self.Btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        __weakSelf.TextF.text=@"请输入";
    }];
    
}

-(void)demo6{
    
  //通知  退到后台
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        //退到后台 清空缓存
        NSLog(@"%@",x);
    }];
    
}

-(void)demo5{
   //delegate 实时监听文本框
    [[self.TextF rac_textSignal]subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

}

-(void)demo4{

    //按钮  addTarget
    [[self.Btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        UIButton *bb=x;
        bb.backgroundColor=[UIColor redColor];
    }];
    
}

//KVO
-(void)demo3{
    //KVO
    self.persion=[[Persion alloc]init];
    //
    [RACObserve(self.persion, name) subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
        self.Lab.text=x;
        
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.persion.name=[NSString stringWithFormat:@"%u",arc4random_uniform(100)];//随机数
}

-(void)demo1{

    //创建信号  订阅信号  发送信号
    
    //创建信号
    RACSignal  *single=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"我创建了信号");
        //发送信号
        [subscriber sendNext:@"this is RAC"];
        
        NSLog(@"我发送了信号");
        
        return nil;//返回空
    }];
    
    //订阅信号
    [single subscribeNext:^(id x) {
        //信号内容  内部执行代码块 执行后才执行发送信号
        NSLog(@"%@",x);
        NSLog(@"我订阅了信号");
    }];

}

-(void)demo2{
    //链式编程 原理同demo1
    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"链式编程发送信号"];
        return nil;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
