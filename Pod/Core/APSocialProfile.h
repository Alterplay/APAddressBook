//
//  APSocialContact.h
//  SyncBook
//
//  Created by David on 2014-08-01.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(u_int, APSocialNetwork) {
    APSocialNetwork_Unknown,
    
    APSocialNetwork_Facebook,
    APSocialNetwork_Twitter,
    APSocialNetwork_LinkedIn
};

@interface APSocialProfile : NSObject

@property (nonatomic, readonly) APSocialNetwork socialNetwork;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *userIdentifier;
@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithSocialDictionary:(NSDictionary *)dictionary;

@end
