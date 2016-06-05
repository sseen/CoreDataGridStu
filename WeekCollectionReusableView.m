//
//  WeekCollectionReusableView.m
//  CoreDataGridStu
//
//  Created by sseen on 16/6/3.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "WeekCollectionReusableView.h"
#import "WeekAndDateView.h"

@interface WeekCollectionReusableView()


@end

@implementation WeekCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0 ; i<5; i++) {
            WeekAndDateView *view = [[WeekAndDateView alloc] initWithWeek:i+1 Date:@"12-11"];
            view.frame = CGRectMake(i*80, 0, CGRectGetWidth(self.frame), 60);
            view.tag = 5000 + i;
            [self addSubview:view];
        }
    }
    return self;
}

- (void)setWeekNow:(int)weekNow year:(int)year{
    NSDateComponents *weekDC = [[NSDateComponents alloc] init];
    weekDC.timeZone = [NSTimeZone localTimeZone];
    weekDC.year = year;
    weekDC.weekOfYear = weekNow;
    weekDC.yearForWeekOfYear = year;
    
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    gregorianCalendar.minimumDaysInFirstWeek = 4; //国际规定 iso 8911 只有这样才能取到正确的 第一周
    NSDate *firstDay = [gregorianCalendar dateFromComponents:weekDC];
    
    for (int i=0 ; i<5; i++) {
        WeekAndDateView *view = [self viewWithTag:5000 + i];
        view.lblDate.text = [self formatDateToStringTpye:[firstDay dateByAddingTimeInterval:24*60*60*(i+1)]];//＋1是因为第一天是周日
    }
}

- (NSString *)formatDateToStringTpye:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    return [format stringFromDate:date];
}

@end
