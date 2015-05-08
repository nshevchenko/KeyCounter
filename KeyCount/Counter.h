//
//  Counter.h
//  KeyCount
//
//  Created by Shevchenko Nik on 03/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Counter : NSManagedObject

@property (nonatomic, retain) NSString * button;
@property (nonatomic, retain) NSNumber * click;

@end
