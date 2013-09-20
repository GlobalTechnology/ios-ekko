//
//  HubXML.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/5/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

/** XML namespaces */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLNSEkko;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLNSHub;

FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementCourses;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementCourse;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementManifest;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementResources;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementResource;

/** meta elements */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMeta;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaTitle;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaAuthor;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaAuthorName;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaAuthorEmail;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaAuthorURL;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaBanner;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaDescription;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementMetaCopyright;

/** content elements */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementContent;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementContentLesson;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementContentQuiz;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementLessonMedia;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementLessonText;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementQuizQuestion;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementQuizQuestionText;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementQuizQuestionOptions;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementQuizQuestionOption;

/** complete elements */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementCompletion;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLElementCompletionMessage;

/** manifest attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrSchemaVersion;

/** generic attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResource;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrThumbnail;

/** courses attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrCoursesStart;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrCoursesLimit;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrCoursesHasMore;

/** course attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrCourseId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrCourseVersion;

/** lesson attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrLessonId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrLessonTitle;

/** quiz attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrQuizId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrQuizTitle;

/** question attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrQuestionId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrQuestionType;

/** question option attribute */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrOptionId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrOptionAnswer;

/** content attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrMediaId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrMediaType;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrTextId;

/** resource attributes */
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceId;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceType;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceSha1;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceSize;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceFile;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceMimeType;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceURI;
FOUNDATION_EXPORT NSString *const kEkkoHubXMLAttrResourceProvider;