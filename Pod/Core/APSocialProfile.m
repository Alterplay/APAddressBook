//
//  APSocialContact.m
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "APSocialProfile.h"
#import <AddressBook/AddressBook.h>

@interface APSocialProfile ()
@property (nonatomic, readwrite) APSocialNetworkType socialNetwork;
@property (nonatomic, readwrite) NSString *username;
@property (nonatomic, readwrite) NSString *userIdentifier;
@property (nonatomic, readwrite) NSURL *url;
@end

@implementation APSocialProfile

#pragma mark - life cycle

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary
{
    
    if (self = [super init])
    {
        NSString *urlKey = (__bridge_transfer NSString *)kABPersonSocialProfileURLKey;
        NSString *usernameKey = (__bridge_transfer NSString *)kABPersonSocialProfileUsernameKey;
        NSString *userIdKey = (__bridge_transfer NSString *)kABPersonSocialProfileUserIdentifierKey;
        NSString *serviceKey = (__bridge_transfer NSString *)kABPersonSocialProfileServiceKey;
        _url = [NSURL URLWithString:dictionary[urlKey]];
        _username = dictionary[usernameKey];
        _userIdentifier = dictionary[userIdKey];
        _socialNetwork = [self socialNetworkTypeFromString:dictionary[serviceKey]];
    }
    
    return self;
}

#pragma mark - private

- (APSocialNetworkType)socialNetworkTypeFromString:(NSString *)string
{
    if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFacebook])
    {
        return APSocialNetworkFacebook;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceTwitter])
    {
        return APSocialNetworkTwitter;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceLinkedIn])
    {
        return APSocialNetworkLinkedIn;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFlickr])
    {
        return APSocialNetworkFlickr;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceGameCenter])
    {
        return APSocialNetworkGameCenter;
    }
    else
    {
        return APSocialNetworkUnknown;
    }
}

@end
