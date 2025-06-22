//
//  godot_plugin_implementation.m
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "core/object/class_db.h"
#include "core/config/project_settings.h"

#import "godot_plugin_implementation.h"

void OMGLifecyclePlugin_iOS::_bind_methods() {
    ClassDB::bind_method(D_METHOD("foo"), &OMGLifecyclePlugin_iOS::foo);
}

Error OMGLifecyclePlugin_iOS::foo() {
    NSLog(@"OMGLifecyclePlugin_iOS::foo");
    return OK;
}

OMGLifecyclePlugin_iOS::OMGLifecyclePlugin_iOS() {
    NSLog(@"initialize object");
}

OMGLifecyclePlugin_iOS::~OMGLifecyclePlugin_iOS() {
    NSLog(@"deinitialize object");
}
