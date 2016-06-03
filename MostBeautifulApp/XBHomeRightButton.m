//
//  HomeRightButton.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/25.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 4
#import "XBHomeRightButton.h"
@interface XBHomeRightButton()
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIImageView   *homeImageView;
@property (strong, nonatomic) UILabel       *dayLabel;
@property (strong, nonatomic) UILabel       *monthLabel;
@property (strong, nonatomic) UILabel       *weekLabel;
@property (strong, nonatomic) NSDate        *date;
@property (copy  , nonatomic) dispatch_block_t  block;
@end
@implementation XBHomeRightButton
- (instancetype)initWithFrame:(CGRect)frame homeBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        self.homeImageView = [UIImageView new];
        self.homeImageView.image = [UIImage imageNamed:@"backtohome_normal"];
        self.homeImageView.userInteractionEnabled = YES;
        [self.homeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeAction)]];
        
        self.dayLabel = [UILabel new];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:31.f];
        self.dayLabel.textAlignment = NSTextAlignmentLeft;
        self.dayLabel.text = @"22";
        
        UIColor *textColor = [UIColor lightTextColor];
        self.monthLabel = [UILabel new];
        self.monthLabel.textColor = textColor;
        self.monthLabel.textAlignment = NSTextAlignmentLeft;
        self.monthLabel.font = [UIFont systemFontOfSize:12.f];
        self.monthLabel.text = @"5月";

        self.weekLabel = [UILabel new];
        self.weekLabel.textColor = textColor;
        self.weekLabel.textAlignment = NSTextAlignmentLeft;
        self.weekLabel.font = [UIFont systemFontOfSize:12.f];
        self.weekLabel.text = @"星期日";
        
        self.block = block;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.homeImageView];
        [self addSubview:self.dayLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.weekLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY).offset(kSpace);
        make.right.equalTo(self);
    }];
    
    [self.homeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(35.f);
        make.height.mas_equalTo(35.f);
    }];
    
    [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeImageView.right).offset(kSpace * 2);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(20.f);
    }];
    
    [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.right).offset(kSpace * 2);
        make.bottom.equalTo(self.dayLabel.centerY);
    }];
    
    [self.weekLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monthLabel);
        make.top.equalTo(self.dayLabel.centerY);
    }];
}

- (void)setCurrentDateString:(NSString *)currentDateString
{
    _currentDateString = currentDateString;
    
    NSString *todayString = [self dateString:[NSDate date]];
    NSString *yesterDayString = [self dateString:[[NSDate date] dateByAddingTimeInterval:-86400]];
    
    if ([currentDateString isEqualToString:todayString]) {
        [self showToDayYesterDay:YES];
        self.titleLabel.text = @"今日最美";
    } else if ([currentDateString isEqualToString:yesterDayString]) {
        [self showToDayYesterDay:YES];
        self.titleLabel.text = @"昨日最美";
    } else {
        [self showToDayYesterDay:NO];
        NSDateComponents *components = [self componentDate:[self formatterDate:currentDateString]];
        self.dayLabel.text = [NSIntegerFormatter formatToNSString:components.day fix:YES];
        self.monthLabel.text = [NSIntegerFormatter formatToNSString:components.month fix:NO];
        self.weekLabel.text = [self formatterWeekDay:components.weekday];
    }
}

- (NSDate *)formatterDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateString];
}

- (NSDateComponents *)componentDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

- (NSString *)dateString:(NSDate *)date
{
    NSDateComponents *comps = [self componentDate:date];
    return [NSString stringWithFormat:@"%@-%@-%@",[NSIntegerFormatter formatToNSString:comps.year fix:YES],[NSIntegerFormatter formatToNSString:comps.month fix:YES],[NSIntegerFormatter formatToNSString:comps.day fix:YES]];
}

- (void)showToDayYesterDay:(BOOL)show
{
    self.titleLabel.hidden = !show;
    self.homeImageView.hidden = show;
    self.dayLabel.hidden = show;
    self.monthLabel.hidden = show;
    self.weekLabel.hidden = show;
}

- (NSString *)formatterWeekDay:(NSInteger)weekday
{
    NSString *weekdayString = @"";
    switch (weekday) {
        case 1:
            weekdayString = @"星期日";
            break;
        case 2:
            weekdayString = @"星期一";
            break;
        case 3:
            weekdayString = @"星期二";
            break;
        case 4:
            weekdayString = @"星期三";
            break;
        case 5:
            weekdayString = @"星期四";
            break;
        case 6:
            weekdayString = @"星期五";
            break;
        case 7:
            weekdayString = @"星期六";
            break;
    }
    return weekdayString;
}

- (void)homeAction
{
    self.block();
}

@end
