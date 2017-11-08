//
//  QuestionTableViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "QuestionTableViewController.h"

@interface QuestionTableViewController ()

@property (weak, nonatomic) UILabel *errorLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property NSArray *questions;

@end

@implementation QuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questions = [[NSArray alloc] init];
    
    [self setupActivityIndicator];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self getData];
    [self setupRefresher];
}

-(void)setupActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = activityIndicator;
    self.activityIndicator.alpha = 1.0;
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2 - (self.tableView.frame.size.height * .15));
    [self.activityIndicator startAnimating];
}

#pragma mark - Table view methods

-(void)setupTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"question"];
}

-(void)setupRefresher {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor  = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getData)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)scrollToTop
{
    UITableView *tableView = self.tableView;
    UIEdgeInsets tableInset = tableView.contentInset;
    [tableView setContentOffset:CGPointMake(- tableInset.left, - tableInset.top)
                       animated:YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self scrollToTop];
}

-(void)setupTableViewErrorLabel:(BOOL)error withData:(NSArray *)data andWithWeakSelf:(QuestionTableViewController *)weakSelf {
    NSString *message = @"";
    
    if (error) {
        message = @"Error, try again!";
    }
    else if ([data count] == 0) {
        message = @"Tap the icon in the top right corner to ask a question!";
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
    return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question" forIndexPath:indexPath];
    
    Question *question = self.questions[indexPath.row];
    if (question.answerTime == nil) {
        cell.statusLabel.text = @"Not Answered";
        cell.statusLabel.textColor = [UIColor colorWithRed:255/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    }
    else {
        cell.statusLabel.text = @"Answered";
        cell.statusLabel.textColor = [UIColor colorWithRed:80/255.0 green:192.0/255.0 blue:203.0/255.0 alpha:1];
    }
    
    cell.timestampLabel.text = [question.questionTime formattedDateString];
    
    return cell;
}

-(void)getData {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId == nil) {
        [self setupTableViewErrorLabel:YES withData:@[] andWithWeakSelf:self];
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    [[HackATLAPI sharedManager] getQuestions: userId completionHandler:^(NSArray *questions, BOOL error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            if (weakSelf.refreshControl) {
                [weakSelf.refreshControl endRefreshing];
            }
            
            [weakSelf setupTableViewErrorLabel:error withData: questions andWithWeakSelf:weakSelf];
            weakSelf.questions = questions;
            [weakSelf.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toAnswer" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toAnswer"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AnswerViewController *destViewController = segue.destinationViewController;
        destViewController.question = [self.questions objectAtIndex:indexPath.row];
    }
}


@end
