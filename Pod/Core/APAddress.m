//
//  APAddress.m
//  AddressBook
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APAddress.h"

@implementation APAddress

- (id)initWithAddressDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _street = dictionary[(__bridge NSString *)kABPersonAddressStreetKey];
        _city = dictionary[(__bridge NSString *)kABPersonAddressCityKey];
        _state = dictionary[(__bridge NSString *)kABPersonAddressStateKey];
        _zip = dictionary[(__bridge NSString *)kABPersonAddressZIPKey];
        _country = dictionary[(__bridge NSString *)kABPersonAddressCountryKey];
        _countryCode = dictionary[(__bridge NSString *)kABPersonAddressCountryCodeKey];
    }
    return self;
}

@end
