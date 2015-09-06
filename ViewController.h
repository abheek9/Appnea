//
//  ViewController.h
//  GyrosAndAccelerometers
//


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

int counter, apneaCounter;
float sd, THRESHOLD;
Boolean isApp,isEnd;

@interface ViewController : UIViewController


@property (strong, nonatomic) CMMotionManager *motionManager;


- (IBAction)start:(id)sender;
- (IBAction)end:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *time;

//@property (weak, nonatomic) IBOutlet UILabel *ahi;

@end
