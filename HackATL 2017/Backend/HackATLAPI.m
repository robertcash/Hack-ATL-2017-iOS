//
//  HackATLAPI.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "HackATLAPI.h"

@implementation HackATLAPI {
    NSDictionary *headers;
}

NSString *API_URL = @"https://s7ajv7yjyc.execute-api.us-west-2.amazonaws.com/prod";

+(instancetype)sharedManager {
    static HackATLAPI *sharedManager = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        headers = @{@"Content-Type": @"application/json", @"accept": @"application/json"};
    }
    return self;
}


#pragma mark - GET


-(void)getAnnoucements:(void (^)(NSArray *annoucements, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/announcements", API_URL]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@[], YES);
            return;
        }
        
        NSMutableArray *announcements = [[NSMutableArray alloc] init];
        UNIJsonNode *body = response.body;
        for (NSDictionary *a in body.object[@"announcements"]) {
            [announcements addObject:[[Annoucement alloc] initWithDictionary:a]];
        }
        
        completionHandler(announcements, NO);
    }];
}

-(void)getSchedule:(void (^)(NSArray *events, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/schedule", API_URL]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@[], YES);
            return;
        }
        
        NSMutableArray *events = [[NSMutableArray alloc] init];
        UNIJsonNode *body = response.body;
        for (NSDictionary *e in body.object[@"events"]) {
            [events addObject:[[Event alloc] initWithDictionary:e]];
        }
        
        completionHandler(events, NO);
    }];
}

-(void)getQuestions:(NSString *)userId completionHandler:(void (^)(NSArray *questions, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/questions/%@", API_URL, userId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@[], YES);
            return;
        }
        
        NSMutableArray *questions = [[NSMutableArray alloc] init];
        UNIJsonNode *body = response.body;
        for (NSDictionary *q in body.object[@"questions"]) {
            [questions addObject:[[Question alloc] initWithDictionary:q]];
        }
        
        completionHandler(questions, NO);
    }];
}

-(void)getMapLocations:(void (^)(NSArray *locations, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/locations", API_URL]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@[], YES);
            return;
        }
        
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        UNIJsonNode *body = response.body;
        for (NSDictionary *l in body.object[@"locations"]) {
            [locations addObject:[[Event alloc] initWithDictionary:l]];
        }
        
        completionHandler(locations, NO);
    }];
}

-(void)getInfo:(NSString *)infoType completionHandler:(void (^)(NSArray *info, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/info/%@", API_URL, infoType]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@[], YES);
            return;
        }
        
        NSMutableArray *info = [[NSMutableArray alloc] init];
        UNIJsonNode *body = response.body;
        for (NSDictionary *i in body.object[@"info"]) {
            [info addObject:[[Info alloc] initWithDictionary:i]];
        }
        
        completionHandler(info, NO);
    }];
}

-(void)getMapImage:(void (^)(NSString *url, BOOL error))completionHandler {
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/map_image", API_URL]];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(@"", YES);
            return;
        }
        UNIJsonNode *body = response.body;
        
        completionHandler(body.object[@"image_url"], NO);
    }];
}

#pragma mark - POST


-(void)createQuestion:(Question *)question completionHandler:(void (^)(BOOL error))completionHandler {
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/questions", API_URL]];
        [request setHeaders:headers];
        [request setParameters:@{
                                 @"asker_id": [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"],
                                     @"question":question.question
                                 }];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(YES);
            return;
        }
        completionHandler(NO);
    }];
}

-(void)createUser:(NSString *)uuidString completionHandler:(void(^)(BOOL error))completionHandler {
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/user", API_URL]];
        [request setHeaders:headers];
        [request setParameters:@{
                                 @"uuid_string":uuidString
                                 }];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            NSLog(@"%ld", (long)code);
            completionHandler(YES);
            return;
        }
        
        UNIJsonNode *body = response.body;
        [[NSUserDefaults standardUserDefaults] setObject:[body.object[@"user_id"] stringValue] forKey:@"user_id"];
        completionHandler(NO);
    }];
}

-(void)sendDeviceToken:(NSString *)deviceToken completionHandler:(void(^)(BOOL error))completionHandler {
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"%@/notifications", API_URL]];
        [request setHeaders:headers];
        [request setParameters:@{
                                 @"device_token":deviceToken,
                                 @"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]
                                 }];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        NSInteger code = response.code;
        if (code != 200) {
            completionHandler(YES);
            return;
        }
        completionHandler(NO);
    }];
}

@end
