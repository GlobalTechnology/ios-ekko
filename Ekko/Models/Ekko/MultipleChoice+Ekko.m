//
//  MultipleChoice+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MultipleChoice+Ekko.h"
#import "MultipleChoiceOption.h"

@implementation MultipleChoice (Ekko)

-(MultipleChoiceOption *)answer {
    for (MultipleChoiceOption *option in self.options) {
        if (option.isAnswer) {
            return option;
        }
    }
    return nil;
}

@end
