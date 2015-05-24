//
//  WeatherModel.h
//  WeatherCast
//
//  Created by long on 15/5/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndexData : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* zs;
@property (nonatomic, strong) NSString* tipt;
@property (nonatomic, strong) NSString* des;

-(id) initWithDict:(NSDictionary*) dict;
@end

@interface WeatherData : NSObject

@property (nonatomic, strong) NSString* date;
@property (nonatomic, strong) NSString* dayPictureUrl;
@property (nonatomic, strong) NSString* nightPictureUrl;
@property (nonatomic, strong) NSString* weather;
@property (nonatomic, strong) NSString* wind;
@property (nonatomic, strong) NSString* temperature;

-(id) initWithDict:(NSDictionary*) dict;
@end

@interface WeatherModel : NSObject

@property (nonatomic, strong) NSString* currentCity;
@property (nonatomic, strong) NSString* pm25;
@property (nonatomic, strong) NSMutableArray* indexArray;
@property (nonatomic, strong) NSMutableArray* weather_data;

-(id) initWithDict:(NSDictionary*)dict;

@end
