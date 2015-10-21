//
//  GlobalResource.h
//  Smile
//
//  Created by Apple on 10/15/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalResource : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSString * page;

@end
