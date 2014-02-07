//
//  Resource+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource+Ekko.h"

#import "NSString+MD5.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const kYouTubeVideoIdPattern = @"^.*(youtu.be\\/|v\\/|u\\/\\w\\/|embed\\/|watch\\?v=|\\&v=)([^#\\&\\?]*).*";

@implementation Resource (Ekko)

-(id)initWithBanner:(Banner *)banner {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.resourceId = banner.bannerId;
    self.type       = banner.type;
    self.provider   = banner.provider;
    self.sha1       = banner.sha1;
    self.size       = [banner.size unsignedLongLongValue];
    self.uri        = banner.uri;
    self.mimeType   = banner.mimeType;
    self.videoId    = banner.videoId;
    self.refId      = banner.refId;
    self.courseId   = banner.courseId;

    return self;
}

-(BOOL)isFile {
    return self.type == EkkoResourceTypeFile;
}

-(BOOL)isUri {
    return self.type == EkkoResourceTypeURI;
}

-(BOOL)isEkkoCloudVideo {
    return self.type == EkkoResourceTypeECV;
}

-(BOOL)isArclight {
    return self.type == EkkoResourceTypeArclight;
}

-(NSString *)filenameOnDisk {
    NSString *filename = nil;
    if ([self isFile] && self.sha1) {
        filename = [self.sha1 copy];
    }
    else if ([self isUri]) {
        filename = [NSString stringWithFormat:@"uri-%@", [[self.uri lowercaseString] MD5]];
    }
    else if ([self isEkkoCloudVideo]) {
        filename = [NSString stringWithFormat:@"ecv-%@", [self.videoId lowercaseString]];
    }
    else if ([self isArclight]) {
        filename = [NSString stringWithFormat:@"arclight-%@", self.refId];
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
