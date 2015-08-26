//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const CGFloat kDIDatepickerHeight;
@class DIDatepicker;
@protocol DIDatepickerDelegate <NSObject>

- (void)DIDatepicker:(DIDatepicker*)picker didSelectToIndex:(NSInteger)index;

@end

@interface DIDatepicker : UIControl <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,assign)id<DIDatepickerDelegate>delegate;
// data
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic, readonly) NSDate *selectedDate;

// UI
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (strong, nonatomic) UIColor *selectedDateBottomLineColor;

// methods
- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)nextDatesCount;
- (void)fillCurrentWeek;
- (void)fillCurrentMonth;
- (void)fillCurrentYear;
- (void)selectDate:(NSDate *)date;
- (void)selectDateAtIndex:(NSUInteger)index;

@end
