//
//  Resource+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource+Ekko.h"
#import "Manifest+Ekko.h"
#import "HubClient.h"

#import "NSString+MD5.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const kYouTubeVideoIdPattern = @"^.*(youtu.be\\/|v\\/|u\\/\\w\\/|embed\\/|watch\\?v=|\\&v=)([^#\\&\\?]*).*";

@implementation Resource (Ekko)

-(EkkoResourceType)type {
    return (EkkoResourceType)[self resourceType];
}

-(void)setType:(EkkoResourceType)type {
    [self setResourceType:type];
}

-(EkkoResourceProvider)provider {
    return (EkkoResourceProvider)[self resourceProvider];
}

-(void)setProvider:(EkkoResourceProvider)provider {
    [self setResourceProvider:provider];
}

-(NSString *)courseId {
    return [self.course courseId];
}

-(BOOL)isFile {
    return self.type == EkkoResourceTypeFile;
}

-(BOOL)isUri {
    return self.type == EkkoResourceTypeURI;
}

-(NSString *)filenameOnDisk {
    NSString *filename = nil;
    if ([self isFile] && self.sha1) {
        filename = [self.sha1 copy];
    }
    else if ([self isUri]) {
        filename = [NSString stringWithFormat:@"uri-%@", [[self.uri lowercaseString] MD5]];
    }
    
    if (filename && self.mimeType) {
        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)self.mimeType, NULL);
        NSString *extension = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension));
        CFRelease(uti);
        if (extension) {
            return [filename stringByAppendingPathExtension:extension];
        }
    }
    return filename;
}

-(NSString *)youtTubeVideoId {
    if ([self isUri] && self.provider == EkkoResourceProviderYouTube) {
        NSError *error = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:kYouTubeVideoIdPattern options:0 error:&error];
        if (error) {
            return nil;
        }
        NSTextCheckingResult *match = [regexp firstMatchInString:self.uri options:0 range:NSMakeRange(0, [self.uri length])];
        if (match.range.location == NSNotFound || match.numberOfRanges < 2) {
            return nil;
        }
        NSRange range = [match rangeAtIndex:2];
        if (range.length == 11) {
            NSString *video_id = [self.uri substringWithRange:range];
            return video_id;
        }
    }
    return nil;
}

@end
