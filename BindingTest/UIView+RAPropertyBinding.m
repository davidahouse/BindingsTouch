//
//  UIView+RAPropertyBinding.m
//  BindingTest
//
//  Created by David House on 2/10/13.
//  Copyright (c) 2013 Random Accident. All rights reserved.
//

#import "UIView+RAPropertyBinding.h"
#import <objc/runtime.h>

static char const * const UndefinedObjectsDictKey = "UndefinedObjectsDict";

@implementation UIView (RAPropertyBinding)


#pragma mark - Overrides

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    // see if the UndefinedObjects dictionary exists, if not, create it
    NSMutableDictionary *undefinedDict = nil;
    if ( objc_getAssociatedObject(self, UndefinedObjectsDictKey) ) {
        undefinedDict = objc_getAssociatedObject(self, UndefinedObjectsDictKey);
    }
    else {
        undefinedDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, UndefinedObjectsDictKey, undefinedDict, OBJC_ASSOCIATION_RETAIN);
    }
    [undefinedDict setValue:value forKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    NSMutableDictionary *undefinedDict = nil;
    if ( objc_getAssociatedObject(self, UndefinedObjectsDictKey) ) {
        undefinedDict = objc_getAssociatedObject(self, UndefinedObjectsDictKey);
        return [undefinedDict valueForKey:key];
    }
    else {
        return nil;
    }
}

#pragma mark - Public Methods

- (void)bindWithObject:(id)obj {
    
    // first check ourselves for any bindable properties. Then process our
    // children.
    NSArray *undefinedKeys = [self undefinedKeys];
    if ( undefinedKeys ) {
        for ( NSString *key in undefinedKeys ) {
            // only bind things that start with the lowercase bind string
            if ( ( [key length] > 4 ) && [[key substringToIndex:4] isEqualToString:@"bind"] ) {
                
                NSString *keyToBind = [key substringFromIndex:4];
                NSString *keyValue = [self valueForKey:key];
                [self setValue:[obj valueForKey:keyValue] forKey:keyToBind];
            }
        }
    }
    
    for ( UIView *subview in [self subviews] ) {
        [subview bindWithObject:obj];
    }
}

#pragma mark - Private Methods
- (NSArray *)undefinedKeys {
    
    if ( objc_getAssociatedObject(self, UndefinedObjectsDictKey) ) {
        NSDictionary *undefinedDict = objc_getAssociatedObject(self, UndefinedObjectsDictKey);
        return [undefinedDict allKeys];
    }
    else {
        return nil;
    }
}

@end
