//
//  StoreData.h
//  TWSLunch
//
//  Created by Andrew Shackelford on 4/29/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreData : NSObject

-(void) updateData:(NSMutableArray*)data;

@property (readwrite, nonatomic) NSMutableArray *HTML;
@property (readwrite, nonatomic) NSDate *dateUpdated;
@property (nonatomic, strong) NSDictionary *storage;

@end
