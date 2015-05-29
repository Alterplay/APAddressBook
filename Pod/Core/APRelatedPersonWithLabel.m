//
//  APPhoneWithLabel.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APRelatedPersonWithLabel.h"

@implementation APRelatedPersonWithLabel

#pragma mark - life cycle

- (id)initWithName:(NSString *)name originalLabel:(NSString *)originalLabel localizedLabel:(NSString *)localizedLabel
{
    self = [super init];
    if (self)
    {
        _name = name;
        _localizedLabel = localizedLabel;
        _originalLabel = originalLabel;
    }
    return self;
}

#pragma mark - overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@) - %@", self.localizedLabel, self.originalLabel, self.name];
}

@end
