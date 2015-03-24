//
//  ViewController.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/23/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "ViewController.h"
#import "CalendarCell.h"
#import "DateUtil.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;
@property (nonatomic) int year;
@property (nonatomic) int week;
@property (nonatomic) int selectedRow;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the current week and year
    self.year = [[DateUtil getCurrentYear]intValue];
    self.week = [[DateUtil getCurrentWeekOfYear]intValue];
    
    // Initialize the selected row
    self.selectedRow = -1;
    
    // Set up the calendarView collection view
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    self.calendarView.scrollEnabled = NO;
    self.calendarView.backgroundColor = [UIColor darkGrayColor];
    [self.calendarView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"calendarDayIdentifier"];
    
    // Set up the agendaTableView
    self.agendaTableView.delegate = self;
    self.agendaTableView.dataSource = self;
    self.agendaTableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// User swiped on the CalendarView
- (IBAction)swipeOnCalendarView:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self slideCalendarView:YES];
    }
}

- (IBAction)swipeDownOnCalendarView:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self slideCalendarView:NO];
    }
}

// Need to "slide" the calendarView based up the direction
- (void)slideCalendarView:(BOOL)isUpDirection
{
    int firstWeekInYear = 1;
    int maxWeeksInYear = 52;
    if (self.year == 2015 || self.year == 2020 || self.year == 2026 || self.year == 2032 || self.year == 2037)
    {
        maxWeeksInYear = 53;
    }
    
    if (isUpDirection)
    {
        if (++self.week > maxWeeksInYear)
        {
            self.week = firstWeekInYear;
            self.year ++;
        }
    }
    else    // !isUpDirection
    {
        if (--self.week < 1)
        {
            self.year--;
            maxWeeksInYear = 52;
            if (self.year == 2015 || self.year == 2020 || self.year == 2026 || self.year == 2032 || self.year == 2037)
            {
                maxWeeksInYear = 53;
            }
            self.week = maxWeeksInYear;
        }
    }
    
    // Select the first cell and reload
    self.selectedRow = 0;
    [self.calendarView reloadData];
}

#pragma mark
#pragma CollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Show 2 weeks at a time, so 14 days
    return 14;
}

// Controls what is displayed in each cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"calendarDayIdentifier" forIndexPath:indexPath];
    
    // This is the first date to show
    NSDate *firstDateToShow = [DateUtil getFirstDayOfWeekWithWeekOfYear:self.week usingYear:self.year];
    
    // Add days to the first date (the # is determined by indexPath.row)
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = indexPath.row;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDateToShow = [calendar dateByAddingComponents:dayComponent toDate:firstDateToShow options:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:currentDateToShow];
    int day = (int)[components day];
    int month = (int)[components month];
    
    // These are the default values for a cell
    cell.circleView.hidden = YES;
    cell.selectedView.hidden = YES;
    cell.dateLabel.textColor = [UIColor darkGrayColor];
    cell.monthLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    // See if currentDateToShow is less than today's date
    NSComparisonResult result = [currentDateToShow compare:[NSDate date]];
    if (result == NSOrderedAscending)
    {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    // Check for "special" cells
    if (indexPath.row == self.selectedRow)
    {
        // Display the blue circle around the selected day
        cell.selectedView.hidden = NO;
        cell.dateLabel.textColor = [UIColor whiteColor];
                cell.monthLabel.textColor = [UIColor whiteColor];
    }
    else if ([[NSCalendar currentCalendar] isDateInToday:currentDateToShow])
    {
        // Display the black circle around the current day
        cell.circleView.hidden = NO;
        cell.dateLabel.textColor = [UIColor whiteColor];
                cell.monthLabel.textColor = [UIColor whiteColor];
    }
    if (day == 1)
    {
        // Display the month
        cell.monthLabel.hidden = NO;
        cell.monthLabel.text = [DateUtil getMonthString:month];
    }
    else
    {
        cell.monthLabel.text = @"";
    }

    // Put the appropriate date in the cell
    cell.dateLabel.text = [NSString stringWithFormat:@"%i", day];
    cell.dateLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

// Set all spaces between the cells to zero
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

// User selected a day from the calendar
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = (int)indexPath.row;
    [collectionView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"VariableHeightCell"];
    
    cell.textLabel.text = @"TESTING";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


