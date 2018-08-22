# HYFDeviceInfo
对iOS设备的采集包括移动信号国家码所属运营商系统版本号系统时间手机系统剩余空间电池电量是否越狱IDFV手机屏幕亮度系统语言IDFA存储容量手机型号app名称启动时间wifi名称DNS网络连接方式等等

＃进口“HYFSystemInfo.h”
直接调用对应的方法即可

例如
获取系统当前时间：[HYFSystemInfo getAppTimestampString]
获取本机的wifi地址:[HYFSystemInfo getLocalWifiIpAddress]
获取越狱状态:[HYFSystemInfo getJailbrokenDevice]

具体使用可运行demo


