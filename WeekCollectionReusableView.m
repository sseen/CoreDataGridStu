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

- (void)setWeekNow:(NSInteger)weekNow {
    
    
    for (int i=0 ; i<5; i++) {
        WeekAndDateView *view = [[WeekAndDateView alloc] initWithWeek:i+1 Date:@"12-11"];
        view.frame = CGRectMake(i*80, 0, CGRectGetWidth(self.frame), 60);
        view.tag = 5000 + i;
        [self addSubview:view];
    }
}

@end
