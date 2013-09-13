//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by Josh Bruce on 13/09/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"

@interface KitchenSinkViewController ()
@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
@property (weak, nonatomic) NSTimer *drainTimer;
@end

@implementation KitchenSinkViewController

#define DRAIN_DURATION 3.0
#define DRAIN_DELAY 1.0
#define MOVE_DURATION 3.0
#define DISH_CLEANING_INTERVAL 2.0

- (void)cleanDish
{
    if (self.kitchenSink.window) {
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISH_CLEANING_INTERVAL];
    }
}

- (void)startDrainTimer
{
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION / 3 target:self selector:@selector(drain:) userInfo:nil repeats:YES];
}

- (void)drain:(NSTimer *)timer
{
    [self drain];
}

- (void)stopDrainTimer
{
    [self.drainTimer invalidate];
    self.drainTimer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrainTimer];
    [self cleanDish];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrainTimer];
}

- (void)drain
{
    for (UIView *view in self.kitchenSink.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)) {
            [UIView animateWithDuration:DRAIN_DURATION / 3 delay:DRAIN_DELAY options:UIViewAnimationOptionCurveLinear animations:^{
                view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2 * M_PI / 3);
            } completion:^(BOOL finished) {
                if (finished) [UIView animateWithDuration:DRAIN_DURATION / 3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2 * M_PI / 3);
                } completion:^(BOOL finished) {
                    if (finished) [UIView animateWithDuration:DRAIN_DURATION / 3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                    } completion:^(BOOL finished) {
                        if (finished) [view removeFromSuperview];
                    }];
                }];
            }];
        }
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.kitchenSink];
    for (UIView * view in self.kitchenSink.subviews) {
        if (CGRectContainsPoint(view.frame, tapLocation)) {
            [UIView animateWithDuration:MOVE_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.99, 0.99);
            } completion:^(BOOL finished) {
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

#define BLUE_FOOD @"Jello"
#define GREEN_FOOD @"Broccoli"
#define ORANGE_FOOD @"Carrot"
#define RED_FOOD @"Beet"
#define PURPLE_FOOD @"Eggplant"
#define BROWN_FOOD @"Potato Peels"

- (void)addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];

    static NSDictionary *foods = nil;
    if (!foods) foods = @{ BLUE_FOOD : [UIColor blueColor],
                           GREEN_FOOD : [UIColor greenColor],
                           ORANGE_FOOD : [UIColor orangeColor],
                           RED_FOOD : [UIColor redColor],
                           PURPLE_FOOD : [UIColor purpleColor],
                           BROWN_FOOD : [UIColor brownColor] };
    if (![food length]) {
        food = [[foods allKeys] objectAtIndex:arc4random() % [foods count]];
        foodLabel.textColor = [foods objectForKey:food];
    }
    
    foodLabel.text = food;
    foodLabel.font = [UIFont systemFontOfSize:46];
    foodLabel.backgroundColor = [UIColor clearColor];
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

- (void)setRandomLocationForView:(UIView *)view
{
    [view sizeToFit];
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width / 2, view.frame.size.height / 2);
    CGFloat x = arc4random() % (int)sinkBounds.size.width + view.frame.size.width / 2;
    CGFloat y = arc4random() % (int)sinkBounds.size.height + view.frame.size.height / 2;
    view.center = CGPointMake(x, y);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"]) {
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"What food do you want in the sink?";
    }
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue
{
}

- (IBAction)doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    [self addFood:asker.answer];
}

@end