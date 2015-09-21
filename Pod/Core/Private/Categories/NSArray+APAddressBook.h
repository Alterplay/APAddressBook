//
//  NSArray(APAddressBook) 
//  AddressBook
//
//  Created by Alexey Belkevich on 21.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APContact;

@interface NSArray (APAddressBook)

- (NSArray *)filteredArrayWithBlock:(BOOL (^)(APContact *contact))filterBlock
              sortedWithDescriptors:(NSArray *)descriptors;

@end