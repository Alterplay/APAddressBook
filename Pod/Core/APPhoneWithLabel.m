//
//  APPhoneWithLabel.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhoneWithLabel.h"

@implementation APPhoneWithLabel

- (id)initWithPhone:(NSString *)phone label:(NSString *)label rawlabel:(NSString*)rawlabel {
    self = [super init];
    if(self)
    {
        _phone = phone;
        _label = label;
        _rawLabel = rawlabel;
    }
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ (%@) - %@", _label, _rawLabel, _phone];
}

@end
