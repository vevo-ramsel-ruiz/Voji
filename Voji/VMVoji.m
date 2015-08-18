//
//  VMVoji.m
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "VMVoji.h"
#import <Parse/PFObject+Subclass.h>


#pragma mark - Keys - Voji
NSString * const kParseKeyVojiType = @"type";
NSString * const kParseKeyVojiTime = @"time";
NSString * const kParseKeyVojiUser = @"user";
NSString * const kParseKeyVojiISRC = @"isrc";

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

+ (instancetype)vojiWithType:(VMVojiType)type
                        time:(NSNumber*)time
                        user:(PFUser*)user
                        isrc:(NSString*)isrc {
    
    // Get class name
    NSString* parseClassName = [VMVoji parseClassName];
    
    VMVoji* voji = (VMVoji*)[PFObject objectWithClassName:parseClassName];
    [voji setObject:user forKey:kParseKeyVojiUser];
    [voji setObject:time forKey:kParseKeyVojiTime];
    [voji setObject:@(type) forKey:kParseKeyVojiType];
    [voji setObject:isrc forKey:kParseKeyVojiISRC];
    
    return voji;
}

@end
