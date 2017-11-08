//
//  Info.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/10/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)data;

@property NSString *title;
@property NSString *imageUrl;
@property NSString *content;

@end
