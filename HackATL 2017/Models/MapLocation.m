//
//  MapLocation.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/6/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

-(instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if(self) {
        _name = data[@"name"];
        _info = data[@"info"];
    }
    return self;
}

@end
