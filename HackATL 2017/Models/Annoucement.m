//
//  Annoucement.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "Annoucement.h"

@implementation Annoucement

-(instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.sender = data[@"sender"];
        self.content = data[@"content"];
        self.timeSent = [NSDate dateWithTimeIntervalSince1970:[data[@"sent_time"] integerValue]];
    }
    return self;
}

@end
