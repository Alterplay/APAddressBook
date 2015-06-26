//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPhoneWithLabel : NSObject

@property (nonnull, nonatomic, readonly) NSString *phone;
@property (nullable, nonatomic, readonly) NSString *originalLabel;
@property (nullable, nonatomic, readonly) NSString *localizedLabel;
@property (nullable, nonatomic, readonly) NSString *label __attribute__((deprecated("Use 'localizedLabel' instead")));

- (nonnull id)initWithPhone:(nonnull NSString *)phone originalLabel:(nullable NSString *)originalLabel localizedLabel:(nullable NSString *)localizedLabel;

@end
