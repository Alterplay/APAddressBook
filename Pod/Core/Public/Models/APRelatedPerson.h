//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRelatedPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *originalLabel;
@property (nonatomic, strong) NSString *localizedLabel;

@end
