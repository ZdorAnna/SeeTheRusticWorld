//
//  Defines.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/13/15.
//  Copyright (c) 2015 anna. All rights reserved.
//


static NSString *const STInstagramCallbackString =              @"http://SeeTheRusticWorld/oauth";
static NSString *const STInstagramClientSecret =                @"44b50223058047aaabbf2ef1b6663aac";
static NSString *const STInstagramClientId  =                   @"49bff5991ae74c1890a11acb6053db1e";

static NSString * const STInstagramPostsRequestString =         @"https://api.instagram.com/v1/tags/%@/media/recent";
static NSString * const STInstagramAuthorizationRequestString = @"https://api.instagram.com/oauth/authorize/?client_id=%@&display=touch&basic&redirect_uri=%@&response_type=code";
static NSString * const STInstagramAccessTokenRequestString =   @"https://api.instagram.com/oauth/access_token";

static NSString * const STInstagramTokenKey =                   @"access_token";
static NSString * const STInstagramTagName =                    @"rustic_world";

#define FETCH_BATCH_SIZE 33
static NSString * const STCountPostsInRequest =                 @"33";




