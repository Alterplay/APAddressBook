//
//  APPhoneWithLabel.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhoneWithLabel.h"

@implementation APPhoneWithLabel

#pragma mark - properties

- (NSString *)label
{
    return self.localizedLabel;
}

#pragma mark - overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@) - %@", self.localizedLabel, self.originalLabel, self.phone];
}

@end
