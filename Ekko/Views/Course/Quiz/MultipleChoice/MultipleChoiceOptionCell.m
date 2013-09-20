//
//  MultipleChoiceOptionCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MultipleChoiceOptionCell.h"
#import "UIColor+Ekko.h"

@implementation MultipleChoiceOptionCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    M13Checkbox *checkbox = [[M13Checkbox alloc] initWithFrame:CGRectInset(self.bounds, 20, 5)];
    [checkbox setCheckAlignment:M13CheckboxAlignmentLeft];
    [checkbox setTintColor:[UIColor ekkoOrange]];
    self.checkbox = checkbox;
    [self addSubview:checkbox];
    
    return self;
}

@end
