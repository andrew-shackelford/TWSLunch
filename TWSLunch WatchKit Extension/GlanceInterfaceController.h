//
//  GlanceInterfaceController.h
//  Lunch
//
//  Created by Andrew Shackelford on 4/2/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *topLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *mainLabel;

@end
