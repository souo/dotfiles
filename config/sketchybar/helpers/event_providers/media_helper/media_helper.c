#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <stdlib.h>
#include "../sketchybar.h" // 引入 sketchybar 的内部通信头文件

// 定义全局变量存储事件名称，以便在回调函数中使用
char g_event_name[256];

extern void *MRMediaRemoteGetLocalOrigin(void);
extern void MRMediaRemoteRegisterForNowPlayingNotifications(void *origin);

void media_changed(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    char event_message[512];
    // 构造发送给 sketchybar 的消息，使用空格分隔参数
    snprintf(event_message, sizeof(event_message), "--trigger %s", g_event_name);
    sketchybar(event_message);
}

int main(int argc, char** argv) {
    // 检查是否传入了 event_name 参数
    if (argc < 2) {
        printf("Usage: %s <event_name>\n", argv[0]);
        return 1;
    }

    // 将命令行参数存储到全局变量中
    snprintf(g_event_name, sizeof(g_event_name), "%s", argv[1]);

    // 注册 MediaRemote 通知
    MRMediaRemoteRegisterForNowPlayingNotifications(MRMediaRemoteGetLocalOrigin());
    CFNotificationCenterRef center = CFNotificationCenterGetLocalCenter();

    // 监听三大核心媒体事件
    CFNotificationCenterAddObserver(center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingApplicationDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingInfoDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    // 挂起进程
    CFRunLoopRun();
    
    return 0;
}