//
//  Annoucement.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Annoucement : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)data;

@property NSString *sender;
@property NSString *content;
@property NSDate *timeSent;

@end
