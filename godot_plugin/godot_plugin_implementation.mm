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

OMGLifecyclePlugin_iOS* OMGLifecyclePlugin_iOS::instance = nullptr;
NSURL* OMGLifecyclePlugin_iOS::pEarlyOpenURL = nullptr;

static const String RECEIVED_URL_SIGNAL = "received_url";
static const String APPLICATION_DID_BECOME_ACTIVE_SIGNAL = "application_did_become_active";

void OMGLifecyclePlugin_iOS::_bind_methods() {
    ClassDB::bind_method(D_METHOD("foo"), &OMGLifecyclePlugin_iOS::foo);
    ClassDB::bind_method(D_METHOD("get_last_url_string"), &OMGLifecyclePlugin_iOS::get_last_url_string);

    ADD_SIGNAL(
        MethodInfo(
            RECEIVED_URL_SIGNAL,
            PropertyInfo(
                Variant::STRING, "url"
            )
        )
    );
    ADD_SIGNAL(
        MethodInfo(
            APPLICATION_DID_BECOME_ACTIVE_SIGNAL
        )
    );
}

Error OMGLifecyclePlugin_iOS::foo() {
    NSLog(@"OMGLifecyclePlugin_iOS::foo");
    return OK;
}

OMGLifecyclePlugin_iOS::OMGLifecyclePlugin_iOS() {
    NSLog(@"OMGLifecyclePlugin_iOS initialize object");

    // :TODO: fail if instance is not nullptr
    this->instance = this;
    
    if( OMGLifecyclePlugin_iOS::pEarlyOpenURL != nullptr ) {
        NSString *urlString = [OMGLifecyclePlugin_iOS::pEarlyOpenURL.absoluteString copy];
        this->m_pLastURLString = urlString;        
    }
}

OMGLifecyclePlugin_iOS::~OMGLifecyclePlugin_iOS() {
    NSLog(@"OMGLifecyclePlugin_iOS deinitialize object");
    this->instance = nullptr;
}

OMGLifecyclePlugin_iOS* OMGLifecyclePlugin_iOS::get_singleton() {
    return OMGLifecyclePlugin_iOS::instance;
}

void OMGLifecyclePlugin_iOS::openURL( NSURL* pURL ) {
    NSString *urlString = [pURL.absoluteString copy];
    this->m_pLastURLString = urlString;
    emit_signal( RECEIVED_URL_SIGNAL, [ urlString UTF8String ]);
}

void OMGLifecyclePlugin_iOS::applicationDidBecomeActive() {
    emit_signal( APPLICATION_DID_BECOME_ACTIVE_SIGNAL );
}

String OMGLifecyclePlugin_iOS::get_last_url_string() {
    NSString* s;
    if( this->m_pLastURLString == nullptr ) {
        s = [[NSString alloc] init];
    } else {
        s = [[NSString alloc] initWithString: this->m_pLastURLString];
    }

    return [s UTF8String];
}
