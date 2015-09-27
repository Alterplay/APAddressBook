//
//  APAddress.h
//  AddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAddress : NSObject

@property (nullable, nonatomic, readonly) NSString *street;
@property (nullable, nonatomic, readonly) NSString *city;
@property (nullable, nonatomic, readonly) NSString *state;
@property (nullable, nonatomic, readonly) NSString *zip;
@property (nullable, nonatomic, readonly) NSString *country;
@property (nullable, nonatomic, readonly) NSString *countryCode;

- (nonnull id)initWithAddressDictionary:(nonnull NSDictionary *)dictionary;

@end
