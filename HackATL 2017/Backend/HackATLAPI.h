//
//  HackATLAPI.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNIRest.h"

#import "Annoucement.h"
#import "Event.h"
#import "Question.h"
#import "MapLocation.h"
#import "Info.h"

@interface HackATLAPI : NSObject

+(instancetype)sharedManager;

// POST
-(void)createQuestion:(Question *)question completionHandler:(void (^)(BOOL error))completionHandler;
-(void)createUser:(NSString *)uuidString completionHandler:(void(^)(BOOL error))completionHandler;
-(void)sendDeviceToken:(NSString *)deviceToken completionHandler:(void(^)(BOOL error))completionHandler;

// GET
-(void)getAnnoucements:(void (^)(NSArray *annoucements, BOOL error))completionHandler;
-(void)getSchedule:(void (^)(NSArray *events, BOOL error))completionHandler;
-(void)getQuestions:(NSString *)userId completionHandler:(void (^)(NSArray *questions, BOOL error))completionHandler;
-(void)getMapLocations:(void (^)(NSArray *locations, BOOL error))completionHandler;
-(void)getInfo:(NSString *)infoType completionHandler:(void (^)(NSArray *info, BOOL error))completionHandler;
-(void)getMapImage:(void (^)(NSString *url, BOOL error))completionHandler;

@end
