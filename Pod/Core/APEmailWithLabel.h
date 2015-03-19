//
//  APEmailWithLabel.h
//  AddressBook
//
//  Created by Sean Langley on 2015-03-18.
//  Copyright (c) 2015 Sean Langley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APEmailWithLabel : NSObject

@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *label;

- (id)initWithEmail:(NSString *)email label:(NSString *)label;

@end
