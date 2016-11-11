//
//  WeekCollectionReusableView.m
//  CoreDataGridStu
//
//  Created by sseen on 16/6/3.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "WeekCollectionReusableView.h"

float width = 80;
float height = 30;


@interface WeekCollectionReusableView()


@end



@implementation WeekCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lblWeek = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];

        [self addSubview:_lblWeek];
        [self addSubview:_lblDate];
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
    
    
    self.lblDate.text = [self formatDateToStringTpye:[firstDay dateByAddingTimeInterval:24*60*60]];//＋1是因为第一天是周日
 
}

- (NSString *)formatDateToStringTpye:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    return [format stringFromDate:date];
}

@end
