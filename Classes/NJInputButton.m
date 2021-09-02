//
//  NJInputButton.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import "NJInputButton.h"

static const CFIndex kMFiAnalogButtonInputMaxThreshold = 10;

@implementation NJInputButton {
    CFIndex _max;
}

- (id)initWithElement:(IOHIDElementRef)element
                index:(int)index
               parent:(NJInputPathElement *)parent
{
    if ((self = [super initWithName:NJINPUT_NAME(NSLocalizedString(@"button %d", @"button name"), index)
                                eid:NJINPUT_EID("Button", index)
                            element:element
                             parent:parent])) {
        CFIndex logicalMax = IOHIDElementGetLogicalMax(element);
        _max = logicalMax <= kMFiAnalogButtonInputMaxThreshold ? logicalMax : kMFiAnalogButtonInputMaxThreshold;
    }
    return self;
}

- (id)findSubInputForValue:(IOHIDValueRef)val {
    return (IOHIDValueGetIntegerValue(val) >= _max) ? self : nil;
}

- (void)notifyEvent:(IOHIDValueRef)value {
    self.active = IOHIDValueGetIntegerValue(value) >= _max;
    self.magnitude = IOHIDValueGetIntegerValue(value) / (float)_max;
}

@end
