//
//  ViewController.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "Course.h"
#import "CoreDataStack.h"
#import "WeekOfYear.h"

int cellsInLine = 5;
float pkWidth = 200;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *pvWeek;
@property (assign, nonatomic) Boolean statusPickerVisible;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *btTitle;

@property (nonatomic, strong) CoreDataStack *coreDataStack;
@property (nonatomic, strong) NSMutableArray *weeksOfSeason;
@property (nonatomic, strong) NSDateComponents *weekOfNow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.dataSource = appDelegate.dataSource;
    self.coreDataStack = appDelegate.coreDataStack;
    self.dataSource = [NSMutableArray array];
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.btTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    NSString *strWeekOfYear = [NSString stringWithFormat:@"第%d周", (int)self.weekOfNow.weekOfYear - 9];
    //初始化 picker
    [_pvWeek selectRow:(int)_weekOfNow.weekOfYear-9 inComponent:1 animated:NO];
    
    [_btTitle setTitle:strWeekOfYear forState:UIControlStateNormal];
    [_btTitle addTarget:self action:@selector(ckTitle:) forControlEvents:UIControlEventTouchUpInside ];
    [buttonsView addSubview: _btTitle];
    self.navigationItem.titleView = buttonsView;
    
    self.statusPickerVisible = NO;
    // 周必须是学期的周，也就是当前自然周减去开学的第一个自然周
    [self fetchManyInfoUseTag:(int)[self.weekOfNow weekOfYear]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - core data
- (NSDateComponents *)weekOfNow {
    if (!_weekOfNow) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:date];
        _weekOfNow = components;
    }
    return _weekOfNow;
}
- (NSMutableArray *)weeksOfSeason{
    if (!_weeksOfSeason) {
        [self fetchWeeks];
    }
    return _weeksOfSeason;
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
    
    Course *tmpCourse = (Course *)obj[0];
    int objIndex = 0;
    NSInteger index = tmpCourse.weekday.integerValue * tmpCourse.time.integerValue;
    NSMutableArray *dataArr = [NSMutableArray array];
    
    // 组成collection data source
    for (int i=0; i< 5 * 6; i++) {
        Course *emptyCourse = [tmpCourse copy];
        [self.coreDataStack.context deleteObject:emptyCourse];
        emptyCourse.weekday = @-1;
        
        if (i+1 == index) {
            [dataArr addObject:obj[objIndex++]];
            // 不能越界
            if (objIndex < obj.count) {
                Course *tmp = (Course *)obj[objIndex];
                int line = (int)(tmp.time.integerValue/2)+1;
                index = tmp.weekday.integerValue +  5 * (line -1);
            }
        } else {
            [dataArr addObject:emptyCourse];
           
        }
        
    }
    self.dataSource = dataArr ;
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
//    [self.view setNeedsUpdateConstraints];
    //[self.view bringSubviewToFront:_pvWeek];
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
    NSString *str = [NSString stringWithFormat:@"第%d周", [self.weeksOfSeason[row] intValue] - 9];
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
    if (component == 1) {
        [self fetchManyInfoUseTag:(int)row + 10];
        [_btTitle setTitle:[NSString stringWithFormat:@"第%d周", (int)row + 1] forState:UIControlStateNormal];
        [pickerView selectRow:1 inComponent:0 animated:YES];
    }else {
        if (row == 0) {
            [self fetchManyInfoUseTag:(int)self.weekOfNow.weekOfYear];
            [_btTitle setTitle:[NSString stringWithFormat:@"第%d周", (int)_weekOfNow.weekOfYear-0] forState:UIControlStateNormal];
            [pickerView selectRow:(int)_weekOfNow.weekOfYear-9 inComponent:1 animated:YES];
        }
    }
}

#pragma mark - datasouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
    
    cell.backgroundColor= [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:1.00];
    UILabel *lblTitle = [cell viewWithTag:1001];
    Course *tmp =  _dataSource[indexPath.item];
    if (tmp.weekday.integerValue != -1) {
        lblTitle.text = [NSString stringWithFormat:@"%@ %@",tmp.name, tmp.rooms];
    }else {
        lblTitle.text = @"";
        cell.backgroundColor = [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:0.4];
    }
    
    return cell;
}

#pragma mark - flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [self itemWidth];
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing];
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //     return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (float)itemSpacing {
    float width = [self itemWidth];
    float spacing = ((CGRectGetWidth(self.view.frame) - cellsInLine * width) / (cellsInLine -1));
    return spacing;
}

- (float)itemWidth {
    float width = roundf(( CGRectGetWidth(self.view.frame) - cellsInLine + 1) / cellsInLine);
    return width;
}

@end
