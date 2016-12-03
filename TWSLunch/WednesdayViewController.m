//
//  WednesdayViewController.m
//  TWS Lunch
//
//  Created by Andrew Shackelford on 4/8/15.
//  Copyright (c) 2015 Golden Dog Productions. All rights reserved.
//

#import "WednesdayViewController.h"
#import "HTMLReader.h"
#import "StoreData.h"

@interface WednesdayViewController ()

@end

@implementation WednesdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
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
    NSArray *today = [data objectAtIndex:2];
    NSString *title = nil;
    NSArray *categories = nil;
    NSArray *items = nil;
    if ([today count] > 2) {
        title = [today objectAtIndex:0];
        categories = [today objectAtIndex:1];
        items = [today objectAtIndex:2];
    }
    if ([categories count] > 0) {
        [_categoryOne setText:[categories objectAtIndex:0]];
    } else {
        [_categoryOne setText:@"No data available"];
    }
    if ([items count] > 0) {
        [_itemOne setText:[items objectAtIndex:0]];
        [_itemOne setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemOne setText:@""];
    }
    if ([categories count] > 1) {
        [_categoryTwo setText:[categories objectAtIndex:1]];
    } else {
        [_categoryTwo setText:@""];
    }
    if ([items count] > 1) {
        [_itemTwo setText:[items objectAtIndex:1]];
        [_itemTwo setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemTwo setText:@""];
    }
    if ([categories count] > 2) {
        [_categoryThree setText:[categories objectAtIndex:2]];
    } else {
        [_categoryThree setText:@""];
    }
    if ([items count] > 2) {
        [_itemThree setText:[items objectAtIndex:2]];
        [_itemThree setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemThree setText:@""];
    }
    if ([categories count] > 3) {
        [_categoryFour setText:[categories objectAtIndex:3]];
    } else {
        [_categoryFour setText:@""];
    }
    if ([items count] > 3) {
        [_itemFour setText:[items objectAtIndex:3]];
        [_itemFour setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemFour setText:@""];
    }
    if ([categories count] > 4) {
        [_categoryFive setText:[categories objectAtIndex:4]];
    } else {
        [_categoryFive setText:@""];
    }
    if ([items count] > 4) {
        [_itemFive setText:[items objectAtIndex:4]];
        [_itemFive setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemFive setText:@""];
        
    }
    if ([categories count] > 5) {
        [_categorySix setText:[categories objectAtIndex:5]];
    } else {
        [_categorySix setText:@""];
    }
    if ([items count] > 5) {
        [_itemSix setText:[items objectAtIndex:5]];
        [_itemSix setFont:[UIFont systemFontOfSize:17]];
    } else {
        [_itemSix setText:@""];
        [_itemSix setFont:[UIFont systemFontOfSize:17]];
        
    }
    
    
}

-(NSMutableArray*) getData {
    NSString *mainURL = @"http://www.myschooldining.com/westminster/?cmd=menus&currDT=";
    NSDate *now = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    NSString *supplementURL = [format stringFromDate:[NSDate dateWithTimeIntervalSinceNow:173000]];
    NSLog(@"%@", supplementURL);
    NSString *totalURL = [mainURL stringByAppendingString:supplementURL];
    totalURL = [totalURL stringByAppendingString:@"&selloc=978"];
    NSLog(@"%@", totalURL);
    NSString *otherURL = @"http://www.myschooldining.com/westminster/?cmd=menus&selloc=978";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatWeekday = [[NSDateFormatter alloc] init];
    [formatWeekday setDateFormat:@"EEEE"];
    NSString *weekday = [formatWeekday stringFromDate:currentDate];
    NSData *bloo;
    if ([weekday isEqualToString:@"Saturday"] || [weekday isEqualToString:@"Sunday"]) {
        NSLog(@"hi there");
        bloo = [NSData dataWithContentsOfURL:[NSURL URLWithString:totalURL]];
    } else {
        NSLog(@"sup");
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
