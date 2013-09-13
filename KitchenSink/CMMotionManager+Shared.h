//
//  CMMotionManager+Shared.h
//  KitchenSink
//
//  Created by Josh Bruce on 13/09/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager;

@end