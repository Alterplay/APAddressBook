//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhoneWithLabel : NSObject

@property (nullable, nonatomic, strong) NSString *phone;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;
@property (nullable, nonatomic, readonly) NSString *label __attribute__((deprecated("Use 'localizedLabel' instead")));

@end
