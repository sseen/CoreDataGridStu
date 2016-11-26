//
//  SNOnePixelLineView.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/11.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "SNOnePixelLineView.h"

@implementation SNOnePixelLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth( [UIScreen mainScreen].bounds), (1 / [UIScreen mainScreen].scale))];
        [self addSubview:line1];
    }
    return self;
}

@end
