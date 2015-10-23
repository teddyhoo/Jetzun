//
//  CalendarViewController.m
//  Example
//
//  Created by Ted Hooban on 10/2/15.
//  Copyright © 2015 Jonathan Tribouharet. All rights reserved.
//

#import "CalendarViewController.h"
#import "ReservationDetails.h"
#import "ReservationTableCell.h"
#import "MGSwipeButton.h"

@interface CalendarViewController () {
    
    NSMutableDictionary *eventsByDate;
    NSMutableArray *theVisitData;
    NSMutableArray *displayVisitData;
}

@end

BOOL startDateTouch;
BOOL endDateTouch;
typedef void(^ClientActionCallback)(BOOL cancelled, BOOL deleted, NSInteger actionIndex);
@implementation CalendarViewController
{
    ClientActionCallback actionCallback;
    UIRefreshControl * refreshControl;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    eventsByDate = [NSMutableDictionary new];
    
    NSString *pListData = [[NSBundle mainBundle]
                           pathForResource:@"EventAppointments"
                           ofType:@"plist"];
    
    _reservationData = [[NSMutableArray alloc]initWithContentsOfFile:pListData];
    
    
    _reservationsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    _reservationsTable.dataSource = self;
    _reservationsTable.delegate = self;
    
    [self.view addSubview:_reservationsTable];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.0;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIImageView *headerBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [headerBack setImage:[UIImage imageNamed:@"light-blue-box"]];
    [view addSubview:headerBack];
    UILabel *appointmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 40)];
    [appointmentLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:18]];
    [appointmentLabel setText:@"My Reservations"];
    [view addSubview:appointmentLabel];
    
    return view;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [_reservationData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void) deleteMail:(NSIndexPath *) indexPath
{
    [_reservationsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"MailCell";
    
    ReservationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.driverImage setImage:nil];
    
    if (!cell) {
        cell = [[ReservationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.driverImage setImage:nil];
        
    }
    NSDictionary *visitDetails = [_reservationData objectAtIndex:indexPath.row];
    
    cell.driverName.text = [visitDetails objectForKey:@"DriverName"];
    cell.dateOfRide.text = [visitDetails objectForKey:@"ReservationDate"];
    cell.startLocation.text = [visitDetails objectForKey:@"PickupLocationAddr"];
    cell.endLocation.text = [visitDetails objectForKey:@"DropoffLocationAddr"];
    
    if ([[visitDetails objectForKey:@"DriverName"]isEqualToString:@"Ismail B."]) {
        
        [cell.driverImage setImage:[UIImage imageNamed:@"avatar-1"]];
        
    } else if ([[visitDetails objectForKey:@"DriverName"]isEqualToString:@"Susie G."]) {
        
        [cell.driverImage setImage:[UIImage imageNamed:@"avatar-2"]];
    } else {
        [cell.driverImage setImage:[UIImage imageNamed:@"avatar-3"]];
    }
    
    [cell.contentView addSubview:cell.driverImage];
    cell.dateDay.text = [visitDetails objectForKey:@"ReservationDayOfWeek"];
    cell.dateNumber.text = [visitDetails objectForKey:@"ReservationDay"];
    cell.timeOfDay.text = [visitDetails objectForKey:@"ReservationTime"];
    cell.eventName.text = [visitDetails objectForKey:@"ReservationEventName"];
    cell.tripCost.text = [visitDetails objectForKey:@"TripCost"];
    
    
    return cell;
    
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSDictionary*) clientInfoForIndexPath:(NSIndexPath *)path {
    
    return [_reservationData objectAtIndex:path.row];
    
}
-(NSString *) readButtonText:(BOOL) read
{
    return read ? @"Not Arrive" :@"Arrived";
}

-(NSString *) readButtonText2:(BOOL) read
{
    return read ? @"Not Complete" :@"Complete";
}

-(void) updateCellIndicator:(NSDictionary*)visitStatus cell:(ReservationTableCell *)cell {
    
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    __weak CalendarViewController* me = self;
    
    NSDictionary *mail = [me clientInfoForIndexPath:[self.reservationsTable indexPathForCell:cell]];
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        return @[[MGSwipeButton buttonWithTitle:[me readButtonText:@"YES"]
                                backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0]
                                        padding:5
                                       callback:^BOOL(MGSwipeTableCell *sender) {
                                           
                                           
                                           [me updateCellIndicator:mail cell:(ReservationTableCell*)sender];
                                           [cell refreshContentView];
                                           
                                           [(UIButton*)[cell.leftButtons objectAtIndex:0]setTitle:[me readButtonText:@"YES"]
                                                                                         forState:UIControlStateNormal];
                                           
                                           return YES;
                                           
                                       }]];
        
    } else if (direction == MGSwipeDirectionRightToLeft) {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        return @[[MGSwipeButton buttonWithTitle:[me readButtonText2:@"YES"]
                                backgroundColor:[UIColor greenColor]
                                        padding:5
                                       callback:^BOOL(MGSwipeTableCell *sender) {
                                           
                                           [me updateCellIndicator:mail cell:(ReservationTableCell*)sender];
                                           [cell refreshContentView];
                                           
                                           [(UIButton*)[cell.leftButtons objectAtIndex:0]setTitle:[me readButtonText2:@"YES"]
                                                                                         forState:UIControlStateNormal];
                                           
                                           return YES;
                                           
                                       }]];
    }
    
    return nil;
    
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

