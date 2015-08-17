//
//  VMVoji.h
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "PFObject.h"

typedef NS_ENUM(NSInteger, VMVojiType)
{
    VMVojiTypeThumbsUp = 0,
    VMVojiTypeThumbsDown,
};


@interface VMVoji : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) PFUser *user;

@end
