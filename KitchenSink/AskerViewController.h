//
//  AskerViewController.h
//  KitchenSink
//
//  Created by Josh Bruce on 13/09/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskerViewController : UIViewController

@property (nonatomic, strong) NSString *question;
@property (nonatomic, readonly) NSString *answer;

@end