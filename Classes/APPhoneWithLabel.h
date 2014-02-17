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
@property (nonatomic, readonly) NSString *label;

- (id)initWithPhone:(NSString *)phone label:(NSString *)label;

@end
