//
//  APAddress.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAddress : NSObject

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;

@end
