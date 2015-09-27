//
//  APEmailWithLabel.h
//  AddressBook
//
//  Created by Sean Langley on 2015-03-18.
//  Copyright (c) 2015 Sean Langley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APEmailWithLabel : NSObject

@property (nullable, nonatomic, strong) NSString *email;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end
