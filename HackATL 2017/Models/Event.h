//
//  Event.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)data;

@property NSDate *startTime;
@property NSDate *endTime;
@property NSString *title;
@property NSString *locationName;
@property NSString *locationInfo;

@end
