//
//  APPhoneLabel.m
//  AddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhoneLabel.h"

@implementation APPhoneLabel

- (APPhoneLabel *)initWithTuple:(NSArray *)tuple {
    self = [super init];
    _phone = tuple[0];
    if([tuple count] == 2) {
        _label = tuple[1];
    }
    return self;
}

@end
