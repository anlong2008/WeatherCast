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

#define COLOR_BEE_THEME [UIColor colorWithRed:74.0/255 green:189.0f/255 blue:204.0f/255 alpha:1.0]

@interface CityListTableViewController ()
{
    NSMutableArray      * cityArray;
    NSMutableDictionary * weatherInfoDict;
    FMDatabase          * database;
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
    //
    database = [[FMDatabase alloc] initWithPath:@"/tmp/weather.db"];
    if ([database open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS CUSTOMER_CITY (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)";
        
        FMResultSet *result = [database executeQuery:sqlCreateTable];
        if (nil == result) {
            NSLog(@"创建表出错");
            return;
        }
        // 读取已经存在的城市
        NSString *sqlQuery = @"SELECT * FROM CUSTOMER_CITY";
        FMResultSet *rs = [database executeQuery:sqlQuery];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            if (name) {
                [cityArray addObject:name];
            }
        }
    }
    __block id that = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [that refreshWeatherData];
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
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    NSString *cityName = [cityArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImageUtil imageFromText:cityName withFont:20.0f withColor:[UIColor whiteColor]];
    image = [UIImage createRoundedRectImage:image size:CGSizeMake(25, 25) radius:12.5f];
    cell.imageView.image = image;
    cell.textLabel.text = cityName;
    
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
    return 50.0f;
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

}

-(BOOL) refreshWeatherData {
    
    [self requestData];

    return YES;
}

- (IBAction)addCity:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    locateView.backgroundColor = COLOR_BEE_THEME;
    [locateView showInView:self.tableView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NSLog(@"Select");
        [cityArray addObject:location.city];
        [self refreshWeatherData];
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
