//
//  WeekAndDateView.m
//  CoreDataGridStu
//
//  Created by sseen on 16/6/3.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "WeekAndDateView.h"

float width = 80;
float height = 30;


@implementation WeekAndDateView

- (id)initWithWeek:(int)week Date:(NSString *)date {
    NSArray *weekCN = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    self = [self initWithFrame:CGRectZero];
    _lblWeek = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _lblWeek.text = [NSString stringWithFormat:@"%@",weekCN[week]];
    
    _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];
    _lblDate.text = [NSString stringWithFormat:@"%@",date];
    
    [self addSubview:_lblWeek];
    [self addSubview:_lblDate];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
