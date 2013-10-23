//
//  HubXML.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/5/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLConstants.h"

/** XML namespaces */
NSString *const kEkkoHubXMLNSEkko = @"https://ekkoproject.org/manifest";
NSString *const kEkkoHubXMLNSHub  = @"https://ekkoproject.org/hub";

NSString *const kEkkoHubXMLElementCourses    = @"hub:courses";
NSString *const kEkkoHubXMLElementCourse     = @"hub:course";
NSString *const kEkkoHubXMLElementPermission = @"hub:permission";
NSString *const kEkkoHubXMLElementManifest   = @"ekko:course";
NSString *const kEkkoHubXMLElementResources  = @"ekko:resources";
NSString *const kEkkoHubXMLElementResource   = @"ekko:resource";

/** meta elements */
NSString *const kEkkoHubXMLElementMeta            = @"ekko:meta";
NSString *const kEkkoHubXMLElementMetaTitle       = @"ekko:title";
NSString *const kEkkoHubXMLElementMetaAuthor      = @"ekko:author";
NSString *const kEkkoHubXMLElementMetaAuthorName  = @"ekko:name";
NSString *const kEkkoHubXMLElementMetaAuthorEmail = @"ekko:email";
NSString *const kEkkoHubXMLElementMetaAuthorURL   = @"ekko:url";
NSString *const kEkkoHubXMLElementMetaBanner      = @"ekko:banner";
NSString *const kEkkoHubXMLElementMetaDescription = @"ekko:description";
NSString *const kEkkoHubXMLElementMetaCopyright   = @"ekko:copyright";

/** content elements */
NSString *const kEkkoHubXMLElementContent             = @"ekko:content";
NSString *const kEkkoHubXMLElementContentLesson       = @"ekko:lesson";
NSString *const kEkkoHubXMLElementContentQuiz         = @"ekko:quiz";
NSString *const kEkkoHubXMLElementLessonMedia         = @"ekko:media";
NSString *const kEkkoHubXMLElementLessonText          = @"ekko:text";
NSString *const kEkkoHubXMLElementQuizQuestion        = @"ekko:question";
NSString *const kEkkoHubXMLElementQuizQuestionText    = @"ekko:text";
NSString *const kEkkoHubXMLElementQuizQuestionOptions = @"ekko:options";
NSString *const kEkkoHubXMLElementQuizQuestionOption  = @"ekko:option";

/** complete elements */
NSString *const kEkkoHubXMLElementCompletion        = @"ekko:complete";
NSString *const kEkkoHubXMLElementCompletionMessage = @"ekko:message";

/** manifest attributes */
NSString *const kEkkoHubXMLAttrSchemaVersion = @"schemaVersion";

/** generic attributes */
NSString *const kEkkoHubXMLAttrResource  = @"resource";
NSString *const kEkkoHubXMLAttrThumbnail = @"thumbnail";

/** courses attributes */
NSString *const kEkkoHubXMLAttrCoursesStart   = @"start";
NSString *const kEkkoHubXMLAttrCoursesLimit   = @"limit";
NSString *const kEkkoHubXMLAttrCoursesHasMore = @"hasMore";

/** course attributes */
NSString *const kEkkoHubXMLAttrCourseId             = @"id";
NSString *const kEkkoHubXMLAttrCourseVersion        = @"version";
NSString *const kEkkoHubXMLAttrCoursePublic         = @"public";
NSString *const kEkkoHubXMLAttrCourseEnrollmentType = @"enrollmentType";

/** permission attributes */
NSString *const kEkkoHubXMLAttrPermissionGuid           = @"guid";
NSString *const kEkkoHubXMLAttrPermissionEnrolled       = @"enrolled";
NSString *const kEkkoHubXMLAttrPermissionAdmin          = @"admin";
NSString *const kEkkoHubXMLAttrPermissionPending        = @"pending";
NSString *const kEkkoHubXMLAttrPermissionContentVisible = @"contentVisible";

/** lesson attributes */
NSString *const kEkkoHubXMLAttrLessonId    = @"id";
NSString *const kEkkoHubXMLAttrLessonTitle = @"title";

/** quiz attributes */
NSString *const kEkkoHubXMLAttrQuizId    = @"id";
NSString *const kEkkoHubXMLAttrQuizTitle = @"title";

/** question attributes */
NSString *const kEkkoHubXMLAttrQuestionId   = @"id";
NSString *const kEkkoHubXMLAttrQuestionType = @"type";

/** question option attribute */
NSString *const kEkkoHubXMLAttrOptionId     = @"id";
NSString *const kEkkoHubXMLAttrOptionAnswer = @"answer";

/** content attributes */
NSString *const kEkkoHubXMLAttrMediaId   = @"id";
NSString *const kEkkoHubXMLAttrMediaType = @"type";
NSString *const kEkkoHubXMLAttrTextId    = @"id";

/** resource attributes */
NSString *const kEkkoHubXMLAttrResourceId       = @"id";
NSString *const kEkkoHubXMLAttrResourceType     = @"type";
NSString *const kEkkoHubXMLAttrResourceSha1     = @"sha1";
NSString *const kEkkoHubXMLAttrResourceSize     = @"size";
NSString *const kEkkoHubXMLAttrResourceFile     = @"file";
NSString *const kEkkoHubXMLAttrResourceMimeType = @"mimeType";
NSString *const kEkkoHubXMLAttrResourceURI      = @"uri";
NSString *const kEkkoHubXMLAttrResourceProvider = @"provider";

/** course enrollment values */
NSString *const kEkkoHubXMLValueEnrollmentTypeDisabled = @"disabled";
NSString *const kEkkoHubXMLValueEnrollmentTypeOpen     = @"open";
NSString *const kEkkoHubXMLValueEnrollmentTypeApproval = @"approval";

/** resource type values */
NSString *const kEkkoHubXMLValueResourceTypeFile    = @"file";
NSString *const kEkkoHubXMLValueResourceTypeURI     = @"uri";
NSString *const kEkkoHubXMLValueResourceTypeDynamic = @"dynamic";

/** resource provider values */
NSString *const kEkkoHubXMLValueResourceProviderYouTube = @"youtube";
NSString *const kEkkoHubXMLValueResourceProviderVimeo   = @"vimeo";
