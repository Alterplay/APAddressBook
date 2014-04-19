//
//  APAddress.h
//  AddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAddress : NSObject

@property (nonatomic, readonly) NSString *street;
@property (nonatomic, readonly) NSString *city;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, readonly) NSString *zip;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *countryCode;

- (id)initWithAddressDictionary:(NSDictionary *)dictionary;

@end
