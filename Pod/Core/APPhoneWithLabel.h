//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhoneWithLabel : NSObject

@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *originalLabel;
@property (nonatomic, readonly) NSString *localizedLabel;
@property (nonatomic, readonly) NSString *label __attribute__((deprecated("Use 'localizedLabel' instead")));

- (id)initWithPhone:(NSString *)phone originalLabel:(NSString *)originalLabel localizedLabel:(NSString *)localizedLabel;

@end
