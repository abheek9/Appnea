//
//  ViewController.m


#import "ViewController.h"
#import "AccelData.h"
#import "SdData.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *data;
@property (nonatomic) NSMutableArray *sdArray;
@property (nonatomic) NSMutableArray *sigmas;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*
* This is the method intiated when the user clicks the start button
* It changes the views in the story board appropriately and then starts
* Logging the acceleration data for the user
*/

- (IBAction)start:(id)sender{
    self.stopButton.hidden = NO;
    self.startButton.hidden = YES;
    isEnd = false;
    self.data = [NSMutableArray array];
    self.sdArray = [NSMutableArray array];
    self.sigmas = [NSMutableArray array];

    counter = 0;
    THRESHOLD = 0.01;
    apneaCounter = 0;
    isApp = false;

    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
        withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [self outputAccelertionData:accelerometerData.acceleration];
                if(error){
                    NSLog(@"hey %@", error);
                }
            }];
}


/*
* The end function is iniated when the user hits the stop button it 
* changes the view, and then logs the results to the results page
*
*/

- (IBAction)end:(id)sender{
    self.stopButton.hidden = YES;
    self.resultsView.hidden = NO;
    isEnd = true;
    self.ahi.text = [NSString stringWithFormat:@"%d", apneaCounter];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    
    AccelData *acceldata = [[AccelData alloc] init];
    acceldata.yCoord = acceleration.y;
    [self.data addObject:acceldata];
    //NSLog(@"%@", self.data);
    
    if (isEnd){
        return;
    }
    
    if (counter >=  50) {
        [self stDev];
    }
    counter++;
   

}

-(void) stDev{
    float mean = 0.0;
    float sumsq = 0.0;
    float sd = 0.0;
    for(int i = counter-49; i <= counter; i++){
        mean += [[self.data objectAtIndex:i] yCoord];
    };
    mean = mean / 50.0;
    float test = 0.0;
    for(int i = counter - 49; i <= counter; i++){
        test = [[self.data objectAtIndex:i] yCoord] - mean;
        sumsq += pow(test,2.0);
    };
    sd = sqrt((1.0/49.0) * sumsq);
    
    if(sd <= THRESHOLD && isApp == false){
        apneaCounter++;
        isApp = true;
    }
    if(sd > THRESHOLD){
        isApp = false;
    }
    
    NSLog(@"SD: %.6f Apnea Counter: %d Sumsq: %f", sd, apneaCounter,sumsq);
    
    SdData *sdData = [[SdData alloc] init];
    sdData.stdev = sd;
    [self.sdArray addObject:sdData];
    
    NSNumber *sigma = [NSNumber numberWithFloat:sd];
    [self.sigmas addObject:sigma];
    
}


-(NSString *)archivePath{
    NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = dirList.firstObject;
    return [dir stringByAppendingPathComponent:@"standardDeviations"];
}

- (void) save {
    [NSKeyedArchiver archiveRootObject:self.sigmas toFile:self.archivePath];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)reset:(id)sender {
    self.resultsView.hidden = YES;
    self.startButton.hidden = NO;
}
@end
