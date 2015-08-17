//
//  VMApiFacade+Parse.h
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "VMApiFacade.h"
#import "VMVoji.h"


@interface VMApiFacade (Parse)


#pragma mark - Voji
/**---------------------------------------------------------------------------------------
 * @name Voji
 *  ---------------------------------------------------------------------------------------
 */
- (void)createVoji:(VMVojiType)type
              time:(NSNumber*)time
              user:(PFUser*)user
              isrc:(NSString*)isrc
        completion:(void(^)(BOOL success, VMError *error))completion;


- (void)getVojis:(NSString*)isrc
      completion:(void(^)(BOOL success, NSArray* vojis, VMError *error))completion;

@end
