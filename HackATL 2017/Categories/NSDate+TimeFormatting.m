//
//  NSDate+TimeFormatting.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "NSDate+TimeFormatting.h"

@implementation NSDate (TimeFormatting)

-(NSString *)createTimestamp {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [[NSDate alloc] init];
    
    unsigned int unitFlags = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitSecond;
    NSDateComponents *conversionInfo = [cal components:unitFlags fromDate:self toDate:now options:0];
    
    if ([conversionInfo day] >= 1) {
        // Return date string
        return [NSString stringWithFormat:@"%ldd", (long)[conversionInfo day]];
    }
    else if ([conversionInfo hour] >= 1) {
        // Return hour string
        return [NSString stringWithFormat:@"%ldh", [conversionInfo hour]];
    }
    else if ([conversionInfo minute] >= 1){
        // Return minute string
        return [NSString stringWithFormat:@"%ldm", [conversionInfo minute]];
    }
    else {
        // Return second string
        return [NSString stringWithFormat:@"%lds", [conversionInfo second]];
    }
}

-(NSString *)formattedDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    formatter.locale = locale;
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

-(NSString *)formattedTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    formatter.locale = locale;
    [formatter setDateFormat:@"h:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

-(NSString *)formalDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    formatter.locale = locale;
    formatter.doesRelativeDateFormatting = YES;
    [formatter setDateStyle:NSDateFormatterFullStyle];
    return [formatter stringFromDate:self];
}

@end
