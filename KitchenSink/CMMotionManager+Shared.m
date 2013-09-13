//
//  CMMotionManager+Shared.m
//  KitchenSink
//
//  Created by Josh Bruce on 13/09/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager
{
    static CMMotionManager *shared = nil;
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           shared = [[CMMotionManager alloc] init];
        });
    }
    return shared;
}

@end