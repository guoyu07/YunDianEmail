//
//  YDHttpRequest.m
//  YunDianEmail
//
//  Created by hzk on 2017/6/2.
//  Copyright © 2017年 yundian. All rights reserved.
//

#import "YDHttpRequest.h"
#import "AFNetworking.h"
@implementation YDHttpRequest


#pragma mark - 监测网络的可链接性
+ (void)netWorkReachabilityWithURLString:(NSString *)strUrl
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable: {
//                UIAlertView *networkAlterView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用，请检查您的网络设置。"
//                                                                           message:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"好"
//                                                                 otherButtonTitles:nil, nil];
//                [networkAlterView show];
                UIAlertController *networkAlterView = [UIAlertController alertControllerWithTitle:nil message:@"当前网络不可用，请检查您的网络设置。" preferredStyle:UIAlertControllerStyleAlert];
                
                // 取消按钮
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                    
                     id rootCViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                    [rootCViewController dismissViewControllerAnimated:YES completion:nil];
                    
                }];
               
                [networkAlterView addAction:cancelAction];
                id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
               [rootViewController presentViewController:networkAlterView animated:YES completion:nil];

                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                
        }}];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)currentRequestType:(NSString *)method requestURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
        if ([method isEqualToString:@"GET"]) {
            [self get:url parameters:parameters success:success failure:failure];
        }else if([method isEqualToString:@"POST"]){
            [self post:url parameters:parameters success:success failure:failure];
        }else if ([method isEqualToString:@"LOGIN"]){
            [self login:url parameters:parameters success:success failure:failure];
    
        }
    
}

#pragma mark - GET请求
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session.requestSerializer setTimeoutInterval:30];
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    session.requestSerializer = [AFJSONRequestSerializer new];
    [session.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSString *valueString = LOGINSESSION;
//    [session.requestSerializer setValue:valueString forHTTPHeaderField:@"Cookie"];
    session.securityPolicy.allowInvalidCertificates=YES;
    //也不验证域名一致性
    
    session.securityPolicy.validatesDomainName=NO;
    
    //关闭缓存避免干扰测试
    
    session.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
 NSString *valueString = LOGINSESSION;
       [session.requestSerializer setValue:valueString forHTTPHeaderField:@"Cookie"];
    
    [session GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
         NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
//        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//        if (![dict isKindOfClass:[NSDictionary class]]) {
//            NSError *error = [NSError errorWithDomain:@"201" code:201 userInfo:nil];
//            NSLog(@"-------请求返回结果不是合理数据格式-----");
//            failure(error);
//            return ;
//        }
//        success(dict);
        
        
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            if (![dict isKindOfClass:[NSDictionary class]]) {
                NSError *error = [NSError errorWithDomain:@"201" code:201 userInfo:nil];
                NSLog(@"-------请求返回结果不是合理数据格式-----");
                failure(error);
                return ;
            }
            success(dict);
            return ;
        }
        
        success(responseObject);
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - POST请求
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session.requestSerializer setTimeoutInterval:30];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    session.requestSerializer = [AFJSONRequestSerializer new];
    [session.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];



   NSString *valueString = LOGINSESSION;
    [session.requestSerializer setValue:valueString forHTTPHeaderField:@"Cookie"];

    session.securityPolicy.allowInvalidCertificates=YES;
    
    //也不验证域名一致性
    
    session.securityPolicy.validatesDomainName=NO;
    
    //关闭缓存避免干扰测试
    
    session.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;


    
    [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            if (![dict isKindOfClass:[NSDictionary class]]) {
                NSError *error = [NSError errorWithDomain:@"201" code:201 userInfo:nil];
                NSLog(@"-------请求返回结果不是合理数据格式-----");
                failure(error);
                return ;
            }
            success(dict);
            return ;
        }

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - login请求
+ (void)login:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
   

    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
     [session.requestSerializer setTimeoutInterval:30];
    [session.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];


    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    session.securityPolicy = securityPolicy;
    
    

    
    [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (complex) {
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        }
        
//        if (complex) {
  
        
        
//        }
        
//
//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
////            NSData * data  = [NSKeyedArchiver archivedDataWithRootObject:cookie];
//            
//            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//
//            SetLOGINSESSION(data);
//        }
//        NSLog(@"%@",responseObject);
        
        
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            NSError *error = [NSError errorWithDomain:@"201" code:201 userInfo:nil];
            NSLog(@"-------请求返回结果不是合理数据格式-----");
            failure(error);
            return ;
        }
        if ([dict[@"result"] isEqualToString:@"success"]) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *responsess = (NSHTTPURLResponse *)task.response;
                NSString  * seesionss = (responsess.allHeaderFields)[@"Set-Cookie"];
                
                SetLOGINSESSION(seesionss);
                
            }
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//            SetLOGINSESSION(response.allHeaderFields[@"Set-Cookie"]);
             success(dict);
        }
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}




@end
