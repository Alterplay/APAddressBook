//
//  APAddressBook.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAddressBook : NSObject

+ (BOOL)isPermissionsDetermined;
- (void)loadContacts:(void (^)(NSArray *contacts, NSError *error))callbackBlock;

@end
