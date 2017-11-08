//
//  Event.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if(self) {
        _startTime = [NSDate dateWithTimeIntervalSince1970:[data[@"start_time"] integerValue]];
        _endTime = [NSDate dateWithTimeIntervalSince1970:[data[@"end_time"] integerValue]];
        _title = data[@"title"];
        _locationName = data[@"location_name"];
        _locationInfo = data[@"location_info"];
    }
    return self;
}

@end
