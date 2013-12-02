//
//  UMResponseSerializer.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "UMResponseSerializer.h"
#import "Mantle.h"

NSString * const UMResponseSerializerErrorDomain = @"UMResponseSerializerErrorDomain";

@interface UMResponseSerializer ()

@property (readonly) Class responseObjectClass;
@property (readonly) BOOL inArray;

@end

@implementation UMResponseSerializer

- (instancetype)initWithResponseObjectClass:(Class)responseObjectClass inArray:(BOOL)inArray {
    if (self = [super init]) {
        _responseObjectClass = responseObjectClass;
        _inArray = inArray;
    }
    return self;
}

- (id)arrayResponseObjectForJSONObject:(id)object error:(NSError *__autoreleasing *)error {
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *responseObjects = [NSMutableArray array];
        for (id element in object) {
            id responseObject = [self nonArrayResponseObjectForJSONObject:element
                                                                    error:error];
            if (responseObject) {
                [responseObjects addObject:responseObject];
            }
            else {
                return nil;
            }
        }
        return responseObjects;
    } else {
        if (error) {
            *error = [NSError errorWithDomain:UMResponseSerializerErrorDomain
                                         code:NSURLErrorBadServerResponse
                                     userInfo:nil];
        }
        return nil;
    }
}

- (id)nonArrayResponseObjectForJSONObject:(id)object error:(NSError *__autoreleasing *)error {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [MTLJSONAdapter modelOfClass:self.responseObjectClass
                         fromJSONDictionary:object
                                      error:error];
    } else {
        if (error) {
            *error = [NSError errorWithDomain:UMResponseSerializerErrorDomain
                                         code:NSURLErrorBadServerResponse
                                     userInfo:nil];
        }
        return nil;
    }
}

- (NSError *)errorForJSONObject:(id)object error:(NSError *__autoreleasing *)error {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return nil;
    } else {
        if (error) {
            *error = [NSError errorWithDomain:UMResponseSerializerErrorDomain
                                         code:NSURLErrorBadServerResponse
                                     userInfo:nil];
        }
        return nil;
    }
}

#pragma mark AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *jsonDict = [super responseObjectForResponse:response
                                                         data:data
                                                        error:error];
    id errorObject = jsonDict[@"error"];
    if (errorObject) {
        NSError *apiError = [self errorForJSONObject:errorObject
                                               error:error];
        if (error && apiError) {
            *error = apiError;
        }
        return nil;
    }
    
    id dataObject = jsonDict[@"response"];
    if (self.inArray) {
        return [self arrayResponseObjectForJSONObject:dataObject
                                                error:error];
    }
    else {
        return [self nonArrayResponseObjectForJSONObject:dataObject
                                                   error:error];
    }
}

@end

@implementation MTLModel (UMResponseSerializer)

+ (UMResponseSerializer *)um_responseSerializer {
    return [[UMResponseSerializer alloc] initWithResponseObjectClass:self inArray:NO];
}

+ (UMResponseSerializer *)um_arrayResponseSerializer {
    return [[UMResponseSerializer alloc] initWithResponseObjectClass:self inArray:YES];
}

@end
