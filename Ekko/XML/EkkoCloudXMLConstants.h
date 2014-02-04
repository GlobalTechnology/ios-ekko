//
//  EkkoCloudXMLConstants.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/29/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

/** XML namespaces */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLNSEkko;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLNSHub;

FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementCourses;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementCourse;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementPermission;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementManifest;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementResources;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementResource;

/** meta elements */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMeta;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaTitle;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaAuthor;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaAuthorName;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaAuthorEmail;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaAuthorURL;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaBanner;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaDescription;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementMetaCopyright;

/** content elements */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementContent;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementContentLesson;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementContentQuiz;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementLessonMedia;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementLessonText;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementQuizQuestion;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementQuizQuestionText;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementQuizQuestionOptions;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementQuizQuestionOption;

/** complete elements */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementCompletion;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLElementCompletionMessage;

/** manifest attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrSchemaVersion;

/** generic attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResource;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrThumbnail;

/** courses attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCoursesStart;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCoursesLimit;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCoursesHasMore;

/** course attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCourseId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCourseVersion;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCoursePublic;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrCourseEnrollmentType;

/** permission attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrPermissionGuid;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrPermissionEnrolled;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrPermissionAdmin;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrPermissionPending;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrPermissionContentVisible;

/** lesson attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrLessonId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrLessonTitle;

/** quiz attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrQuizId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrQuizTitle;

/** question attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrQuestionId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrQuestionType;

/** question option attribute */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrOptionId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrOptionAnswer;

/** content attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrMediaId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrMediaType;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrTextId;

/** resource attributes */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceType;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceSha1;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceSize;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceFile;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceMimeType;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceURI;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceProvider;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceVideoId;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLAttrResourceRefId;

/** course enrollment values */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueEnrollmentTypeDisabled;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueEnrollmentTypeOpen;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueEnrollmentTypeApproval;

/** resource type values */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceTypeFile;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceTypeURI;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceTypeDynamic;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceTypeECV;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceTypeArclight;

/** resource provider values */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceProviderYouTube;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueResourceProviderVimeo;

/** question type values */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueQuestionTypeMultipleChoice;

/** media type values */
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueMediaTypeAudio;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueMediaTypeImage;
FOUNDATION_EXPORT NSString *const kEkkoCloudXMLValueMediaTypeVideo;
