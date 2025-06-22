//
//  godot_plugin_implementation.h
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#ifndef godot_plugin_implementation_h
#define godot_plugin_implementation_h

#include "core/version.h"

#if VERSION_MAJOR == 4
#include "core/object/class_db.h"
#else
#include "core/object.h"
#endif

class OMGLifecyclePlugin_iOS : public Object {
    GDCLASS(OMGLifecyclePlugin_iOS, Object);
    
    static void _bind_methods();
    
    static OMGLifecyclePlugin_iOS* instance;

    NSString*  m_pLastURLString = nullptr;
public:
    
    Error foo();
    
    OMGLifecyclePlugin_iOS();
    ~OMGLifecyclePlugin_iOS();

    void openURL( NSURL* pURL );
    void applicationDidBecomeActive();

    static OMGLifecyclePlugin_iOS* get_singleton();

    String get_last_url_string();

    static NSURL* pEarlyOpenURL;
};

#endif /* godot_plugin_implementation_h */
