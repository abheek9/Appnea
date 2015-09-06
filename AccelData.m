//
//  AccelData.m
//  GyrosAndAccelerometers
//
//  Created by Meredith Margulies on 9/5/15.
//  Copyright © 2015 Joe Hoffman. All rights reserved.
//

#import "AccelData.h"

@implementation AccelData



- (NSString *)description {
    NSString *superDescription = [super description];
    NSString *description = [NSString stringWithFormat:@"yCoord: %.5f", self.yCoord];
    description = [superDescription stringByAppendingString:description];
    
    return description;
}

@end
