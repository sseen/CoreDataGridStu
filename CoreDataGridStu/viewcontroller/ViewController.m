//
//  ViewController.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "Course+CoreDataClass.h"
#import "CoreDataStack.h"
#import "WeekOfYear+CoreDataClass.h"

#import "TopWeekdayView.h"
#import "LeftHourView.h"

#import "SNTimeTableDataSource.h"
#import "SNTimeTableFlowLayout.h"


float pkWidth = 200;

@interface ViewController () <UICollectionViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *pvWeek;
@property (assign, nonatomic) Boolean statusPickerVisible;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;  
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *btTitle;

@property (nonatomic, strong) CoreDataStack *coreDataStack;
@property (nonatomic, strong) NSMutableArray *weeksOfSeason;
@property (nonatomic, strong) NSDateComponents *weekOfNow;
@property (nonatomic, assign) NSInteger nowSelected;
@property (nonatomic, assign) int humanWeek;

@property (nonatomic, strong) SNTimeTableDataSource *delDatasource;
@property (nonatomic, strong) SNTimeTableFlowLayout *delFlowLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.dataSource = appDelegate.dataSource;
    self.coreDataStack = appDelegate.coreDataStack;
    self.dataSource = [NSMutableArray array];
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.btTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.btTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btTitle addTarget:self action:@selector(ckTitle:) forControlEvents:UIControlEventTouchUpInside ];
    [buttonsView addSubview: _btTitle];
    self.navigationItem.titleView = buttonsView;
    
    UINib *TopWeekdayViewNib = [UINib nibWithNibName:@"TopWeekdayView" bundle:nil];
    UINib *LeftHourViewNib = [UINib nibWithNibName:@"LeftHourView" bundle:nil];
    
    [_collectionView registerNib:TopWeekdayViewNib forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"supplementCell"];
    [_collectionView registerNib:LeftHourViewNib forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"supplementCell"];
    
    
    self.delDatasource = [[SNTimeTableDataSource alloc] init];
    self.collectionView.dataSource = self.delDatasource;
    
    self.statusPickerVisible = NO;
    // 周必须是学期的周，也就是当前自然周减去开学的第一个自然周
    self.nowSelected = self.weekOfNow.weekOfYear - self.humanWeek;
    [self fetchManyInfoUseTag:(int)[self.weekOfNow weekOfYear]];
    

    self.delDatasource.configureCellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath, Course* model) {
        
        UILabel *lblTitle = [cell viewWithTag:1001];
        
        lblTitle.text = [NSString stringWithFormat:@"%@ %@",model.name, model.rooms];
        cell.backgroundColor = UIColorFromRGB([model.color longValue]);

    };
    
    __weak ViewController *wSelf = self;
    self.delDatasource.configureHeaderViewBlock = ^(UICollectionReusableView *headerView, NSString *kind, NSIndexPath *indexPath) {
            if ([kind isEqualToString:@"DayHeaderView"]) {
            TopWeekdayView *topView = (TopWeekdayView *)headerView;
            [topView setWeekNow:(int)_nowSelected + _humanWeek year:(int)wSelf.weekOfNow.year index:(int)indexPath.item];
        }else if ([kind isEqualToString:@"HourHeaderView"]) {
            LeftHourView *leftView = (LeftHourView *)headerView;
            if (indexPath.item != 0) {
                leftView.lblWeek.text = [NSString stringWithFormat:@"%2ld", indexPath.item ];
            } else {
                leftView.lblWeek.text = @"";
            }
            
        }
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - core data
- (NSDateComponents *)weekOfNow {
    if (!_weekOfNow) {
        NSDate *date = [NSDate date];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [date dateByAddingTimeInterval:timeZoneSeconds];
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        // calendar.minimumDaysInFirstWeek = 4;
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:dateInLocalTimezone];
        _weekOfNow = components;
        self.nowSelected = _weekOfNow.weekOfYear;
    }
    return _weekOfNow;
}
- (NSMutableArray *)weeksOfSeason{
    if (!_weeksOfSeason) {
        [self fetchWeeks];
    }else if (_weeksOfSeason.count <= 0) {
        [self fetchWeeks];
    }
    return _weeksOfSeason;
}

- (int)humanWeek {
    if (!_humanWeek) {
        if (self.weeksOfSeason.count >0) {
            _humanWeek =  [self.weeksOfSeason[0] intValue];
        }
    }
    return _humanWeek;
}

- (void)fetchManyInfoUseTag:(int)weekOfYear {
    [self.dataSource removeAllObjects];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY week_of_year.weekOfYear == %d", weekOfYear];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSSortDescriptor *sortDesc2 = [[NSSortDescriptor alloc] initWithKey:@"weekday" ascending:YES];
    
    [fetch setSortDescriptors:@[sortDesc, sortDesc2]];
    [fetch setPredicate:predicate];
    
    NSError *error ;
    NSArray *obj = [_coreDataStack.context executeFetchRequest:fetch error:&error];
    for (Course *course in obj) {
        NSLog(@"%@\n", course.description);
    }
    
    NSString *strWeekOfYear = [NSString stringWithFormat:@"第%ld周", self.nowSelected + 1];
    [_btTitle setTitle:strWeekOfYear forState:UIControlStateNormal];
    [_pvWeek selectRow:_nowSelected inComponent:1 animated:NO];
    
    self.delDatasource.dataSource = [NSMutableArray arrayWithArray:obj];
    [self.collectionView reloadData];
}

- (void)fetchWeeks{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"WeekOfYear"];
    NSSortDescriptor *sortDesc2 = [[NSSortDescriptor alloc] initWithKey:@"weekOfYear" ascending:YES];
    
    [fetch setSortDescriptors:@[sortDesc2]];
    
    NSError *error ;
    NSArray *obj = [_coreDataStack.context executeFetchRequest:fetch error:&error];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (WeekOfYear *week in obj) {
        [dataArr addObject:week.weekOfYear];
    }
    
    self.weeksOfSeason = [dataArr mutableCopy];
}



#pragma mark - target
- (void)ckTitle:(UIButton *)sender {

    if (_statusPickerVisible) {
        [self hideStatusPickerCell];
    }else {
        [self showStatusPickerCell];
    }
}
- (void)showStatusPickerCell {
    self.statusPickerVisible = YES;
    self.pvWeek.hidden = NO;
    self.pvWeek.alpha = 0.0f;
    self.constraintBottom.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.pvWeek.alpha = 1.0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideStatusPickerCell {
    self.statusPickerVisible = NO;
    self.constraintBottom.constant = -pkWidth;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.pvWeek.alpha = 0.0f;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.pvWeek.hidden = YES;
                     }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 2;
    }
    return self.weeksOfSeason.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = [NSString stringWithFormat:@"第%d周", [self.weeksOfSeason[row] intValue] - self.humanWeek + 1];
    if (component == 0) {
        if ( row == 0) {
            str = @"今天";
        }else {
            str = @"其它";
        }
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _nowSelected = row;
    if (component == 1) {
        [self fetchManyInfoUseTag:[self.weeksOfSeason[row] intValue]];
        [pickerView selectRow:1 inComponent:0 animated:YES];
    }else {
        // 今天
        _nowSelected = _weekOfNow.weekOfYear- self.humanWeek;
        if (row == 0) {
            [self fetchManyInfoUseTag:(int)self.weekOfNow.weekOfYear];
            [pickerView selectRow:_nowSelected inComponent:1 animated:YES];
        }
    }
}

@end
