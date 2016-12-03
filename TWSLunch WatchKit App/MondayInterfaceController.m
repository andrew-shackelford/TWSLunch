//
//  MondayInterfaceController.m
//  Lunch
//
//  Created by Andrew Shackelford on 4/1/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import "MondayInterfaceController.h"
#import "HTMLReader.h"
#import "StoreData.h"


@interface MondayInterfaceController()

@end


@implementation MondayInterfaceController


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatWeekday = [[NSDateFormatter alloc] init];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *weekday = [formatWeekday stringFromDate:currentDate];
    if ([weekday isEqualToString:@"Monday"]) {
        [self becomeCurrentPage];
    }
    
    NSTimer *dataTimer;
    dataTimer = [NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
    [_mainLabel setText:@"Loading..."];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [_mainLabel setText:@"Loading..."];



}

- (void)loadData {
    StoreData *storage = [[StoreData alloc] init];
    NSDateFormatter *weekFormat = [[NSDateFormatter alloc] init];
    [weekFormat setDateFormat:@"w"];
    NSString *currentWeek = [weekFormat stringFromDate:[NSDate date]];
    NSString *updatedWeek = [weekFormat stringFromDate:[storage dateUpdated]];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatWeekday = [[NSDateFormatter alloc] init];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *weekday = [formatWeekday stringFromDate:currentDate];
    NSMutableArray *data;
    if ([currentWeek isEqualToString:updatedWeek]) {
        data = [storage HTML];
    } else {
        data = [self newData];
        [storage updateData:data];
    }
    NSArray *today = [data objectAtIndex:0];
    NSString *title = nil;
    NSArray *categories = nil;
    NSArray *items = nil;
    NSString *finalString = @"";
    if ([today count] > 2) {
        title = [today objectAtIndex:0];
        categories = [today objectAtIndex:1];
        items = [today objectAtIndex:2];
    } else {
        finalString = @"No data available";
    }
    

    for (NSString* x in items) {
        if ([finalString isEqualToString:@""]) {
            finalString = x;
        } else {
            finalString = [finalString stringByAppendingString:[NSString stringWithFormat:@"\n%@", x]];
        }
    }
    if ([finalString isEqualToString:@""]) finalString = @"No data available";
    
    [_mainLabel setText:finalString];
}

- (NSMutableArray*)newData {
    NSData *bloo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.myschooldining.com/westminster/?cmd=menus"]];
    NSString *strData = [[NSString alloc]initWithData:bloo encoding:NSUTF8StringEncoding];
    // NSLog(@"%@", strData);
    HTMLDocument *document = [HTMLDocument documentWithString:strData];
    NSMutableArray *booty = [NSMutableArray arrayWithArray:[document nodesMatchingSelector:@"span"]];
    NSDateFormatter *formatCurrentDate = [[NSDateFormatter alloc] init];
    [formatCurrentDate setDateFormat:@"EEEE"];
    NSString *weekday = [formatCurrentDate stringFromDate:[NSDate date]];
    
    double time = 0;
    
    if ([weekday isEqualToString:@"Sunday"]) {
        time = -144;
    } else if ([weekday isEqualToString:@"Monday"]) {
        time = 0;
    } else if ([weekday isEqualToString:@"Tuesday"]) {
        time = -24;
    } else if ([weekday isEqualToString:@"Wednesday"]) {
        time = -48;
    } else if ([weekday isEqualToString:@"Thursday"]) {
        time = -72;
    } else if ([weekday isEqualToString:@"Friday"]) {
        time = -96;
    } else if ([weekday isEqualToString:@"Saturday"]) {
        time = -120;
    }
    
    NSTimeInterval timeInterval = time * 3600;
    
    NSDate *thisMonday = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    
    NSDateFormatter *formatDateTwo = [[NSDateFormatter alloc] init];
    [formatDateTwo setDateFormat:@"d"];
    
    int monday = [[formatDateTwo stringFromDate:thisMonday] intValue];
    
    NSMutableArray *shack = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < 432000; a+= 86400) {
        NSDate *newDate = [thisMonday dateByAddingTimeInterval:a];
        NSDateFormatter *formatNewDate = [[NSDateFormatter alloc] init];
        [formatNewDate setDateFormat:@"M/d/yy"];
        NSString *newDateString = [formatNewDate stringFromDate:newDate];
        NSDateFormatter *formatOtherDate = [[NSDateFormatter alloc] init];
        [formatOtherDate setDateFormat:@"d"];
        NSString *otherDateString = [formatOtherDate stringFromDate:newDate];
        bool newCategory = false;
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSString *title;
        NSError *error;
        NSString *itemString;
        NSLog(newDateString);
        
        bool stupidFlik = false;
        
        for (HTMLElement *x in booty) {
            if ([[x parentElement] hasClass:@"menu-presslyhall"] && [[x parentElement] hasClass:[NSString stringWithFormat:@"day-%@", otherDateString]]) {
                
                
                NSLog(@"hey");
                if ([x hasClass:@"month-period"]) {
                    if (!stupidFlik) {
                        title = [self getString:[x childAtIndex:0]];
                    } else {
                        [categories addObject:[self getCategoryString:[x childAtIndex:0]]];
                        //NSLog(@"%@", [self getString:[x childAtIndex:0]]);
                        newCategory = true;
                        if (itemString != nil) {
                            [items addObject:itemString];
                        }
                        itemString = @"";
                    }
                }
                if ([x hasClass:@"month-category"]) {
                    if ([[self getCategoryString:[x childAtIndex:0]] length] < 10 || [[self getCategoryString:[x childAtIndex:0]] containsString:@"ecialty"]  || [[self getCategoryString:[x childAtIndex:0]] containsString:@"ecial"]) {
                        [categories addObject:[self getCategoryString:[x childAtIndex:0]]];
                        //NSLog(@"%@", [self getString:[x childAtIndex:0]]);
                        newCategory = true;
                        if (itemString != nil) {
                            [items addObject:itemString];
                        }
                        itemString = @"";
                    } else {
                        stupidFlik = true;
                        if (newCategory) {
                            itemString = [self getString:[x childAtIndex:0]];
                            newCategory = false;
                        } else {
                            itemString = [itemString stringByAppendingString:@"\n"];
                            itemString = [itemString stringByAppendingString:[self getString:[x childAtIndex:0]]];
                        }
                        NSLog([self getString:[x childAtIndex:0]]);
                    }
                }
                if ([x hasClass:@"month-item"]) {
                    if (newCategory) {
                        itemString = [self getString:[x childAtIndex:0]];
                        newCategory = false;
                    } else {
                        itemString = [itemString stringByAppendingString:@"\n"];
                        itemString = [itemString stringByAppendingString:[self getString:[x childAtIndex:0]]];
                    }
                    NSLog([self getString:[x childAtIndex:0]]);
                    
                }
            }
        }
        if (itemString != nil) {
            [items addObject:itemString];
        }
        [shack addObject:[[NSMutableArray alloc] initWithObjects:title, categories, items, nil]];
    }

    
    return shack;
}

-(NSString*)getString:(HTMLNode*)sup {
    NSString *hey = [sup textContent];
    hey = [hey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    hey = [hey stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    hey = [hey stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    if ([hey containsString:@"PDF of today's menu"]) {
    //        return nil;
    //    }
    //    if ([hey length] > 6) {
    hey = [hey substringFromIndex:28];
    hey = [hey substringToIndex:[hey length] - 26];
    //    }
    return hey;
}

-(NSString*)getCategoryString:(HTMLNode*)sup {
    NSString *hey = [sup textContent];
    hey = [hey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    hey = [hey stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    hey = [hey stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    if ([hey containsString:@"PDF of today's menu"]) {
    //        return nil;
    //    }
    //    if ([hey length] > 6) {
    hey = [hey substringFromIndex:28];
    hey = [hey substringToIndex:[hey length] - 26];
    //    }
    return hey;
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(NSMutableArray*) getData {
    NSString *mainURL = @"http://www.myschooldining.com/westminster/?cmd=menus&currDT=";
    NSDate *now = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *supplementURL = [format stringFromDate:[NSDate dateWithTimeIntervalSinceNow:173000]];
    NSString *totalURL = [mainURL stringByAppendingString:supplementURL];
    totalURL = [totalURL stringByAppendingString:@"&selloc=978"];
    NSString *otherURL = @"http://www.myschooldining.com/westminster/?cmd=menus&selloc=978";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatWeekday = [[NSDateFormatter alloc] init];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *weekday = [formatWeekday stringFromDate:currentDate];
    NSData *bloo;
    if ([weekday isEqualToString:@"Saturday"] || [weekday isEqualToString:@"Sunday"]) {
        bloo = [NSData dataWithContentsOfURL:[NSURL URLWithString:totalURL]];
    } else {
        bloo = [NSData dataWithContentsOfURL:[NSURL URLWithString:otherURL]];
    }
    NSString *strData = [[NSString alloc]initWithData:bloo encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", strData);
    HTMLDocument *document = [HTMLDocument documentWithString:strData];
    NSMutableArray *booty = [NSMutableArray arrayWithArray:[document nodesMatchingSelector:@"span"]];
    [booty removeObjectAtIndex:0];
    [booty removeObjectAtIndex:0];
    [booty removeObjectAtIndex:0];
    [booty removeObjectAtIndex:0];
    [booty removeObjectAtIndex:0];
    [booty removeLastObject];
    [booty removeLastObject];
    NSMutableArray *shack = [NSMutableArray array];
    for (HTMLElement* x in booty) {
        NSString *heythere = [self getString:[x childAtIndex:0]];
        if (heythere != nil) {
            [shack addObject:heythere];
        }
    }
    return shack;
}

@end



