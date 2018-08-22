//
//  HYFSystemInfo.m
//  HYFSystemInfoDemo
//
//  Created by betop on 2016/11/05.
//  Copyright © 2016年 HYF. All rights reserved.
//

#import "HYFSystemInfo.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/socket.h>
#import <net/if.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>
#import <sys/mount.h>
#import <mach/vm_statistics.h>
#import <mach/message.h>
#import <mach/mach_host.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <dlfcn.h>
#import <resolv.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "sys/utsname.h"
@implementation HYFSystemInfo

+ (NSTimeInterval)getAppLaunchedCurrentTimestamp{
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    return [currentDate timeIntervalSince1970] * 1000;
    
}

+ (NSString *)getAppTimestampString{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[self class] getAppLaunchedCurrentTimestamp]/ 1000.0];
    return [formatter stringFromDate:date];
    
}

+ (NSString *)getAppDisplayName{
    
    return appInfoDictionary()[@"CFBundleDisplayName"];
}

+ (NSString *)getAppVersion{
    
    return appInfoDictionary()[@"CFBundleShortVersionString"];
}

+ (NSString *)getPhoneSystemVersion{
    
    return [currentDevice() systemVersion];
    
}

+ (NSString *)getPhoneSystemName{
    
    return [currentDevice() systemName];
}

+ (NSString *)getSystemPreferredLanguage{
    
    return [NSLocale preferredLanguages][0];
    
}

+ (NSString *)getPhoneModel{
    
    return [currentDevice() model];
}

+ (NSString *)getAdvertisingIdentifier{
    
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
}

+ (NSString *)getIdentifierForVendor{
    return [[currentDevice() identifierForVendor] UUIDString];
}

+ (NSString *)getTelephonyCarrier{
    
    CTTelephonyNetworkInfo * networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return @"没有SIM卡--无运营商";
    }
    
    return [carrier carrierName];
    
}

+ (NSString *)getMobileCountryCode{
    
    CTTelephonyNetworkInfo * networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return @"没有SIM卡--无运营商";
    }
    
    return [carrier mobileCountryCode];
    
}

+ (NSString *)getMobileNetworkCode{
    
    CTTelephonyNetworkInfo * networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return @"没有SIM卡--无运营商";
    }
    
    return [carrier mobileNetworkCode];
    
}

// 获取电池当前的状态，共有4种状态
+ (NSString *)getBatteryState {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return @"UIDeviceBatteryStateUnknown";
    }else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return @"UIDeviceBatteryStateUnplugged";
    }else if (device.batteryState == UIDeviceBatteryStateCharging){
        if (device.batteryLevel == 1.0) {
            return @"UIDeviceBatteryStateFull";
        }
        return @"UIDeviceBatteryStateCharging";
    }else if (device.batteryState == UIDeviceBatteryStateFull){
        return @"UIDeviceBatteryStateFull";
    } else {
        return @"uunkonw";
    }

}

+ (NSString *)getDeviceIpAddress{
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
    
}

+ (NSString *)getLocalWifiIpAddress{
    
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
    
}

+ (NSString *)getWifiName{
    
    NSString *wifiName = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            wifiName = [dict valueForKey:@"SSID"];
            
        }
    }
    
    return wifiName;
}

+ (long long)getTotalMemorySize{
    
    return [[NSProcessInfo processInfo] physicalMemory];
    
}
+(NSString *)getTotalMemorySizeString{
    
    return [self fileSizeToString:[self getTotalMemorySize]];
    
}

+ (long long)getAvailableMemorySize{
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

+(NSString *)getAvailableMemorySizeString{
    
    return [self fileSizeToString:[self getAvailableMemorySize]];
}

+ (long long)getTotalDiskSize{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
    
}

+(NSString *)getTotalDiskSizeString{
    
    return [self fileSizeToString:[self getTotalDiskSize]];
}

+ (long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
    
}
+ (NSString *)getAvailableDiskSizeString{
    
    return [self fileSizeToString:[self getAvailableDiskSize]];
}

+ (BOOL)getJailbrokenDevice{
    
    BOOL jailbroken = NO;
    NSString * cydiaPath = @"/Applications/Cydia.app";
    NSString * aptPath = @"/private/var/lib/apt";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath] || [[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

+ (CGFloat)getBrightness{
    
    return [UIScreen mainScreen].brightness;
}


+ (NSString *)getUserDiskSizeString {
    return [self fileSizeToString:([self getTotalDiskSize] - [self getAvailableDiskSize])];
}

// 获取网络类型
+ (NSString *)getNetworkType{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *netconnType = @"";
    for (id subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    netconnType = @"NONE";
                    break;
                case 1:
                    netconnType = @"2G";
                    break;
                case 2:
                    netconnType = @"3G";
                    break;
                case 3:
                    netconnType = @"4G";
                    break;
                case 5:
                    netconnType = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    if ([netconnType isEqualToString:@""]) {
        netconnType = @"NO DISPLAY";
    }
    return netconnType;
}

// 获取设备型号
+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"国行、日版、港行iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"港行、国行iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPhone9,3"]) return @"美版、台版iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,4"]) return @"美版、台版iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return deviceString;
}

+ (NSString *)getLocalCountryCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}



/**
 将空间大小转化为字符串
 
 @param fileSize 空间大小
 @return 字符串
 */
+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.0f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.0f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}

@end
