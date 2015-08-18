//
//  VMApiFacade+Parse.m
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "VMApiFacade+Parse.h"




@implementation VMApiFacade (Parse)

#pragma mark - API vParse --- Voji - (Public) ---
- (void)saveVoji:(VMVoji*)voji
        completion:(void(^)(BOOL success, VMError *error))completion {
    
    
    // Create a voji
    [voji saveEventually];
    
    // Callback
    if (completion)
        completion(YES, nil);
}

- (void)getVojis:(NSString*)isrc
      completion:(void(^)(BOOL success, NSArray* vojis, VMError *error))completion {
    
    // Get class name
    NSString* parseClassName = [VMVoji parseClassName];
    
    
    // Query
    PFQuery* query = [PFQuery queryWithClassName:parseClassName];
    [query whereKey:kParseKeyVojiISRC equalTo:isrc];
    [query orderByAscending:kParseKeyVojiTime];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            // Set success flag
            BOOL success = error ? NO : YES;
            
            
            // Callback
            VMError* errorVM = [VMError errorWithError:error];
            if (completion)
                completion(success, objects,errorVM);
        }
        else {
            
            // Callback
            VMError* errorVM = [VMError errorWithError:error];
            if (completion)
                completion(NO, nil, errorVM);
        }
    }];
}



@end
