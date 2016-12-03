//
//  InterfaceController.m
//  Lunch WatchKit Extension
//
//  Created by Andrew Shackelford on 4/1/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import "InterfaceController.h"
#import "HTMLReader.h"

@interface InterfaceController()

@end


@implementation InterfaceController

-(NSMutableArray*) getData {
    NSData *bloo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.myschooldining.com/westminster/?cmd=menus&selloc=978"]];
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

-(NSString*)getString:(HTMLNode*)sup {
    NSString *hey = [sup textContent];
    hey = [hey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    hey = [hey stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if ([hey containsString:@"PDF of today's menu"]) {
        return nil;
    }
    if ([hey length] > 6) {
        hey = [hey substringFromIndex:2];
    }
    return hey;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
//    NSMutableArray *data = [self getData];
//    NSMutableArray *monday = [NSMutableArray array];
//    NSMutableArray *tuesday = [NSMutableArray array];
//    NSMutableArray *wednesday = [NSMutableArray array];
//    NSMutableArray *thursday = [NSMutableArray array];
//    NSMutableArray *friday = [NSMutableArray array];
//    NSMutableArray *indexes = [NSMutableArray array];
//    for (NSString* x in data) {
//        if ([x length] < 6) {
//            [indexes addObject:[NSNumber numberWithInteger:[data indexOfObject:x]]];
//        }
//    }
//    for (int i = 0; i < [[indexes objectAtIndex:1] intValue]; i++) {
//        [monday addObject:[data objectAtIndex:i]];
//    }
//    NSLog(@"%@", monday);
//    for (int i = [[indexes objectAtIndex:1] intValue]; i < [[indexes objectAtIndex:2] intValue]; i++) {
//        [tuesday addObject:[data objectAtIndex:i]];
//    }
//    NSLog(@"%@", tuesday);
//    for (int i = [[indexes objectAtIndex:2] intValue]; i < [[indexes objectAtIndex:3] intValue]; i++) {
//        [wednesday addObject:[data objectAtIndex:i]];
//    }
//    NSLog(@"%@", wednesday);
//    for (int i = [[indexes objectAtIndex:3] intValue]; i < [[indexes objectAtIndex:4] intValue]; i++) {
//        [thursday addObject:[data objectAtIndex:i]];
//    }
//    NSLog(@"%@", thursday);
//    for (int i = [[indexes objectAtIndex:4] intValue]; i < [data count]; i++) {
//        [friday addObject:[data objectAtIndex:i]];
//    }
//    NSLog(@"%@", friday);
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



