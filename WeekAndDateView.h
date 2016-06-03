//
//  WeekAndDateView.h
//  CoreDataGridStu
//
//  Created by sseen on 16/6/3.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekAndDateView : UIView
@property (nonatomic, strong) UILabel *lblWeek;
@property (nonatomic, strong) UILabel *lblDate;

- (id)initWithWeek:(int)week Date:(NSString *)date ;
@end
