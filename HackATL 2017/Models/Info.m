//
//  Info.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/10/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "Info.h"

@implementation Info

-(instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if(self) {
        _title = data[@"title"];
        if ([NSNull null] != [data objectForKey:@"image_url"]) {
            _imageUrl = data[@"image_url"];
        }
        else {
            _imageUrl = nil;
        }
        _content = data[@"content"];
    }
    return self;
}

@end
