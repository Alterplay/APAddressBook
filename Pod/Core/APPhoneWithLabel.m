//
//  APPhoneWithLabel.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhoneWithLabel.h"

@implementation APPhoneWithLabel

- (id)initWithPhone:(NSString *)phone label:(NSString *)label {
    self = [super init];
    if(self)
    {
        _phone = phone;
        _label = label;
    }
    return self;
}

@end
