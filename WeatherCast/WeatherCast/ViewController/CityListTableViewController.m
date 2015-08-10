//
//  CityListTableViewController.m
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "CityListTableViewController.h"
#import "WeatherModel.h"
#import "ConstDef.h"
#import "SBJson4.h"
#import "AFNetworking.h"
#import "SVPullToREfresh.h"
#import "FMDB.h"
#import "TSLocateView.h"
#import "UIImageUtil.h"
#import "UIImage+wiRoundedRectImage.h"
#import "UIFunction.h"
#import "JXBAdPageView.h"
#import "WeatherDetailViewController.h"

#define COLOR_BEE_THEME [UIColor colorWithRed:74.0f/255 green:189.0f/255 blue:204.0f/255 alpha:1.0]

@interface CityListTableViewController ()
{
    NSMutableArray      * cityArray;
    NSMutableDictionary * weatherInfoDict;
    FMDatabase          * database;
    CLLocationManager *locationManager;
    JXBAdPageView       *scrollView;
}

@end

@implementation CityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cityArray       = [[NSMutableArray alloc] init];
    weatherInfoDict = [[NSMutableDictionary alloc] init];
    
    [self setNavigationBar];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];

    scrollView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    scrollView.iDisplayTime = 0;
    [scrollView startAdsWithBlock:@[@"m1",@"m2",@"m3",@"m4",@"m5"] block:^(NSInteger clickIndex){
        NSLog(@"%d",(int)clickIndex);
    }];
//    [self.view addSubview:scrollView];
    
    cityArray = [[NSMutableArray alloc] init];
    weatherInfoDict = [[NSMutableDictionary alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = COLOR_BEE_THEME;
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.barTintColor = COLOR_BEE_THEME;
    }
    
    NSLog(@"path:%@", [NSBundle mainBundle].resourcePath);
    //
    NSString *strPath = [NSString stringWithFormat:@"%@/tmp/weather.db", NSHomeDirectory()];
    NSLog(@"strPath: %@", strPath);
    database = [[FMDatabase alloc] initWithPath:strPath];
    if ([database open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS custom_city (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)";
        BOOL result = [database executeUpdate:sqlCreateTable];
        if (NO == result) {
            NSLog(@"创建表出错");
            return;
        }
        // 读取已经存在的城市
        NSString *sqlQuery = @"SELECT * FROM custom_city";
        FMResultSet *rs = [database executeQuery:sqlQuery];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            if (name) {
                [cityArray addObject:name];
            }
        }
    }
    [self refreshWeatherData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = COLOR_BEE_THEME;
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.barTintColor = COLOR_BEE_THEME;
    }
    
    self.navigationItem.titleView = [UIFunction navgationLabel:@"城市列表"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuserIdentifier = @"reuse_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    NSString *cityName = [cityArray objectAtIndex:indexPath.row];
//    UIImage *image = [UIImageUtil imageFromText:cityName withFont:20.0f withColor:[UIColor whiteColor]];
//    image = [UIImage createRoundedRectImage:image size:CGSizeMake(30, 30) radius:15.0f];
    
    cell.textLabel.text = cityName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    WeatherModel* weatherModel = [weatherInfoDict objectForKey:[cityArray objectAtIndex:indexPath.row]];
    WeatherData* data = ((WeatherData*)[weatherModel.weather_data objectAtIndex:indexPath.section]);
    if(data){
        NSString *strData = [NSString stringWithFormat:@"%@  %@  %@", data.weather, data.temperature, data.wind];
        
        if ([data.weather isEqualToString:@"晴"]) {
            cell.imageView.image = [UIImage imageNamed:@"sunny.png"];
        }else if([data.weather isEqualToString:@"晴转多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy3.png"];
        }else if([data.weather isEqualToString:@"多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy5.png"];
        }else if([data.weather isEqualToString:@"多云转晴"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy1.png"];
        }else if([data.weather isEqualToString:@"中雨转大雨"]) {
            cell.imageView.image = [UIImage imageNamed:@"shower3.png"];
        }else if([data.weather isEqualToString:@"雷阵雨转多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"tstorm3.png"];
        }else if([data.weather isEqualToString:@"多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy2.png"];
        }else if([data.weather isEqualToString:@"多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy2.png"];
        }else if([data.weather isEqualToString:@"多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy2.png"];
        }else if([data.weather isEqualToString:@"多云"]) {
            cell.imageView.image = [UIImage imageNamed:@"cloudy2.png"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"shower3.png"];
        }
        
       cell.detailTextLabel.text = strData;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WeatherDetailViewController *detailInfo = [[WeatherDetailViewController alloc] init];
    detailInfo.weatherModel = [weatherInfoDict valueForKey:[cityArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailInfo animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // 删除数据库 delete from custom_city where name=
        BOOL result = [database executeUpdate:@"delete from custom_city where name=?", [cityArray objectAtIndex:indexPath.row]];
        [cityArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = nil;
    if (weatherInfoDict && cityArray.count > 0) {
        WeatherModel *model = [weatherInfoDict valueForKey:[cityArray objectAtIndex:0]];
        
        if (model) {
            view = [UIFunction tableViewHeaderViewLabel:((WeatherData *)[model.weather_data objectAtIndex:section]).date frame:CGRectMake(0, 0, WIDTH_SCREEN, 40.0f) fontsize:18.0f textColor:[UIColor whiteColor]];
            view.backgroundColor = [UIColor grayColor];
            view.alpha = 0.8f;
        }
    }
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)popForSegue:(UIStoryboardSegue *)segue {

}

-(BOOL) refreshWeatherData {
    
    [self requestData];
    [self.tableView reloadData];

    return YES;
}

- (IBAction)addCity:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"城市选择" delegate:self];
    locateView.backgroundColor = COLOR_BEE_THEME;
    [locateView showInView:self.tableView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        [cityArray addObject:location.city];
        [self refreshWeatherData];
        // 在数据库中添加
        [database executeUpdate:@"INSERT INTO custom_city (name) VALUES (?)", location.city];
    }
}

-(void) requestData {
    
    NSMutableString* strCitys = [[NSMutableString alloc] init];
    for ( NSInteger i = 0; i < [cityArray count]; i ++ ) {
        [strCitys appendString:[cityArray objectAtIndex:i]];
        if( i < ([cityArray count] - 1 )){
            [strCitys appendString:@"|"];
        }
    }
    
    if ([strCitys isEqual:@""]) {
        return;
    }
    
    NSString* url = URL_GET_WEATHER;
     NSDictionary *parameter=@{@"location": strCitys ,@"output": @"json",@"ak": @"vprRmjakEGo0ONk5kAVo5Gie", @"mcode": @"long.Weather"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"获取到的天气数据: %@", responseObject);
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray* array = responseObject;
            for (NSDictionary* dict in array) {
                NSArray* results = [dict objectForKey:@"results"];
                for (NSDictionary* dictCity in results) {
                    WeatherModel* weatherModel = [[WeatherModel alloc] initWithDict:dictCity];
                    [weatherInfoDict setObject:weatherModel forKey:weatherModel.currentCity];
                }
            }
        }else if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = responseObject;
            NSArray* results = [dict objectForKey:@"results"];
            for (NSDictionary* dictCity in results) {
                WeatherModel* weatherModel = [[WeatherModel alloc] initWithDict:dictCity];
                [weatherInfoDict setObject:weatherModel forKey:weatherModel.currentCity];
            }
        }
        else{
            
        }
        // refresh table view
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark Core Location委托方法用于实现位置的更新

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * currLocation = [locations lastObject];
    
    NSLog(@"%@", currLocation.description);
    
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"State"]);
            
            [cityArray addObject:[test objectForKey:@"State"]];
            [self refreshWeatherData];
            // 在数据库中添加
            [database executeUpdate:@"INSERT INTO custom_city (name) VALUES (?)", [test objectForKey:@"State"]];
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"error: %@",error);
    
}
@end
