//
//  APEmailWithLabel.m
//  AddressBook
//
//  Created by Sean Langley on 2015-03-18.
//  Copyright (c) 2015 Sean Langley. All rights reserved.
//

#import "APEmailWithLabel.h"

@implementation APEmailWithLabel

- (id)initWithEmail:(NSString *)email label:(NSString *)label {
    self = [super init];
    if (self)
    {
        _email = email;
        _label = label;
    }
    return self;
}

@end
