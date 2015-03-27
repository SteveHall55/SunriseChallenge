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
#import "Event.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;
@property (nonatomic) int year;
@property (nonatomic) int week;
@property (strong, nonatomic) NSMutableArray *viewableDatesArray;
@property (nonatomic) int currentDayIndex;
@property (nonatomic) int lastAgendaViewDayIndex;

@end

@implementation ViewController

-(void)awakeFromNib
{
    self.daysArray =[[NSMutableArray alloc] init];
}

// Whenever there is a change to the events, we need to update the view
// For this demo app, this won't happen, but in production app it will
- (void)setEventsArray:(NSMutableArray *)eventsArray
{
    _eventsArray = eventsArray;
    [self.agendaTableView reloadData];
}

// As this is a demo, I'm not dealing with the fact that the
// user could scroll beyond daysArray in either direction


// Load the days
- (void)loadDays
{
    // Load a 100 days worth of days
    // I know that a production app would have to deal with updating
    // the dates as the user scrolls in either direction
    NSDate *todaysDate = [NSDate date];
    todaysDate = [DateUtil updateTimeForDate:todaysDate hour:23 minutes:59 seconds:59];
    
    for (int i = -50; i <= 50; i++)
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = i;
        
        // Add "i" days to todaysDate to get the newDate
        NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:todaysDate options:0];
        [self.daysArray addObject:newDate];
    }
    
    // Set the current day index - 50 is today
    self.currentDayIndex = 50;
    self.lastAgendaViewDayIndex = 50;
}

// Load the events
- (void)loadEvents
{
    // Create some hard-coded events for this demo
    NSDate *todaysDate = [NSDate date];
    NSMutableArray *hardCodedEventsArray = [[NSMutableArray alloc] init];
    
    // Event 1
    Event *event1 = [[Event alloc] init];
    event1.eventStartDate = [NSDate date];
    event1.duration = @"1d";
    event1.title = @"My Birthday!";
    event1.eventType = @"Holiday";
    event1.longDescription = @"Celebrate with family";
    [hardCodedEventsArray addObject:event1];

    // Event 2
    Event *event2 = [[Event alloc] init];
    event2.eventStartDate = [DateUtil updateTimeForDate:todaysDate hour:11 minutes:30 seconds:0];
    event2.duration = @"1h30m";
    event2.title = @"Lunch w/ Pierre";
    event2.eventType = @"Meal";
    event2.longDescription = @"Lefty O'Douls";
    [hardCodedEventsArray addObject:event2];
    
    // Event 3
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;   // Event 1 day from now
    NSDate *event3Date = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:todaysDate options:0];
    Event *event3 = [[Event alloc] init];
    event3.eventStartDate = [DateUtil updateTimeForDate:event3Date hour:14 minutes:30 seconds:0];
    event3.duration = @"30m";
    event3.title = @"One-on-on with Scott";
    event3.eventType = @"Holiday";
    event3.longDescription = @"Recurring weekly meeting";
    [hardCodedEventsArray addObject:event3];
    
    // Sort the array of events by start Date (just to make sure we have them in the right order)
    NSArray *sortedEventsArray = [hardCodedEventsArray sortedArrayUsingComparator:^NSComparisonResult(id first, id second)
    {
        NSDate *firstDate = [(Event*)first eventStartDate];
        NSDate *secondDate = [(Event*)second eventStartDate];
        return [firstDate compare:secondDate];
    }];
    self.eventsArray = [NSMutableArray arrayWithArray:sortedEventsArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the days
    // As this is a demo, we are only loading 360 days
    // A production app would need to be dynamic and be sure
    // to add new days as the user scrolls in each direction
    [self loadDays];
    
    // Load the events
    // As this is a demo, we are only pulling hard-coded events, but a
    // production app would need to go out to the network and get the data
    // and the overhead for all that would need to be handled
    [self loadEvents];
    
    // Get the current week and year
    self.year = [[DateUtil getCurrentYear]intValue];
    self.week = [[DateUtil getCurrentWeekOfYear]intValue];
    
    // Initialzie the viewableDatesArray
    self.viewableDatesArray = [[NSMutableArray alloc] init];
    [self updateViewableDatesArray];
    
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
    self.agendaTableView.contentInset = UIEdgeInsetsMake(-68,0,0,0);
    
    // Move the table view to the
    [self.agendaTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:50];
    [self.agendaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Update the viewableDatesArray used in the calendarView
-(void)updateViewableDatesArray
{
    [self.viewableDatesArray removeAllObjects];
    
    // Initially, this will be the first day of the fortnight
    NSDate *currentDate = [DateUtil getFirstDayOfWeekWithWeekOfYear:self.week usingYear:self.year];
    [self.viewableDatesArray addObject:currentDate];
    
    for (int i = 1; i < 14; i++)
    {
        // Add days to the first date (the # is determined by indexPath.row)
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;   // Add one day
        currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:currentDate options:0];
        [self.viewableDatesArray addObject:currentDate];
    }
}

// Update the agendaView because the selected date has changed
-(void)updateAgendaViewBecauseSelectedDateChanged
{
    [self.agendaTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentDayIndex];
    [self.agendaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

// Update the calendarView because the selected date has changed
-(void)updateCalendarViewBecauseSelectedDateChanged
{
    // Update calendarView
    [self updateViewableDatesArray];
    [self.calendarView reloadData];
}

// User swiped up on the CalendarView
- (IBAction)swipeUpOnCalendarView:(id)sender
{
    UISwipeGestureRecognizer *swipeGestureRecognizer = sender;
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self slideCalendarView:YES];
    }
}

// User swiped down on the CalendarView
- (IBAction)swipeDownOnCalendarView:(id)sender
{
    UISwipeGestureRecognizer *swipeGestureRecognizer = sender;
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self slideCalendarView:NO];
    }
}

// Need to "slide" the calendarView based up the direction
- (void)slideCalendarView:(BOOL)isUpDirection
{
    if (isUpDirection)
    {
        [self incrementWeek];
        [self incrementWeek];
        self.currentDayIndex = self.currentDayIndex + 14;
    }
    else    // !isUpDirection
    {
        [self decrementWeek];
        [self decrementWeek];
        self.currentDayIndex = self.currentDayIndex - 14;
    }
    
    // Update updateViewableDatesArray with the new dates
    [self updateViewableDatesArray];
    
    // Reload calendar view
    [self.calendarView reloadData];
    
    // Update the agendaView because the selected date change
    [self updateAgendaViewBecauseSelectedDateChanged];
}

// Increment the current week
-(void)incrementWeek
{
    int firstWeekInYear = 1;
    int maxWeeksInYear = 52;
    if (self.year == 2015 || self.year == 2020 || self.year == 2026 || self.year == 2032 || self.year == 2037)
    {
        maxWeeksInYear = 53;
    }
    
    if (++self.week > maxWeeksInYear)
    {
        self.week = firstWeekInYear;
        self.year++;
    }
}

// Decrement the current week
-(void)decrementWeek
{
    if (--self.week < 1)
    {
        self.year--;
        int maxWeeksInYear = 52;
        if (self.year == 2015 || self.year == 2020 || self.year == 2026 || self.year == 2032 || self.year == 2037)
        {
            maxWeeksInYear = 53;
        }
        self.week = maxWeeksInYear;
    }
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
    
    // Get the current date to show along with its day and month components
    NSDate *currentDateToShow = [self.viewableDatesArray objectAtIndex:indexPath.row];
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
    if ([currentDateToShow isEqualToDate:[self.daysArray objectAtIndex:self.currentDayIndex]])
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

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

// User selected a day from the calendar
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentDayIndex = (int)[self.daysArray indexOfObject:[self.viewableDatesArray objectAtIndex:indexPath.row]];
    
    // Update the views
    [self updateAgendaViewBecauseSelectedDateChanged];
}

#pragma mark - Table view data source

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.daysArray count];
}

// Section header height is always the same
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

// Display the header (the date)
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate *headerDate = [self.daysArray objectAtIndex:section];
    NSString *headerText = [NSString stringWithFormat:@"     %@", [DateUtil getFormattedDateString:headerDate]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    headerLabel.text = headerText;
    headerLabel.backgroundColor = [UIColor lightGrayColor];
    headerLabel.textColor = [UIColor blueColor];
    headerLabel.font = [UIFont systemFontOfSize:12];
    
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"VariableHeightCell"];
    
    cell.textLabel.text = @"TESTING";
    
   
    
    NSArray *visableleRowsIndexPathArray = [NSArray arrayWithArray:[tableView indexPathsForVisibleRows]];
    NSIndexPath *firstIndexPath = [visableleRowsIndexPathArray firstObject];
    self.currentDayIndex = (int)firstIndexPath.section;
    
    // Update the calendarView because the selected date change
    if (self.lastAgendaViewDayIndex != self.currentDayIndex)
    {
        // Will need to update the week and year if the new selected date is not currently viewable
        NSDate *selectedDate = [self.daysArray objectAtIndex:self.currentDayIndex];
        
        BOOL isDate = NO;
        for (NSDate *checkDate in self.viewableDatesArray)
        {
            if ([selectedDate isEqualToDate:checkDate])
            {
                isDate = YES;
                break;
            }
        }
        // Selected date is not viewable
        if (!isDate)
        {
            // Update the new values of week and year
            self.week = (int)[DateUtil getWeekOfYearFromDate:selectedDate];
            self.year = (int)[DateUtil getYearFromDate:selectedDate];
            
            // The new day is less than the old one, so we need to go back an additional week
            if (self.currentDayIndex < self.lastAgendaViewDayIndex)
            {
                [self decrementWeek];
            }
        }
        [self updateCalendarViewBecauseSelectedDateChanged];
        self.lastAgendaViewDayIndex = self.currentDayIndex;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


