//
//  HYFSystemInfo.h
//  HYFSystemInfoDemo
//
//  Created by betop on 2016/11/05.
//  Copyright © 2016年 HYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYFSystemInfo : NSObject
/**
 获取当前时间戳
 @return 返回当前时间戳
 */
+ (NSTimeInterval)getAppLaunchedCurrentTimestamp;

/**
 系统当前时间
 
 @return 当前时间:yyyy-MM-dd HH:mm
 */
+ (NSString *)getAppTimestampString;
/**
 应用名称
 
 @return 应用名称
 */
+ (NSString *)getAppDisplayName;

/**
 应用版本号
 
 @return 应用版本号
 */
+ (NSString *)getAppVersion;

/**
 系统版本号
 
 @return 系统版本号
 */
+ (NSString *)getPhoneSystemVersion;

/**
 系统名称
 
 @return 系统名称
 */
+ (NSString *)getPhoneSystemName;

/**
 系统使用语言
 
 @return 系统使用语言
 */
+ (NSString *)getSystemPreferredLanguage;

/**
 设备型号
 
 @return 手机型号
 */
+ (NSString *)getPhoneModel;

/**
 设备类型
 
 @return 设备类型(详细)
 */
+ (NSString *)getDeviceName;

/**
 电池状态
 
 @return 返回电池当前状态
 */
+ (NSString *)getBatteryState;
/**
 
 总内存大小
 
 @return 总内存大小
 */
+ (long long)getTotalMemorySize;

+ (NSString *)getTotalMemorySizeString;
/**
 手机可用内存
 
 @return  手机可用内存
 */
+ (long long)getAvailableMemorySize;
+ (NSString *)getAvailableMemorySizeString;
/**
 总磁盘容量
 
 @return 总磁盘容量
 */
+ (long long)getTotalDiskSize;
+ (NSString *)getTotalDiskSizeString;


/**
 已用空间
 
 @return 已用空间
 */
+ (NSString *)getUserDiskSizeString;

/**
 可用磁盘空间
 
 @return 可用磁盘空间
 */
+ (long long)getAvailableDiskSize;
+ (NSString *)getAvailableDiskSizeString;

// 广告位标识符
+ (NSString *)getAdvertisingIdentifier;

//由数字和字母组成的用来标识唯一设备的字符串
+ (NSString *)getIdentifierForVendor;

/**
 所在国家
 
 @return 所在国家
 */
+ (NSString *)getLocalCountryCode;
/**
 运营商
 
 @return 运营商
 */
+ (NSString *)getTelephonyCarrier;


/**
 mcc
 
 @return mcc
 */
+ (NSString *)getMobileCountryCode;

/**
 mnc
 
 @return mnc
 */
+ (NSString *)getMobileNetworkCode;

/**
 设备ip
 
 @return 设备ip
 */
+ (NSString *)getDeviceIpAddress;
/**
 网络类型
 
 @return 返回网络类型
 */
+ (NSString *)getNetworkType;
/**
 本地WiFi地址
 
 @return 本地WiFi地址
 */
+ (NSString *)getLocalWifiIpAddress;

/**
 WiFi名称
 
 @return  WiFi名称
 */
+ (NSString *)getWifiName;

/**
 是否越狱
 
 @return yes/no
 */
+ (BOOL)getJailbrokenDevice;

/**
 屏幕亮度
 
 @return 屏幕亮度
 */
+ (CGFloat)getBrightness;




@end


NS_INLINE NSDictionary * appInfoDictionary (void){
    
    return [[NSBundle mainBundle] infoDictionary];
}

NS_INLINE UIDevice * currentDevice (void){
    
    return [UIDevice currentDevice];
}


