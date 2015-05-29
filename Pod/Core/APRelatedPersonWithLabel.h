//
//  APPhoneWithLabel.h
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRelatedPersonWithLabel : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *originalLabel;
@property (nonatomic, readonly) NSString *localizedLabel;

- (id)initWithName:(NSString *)name originalLabel:(NSString *)originalLabel localizedLabel:(NSString *)localizedLabel;

@end
