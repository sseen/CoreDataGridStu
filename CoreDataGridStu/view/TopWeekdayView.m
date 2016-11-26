//
//  TopWeekdayView.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/11.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "TopWeekdayView.h"

@implementation TopWeekdayView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setWeekNow:(int)weekNow year:(int)year index:(int)weekDay{
    
    NSArray *weekCN = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    NSDateComponents *weekDC = [[NSDateComponents alloc] init];
    weekDC.timeZone = [NSTimeZone localTimeZone];
    weekDC.year = year;
    weekDC.weekOfYear = weekNow;
    weekDC.yearForWeekOfYear = year;
    
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    gregorianCalendar.minimumDaysInFirstWeek = 4; //国际规定 iso 8911 只有这样才能取到正确的 第一周
    NSDate *firstDay = [gregorianCalendar dateFromComponents:weekDC];
    
    self.lblDate.text = [self formatDateToStringTpye:[firstDay dateByAddingTimeInterval:24*60*60*weekDay]];//＋1是因为第一天是周日
    self.lblWeek.text = weekCN[weekDay];
}

- (NSString *)formatDateToStringTpye:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    return [format stringFromDate:date];
}

@end
