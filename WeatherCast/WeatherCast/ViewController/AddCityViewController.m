//
//  AddCityViewController.m
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AddCityViewController.h"

@interface AddCityViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneItemBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItemBar;
@end

@implementation AddCityViewController

@synthesize cityName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender != self.doneItemBar) {
        return;
    }
    else{
        self.cityName = self.cityTextField.text;
    }
}


@end
