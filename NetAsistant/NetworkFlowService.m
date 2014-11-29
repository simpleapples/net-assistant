//
//  SystemService.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "NetworkFlowService.h"
#import "NetworkFlow.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

@implementation NetworkFlowService

+ (NetworkFlow *)networkFlow {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return nil;
    }
    
    int64_t iBytes     = 0;
    int64_t oBytes     = 0;
    int64_t allFlow    = 0;
    int64_t wifiIBytes = 0;
    int64_t wifiOBytes = 0;
    int64_t wifiFlow   = 0;
    int64_t wwanIBytes = 0;
    int64_t wwanOBytes = 0;
    int64_t wwanFlow   = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) {
            continue;
        }
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }
        if (ifa->ifa_data == 0) {
            continue;
        }
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    NetworkFlow *networkFlow = [[NetworkFlow alloc] initWithAllFlow:allFlow allInFlow:iBytes allOutFlow:oBytes wifiFlow:wifiIBytes wifiInFlow:wifiIBytes wifiOutFlow:wifiOBytes wwanFlow:wwanFlow wwanInFlow:wwanIBytes wwanOutFlow:wwanOBytes];
    return networkFlow;
}

@end
