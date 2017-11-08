//
//  MapViewController.m
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) UILabel *errorLabel;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupScrollView];
    [self setupActivityIndicator];
    [self getImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupScrollView {
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.mapView.frame.size;
    self.mapView.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollView.delegate = self;
}

-(void)setupActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = activityIndicator;
    self.activityIndicator.alpha = 1.0;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
}

-(void)getImage {
    __weak __typeof__(self) weakSelf = self;
    [self.activityIndicator startAnimating];
    [[HackATLAPI sharedManager] getMapImage:^(NSString *url, BOOL error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf.activityIndicator setHidden:YES];
            if (error) {
                [weakSelf showAlert:@"Error" subTitle:@"Map image failed to load, try again!" dismiss:YES controller:weakSelf];
                return;
            }
            NSLog(@"%@", url);
            [weakSelf.mapView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        });
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapView;
}

-(void)showAlert:(NSString *)title subTitle:(NSString *)subTitle dismiss:(BOOL)dismiss controller:(MapViewController *)controller {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
