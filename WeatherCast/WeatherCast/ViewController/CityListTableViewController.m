//
//  CityListTableViewController.m
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "CityListTableViewController.h"
#import "AddCityViewController.h"
#import "WeatherModel.h"
#import "ConstDef.h"
#import "SBJson4.h"
#import "AFNetworking.h"
#import "SVPullToREfresh.h"

#define COLOR_BEE_THEME [UIColor colorWithRed:74.0/255 green:189.0f/255 blue:204.0f/255 alpha:1.0]

@interface CityListTableViewController ()
{
    NSMutableArray* cityArray;
    NSMutableDictionary* weatherInfoDict;
}
@end

@implementation CityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cityArray = [[NSMutableArray alloc] init];
    weatherInfoDict = [[NSMutableDictionary alloc] init];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = COLOR_BEE_THEME;
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.barTintColor = COLOR_BEE_THEME;
    }
    
    //TODO 读取已经存储的城市
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refreshWeatherData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
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
    cell.textLabel.text = [cityArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    WeatherModel* weatherModel = [weatherInfoDict objectForKey:[cityArray objectAtIndex:indexPath.row]];
    WeatherData* data = ((WeatherData*)[weatherModel.weather_data objectAtIndex:0]);
    if(data){
        
        NSString *strData = [NSString stringWithFormat:@"%@  %@  %@", data.weather, data.temperature, data.wind];
       cell.detailTextLabel.text = strData;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)popForSegue:(UIStoryboardSegue *)segue {
    AddCityViewController* addCityVC = (AddCityViewController*)[segue sourceViewController];
    
    if(addCityVC && addCityVC.cityName && ![addCityVC.cityName isEqual:@""]){
        // 存储城市
        [cityArray addObject:addCityVC.cityName];
        
        [self refreshWeatherData];
    }
}

-(BOOL) refreshWeatherData {
    
    [self requestData];

    return YES;
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
@end
