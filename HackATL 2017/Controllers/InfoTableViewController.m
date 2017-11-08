//
//  InfoTableViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@property (weak, nonatomic) UILabel *errorLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property NSArray *info;

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.info = [[NSArray alloc] init];
    [self setupTableView];
    [self setNavBarTitle];
    [self setupActivityIndicator];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle {
    if ([self.infoType isEqualToString:@"rounds"]) {
        self.navigationItem.title = @"General Round Info";
    }
    else if ([self.infoType isEqualToString:@"random"]) {
        self.navigationItem.title = @"Random";
    }
    else if ([self.infoType isEqualToString:@"sponsors"]) {
        self.navigationItem.title = @"Sponsors";
    }
    else if ([self.infoType isEqualToString:@"activities"]) {
        self.navigationItem.title = @"Activities";
    }
    else if ([self.infoType isEqualToString:@"food"]) {
        self.navigationItem.title = @"Food";
    }
}

-(void)setupActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = activityIndicator;
    self.activityIndicator.alpha = 1.0;
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2 - (self.tableView.frame.size.height * .10));
}

#pragma mark - Table view methods

-(void)setupTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 109;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"info"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.info count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Info *info = self.info[indexPath.row];
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
    cell.headerLabel.text = info.title;
    cell.contentLabel.text = info.content;
    
    return cell;
}

-(void)setupTableViewErrorLabel:(BOOL)error withData:(NSArray *)data andWithWeakSelf:(InfoTableViewController *)weakSelf {
    NSString *message = @"";
    
    if (error) {
        message = @"Error, try again!";
    }
    else if ([data count] == 0) {
        message = @"No info yet!";
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
    [self.activityIndicator startAnimating];
    [[HackATLAPI sharedManager] getInfo:self.infoType completionHandler:^(NSArray *info, BOOL error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf setupTableViewErrorLabel:error withData: info andWithWeakSelf:weakSelf];
            weakSelf.info = info;
            [weakSelf.tableView reloadData];
        });
    }];
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
