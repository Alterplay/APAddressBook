//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhoneWithLabel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *originalLabel;
@property (nonatomic, strong) NSString *localizedLabel;
@property (nonatomic, readonly) NSString *label __attribute__((deprecated("Use 'localizedLabel' instead")));

@end
