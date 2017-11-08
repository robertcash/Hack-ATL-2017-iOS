//
//  CreateQuestionViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "CreateQuestionViewController.h"

@interface CreateQuestionViewController ()

@end

@implementation CreateQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.questionTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(NSString *)title subTitle:(NSString *)subTitle dismiss:(BOOL)dismiss controller:(CreateQuestionViewController *)controller {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:subTitle
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction;
    if (dismiss) {
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [controller dismissViewControllerAnimated:YES completion:^{}];}];
    }
    else {
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {}];
    }
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBAction methods

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)send:(id)sender {
    if ([self.questionTextView.text length] == 0) {
        [self showAlert:@"Error" subTitle:@"Please write a question before sending!" dismiss:NO controller:self];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] == nil) {
        [self showAlert:@"Error" subTitle:@"Try again later!" dismiss:NO controller:self];
        return;
    }
    self.sendButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
    Question *question = [[Question alloc] init];
    question.question = self.questionTextView.text;
    
    __weak __typeof__(self) weakSelf = self;
    
    [[HackATLAPI sharedManager] createQuestion:question completionHandler:^(BOOL error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CreateQuestionViewController *selfRef = weakSelf;
            if (error) {
                [selfRef showAlert:@"Error" subTitle:@"Please try again!" dismiss:NO controller:selfRef];
                return;
            }
            [selfRef showAlert:@"Success" subTitle:@"Question sent!" dismiss:YES controller:selfRef];
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
