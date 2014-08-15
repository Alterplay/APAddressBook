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
@property (nonatomic, readwrite) APSocialNetwork socialNetwork;
@property (nonatomic, readwrite) NSString *username;
@property (nonatomic, readwrite) NSString *userIdentifier;
@property (nonatomic, readwrite) NSURL *url;
@end

@implementation APSocialProfile

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        
        _url = [NSURL URLWithString:dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileURLKey]];
        _username = dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileUsernameKey];
        _userIdentifier = dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileUserIdentifierKey];
        
        if ([dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileServiceKey] isEqualToString:@"facebook"])
            _socialNetwork = APSocialNetwork_Facebook;
        else if ([dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileServiceKey] isEqualToString:@"twitter"])
            _socialNetwork = APSocialNetwork_Twitter;
        else if ([dictionary[(__bridge_transfer NSString *)kABPersonSocialProfileServiceKey] isEqualToString:@"linkedin"])
            _socialNetwork = APSocialNetwork_LinkedIn;
        else
            _socialNetwork = APSocialNetwork_Unknown;
    }
    
    return self;
}


@end
