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

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)start:(id)sender;
- (IBAction)end:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *resultsView;

- (IBAction)reset:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *ahi;

//@property (weak, nonatomic) IBOutlet UILabel *ahi;

@end
