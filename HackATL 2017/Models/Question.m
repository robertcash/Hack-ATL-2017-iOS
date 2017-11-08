//
//  Question.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if(self) {
        _question = data[@"question"];
        _answer = data[@"answer"];
        _questionTime = [NSDate dateWithTimeIntervalSince1970:[data[@"question_time"] integerValue]];
        if ([NSNull null] != [data objectForKey:@"answer_time"]) {
            _answerTime = [NSDate dateWithTimeIntervalSince1970:[data[@"answer_time"] integerValue]];
        }
        else {
            _answerTime = nil;
        }
    }
    return self;
}

@end
