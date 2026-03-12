#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <stdlib.h>
#include "../sketchybar.h"

char g_event_name[256];

extern void *MRMediaRemoteGetLocalOrigin(void);
extern void MRMediaRemoteRegisterForNowPlayingNotifications(void *origin);

void media_changed(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // 增加调试日志（可选，可在终端查看 sketchybar 输出）
    // printf("Media notification received: %s\n", CFStringGetCStringPtr(name, kCFStringEncodingUTF8));

    char event_message[512];
    snprintf(event_message, sizeof(event_message), "--trigger %s", g_event_name);
    sketchybar(event_message);
}

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Usage: %s <event_name>\n", argv[0]);
        return 1;
    }

    snprintf(g_event_name, sizeof(g_event_name), "%s", argv[1]);

    // 1. 注册 MediaRemote (私有 API)
    MRMediaRemoteRegisterForNowPlayingNotifications(MRMediaRemoteGetLocalOrigin());

    // 2. 获取本地通知中心 (用于接收 MediaRemote 代理的通知)
    CFNotificationCenterRef local_center = CFNotificationCenterGetLocalCenter();

    // 3. 获取分布式通知中心 (用于接收 App 级的启动/状态变更通知)
    CFNotificationCenterRef dist_center = CFNotificationCenterGetDistributedCenter();

    // 监听：媒体信息/状态变更
    CFNotificationCenterAddObserver(local_center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingApplicationDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(local_center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingInfoDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(local_center, NULL, media_changed, CFSTR("kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    // 监听：特定 App 的分布式通知 (Music/Spotify 重新打开时的唤醒信号)
    if (dist_center)
    {
        CFNotificationCenterAddObserver(dist_center, NULL, media_changed, CFSTR("com.apple.Music.playerInfo"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(dist_center, NULL, media_changed, CFSTR("com.spotify.client.PlaybackStateChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }

    CFRunLoopRun();
    return 0;
}
