//
//  InfoDirectoryViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "InfoDirectoryViewController.h"

@interface InfoDirectoryViewController ()

@end

@implementation InfoDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        [self performSegueWithIdentifier:@"toInfo" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        InfoTableViewController *destViewController = segue.destinationViewController;
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    destViewController.infoType = @"rounds";
                    break;
                case 1:
                    destViewController.infoType = @"sponsors";
                    break;
                case 2:
                    destViewController.infoType = @"random";
                    break;
                default:
                    break;
            }
        }
        else {
            switch (indexPath.row) {
                case 0:
                    destViewController.infoType = @"activities";
                    break;
                case 1:
                    destViewController.infoType = @"food";
                    break;
                default:
                    break;
            }
        }
    }
}


@end
