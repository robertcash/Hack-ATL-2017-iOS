//
//  NSDate+TimeFormatting.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeFormatting)

-(NSString *)createTimestamp;
-(NSString *)formattedDateString;
-(NSString *)formattedTimeString;
-(NSString *)formalDateString;

@end
