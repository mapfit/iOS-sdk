//
//  TGTypes.h
//  TangramMap
//
//  Created by Karim Naaji on 4/20/17.
//  Copyright (c) 2017 Mapzen. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Indicates an error occurred in the Tangram Framework.
extern NSString* const TGErrorDomain;

/**
 Describes ease functions to be used for camera or other transition animation.
 */
typedef NS_ENUM(NSInteger, TGEaseType) {
    TGEaseTypeCubicIn,
    /// f = _t * _t * _t;
    TGEaseTypeCubicOut,
    /// f = --_t * _t * _t + 1;
    TGEaseTypeCubicInOut,
    /// f = ((_t *= 2) <= 1 ? _t * _t * _t : (_t -= 2) * _t * _t + 2) / 2;
    TGEaseTypeQuartIn,
    /// f = _t * _t * _t * _t;
    TGEaseTypeQuartOut,
    /// f = 1 - (--_t) * _t * _t * _t;
    TGEaseTypeQuartInOut,
    /// f = _t < .5 ? 8 * _t * _t * _t * _t : 1 - 8 * (--_t) * _t * _t * _t;
    TGEaseTypeQuintIn,
    /// f = _t * _t * _t * _t * _t;
    TGEaseTypeQuintOut,
    ///  f = 1 + (--_t) * _t * _t * _t * _t;
    TGEaseTypeQuintInOut,
    /// f = _t < .5 ? 16 * _t * _t * _t * _t * _t : 1 + 16 * (--_t) * _t * _t * _t * _t;
    TGEaseTypeSineIn,
    /// f = static_cast<float>(1 - cos(_t * PI / 2));
    TGEaseTypeSineOut,
    /// f = static_cast<float>(sin(_t * PI / 2));
    TGEaseTypeSineInOut,
    /// f = static_cast<float>((1 + sin(PI * _t - PI / 2)) / 2);
    TGEaseTypeExpIn,
    /// f = static_cast<float>(pow(2, 10 * _t - 10));
    TGEaseTypeExpOut,
    /// f = static_cast<float>(1 - pow(2, -10 * _t));
    TGEaseTypeExpInOut
    /// ((f *= 2) <= 1 ? pow(2, 10 * f - 10) : 2 - pow(2, 10 - 10 * f)) / 2);
};

/**
 Describes <a href="https://mapzen.com/documentation/tangram/Cameras-Overview/#camera-types">
 Tangram camera types</a>.
 */
typedef NS_ENUM(NSInteger, TGCameraType) {
    /// Type for a <a href="https://mapzen.com/documentation/tangram/Cameras-Overview/#perspective-camera">perspective camera</a>
    TGCameraTypePerspective = 0,
    /// Type for an <a href="https://mapzen.com/documentation/tangram/Cameras-Overview/#isometric-camera">isometric camera</a>
    TGCameraTypeIsometric,
    /// Type for a <a href="https://mapzen.com/documentation/tangram/Cameras-Overview/#flat-camera">flat camera</a>
    TGCameraTypeFlat,
};

/**
 Error statuses from Tangram
 */
typedef NS_ENUM(NSInteger, TGError) {
    /// No Error
    TGErrorNone,
    /// The path of the scene update was not found on the scene file
    TGErrorSceneUpdatePathNotFound,
    /// The YAML syntax of the scene udpate path has a syntax error
    TGErrorSceneUpdatePathYAMLSyntaxError,
    /// The YAML syntax of the scene update value has a syntax error
    TGErrorSceneUpdateValueYAMLSyntaxError,
    /// No valid scene was loaded (and on tries to update the scene)
    TGErrorNoValidScene,
    /// An error code for markers
    TGErrorMarker,
};

/**
 Debug flags to render additional information about various map components
 */
typedef NS_ENUM(NSInteger, TGDebugFlag) {
    /// While on, the set of tiles currently being drawn will not update to match the view
    TGDebugFlagFreezeTiles = 0,
    /// Apply a color change to every other zoom level to visualize proxy tile behavior
    TGDebugFlagProxyColors,
    /// Draw tile boundaries
    TGDebugFlagTileBounds,
    /// Draw tile infos (tile coordinates)
    TGDebugFlagTileInfos,
    /// Draw label bounding boxes and collision grid
    TGDebugFlagLabels,
    /// Draw tangram infos (framerate, debug log...)
    TGDebugFlagTangramInfos,
    /// Draw all labels (including labels being occluded)
    TGDebugFlagDrawAllLabels,
    /// Draw tangram frame graph stats
    TGDebugFlagTangramStats,
    /// Draw feature selection framebuffer
    TGDebugFlagSelectionBuffer,
};

