//
//  AnnoucementsTableViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/5/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "AnnoucementsTableViewController.h"

@interface AnnoucementsTableViewController ()

@property (weak, nonatomic) UILabel *errorLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property NSArray *annoucements;

@end

@implementation AnnoucementsTableViewController

#pragma mark - ViewController Setup Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.annoucements = [[NSArray alloc] init];
    [self setupActivityIndicator];
    [self setupTableView];
}

-(void)setupActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = activityIndicator;
    self.activityIndicator.alpha = 1.0;
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2 - (self.tableView.frame.size.height * .15));
    [self.activityIndicator startAnimating];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getData];
    [self setupRefresher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

-(void)setupTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 76;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnoucementTableViewCell" bundle:nil] forCellReuseIdentifier:@"annoucement"];
}

-(void)setupRefresher {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor  = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getData)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)setupTableViewErrorLabel:(BOOL)error withData:(NSArray *)data andWithWeakSelf:(AnnoucementsTableViewController *)weakSelf {
    NSString *message = @"";
    
    if (error) {
        message = @"Error, try again!";
    }
    else if ([data count] == 0) {
        message = @"No announcements!";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.annoucements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnoucementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"annoucement" forIndexPath:indexPath];
    
    Annoucement *annoucement = self.annoucements[indexPath.row];
    cell.senderLabel.text = annoucement.sender;
    cell.contentLabel.text = annoucement.content;
    cell.timeLabel.text = [annoucement.timeSent createTimestamp];
    
    return cell;
}

-(void)getData {
    __weak __typeof__(self) weakSelf = self;
    
    [[HackATLAPI sharedManager] getAnnoucements:^(NSArray *annoucements, BOOL error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AnnoucementsTableViewController *selfRef = weakSelf;
            [selfRef.activityIndicator stopAnimating];
            if (selfRef.refreshControl) {
                [selfRef.refreshControl endRefreshing];
            }
            
            [selfRef setupTableViewErrorLabel:error withData: annoucements andWithWeakSelf: selfRef];
            selfRef.annoucements = annoucements;
            [selfRef.tableView reloadData];
        });
    }];
}

@end
