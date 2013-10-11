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

-(void)setCheckbox:(M13Checkbox *)checkbox {
    _checkbox = checkbox;
    [checkbox setCheckAlignment:M13CheckboxAlignmentLeft];
    [checkbox setTintColor:[UIColor ekkoLightBlue]];
}

@end
