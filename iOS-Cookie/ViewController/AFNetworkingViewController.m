//
//  AFNetworkingViewController.m
//  iOS-Cookie
//
//  Created by Jakey on 2016/12/7.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "AFNetworkingViewController.h"
#import "AFNetworking.h"
@interface AFNetworkingViewController ()

@end

@implementation AFNetworkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.初始化单例类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    // 2.设置证书模式
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"cert"ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData,nil]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.securityPolicy.validatesDomainName = YES;//不验证证书的域名
    //manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;//不验证证书的域名
//    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"appid":@"110020800010002",@"termid":@"00000001",@"systype":@"2"}];
    
    //[dic setObject:@"110020800010004" forKey:@"appid"];
    //[dic setObject:@"00000001" forKey:@"termid"];
    //[dic setObject:@"2" forKey:@"systype"];
    
    [dic setObject:@"13883737663" forKey:@"phone"];
    [dic setObject:@"123456" forKey:@"captcha"];
    [dic setObject:@"e87eed0e17d0776950d7447568079b49" forKey:@"sign"];
    
    
    
    [manager POST:@"https://www.dzkjpay.com/mkapp/app/login.shtml" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    //[manager GET:@"https://www.dzkjpay.com/mkapp/app/getSignKey.shtml" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        NSArray *cookies2 = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies2) {
            NSLog(@"cookie,name:= %@,valuie = %@",cookie.name,cookie.value);
        }
        
        //[self saveCookies];
        //[self loadCookies];
        
        NSLog(@"\n======================================\n");
        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
        NSLog(@"fields = %@",[fields description]);
        NSURL *url = [NSURL URLWithString:@"https://www.dzkjpay.com/mkapp/app/login.shtml"];
        NSLog(@"\n======================================\n");
        //获取cookie方法1
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
        for (NSHTTPCookie *cookie in cookies) {
            NSLog(@"cookie,name:= %@,valuie = %@",cookie.name,cookie.value);
        }
        
        //获取cookie方法2
        NSString *cookies3 = [((NSHTTPURLResponse*)task.response).allHeaderFields valueForKey:@"Set-Cookie"];
        NSLog(@"cookies2 = %@",cookies3);
        NSLog(@"\n======================================\n");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n======================================\n");
    }];

}

//合适的时机持久化Cookie
- (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"com.kingbom.cookiesave"];
    [defaults synchronize];
}
//合适的时机加载持久化后Cookie 一般都是app刚刚启动的时候
- (void)loadCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"com.kingbom.cookiesave"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookies){
        NSLog(@"cookie,name:= %@,valuie = %@",cookie.name,cookie.value);
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
