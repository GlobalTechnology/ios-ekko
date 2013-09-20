//
//  UIColor+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "UIColor+Ekko.h"

@implementation UIColor (Ekko)

+(UIColor *)ekkoLightBlue {
    return [UIColor colorWithRed:0.365 green:0.647 blue:0.890 alpha:1.000];
}

+(UIColor *)ekkoMediumBlue {
    return [UIColor colorWithRed:0.404 green:0.494 blue:0.627 alpha:1.000];
}

+(UIColor *)ekkoDarkBlue {
    return [UIColor colorWithRed:0.165 green:0.314 blue:0.529 alpha:1.000];
}

+(UIColor *)ekkoWhite {
    return [UIColor whiteColor];
}

+(UIColor *)ekkoOrange {
    return [UIColor colorWithRed:0.812 green:0.427 blue:0.173 alpha:1.000];
}

+(UIColor *)ekkoGrey {
    return [UIColor colorWithRed:0.906 green:0.906 blue:0.914 alpha:1.000];
}

+(UIColor *)ekkoLightGrey {
    return [UIColor colorWithWhite:0.961 alpha:1.000];
}

@end
