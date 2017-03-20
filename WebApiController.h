//
//  WebApiController.h
//  Chirag Lukhi
//
//  Created by Lanetteam on 9/9/12.
//  Copyright (c) 2012 HongYing Dev Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWebApi.h"
#import "Reachability.h"
#import "TSearchInfo.h"
#import "GlobalClass.h"


@interface WebApiController : NSObject

+ (Reachability *) checkServerConnection;
+ (void)callAPI_POST:(NSString *)apiName  andParams:(NSDictionary *)params SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

+ (void)callAPIWithImage:(NSString *)apiName WithImageParameter:(NSMutableDictionary *)Iparameter WithoutImageParameter:(NSMutableDictionary *)WIparameter SuccessCallback:(SEL)successCallback andDelegate:delegateObj ;

+ (void)callAPI_GET:(NSString *)apiName andParams:(NSDictionary *)params SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

+ (void)callAPIWithVideo:(NSString *)apiName WithImageParameter:(NSMutableDictionary *)Iparameter WithoutImageParameter:(NSMutableDictionary *)WIparameter SuccessCallback:(SEL)successCallback andDelegate:delegateObj ;

+(void) callAPI_POSTJsonData:(NSString *)apiName andParams:(NSDictionary *)params andJsonParams:(NSString *)jsonparams SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

+ (void)callAPI_POST_COUNTRY:(NSString *)apiName andParams:(NSDictionary *)params SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

@end
