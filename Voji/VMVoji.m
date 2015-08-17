//
//  VMVoji.m
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "VMVoji.h"
#import <Parse/PFObject+Subclass.h>


@implementation VMVoji

@dynamic type;
@dynamic time;
@dynamic user;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Voji";
}

@end
