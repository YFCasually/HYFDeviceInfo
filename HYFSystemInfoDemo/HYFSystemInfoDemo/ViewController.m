//
//  ViewController.m
//  HYFSystemInfoDemo
//
//  Created by betop on 2016/11/05.
//  Copyright © 2016年 HYF. All rights reserved.
//

#import "ViewController.h"
#import "HYFSystemInfo/HYFSystemInfo.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *infoTableview;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *messageViewsArray;


@end

@implementation ViewController
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"获取当前时间戳", @"系统当前时间", @"应用名称",
                      @"应用版本号", @"系统版本号", @"系统名称",
                      @"系统使用语言", @"手机型号", @"设备类型(详细)",
                      @"电池充电状态", @"总内存大小", @"手机可用内存", @"总磁盘容量",
                      @"已用磁盘空间", @"可用磁盘空间", @"广告位标识符",
                      @"唯一设备id", @"所在国家", @"运营商",
                      @"mcc",@"mnc", @"设备ip", @"网络类型",
                      @"本地WiFi地址", @"WiFi名称", @"是否越狱" , nil];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageViewsArray = [NSMutableArray array];
}




#pragma mark - table view dataSource
//返回多少组的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//返回多少行的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//每一行的具体数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedInfo = @"";
    if (indexPath.row == 0 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%.0f",self.dataArray[indexPath.row], [HYFSystemInfo getAppLaunchedCurrentTimestamp]];
    } else if (indexPath.row == 1 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAppTimestampString]];
    } else if (indexPath.row == 2 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAppDisplayName]];
    } else if (indexPath.row == 3 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAppVersion]];
    } else if (indexPath.row == 4 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:iOS %@",self.dataArray[indexPath.row], [HYFSystemInfo getPhoneSystemVersion]];
    } else if (indexPath.row == 5 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getPhoneSystemName]];
    } else if (indexPath.row == 6 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getSystemPreferredLanguage]];
    } else if (indexPath.row == 7 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getPhoneModel]];
    } else if (indexPath.row == 8 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getDeviceName]];
    } else if (indexPath.row == 9 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row],
                        [[HYFSystemInfo getBatteryState] isEqualToString:@"UIDeviceBatteryStateUnknown"] ? @"未检测到" : [[HYFSystemInfo getBatteryState] isEqualToString:@"UIDeviceBatteryStateUnplugged"] ? @"未连接电源:正常使用" : [[HYFSystemInfo getBatteryState] isEqualToString:@"UIDeviceBatteryStateCharging"] ? @"充电中" : [[HYFSystemInfo getBatteryState] isEqualToString:@"UIDeviceBatteryStateFull"] ? @"已连接电源:已充满" : @"未检测到"];
    } else if (indexPath.row == 10 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getTotalMemorySizeString]];
    } else if (indexPath.row == 11 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAvailableMemorySizeString]];
    } else if (indexPath.row == 12 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getTotalDiskSizeString]];
    } else if (indexPath.row == 13 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getUserDiskSizeString]];
    } else if (indexPath.row == 14 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAvailableDiskSizeString]];
    } else if (indexPath.row == 15 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getAdvertisingIdentifier]];
    } else if (indexPath.row == 16 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getIdentifierForVendor]];
    } else if (indexPath.row == 17 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getLocalCountryCode]];
    } else if (indexPath.row == 18 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getTelephonyCarrier]];
    } else if (indexPath.row == 19 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getMobileCountryCode]];
    } else if (indexPath.row == 20 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getMobileNetworkCode]];
    } else if (indexPath.row == 21 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getDeviceIpAddress]];
    } else if (indexPath.row == 22 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getNetworkType]];
    } else if (indexPath.row == 23 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getLocalWifiIpAddress]];
    } else if (indexPath.row == 24 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%@",self.dataArray[indexPath.row], [HYFSystemInfo getWifiName]];
    } else if (indexPath.row == 25 ) {
        selectedInfo = [NSString stringWithFormat:@"%@:%@",self.dataArray[indexPath.row], [HYFSystemInfo getJailbrokenDevice] ? @"已越狱" : @"未越狱"];
    } else if (indexPath.row == 26 ) {
        selectedInfo = [NSString stringWithFormat:@"%@为:%.0f",self.dataArray[indexPath.row], [HYFSystemInfo getBrightness]];
    }
    
    [self showMessage:selectedInfo alpha:1.0];
    
}

- (void)showMessage:(NSString *)message alpha:(CGFloat)alpha{
    if (message.length<=0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        __block UIView *showview =  [[UIView alloc]init];
        showview.backgroundColor = [UIColor blackColor];
        showview.layer.cornerRadius = 5.0f;
        showview.layer.masksToBounds = YES;
        showview.userInteractionEnabled = NO;
        showview.alpha = alpha;
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.text = message;
        if ([message rangeOfString:@"!!!"].location == NSNotFound) {
            label.textColor = [UIColor whiteColor];
        } else {
            label.textColor = [UIColor redColor];
        }
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = 1;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize LabelSize = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 999) options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
        
        CGFloat showViewWidth = LabelSize.width+20;
        CGFloat showViewHeight = LabelSize.height+10;
        
        showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - showViewWidth) * 0.5, ([UIScreen mainScreen].bounds.size.height - showViewHeight) * 0.5 - 18 , showViewWidth, showViewHeight);
        
        [showview addSubview:label];
        [window addSubview:showview];
        [UIView animateWithDuration:3.0 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
            [self.messageViewsArray removeObject:showview];
            showview = nil;
        }];
        
        for (UIView *messageView in self.messageViewsArray) {
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.2 options:!UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect origFrame = messageView.frame;
                messageView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y - (showViewHeight + 8), origFrame.size.width, origFrame.size.height);
            } completion:^(BOOL finished) {}];
        }
        [self.messageViewsArray addObject:showview];
        if (self.messageViewsArray.count > 3) {
            UIView *firstView = self.messageViewsArray[0];
            [firstView removeFromSuperview];
            firstView = nil;
            [self.messageViewsArray removeObjectAtIndex:0];
        }
    });
}

@end
