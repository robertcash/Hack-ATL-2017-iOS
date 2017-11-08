//
//  MapLocation.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/6/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapLocation : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)data;

@property NSString *name;
@property NSString *info;

@end
