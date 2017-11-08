//
//  AnswerViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [self.question.questionTime formattedDateString];
    
    self.questionLabel.text = self.question.question;
    [self.questionLabel sizeToFit];
    
    NSLog(@"%@", self.question.answer);
    if (self.question.answerTime != nil) {
        self.answerLabel.text = self.question.answer;
    }
    else {
        self.answerLabel.text = @"No answer yet!";
    }
    [self.answerLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
