
//
//  StoreData.m
//  TWSLunch
//
//  Created by Andrew Shackelford on 4/29/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import "StoreData.h"

@implementation StoreData

@synthesize HTML;
@synthesize dateUpdated;
@synthesize storage;

-(id) init {
    self = [super init];
    if (self) {
        NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        destPath = [destPath stringByAppendingPathComponent:@"Storage.plist"];
        
        // If the file doesn't exist in the Documents Folder, copy it.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:destPath]) {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Storage" ofType:@"plist"];
            [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
        }
        
        // Load the Property List.
        storage = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
        
        HTML = [storage objectForKey:@"HTML"];
        dateUpdated = [storage objectForKey:@"dateUpdated"];

    }
    
    return self;
}

-(void) updateData:(NSMutableArray *)data {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"Storage.plist"];
    storage = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
    [storage setValue:data forKey:@"HTML"];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatWeekday = [[NSDateFormatter alloc] init];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *weekday = [formatWeekday stringFromDate:currentDate];
    [storage setValue:[NSDate date] forKey:@"dateUpdated"];
    [storage writeToFile:destPath atomically:YES];
}

@end
