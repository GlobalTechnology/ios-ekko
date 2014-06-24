//
//  EkkoCloudXMLConstants.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/29/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoCloudXMLConstants.h"

/** XML namespaces */
NSString *const kEkkoCloudXMLNSEkko = @"https://ekkoproject.org/manifest";
NSString *const kEkkoCloudXMLNSHub  = @"https://ekkoproject.org/hub";

NSString *const kEkkoCloudXMLElementCourses    = @"hub:courses";
NSString *const kEkkoCloudXMLElementCourse     = @"hub:course";
NSString *const kEkkoCloudXMLElementPermission = @"hub:permission";
NSString *const kEkkoCloudXMLElementManifest   = @"ekko:course";
NSString *const kEkkoCloudXMLElementResources  = @"ekko:resources";
NSString *const kEkkoCloudXMLElementResource   = @"ekko:resource";

/** meta elements */
NSString *const kEkkoCloudXMLElementMeta            = @"ekko:meta";
NSString *const kEkkoCloudXMLElementMetaTitle       = @"ekko:title";
NSString *const kEkkoCloudXMLElementMetaAuthor      = @"ekko:author";
NSString *const kEkkoCloudXMLElementMetaAuthorName  = @"ekko:name";
NSString *const kEkkoCloudXMLElementMetaAuthorEmail = @"ekko:email";
NSString *const kEkkoCloudXMLElementMetaAuthorURL   = @"ekko:url";
NSString *const kEkkoCloudXMLElementMetaBanner      = @"ekko:banner";
NSString *const kEkkoCloudXMLElementMetaDescription = @"ekko:description";
NSString *const kEkkoCloudXMLElementMetaCopyright   = @"ekko:copyright";

/** content elements */
NSString *const kEkkoCloudXMLElementContent             = @"ekko:content";
NSString *const kEkkoCloudXMLElementContentLesson       = @"ekko:lesson";
NSString *const kEkkoCloudXMLElementContentQuiz         = @"ekko:quiz";
NSString *const kEkkoCloudXMLElementLessonMedia         = @"ekko:media";
NSString *const kEkkoCloudXMLElementLessonText          = @"ekko:text";
NSString *const kEkkoCloudXMLElementQuizQuestion        = @"ekko:question";
NSString *const kEkkoCloudXMLElementQuizQuestionText    = @"ekko:text";
NSString *const kEkkoCloudXMLElementQuizQuestionOptions = @"ekko:options";
NSString *const kEkkoCloudXMLElementQuizQuestionOption  = @"ekko:option";

/** complete elements */
NSString *const kEkkoCloudXMLElementCompletion        = @"ekko:complete";
NSString *const kEkkoCloudXMLElementCompletionMessage = @"ekko:message";

/** manifest attributes */
NSString *const kEkkoCloudXMLAttrSchemaVersion = @"schemaVersion";

/** generic attributes */
NSString *const kEkkoCloudXMLAttrResource  = @"resource";
NSString *const kEkkoCloudXMLAttrThumbnail = @"thumbnail";

/** courses attributes */
NSString *const kEkkoCloudXMLAttrCoursesStart   = @"start";
NSString *const kEkkoCloudXMLAttrCoursesLimit   = @"limit";
NSString *const kEkkoCloudXMLAttrCoursesHasMore = @"hasMore";

/** course attributes */
NSString *const kEkkoCloudXMLAttrCourseId             = @"id";
NSString *const kEkkoCloudXMLAttrCourseVersion        = @"version";
NSString *const kEkkoCloudXMLAttrCoursePublic         = @"public";
NSString *const kEkkoCloudXMLAttrCourseEnrollmentType = @"enrollmentType";

/** permission attributes */
NSString *const kEkkoCloudXMLAttrPermissionGuid           = @"guid";
NSString *const kEkkoCloudXMLAttrPermissionEnrolled       = @"enrolled";
NSString *const kEkkoCloudXMLAttrPermissionAdmin          = @"admin";
NSString *const kEkkoCloudXMLAttrPermissionPending        = @"pending";
NSString *const kEkkoCloudXMLAttrPermissionContentVisible = @"contentVisible";

/** lesson attributes */
NSString *const kEkkoCloudXMLAttrLessonId    = @"id";
NSString *const kEkkoCloudXMLAttrLessonTitle = @"title";

/** quiz attributes */
NSString *const kEkkoCloudXMLAttrQuizId    = @"id";
NSString *const kEkkoCloudXMLAttrQuizTitle = @"title";

/** question attributes */
NSString *const kEkkoCloudXMLAttrQuestionId   = @"id";
NSString *const kEkkoCloudXMLAttrQuestionType = @"type";

/** question option attribute */
NSString *const kEkkoCloudXMLAttrOptionId     = @"id";
NSString *const kEkkoCloudXMLAttrOptionAnswer = @"answer";

/** content attributes */
NSString *const kEkkoCloudXMLAttrMediaId   = @"id";
NSString *const kEkkoCloudXMLAttrMediaType = @"type";
NSString *const kEkkoCloudXMLAttrTextId    = @"id";

/** resource attributes */
NSString *const kEkkoCloudXMLAttrResourceId       = @"id";
NSString *const kEkkoCloudXMLAttrResourceType     = @"type";
NSString *const kEkkoCloudXMLAttrResourceSha1     = @"sha1";
NSString *const kEkkoCloudXMLAttrResourceSize     = @"size";
NSString *const kEkkoCloudXMLAttrResourceFile     = @"file";
NSString *const kEkkoCloudXMLAttrResourceMimeType = @"mimeType";
NSString *const kEkkoCloudXMLAttrResourceURI      = @"uri";
NSString *const kEkkoCloudXMLAttrResourceProvider = @"provider";
NSString *const kEkkoCloudXMLAttrResourceVideoId  = @"videoId";
NSString *const kEkkoCloudXMLAttrResourceRefId    = @"refId";

/** course enrollment values */
NSString *const kEkkoCloudXMLValueEnrollmentTypeDisabled = @"disabled";
NSString *const kEkkoCloudXMLValueEnrollmentTypeOpen     = @"open";
NSString *const kEkkoCloudXMLValueEnrollmentTypeApproval = @"approval";

/** resource type values */
NSString *const kEkkoCloudXMLValueResourceTypeFile     = @"file";
NSString *const kEkkoCloudXMLValueResourceTypeURI      = @"uri";
NSString *const kEkkoCloudXMLValueResourceTypeDynamic  = @"dynamic";
NSString *const kEkkoCloudXMLValueResourceTypeECV      = @"ecv";
NSString *const kEkkoCloudXMLValueResourceTypeArclight = @"arclight";

/** resource provider values */
NSString *const kEkkoCloudXMLValueResourceProviderYouTube = @"youtube";
NSString *const kEkkoCloudXMLValueResourceProviderVimeo   = @"vimeo";

/** question type values */
NSString *const kEkkoCloudXMLValueQuestionTypeMultipleChoice = @"multiple";

/** media type values */
NSString *const kEkkoCloudXMLValueMediaTypeAudio = @"audio";
NSString *const kEkkoCloudXMLValueMediaTypeImage = @"image";
NSString *const kEkkoCloudXMLValueMediaTypeVideo = @"video";
