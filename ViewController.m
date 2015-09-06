//
//  ViewController.m
//  GyrosAndAccelerometers


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
	// Do any additional setup after loading the view
    
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Press Me" forState:UIControlStateNormal];
    [button sizeToFit];
    
    
    // Set a new (x,y) point for the button's center
    button.center = CGPointMake(320/2, 60);
    
    
    // Add an action in current code file (i.e. target)
    [button addTarget:self action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button];
    */
    
    //MOST RECENT
    /*
    self.data = [NSMutableArray array];
    self.sdArray = [NSMutableArray array];
    self.sigmas = [NSMutableArray array];
    //sd = 0;
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
    
    */
    
    //MOST RECENT
    
}

/*
- (void)buttonPressed:(UIButton *)button {
    NSLog(@"Button Pressed");
}
*/



- (IBAction)start:(id)sender{
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
    
    
    int min = (int)(counter / 5 % 60);
    int hours = (counter / 5 % 3600);
    self.time.text = [NSString stringWithFormat:@"%d hrs %d min", hours, min];
    //self.ahi.text = [NSString stringWithFormat:@"%d", apneaCounter];


}


- (IBAction)end:(id)sender{
    isEnd = true;

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
    // Dispose of any resources that can be recreated.
}
@end
