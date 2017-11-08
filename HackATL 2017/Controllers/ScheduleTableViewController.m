//
//  ScheduleTableViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/27/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "ScheduleTableViewController.h"

@interface ScheduleTableViewController ()

@property (weak, nonatomic) UILabel *errorLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property NSMutableDictionary *schedule;
@property NSMutableArray *sections;

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.schedule = [[NSMutableDictionary alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    
    [self setupActivityIndicator];
    [self setupTableView];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 76;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTableViewCell" bundle:nil] forCellReuseIdentifier:@"event"];
}

-(void)setupActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = activityIndicator;
    self.activityIndicator.alpha = 1.0;
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2 - (self.tableView.frame.size.height * .15));
    [self.activityIndicator startAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.schedule count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.schedule[self.sections[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sections[section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, tableView.frame.size.width, 18)];
    label.textColor = [UIColor colorWithRed:80/255.0 green:192.0/255.0 blue:203.0/255.0 alpha:1];
    [view setOpaque:YES];
    [label setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]];
    NSString *string = self.sections[section];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"event" forIndexPath:indexPath];
    
    Event *event = self.schedule[self.sections[indexPath.section]][indexPath.row];
    
    cell.eventNameLabel.text = event.title;
    cell.locationNameLabel.text = event.locationName;
    cell.startTimeLabel.text = [event.startTime formattedTimeString];
    cell.endTimeLabel.text = [event.endTime formattedTimeString];
    
    return cell;
}

-(void)setupTableViewErrorLabel:(BOOL)error withData:(NSArray *)data andWithWeakSelf:(ScheduleTableViewController *)weakSelf {
    NSString *message = @"";
    
    if (error) {
        message = @"Error, try again!";
    }
    else if ([data count] == 0) {
        message = @"No events scheduled!";
    }
    
    if(!weakSelf.tableView.backgroundView){
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height)];
        weakSelf.errorLabel = errorLabel;
        weakSelf.errorLabel.textColor = [UIColor blackColor];
        weakSelf.errorLabel.numberOfLines = 0;
        weakSelf.errorLabel.textAlignment = NSTextAlignmentCenter;
        weakSelf.errorLabel.font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightMedium];
        [weakSelf.errorLabel sizeToFit];
        weakSelf.tableView.backgroundView = weakSelf.errorLabel;
    }
    
    weakSelf.errorLabel.text = message;
}

-(void)getData {
    __weak __typeof__(self) weakSelf = self;
    
    [[HackATLAPI sharedManager] getSchedule:^(NSArray *events, BOOL error){
        dispatch_async(dispatch_get_main_queue(), ^{
            ScheduleTableViewController *selfRef = weakSelf;
            [selfRef.activityIndicator stopAnimating];
            [selfRef setupTableViewErrorLabel:error withData: events andWithWeakSelf:selfRef];
            [selfRef setupData:events controller:selfRef];
            [selfRef.tableView reloadData];
        });
    }];
}

-(void)setupData:(NSArray *)data controller:(ScheduleTableViewController *)controller {
    controller.sections = nil;
    controller.schedule = nil;
    controller.sections = [[NSMutableArray alloc] init];
    controller.schedule = [[NSMutableDictionary alloc] init];
    
    for(Event *event in data) {
        NSString *section = [event.startTime formalDateString];
        
        if([controller.schedule objectForKey:section]) {
            [controller.schedule[section] addObject:event];
        }
        else {
            [controller.sections addObject:section];
            [controller.schedule setObject:[[NSMutableArray alloc] initWithArray:@[event]] forKey:section];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
