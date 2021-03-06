//
//  Engagement.h
//  Engagement
//
//  Created by Brandon Trebitowski on 2/3/14.
//  Copyright (c) 2014 Bissell Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  The Jesus Film Media Event Tracker is used to track plays of a given JFM video.
 */
@interface EventTracker : NSObject

/**
*  Configures the tracker for the given application.
*
*  @param apiKey     Your application's API key
*  @param appDomain  the domain of the application (ie com.jesusfilmmedia). This should be your bundle identifier
*  @param appName    The name of your application
*  @param appVersion The version of your application
*/
+ (void) initializeWithApiKey:(NSString *) apiKey appDomain:(NSString *) appDomain appName:(NSString *) appName appVersion:(NSString *) appVersion;

/**
 * This method should be called when the application resumes from the background.  It performs another check to
 * see if the user's location changed.
 */
+ (void) applicationDidBecomeActive;

/**
 *  This method is used to track a play event. It's meant to be called when a user plays a video.
 *
 *  @param refID                        the id of the video being played
 *  @param apiSessionID                 this should be retrieved from the server and is used to track a single playback session
 *  @param streaming                    a boolean value that is true when the video is being streamed from the web vs played from cache
 *  @param seconds                      the number of secons that the video was viewed
 *  @param mediaEngagementOver75Percent set to true only if the video was played over 75%
 */
+ (void) trackPlayEventWithRefID:(NSString *) refID apiSessionID:(NSString *) apiSessionID streaming:(BOOL) streaming mediaViewTimeInSeconds:(float) seconds mediaEngagementOver75Percent:(BOOL) mediaEngagementOver75Percent;

/**
 * Singleton reference so that there only ever exists one event tracker. Make sure to 
 * use this method when intializing and interfacing with the tracker.
 *
 * @return the one and only instance of the event tracker.
 */
+ (id)sharedInstance;

/**
 *  Allows you to update the API key for the tracker
 */
@property(nonatomic, readonly) NSString *apiKey;

@end
