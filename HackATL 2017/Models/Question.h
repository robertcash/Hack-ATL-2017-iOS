//
//  Question.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)data;

@property NSString *question;
@property NSString *answer;
@property NSDate *questionTime;
@property NSDate *answerTime;

@end
