//
//  WeatherModel.m
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "WeatherModel.h"

@implementation IndexData

@synthesize title, zs, tipt, des;

-(id) initWithDict:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.title = [dict objectForKey:@"title"];
        self.zs = [dict objectForKey:@"zs"];
        self.tipt = [dict objectForKey:@"tipt"];
        self.des = [dict objectForKey:@"des"];
    }
    return self;
}

@end

@implementation WeatherData
@synthesize date, dayPictureUrl, nightPictureUrl, weather, wind, temperature;

-(id) initWithDict:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.date = [dict objectForKey:@"date"];
        self.dayPictureUrl = [dict objectForKey:@"dayPictureUrl"];
        self.nightPictureUrl = [dict objectForKey:@"nightPictureUrl"];
        self.weather = [dict objectForKey:@"weather"];
        self.wind = [dict objectForKey:@"wind"];
        self.temperature = [dict objectForKey:@"temperature"];
    }
    return self;
}

@end

@implementation WeatherModel

@synthesize currentCity, pm25, indexArray, weather_data;

-(id) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        self.currentCity = [dict objectForKey:@"currentCity"];
        self.pm25 = [dict objectForKey:@"pm25"];
        
        self.indexArray = [[NSMutableArray alloc] init];
        NSArray* array0 = [dict objectForKey:@"index"];
        for (NSDictionary* obj in array0) {
            IndexData* indexData = [[IndexData alloc] initWithDict:obj];
            [self.indexArray addObject:indexData];
        }
        
        self.weather_data = [[NSMutableArray alloc] init];
        NSArray* array1 = [dict objectForKey:@"weather_data"];
        for (NSDictionary* obj in array1) {
            WeatherData* weatherData = [[WeatherData alloc] initWithDict:obj];
            [self.weather_data addObject:weatherData];
        }
    }
    return self;
}
@end
