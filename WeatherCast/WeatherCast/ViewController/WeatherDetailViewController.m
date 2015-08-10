//
//  WeatherDetailViewController.m
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "PNChart.h"
#import "IndexView.h"
#import "UIFunction.h"

@interface WeatherDetailViewController ()
@property (strong, nonatomic) UIScrollView *chartScrollView;
@end

@implementation WeatherDetailViewController
@synthesize chartScrollView;
@synthesize weatherModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [UIFunction navgationLabel:self.weatherModel.currentCity];
    
    chartScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //Add LineChart
    
    PNChart * lineChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 10.0, SCREEN_WIDTH, 130.0)];
    lineChart.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *arrayData = [NSMutableArray arrayWithCapacity:weatherModel.weather_data.count];
    NSMutableArray *arrayDate = [NSMutableArray arrayWithCapacity:weatherModel.weather_data.count];
    
    for (WeatherData* data in weatherModel.weather_data) {
        
        NSString * strNumber = [[data.temperature componentsSeparatedByString:@" ~ "] firstObject];
        
        NSNumber *number1 = [NSNumber numberWithInt:strNumber.intValue];
        
        [arrayData addObject:number1];
        [arrayDate addObject:[[data.date componentsSeparatedByString:@" "] firstObject]];
        
    }
    [lineChart setXLabels:arrayDate];
    [lineChart setYValues:arrayData];
    [lineChart strokeChart];

    [self.chartScrollView addSubview:lineChart];
    
    [self.view addSubview:chartScrollView];
    
    IndexView *indexView0 = [[IndexView alloc] initWithFrame:CGRectMake(10, 210, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:0]];
    IndexView *indexView1 = [[IndexView alloc] initWithFrame:CGRectMake(20 + indexView0.frame.size.width, 210, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:1]];
    IndexView *indexView2 = [[IndexView alloc] initWithFrame:CGRectMake(10, 300, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:2]];
    IndexView *indexView3 = [[IndexView alloc] initWithFrame:CGRectMake(20 + indexView0.frame.size.width, 300, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:3]];
    
    IndexView *indexView4 = [[IndexView alloc] initWithFrame:CGRectMake(10, 390, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:4]];
    IndexView *indexView5 = [[IndexView alloc] initWithFrame:CGRectMake(20 + indexView0.frame.size.width, 390, (self.view.frame.size.width -20 )/2 - 5, 80.0f) indexData:[weatherModel.indexArray objectAtIndex:5]];

    [self.view addSubview:indexView0];
    [self.view addSubview:indexView1];
    [self.view addSubview:indexView2];
    [self.view addSubview:indexView3];
    [self.view addSubview:indexView4];
    [self.view addSubview:indexView5];
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
