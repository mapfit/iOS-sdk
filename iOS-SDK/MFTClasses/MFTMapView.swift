//
//  MFTMapView.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/13/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import UIKit
import TangramMap
import CoreLocation
import SystemConfiguration

/**
 `MFTMapView` This is the main class of the Mapfit SDK for iOS and is the entry point for methods related to the map.
 */

open class MFTMapView: UIView {
    //CHANGE TO PUBLIC AS NEEDED
    internal var uuid: UUID = UUID()
    public var layers: [MFTLayer] = [MFTLayer]()
    public var defaultAnnotationMFTLayer: MFTLayer = MFTLayer()
    public var directionsOptions = MFTDirectionsOptions()
    public var mapOptions = MFTMapOptions()
    internal var easeDuration: Float = 0.4
    internal var placeInfo: MFTPlaceInfo?
    internal var placeInfoTimer = Timer()
    internal var minMaxZoomTimer = Timer()
    internal var placeInfoXAnchorPadding: CGFloat = -145
    internal var placeInfoYAnchorPadding: CGFloat = -120
    internal var placeInfoAdapter: MFTPlaceInfoAdapter?
    private var dataMFTLayer: TGMapData?
    private var placeMarkMarker: MFTMarker?
    private var placeInfoTapGesture = UITapGestureRecognizer()
    
    /// The current center of the map.
    internal var position: CLLocationCoordinate2D
    /// The current tile level.
    internal var tilt: Float
    /// The current zoom level.
    internal var zoom: Float
    /// The current roation, in radians from north.
    internal var rotation: Float
    
    // Receiever for single tap callbacks
    weak public var singleTapGestureDelegate: MapSingleTapGestureDelegate?
    
    /// Receiver for double tap callbacks
    weak public var doubleTapGestureDelegate: MapDoubleTapGestureDelegate?
    
    /// Receiver for single tap callbacks
    weak public var longPressGestureDelegate: MapLongPressGestureDelegate?
    
    /// Receiver for pan gesture callbacks
    weak public var panDelegate: MapPanGestureDelegate?
    
    /// Receiver for pinch gesture callbacks
    weak public var pinchDelegate: MapPinchGestureDelegate?
    
    /// Receiver for rotation gesture callbacks
    weak public var rotateDelegate: MapRotateGestureDelegate?
    
    /// Receiver for shove gesture callbacks
    weak public var shoveDelegate: MapShoveGestureDelegate?
    
    /// Receiver for feature selection callbacks
    weak internal var featureSelectDelegate: MapFeatureSelectDelegate?
    
    /// Receiver for label selection callbacks
    weak internal var labelSelectDelegate: MapLabelSelectDelegate?
    
    /// Receiver for marker selection callbacks
    weak public var markerSelectDelegate: MapMarkerSelectDelegate?
    
    weak public var placeInfoSelectDelegate: MapPlaceInfoSelectDelegate?
    
    weak public var polygonSelectDelegate: MapPolygonSelectDelegate?
    
    weak public var polylineSelectDelegate: MapPolylineSelectDelegate?
    
    /// Receiver for tile load completion callbacks
    weak internal var tileLoadDelegate: MapTileLoadDelegate?
    private var isUserLocationEnabled: Bool = false
    
    internal var tgMapView: TGMapViewController = TGMapViewController()
    
    private static let MapfitGeneralErrorDomain = "MapfitGeneralErrorDomain"
    private static let mapfitRights =  "https://mapfit.com/terms"
    
    public typealias OnStyleLoaded = (MFTMapTheme) -> ()
    fileprivate var onStyleLoadedClosure : OnStyleLoaded? = nil

    let application : ApplicationProtocol
    
    //Location Properties
    var shouldShowCurrentLocation = false
    private var locale = Locale.current
    var lastSetPoint: TGGeoPoint?
    var currentLocation = CLLocation()
    
    //transit
    var transitOverlayIsShowing = false
    var bikeOverlayIsShowing = false
    var walkingOverlayIsShowing = false
    
    var sceneUpdates: [TGSceneUpdate] = []
    var globalSceneUpdates: [TGSceneUpdate] = []
    fileprivate var sceneLoadCallback: OnStyleLoaded?
    
    //Style Properties
    //var currentStyle: MFTMapTheme = .day
    
    //amount of times a scene has been loaded 
    public var latestSceneId: Int32 = 0
    
    var firstRun: Bool = true
    private var attributionBtn: UIButton = UIButton()
    private var zoomPlusBtn: UIButton = UIButton()
    private var zoomMinusBtn: UIButton = UIButton()
    let mapfitManger: MFTManagerProtocol
    
    
    //stackview buttons
    lazy var toggleStackView: UIStackView = UIStackView()
    lazy var zoomPlusButton: UIButton = UIButton()
    lazy var zoomMinusButton: UIButton = UIButton()
    lazy var userLocationButton: UIButton = UIButton()
    lazy var recenterButton: UIButton = UIButton()
    lazy var compassButton: UIButton = UIButton()
    
    //Markers
    public var currentMarkers: [TGMarker : MFTMarker] = Dictionary()
    public var currentPolylines: [TGGeoPolyline : MFTPolyline] = Dictionary()
    public var currentPolygons: [TGGeoPolygon : MFTPolygon] = Dictionary()
    public var currentAnnotations: [UUID : MFTAnnotation] = Dictionary()
    private var dataLayers: [UUID : TGMapData] = Dictionary()
    //Marker Info View
    let zoomButtonsView = MFTZoomButtonsView()
    
    
    //attribution button bottom constraint
    var initialAttributionBottomConstraintConstant: CGFloat = -16.5
    var pressedAttributionBottomConstraintConstant: CGFloat = -35
    var initialLegalButtonBottomConstraintConstant: CGFloat = 30
    var pressedLegalButtonBottomConstraintConstant: CGFloat = -10
    
    var attributionButtonBottomConstraint = NSLayoutConstraint()
    var legalButtonBottomConstraint = NSLayoutConstraint()
    let httpHandler = TGHttpHandler()
    
    //Legal Notices button
    lazy var legalButton: UIButton = UIButton()

    
    
    //MARK: - Creating Instances
    
    /**
     Initializes and returns a newly allocated map view with the specified frame and the default style.
     - parameter frame: The frame for the view, measured in points.
     - returns: An initialized map view.
     */
    public override init(frame: CGRect) {
        
        self.application = UIApplication.shared
        self.mapfitManger = MFTManager.sharedManager
        self.position = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445)
        
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let httpHandler = TGHttpHandler.init(sessionConfiguration: configuration)
        httpHandler.httpAdditionalHeaders = NSMutableDictionary(dictionary: MFTManager.sharedManager.httpHeaders())
        tgMapView.httpHandler = httpHandler
        
        self.zoom = 1
        self.rotation = 0
        self.tilt = 0
        
        super.init(frame: frame)
        self.directionsOptions.setMapView(self)
        self.mapOptions.setMapView(mapView: self)
        self.mapOptions.setTheme(theme: .day)
        self.setUpView(frame: frame, position: self.position, customTheme: nil) // Default statue of liberty
        
        self.setDelegates()
        self.setupAttribution()
        self.setUpMapControls()
        self.accessibilityIdentifier = "mapView"
    }
    
    /**
     Initializes and returns a newly allocated map view with the specified frame, positions mapstyle.
     - parameter frame: The frame for the view, measured in points.
     - parameter position: The center coordinate of the map.
     - parameter style: The appearance style of the map.
     */
    
    public convenience init(frame: CGRect, position: CLLocationCoordinate2D, mapStyle: MFTMapTheme) {
        self.init(frame: frame)
        self.position = position
        self.setCenter(position: position)
        self.directionsOptions.setMapView(self)
        self.mapOptions = MFTMapOptions(mapView: self)
        self.mapOptions.setTheme(theme: mapStyle)
    }
    
    public init(frame: CGRect, customMapStyle: String) {
        self.application = UIApplication.shared
        self.mapfitManger = MFTManager.sharedManager
        self.position = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445)
        
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let httpHandler = TGHttpHandler.init(sessionConfiguration: configuration)
        httpHandler.httpAdditionalHeaders = NSMutableDictionary(dictionary: MFTManager.sharedManager.httpHeaders())
        tgMapView.httpHandler = httpHandler
        
        self.zoom = 1
        self.rotation = 0
        self.tilt = 0
        
        super.init(frame: frame)
        self.directionsOptions.setMapView(self)
        self.mapOptions.setMapView(mapView: self)
        self.mapOptions.setTheme(theme: .custom)
        
        self.setUpView(frame: frame, position: self.position, customTheme: customMapStyle) // Default statue of liberty
        
        self.setDelegates()
        self.setupAttribution()
        self.setUpMapControls()
        self.accessibilityIdentifier = "mapView"
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Manipulating Viewpoint
    
    /**
     Changes the center coordinate of the map.
     - parameter position: The center coordinate of the map.
     */
    
    public func setCenter(position: CLLocationCoordinate2D){
        tgMapView.position = TGGeoPointMake(position.longitude, position.latitude)
        self.position = position
    }
    
    
    /**
     Changes the center coordinate of the map.
     - parameter position: The center coordinate of the map.
     - parameter duration: The duration of the centering animation.
     */
    
    public func setCenter(position: CLLocationCoordinate2D, duration: Float){
        self.position = position
        tgMapView.animate(toPosition: TGGeoPointMake(position.longitude, position.latitude), withDuration: duration, with: .cubic)
        
    }
    
    private func animateTocenter(position: CLLocationCoordinate2D, duration: Float){
        tgMapView.animate(toPosition: TGGeoPointMake(position.longitude, position.latitude), withDuration: duration, with: .cubic)
    }
    
    /**
     Map will be re-centered to the last position it is centered.
     */
    
    public func reCenter(){
        tgMapView.animate(toPosition: TGGeoPointMake(position.longitude, position.latitude), withDuration: easeDuration, with: .cubic)
    }
    
    public func setCenterWithOffset(latLng: CLLocationCoordinate2D, offsetX: Int, offsetY: Int, duration: Float){
        let center = computeOffsetToPoint(from: latLng, distance: Double(offsetY), heading: Double(offsetX))
        setCenter(position: center, duration: duration)
    }
    
    private func computeOffsetToPoint(from: CLLocationCoordinate2D, distance: Double, heading: Double) -> CLLocationCoordinate2D {
        let dist = distance / 6371009
        let radHeading = heading.degreesToRadians
        // http://williams.best.vwh.net/avform.htm#LL
        let fromLat = from.latitude.degreesToRadians
        let fromLng = from.longitude.degreesToRadians
        let cosDistance = cos(dist)
        let sinDistance = sin(dist)
        let sinFromLat = sin(fromLat)
        let cosFromLat = cos(fromLat)
        let sinLat = cosDistance * sinFromLat + sinDistance * cosFromLat * cos(radHeading)
        let dLng = atan2(sinDistance * cosFromLat * sin(radHeading), cosDistance - sinFromLat * sinLat)
        return CLLocationCoordinate2D(latitude: asin(sinLat).radiansToDegrees, longitude: (fromLng + dLng).radiansToDegrees)
    }
    
    
    /**
     Returns the center coordinate of the map.
     - returns: The center coordinate of the map.
     */
    
    public func getCenter()-> CLLocationCoordinate2D {
        return self.position
    }
    
    /**
     Changes the zoom level of the map.
     - parameter zoomLevel: The new zoom level of the map.
     */
    
    public func setZoom(zoomLevel: Float){
        var zoomL = zoomLevel
        if zoomLevel > mapOptions.getMaxZoomLevel() {
            zoomL = mapOptions.getMaxZoomLevel()
        }
        
        if zoomLevel < mapOptions.getMinZoomLevel() {
            zoomL = mapOptions.getMinZoomLevel()
        }
        
        self.tgMapView.zoom = zoomL
        self.zoom = zoomL
    }
    
    /**
     Changes the zoom level of the map.
     - parameter zoomLevel: The new zoom level of the map.
     - parameter duration: The duration of the zooming animation.
     */
    
    public func setZoom(zoomLevel: Float, duration: Float){
        var zoomL = zoomLevel
        if zoomLevel > mapOptions.getMaxZoomLevel() {
            zoomL = mapOptions.getMaxZoomLevel()
        }
        
        if zoomLevel < mapOptions.getMinZoomLevel() {
            zoomL = mapOptions.getMinZoomLevel()
        }
        
        self.zoom = zoomL
        tgMapView.animate(toZoomLevel: zoomL, withDuration: duration, with: .cubic)
        
    }
    
    /**
     Returns the zoom level of the map.
     - returns: The zoom level of the map.
     */
    
    public func getZoom() -> Float {
        return self.zoom
    }
    
    /**
     Changes the tilt level of the map.
     - parameter tiltLevel: The new tilt level of the map.
     */
    
    public func setTilt(tiltValue: Float){
        self.tilt = tiltValue
        tgMapView.tilt = tiltValue
    }
    
    /**
     Changes the tilt level of the map.
     - parameter tiltLevel: The new tilt level of the map.
     - parameter duration: The duration of the tilt animation.
     */
    
    public func setTilt(tiltValue: Float, duration: Float){
        self.tilt = tiltValue
        tgMapView.animate(toTilt: tiltValue, withDuration: duration)
    }
    
    /**
     Returns the tilt level of the map.
     - returns: The tilt level of the map.
     */
    
    public func getTilt()->Float{
        return tgMapView.tilt
    }
    
    /**
     Changes the rotation value of the map.
     - parameter rotationValue: The new rotation value of the map.
     */
    
    public func setRotation(rotationValue: Float){
        self.rotation = rotationValue
        tgMapView.rotation = rotationValue
    }
    
    /**
     Changes the rotation value of the map.
     - parameter rotationValue: The new rotation value of the map.
     - parameter duration: The duration of the rotation animation.
     */
    
    public func setRotation(rotationValue: Float, duration: Float){
        self.rotation = rotationValue
        tgMapView.animate(toRotation: rotationValue, withDuration: duration, with: .cubic)
    }
    
    /**
     Returns the rotation value of the map.
     - returns: The current rotation value of the map.
     */
    
    public func getRotation()->Float{
        return tgMapView.rotation
    }
    
    
    /**
     Changes the map view to fit the given coordinate bounds.
     - parameter bounds: The bounds coordinates for the new view.
     - parameter padding: The minimum padding that will be visible around the given coordinate bounds.
     */
    
    public func setLatLngBounds(bounds: MFTLatLngBounds, padding: Float){
        let pair = bounds.getVisibleBounds(viewWidth: Float(tgMapView.view.bounds.width * UIScreen.main.scale), viewHeight: Float(tgMapView.view.bounds.height * UIScreen.main.scale), padding: padding)
        self.setCenter(position: CLLocationCoordinate2D(latitude: pair.0.latitude, longitude: pair.0.longitude))
        self.setZoom(zoomLevel: pair.1)
    }
    
    /**
     Changes the map view to fit the given coordinate bounds.
     - parameter bounds: The bounds coordinates for the new view.
     - parameter padding: The minimum padding that will be visible around the given coordinate bounds.
     - parameter duration: The duration animation duration for the setting of the lat lng bounds.
     */
    
    public func setLatLngBounds(bounds: MFTLatLngBounds, padding: Float, duration: Float){
        let pair = bounds.getVisibleBounds(viewWidth: Float(tgMapView.view.bounds.width * UIScreen.main.scale), viewHeight: Float(tgMapView.view.bounds.height * UIScreen.main.scale), padding: padding)
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = (2)
        queue.addOperation({self.setCenter(position: CLLocationCoordinate2D(latitude: pair.0.latitude, longitude: pair.0.longitude), duration: duration)})
        queue.addOperation({self.setZoom(zoomLevel: pair.1, duration: duration)})
    }
    
    /**
     Returns the bounds coordinates of the map.
     - returns: The bounds coordinates for the map.
     */
    
    
    public func getLatLngBounds()-> MFTLatLngBounds{
        let sw = tgMapView.screenPosition(toLngLat: CGPoint(x: 0, y: tgMapView.view.bounds.height))
        let ne = tgMapView.screenPosition(toLngLat: CGPoint(x: tgMapView.view.bounds.width, y: 0))
        return MFTLatLngBounds(northEast: CLLocationCoordinate2DMake(ne.latitude, ne.longitude), southWest: CLLocationCoordinate2DMake(sw.latitude, sw.longitude))
    }
    
    
    
    
    //MARK: - Annotating the Map
    
    /**
     Returns the current layers on the map.
     - returns: The current layers on the map.
     */
    public func getLayers() -> [MFTLayer] {
        return layers
        
    }
    
    /**
     Adds a new layer onto the map.
     - parameter layer: The layer to be added to the map.
     */
    public func addLayer(layer: MFTLayer) {
        for annotation in layer.annotations {
            addAnnotation(annotation)
        }
        
        layer.bindToMap(mapView: self)
        layers.append(layer)
    }
    
    /**
     Removes a layer from the map.
     - parameter layer: The layer to be removed from the map.
     */
    
    public func removeLayer(layer: MFTLayer){
        for annotation in layer.annotations {
            removeAnnotation(annotation)
        }
        for mapMFTLayer in layers {
            var layerIndexToRemove: Int?
            if mapMFTLayer.uuid == layer.uuid {
                layerIndexToRemove = layers.index(of: mapMFTLayer)!
            }
            
            if let index = layerIndexToRemove {
                layers.remove(at: index)
            }
        }
        
    }
    
    /**
     Adds a a group of annotations to the map.
     - parameter annotations: The group of annotations to be added to the map.
     */
    
    internal func addAnnotations(_ annotations: [MFTAnnotation]){
        for annotation in annotations {
            addAnnotation(annotation)
        }
    }
    
    
    
    /**
     Adds a new annotation to the map.
     - parameter annotation: The annotation to be added to the map.
     */
    
    internal func addAnnotation(_ annotation: MFTAnnotation){
        switch annotation.style {
            
        case .point :
            let marker = annotation as! MFTMarker
            _ = addMarkerToMap(marker)
            
        case .polygon:
            let polygon = annotation as! MFTPolygon
            self.addPolygon(polygon: polygon)
            
        case .polyline:
            let polyline = annotation as! MFTPolyline
            self.addPolyline(polyline: polyline)
            
            
        }
    }
    
    /**
     Removes a group of annotations from the map.
     - parameter annotations: The annotations to be removed from the map.
     */
    
    internal func removeAnnotations(_ annotations: [MFTAnnotation]){
        for annotation in annotations {
            removeAnnotation(annotation)
        }
    }
    
    /**
     Removes an annotations from the map.
     - parameter annotation: The annotation to be removed from the map.
     */
    
    internal func removeAnnotation(_ annotation: MFTAnnotation){
        
        switch annotation.style {
            
        case .point :
            let marker = annotation as! MFTMarker
            removeMarker(marker)
            
            
        case .polygon:
            let polygon = annotation as! MFTPolygon
            removePolygon(polygon)
            
            
        case .polyline:
            let polyline = annotation as! MFTPolyline
            removePolyline(polyline)
            
        }
    }
    
    
    private func clearMap(){
        for (_,annotation) in self.currentAnnotations{
            removeAnnotation(annotation)
        }
    }
    
    private func reDrawAnnotations(){
        for (_,annotation) in self.currentAnnotations{
            addAnnotation(annotation)
        }
        tgMapView.requestRender()
    }
    
    
    /**
     Adds a marker to the map. Returns marker for styling and place info customization.
     - parameter position: The position of the marker to be added to the map.
     - returns: The marker that was added to the map.
     */
    
    public func addMarker(position: CLLocationCoordinate2D) -> MFTMarker {
        let options = MFTMarkerOptions()
        options.position = position
        let marker = MFTMarker(markerOptions: options)
        marker.mapView = self
        self.addMarkerToMap(marker)
        return marker
        
        
    }
    
    public func addMarker(_ options: MFTMarkerOptions, completion: ((_ returnedMarker: MFTMarker?, _ error: Error?)->Void)?){
        let marker = MFTMarker(markerOptions: options)
        
        if (options.geocode) || (options.building){
            
            marker.geocode { (marker, error) in
                
                if let err = error {
                    if let comp = completion {
                        comp(nil, err)
                    }
                 
                }
                
                if let mark = marker {
                    if let comp = completion {
                        mark.mapView = self
                        self.addMarkerToMap(mark)
                        if let polygon = mark.buildingPolygon {
                            self.addPolygon(polygon: polygon)
                        }
                        
                        comp(mark, nil)
                    }
                }
            }
        }
    }
    
    
    /**
     Adds a marker to the map after the address has been geocoded. Returns marker for styling and place info customization.
     - parameter address: The address of the marker to be added to the map.
     - returns: The marker that was added to the map.
     */
    
    
    
//    public func addMarker(address: String, completion:@escaping (_ marker: MFTMarker?, _ errror: Error?)->Void){
//        MFTGeocoder.sharedInstance.geocode(address: address, includeBuilding: true) { (addresses, error) in
//            if error == nil {
//                guard let addressObject = addresses else { return }
//                
//                let response = MFTGeocoder.sharedInstance.parseAddressObjectForPosition(addressObject: addressObject)
//                
//                guard let position = response.0 else { return }
//                
//                
//                DispatchQueue.main.async {
//                    let address = addressObject[0]
//                    //add Marker
//                    let markerOptions = MFTMarkerOptions()
//                    markerOptions.position = CLLocationCoordinate2DMake(position.latitude, position.longitude)
//                    
//                    //self.addAnnotation(marker!)
//                    
//                    //add building polygon
//                    if let building = address.building{
//                        var polygon = [CLLocationCoordinate2D]()
//                        if let _ = building.coordinates {
//                            guard let polygonCoordinates = building.coordinates else { return }
//                            for point in polygonCoordinates[0]{
//                                polygon.append(CLLocationCoordinate2DMake(point[1], point[0]))
//                            }
//                            
//    
//                            
//                            markerOptions.addBuildingPolygon(true, options: markerOptions.buildingPolygonOptions ?? MFTPolygonOptions())
//                            
//                            
//                            self.addMarker(markerOptions, completion: { (marker, error) in
//                                if var annotations = marker?.subAnnotations {
//                                    annotations["building"] = marker?.buildingPolygon
//                                }else{
//                                    marker?.subAnnotations = ["building" : marker?.buildingPolygon as! MFTAnnotation]
//                                }
//                                completion(marker, nil)
//                            })
//                        }
//                    }
//                    
//                }
//            } else {
//                completion(nil, error)
//            }
//            
//        }
//    }
    
    /**
     Enables customizaion of placeinfo view.
     - parameter adapter: The adapter that will be responsible for creating to the view that will be displayed when a marker is tapped.
     */
    
    public func setPlaceInfoAdapter(adapter: MFTPlaceInfoAdapter) {
        
        self.placeInfoAdapter = adapter
    }
    
    
    //MARK: - Annotating the Map (Private Functions)
    
    public func removeMarker(_ marker: MFTMarker) {
        guard let tgMarker = marker.tgMarker else { return }
        currentMarkers.removeValue(forKey: tgMarker)
        currentAnnotations.removeValue(forKey: marker.uuid)
        tgMapView.markerRemove(tgMarker)
        marker.subAnnotations?.removeAll()
    }
    
    public func removePolyline(_ polyline: MFTPolyline) {
        guard let tgPolyline = polyline.tgPolyline else { return }
        currentPolylines.removeValue(forKey: tgPolyline)
        currentAnnotations.removeValue(forKey: polyline.uuid)
        let dataLayer = dataLayers[polyline.uuid]
        dataLayers.removeValue(forKey: polyline.uuid)
        dataLayer?.remove()
        dataLayer?.clear()
        
    }
    
    public func removePolygon(_ polygon: MFTPolygon) {
        guard let tgPolygon = polygon.tgPolygon else { return }
        currentPolygons.removeValue(forKey: tgPolygon)
        currentAnnotations.removeValue(forKey: polygon.uuid)
        let dataLayer = dataLayers[polygon.uuid]
        dataLayers.removeValue(forKey: polygon.uuid)
        dataLayer?.remove()
        dataLayer?.clear()
        
    }
    
    
    //adds marker to the map
    private func addMarkerToMap(_ marker: MFTMarker){
        if marker.tgMarker == nil {
            marker.tgMarker = tgMapView.markerAdd()
        }
        currentMarkers[marker.tgMarker!] = marker
        currentAnnotations[marker.uuid] = marker
        defaultAnnotationMFTLayer.add(annotation: marker)
        
    }
    
    fileprivate func restoreUserMarkers() {
        //Since we're re-initializing markers, we need to redo the linkage we're using between them
        for (_, marker) in currentMarkers {
            marker.tgMarker = nil
            self.addMarkerToMap(marker)
        }
    }
    
    public func addPolyline(options: MFTPolylineOptions) -> MFTPolyline?{
        let rPolyline = MFTPolyline(polylineOptions: options)
        let tgPolyline = TGGeoPolyline()
        rPolyline.tgPolyline = tgPolyline
        drawPolyline(polyline: rPolyline)
        let layer = tgMapView.addDataLayer("mz_default_line")
        if let dataLayer = layer {
            rPolyline.dataLayer = dataLayer
            self.dataLayers[rPolyline.uuid] = dataLayer
            dataLayer.add(tgPolyline, withProperties: ["type":"polyline", "uuid" : "\(rPolyline.uuid)", "line_color" : "\(rPolyline.strokeColor)", "line_width" : "\(rPolyline.strokeWidth)", "line_stroke_width" : "\(rPolyline.strokeOutlineWidth)", "line_stroke_color" : "\(rPolyline.strokeOutlineColor)", "line_cap" : "\(rPolyline.lineCapType.rawValue)", "line_join" : "\(rPolyline.lineJoinType.rawValue)", "line_order" : "\(rPolyline.drawOrder)"])
            currentPolylines[rPolyline.tgPolyline!] = rPolyline
            currentAnnotations[rPolyline.uuid] = rPolyline
            tgMapView.update()
        }
        
        return rPolyline
        
    }
    
    internal func addPolyline(polyline: MFTPolyline) {
        let tgPolyline = TGGeoPolyline()
        polyline.tgPolyline = tgPolyline
        drawPolyline(polyline: polyline)
        let layer = tgMapView.addDataLayer("mz_default_line")
        if let dataLayer = layer {
            polyline.dataLayer = dataLayer
            self.dataLayers[polyline.uuid] = dataLayer
            dataLayer.add(tgPolyline, withProperties: ["type":"polyline", "uuid" : "\(polyline.uuid)", "line_color" : "\(polyline.strokeColor)", "line_width" : "\(polyline.strokeWidth)", "line_stroke_width" : "\(polyline.strokeOutlineWidth)", "line_stroke_color" : "\(polyline.strokeOutlineColor)", "line_cap" : "\(polyline.lineCapType.rawValue)", "line_join" : "\(polyline.lineJoinType.rawValue)", "line_order" : "\(polyline.drawOrder)"])
            currentPolylines[polyline.tgPolyline!] = polyline
            currentAnnotations[polyline.uuid] = polyline
            tgMapView.update()
        }
    }
    
    public func addPolygon(options: MFTPolygonOptions)-> MFTPolygon?{
        let rPolygon = MFTPolygon(polygonOptions: options)
        let tgPolygon = TGGeoPolygon()
        rPolygon.tgPolygon = tgPolygon
        drawPolygon(polygon: rPolygon)

        let layer = tgMapView.addDataLayer("mz_default_polygon")
        if let dataLayer = layer {
            
            self.dataLayers[rPolygon.uuid] = dataLayer
            dataLayer.add(tgPolygon, withProperties: ["type":"polygon", "uuid" : "\(rPolygon.uuid)", "line_color" : "\(rPolygon.strokeColor)", "line_width" : "\(rPolygon.strokeWidth)", "line_stroke_width" : "\(rPolygon.strokeOutlineWidth)", "line_stroke_color" : "\(rPolygon.strokeOutlineColor)", "line_cap" : "\(rPolygon.lineCapType.rawValue)", "line_join" : "\(rPolygon.lineJoinType.rawValue)", "line_order" : "\(rPolygon.drawOrder)", "polygon_color" : "\(rPolygon.fillColor)"])
            currentPolygons[rPolygon.tgPolygon!] = rPolygon
            currentAnnotations[rPolygon.uuid] = rPolygon
            
            tgMapView.requestRender()
            tgMapView.update()
            
        }
        return rPolygon
    }
    
    internal func addPolygon(polygon: MFTPolygon) {
        polygon.mapView = self
        let tgPolygon = TGGeoPolygon()
        polygon.tgPolygon = tgPolygon
        drawPolygon(polygon: polygon)
        let layer = tgMapView.addDataLayer("mz_default_polygon")
       
        DispatchQueue.main.async {
            if let dataLayer = layer {
                self.dataLayers[polygon.uuid] = dataLayer
                dataLayer.add(tgPolygon, withProperties: ["type":"polygon", "uuid" : "\(polygon.uuid)", "line_color" : "\(polygon.strokeColor)", "line_width" : "\(polygon.strokeWidth)", "line_stroke_width" : "\(polygon.strokeOutlineWidth)", "line_stroke_color" : "\(polygon.strokeOutlineColor)", "line_cap" : "\(polygon.lineCapType.rawValue)", "line_join" : "\(polygon.lineJoinType.rawValue)", "line_order" : "\(polygon.drawOrder)", "polygon_color" : "\(polygon.fillColor)"])
                self.currentPolygons[polygon.tgPolygon!] = polygon
                self.currentAnnotations[polygon.uuid] = polygon
                self.tgMapView.update()
            }
        }
    }
    
    
    internal func updatePolylineStyle(_ polyline: MFTPolyline){
        
        let dataLayer = self.dataLayers[polyline.uuid]
        dataLayer?.clear()
        guard let tgPolyline = polyline.tgPolyline else { return }
        if let layer = dataLayer {
            
            var properties = [String : String]()
            properties["type"] = "polyline"
            properties["uuid"] = "\(polyline.uuid)"
            properties["line_color"] = String(describing: polyline.strokeColor)
            properties["line_width"] = String(describing: polyline.strokeWidth)
            properties["line_stroke_width"] = String(describing: polyline.strokeOutlineWidth)
            properties["line_stroke_color"] = String(describing: polyline.strokeOutlineColor)
            properties["line_cap"] = String(describing: polyline.lineJoinType.rawValue)
            properties["line_join"] = String(describing: polyline.lineCapType.rawValue)
            properties["line_order"] = String(describing: polyline.drawOrder)
            self.dataLayers[polyline.uuid] = layer
            layer.add(tgPolyline, withProperties: properties)
        }
        
    }
    
    internal func updatePolygonStyle(_ polygon: MFTPolygon){
        
        let dataLayer = self.dataLayers[polygon.uuid]
        dataLayer?.clear()
        guard let tgPolygon = polygon.tgPolygon else { return }
        if let layer = dataLayer {

            var properties = [String : String]()
            properties["type"] = "polygon"
            properties["uuid"] = "\(polygon.uuid)"
            properties["polygon_color"] = String(describing: polygon.fillColor)
            properties["line_color"] = String(describing: polygon.strokeColor)
            properties["line_width"] = String(describing: polygon.strokeWidth)
            properties["line_stroke_width"] = String(describing: polygon.strokeOutlineWidth)
            properties["line_stroke_color"] = String(describing: polygon.strokeOutlineColor)
            properties["line_cap"] = String(describing: polygon.lineJoinType.rawValue)
            properties["line_join"] = String(describing: polygon.lineCapType.rawValue)
            properties["line_order"] = String(describing: polygon.drawOrder)
            
            self.dataLayers[polygon.uuid] = layer
            layer.add(tgPolygon, withProperties: properties)
            
        }
        
    }
    

//    public func addPolygon(_ polygon: [[CLLocationCoordinate2D]], color: String)-> MFTPolygon?{
//        let rPolygon = MFTPolygon()
//        let tgPolygon = TGGeoPolygon()
//        rPolygon.tgPolygon = tgPolygon
//        rPolygon.addPoints(polygon)
//        drawPolygon(polygon: rPolygon)
//        
//        let layer = tgMapView.addDataLayer("mz_default_polygon")
//        if let dataLayer = layer {
//            
//            self.dataLayers[rPolygon.uuid] = dataLayer
//            dataLayer.add(tgPolygon, withProperties: ["type":"polygon", "uuid" : "\(rPolygon.uuid)"])
//            currentPolygons[rPolygon.tgPolygon!] = rPolygon
//            currentAnnotations[rPolygon.uuid] = rPolygon
//            
//            tgMapView.requestRender()
//            tgMapView.update()
//            
//        }
//        return rPolygon
//    }
    
    
    
    private func drawPolygon(polygon: MFTPolygon){
        let coordinates = polygon.points[0]
        for (index, point) in coordinates.enumerated() {
            if index == 0 {
                polygon.tgPolygon?.startPath(TGGeoPointMake(point.longitude, point.latitude))
            }else{
                polygon.tgPolygon?.add(TGGeoPointMake(point.longitude, point.latitude))
            }
        }
    }
    
    private func drawPolyline(polyline: MFTPolyline){
        let points = polyline.points[0]
        for point in points {
            polyline.tgPolyline?.add(TGGeoPointMake(point.longitude, point.latitude))
        }
    }
    
    
    private func setDelegates(){
        tgMapView.mapViewDelegate = self
        tgMapView.gestureDelegate = self
        zoomButtonsView.delegate = self
    }
    
    private func setUpView(frame: CGRect, position: CLLocationCoordinate2D, customTheme: String?){
        
        self.addSubview(tgMapView.view)
        self.sendSubview(toBack: tgMapView.view)
        self.layer.masksToBounds = true
        
        
        tgMapView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = tgMapView.view.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightConstraint = tgMapView.view.rightAnchor.constraint(equalTo: self.rightAnchor)
        let topConstraint = tgMapView.view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraint = tgMapView.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        
        //Set Position and initial position for recenter button
        self.position = position
        
        //check if API Key is empty 
        guard let _ = mapfitManger.apiKey else { return }
        
        if let theme = customTheme {
            try? loadCustomThemeAsync(theme)
        }else{
            try? loadMapfitStyleAsync(mapOptions.mapTheme, locale: self.locale)
        }

        
    }
    
    
    
    private func setupAttribution(){
        attributionBtn = UIButton()
        //attributionBtn.setTitle("Powered by Mapfit", for: .normal)
        
        //attributionBtn.setImage(UIImage(named: "Watermark_Day_Sm.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        attributionBtn.imageView?.contentMode = .scaleAspectFit
        attributionBtn.setTitleColor(.darkGray, for: .normal)
        attributionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        attributionBtn.addTarget(self, action: #selector(attributionButtonTapped), for: .touchUpInside)
        attributionBtn.sizeToFit()
        attributionBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(attributionBtn)
        
        //tabbaroffset
        self.attributionBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        self.attributionBtn.heightAnchor.constraint(equalToConstant: 41.3).isActive = true
        self.attributionBtn.widthAnchor.constraint(equalToConstant: 38.6).isActive = true
        self.attributionButtonBottomConstraint = attributionBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: initialAttributionBottomConstraintConstant)
        
        if mapOptions.mapTheme == .day {
            attributionBtn.setImage(UIImage(named: "Watermark_Day_Sm.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }else{
            attributionBtn.setImage(UIImage(named: "Watermark_Night_Sm.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }
        
        attributionButtonBottomConstraint.isActive = true
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 9)]
        
        let attributedString = NSMutableAttributedString(string: "Mapfit Legal", attributes: attributes)
        legalButton.addTarget(self, action: #selector(legalButtonTapped), for: .touchUpInside)
        legalButton.setAttributedTitle(attributedString, for: .normal)
        self.addSubview(legalButton)
        legalButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.legalButtonBottomConstraint = self.legalButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: initialLegalButtonBottomConstraintConstant)
        self.legalButtonBottomConstraint.isActive = true
        self.legalButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
    }
    
    private func setUpMapControls() {
        //set images
        
        userLocationButton.setImage(UIImage(named: "currentLocation.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        recenterButton.setImage(UIImage(named: "reCenter.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        compassButton.setImage(UIImage(named: "compassNorth.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        
        
        //aspect fill
        userLocationButton.imageView?.contentMode = .scaleToFill
        recenterButton.imageView?.contentMode = .scaleToFill
        compassButton.imageView?.contentMode = .scaleToFill
        
        //add Targets
        recenterButton.addTarget(self, action: #selector(recenterButtonTapped), for: .touchUpInside)
        userLocationButton.addTarget(self, action: #selector(userLocationButtonTapped), for: .touchUpInside)
        compassButton.addTarget(self, action: #selector(compassButtonTapped), for: .touchUpInside)
        
        
        recenterButton.translatesAutoresizingMaskIntoConstraints = false
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        
        if !mapOptions.isUserLocationEnabled && mapOptions.isUserLocationButtonVisible {
            userLocationButton.isEnabled = false
        }
    }
    
    
    internal func toggleRecenterButton(){
        
        
        if mapOptions.isRecenterControlVisible{
            zoomButtonsView.removeFromSuperview()
            userLocationButton.removeFromSuperview()
            self.addSubview(recenterButton)
            self.recenterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
            self.recenterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5).isActive = true
            self.recenterButton.widthAnchor.constraint(equalToConstant: 57).isActive = true
            self.recenterButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
            toggleUserLocationButton()
        }
    }
    
    
    internal func toggleUserLocationButton(){
        
        if mapOptions.isUserLocationButtonVisible{
            zoomButtonsView.removeFromSuperview()
            self.addSubview(userLocationButton)
            self.userLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
            self.userLocationButton.widthAnchor.constraint(equalToConstant: 57).isActive = true
            self.userLocationButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
            
            if mapOptions.isRecenterControlVisible {
                self.userLocationButton.bottomAnchor.constraint(equalTo: self.recenterButton.topAnchor, constant: 6.6).isActive = true
            }else{
                self.userLocationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5).isActive = true
            }
            
        }else{
            userLocationButton.removeFromSuperview()
        }
        toggleZoomButtons()
    }
    
    
    internal func toggleCompassButton() {
        if mapOptions.isCompassVisible {
            self.addSubview(compassButton)
            
            self.compassButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            self.compassButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
            self.compassButton.widthAnchor.constraint(equalToConstant: 57).isActive = true
            self.compassButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
            self.compassButton.imageView?.clipsToBounds = false
            self.compassButton.imageView?.contentMode = .center
            self.compassButton.alpha = 0
        }
    }
    
    
    
    internal func updateCompass(){
        
        UIView.animate(withDuration: 0.5) {
            let angle = self.rotation // convert from degrees to radians
            self.compassButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(angle)) // rotate the picture
        }
    }
    
    
    internal func toggleZoomButtons() {
        if mapOptions.isZoomControlVisible {
            zoomButtonsView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(zoomButtonsView)
            self.zoomButtonsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
            self.zoomButtonsView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.zoomButtonsView.widthAnchor.constraint(equalToConstant: 57).isActive = true
            
            if mapOptions.isUserLocationButtonVisible && mapOptions.isRecenterControlVisible || mapOptions.isUserLocationButtonVisible{
                self.zoomButtonsView.bottomAnchor.constraint(equalTo: self.userLocationButton.topAnchor, constant: 6.6).isActive = true
            }else if mapOptions.isRecenterControlVisible && !mapOptions.isUserLocationButtonVisible{
                self.zoomButtonsView.bottomAnchor.constraint(equalTo: self.recenterButton.topAnchor, constant: 6.6).isActive = true
            }else {
                self.zoomButtonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5).isActive = true
            }
        } else {
            zoomButtonsView.removeFromSuperview()
        }
    }
    
    
    
    @objc private func zoomPlusButtonTapped(){
        tgMapView.animate(toZoomLevel:zoom + 1, withDuration: easeDuration, with: .cubic)
    }
    
    @objc private func zoomMinusButtonTapped(){
        tgMapView.animate(toZoomLevel: zoom - 1, withDuration: easeDuration, with: .cubic)
    }
    
    @objc private func recenterButtonTapped(){
        tgMapView.animate(toPosition: TGGeoPointMake(self.position.longitude, self.position.latitude), withDuration: easeDuration)
        recenterButton.setImage(UIImage(named: "reCenter.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        
    }
    
    @objc private func userLocationButtonTapped(){
        guard let locationMarker = self.mapOptions.currentLocationGem else { return }
        
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = (2)
        queue.addOperation({self.tgMapView.animate(toPosition: TGGeoPointMake(locationMarker.position.longitude, locationMarker.position.latitude), withDuration: self.easeDuration, with: .cubic)})
        queue.addOperation({self.tgMapView.animate(toZoomLevel: 17, withDuration: self.easeDuration, with: .cubic)})
        
        mapOptions.adjustAccuracyCircle()
        
    }
    
    private func toggleCompassVisibility() {
        
        if self.compassButton.isHidden {
            
            UIView.transition(with: self.compassButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.compassButton.isHidden = false
            })
            
            
            
        }else {
            
            UIView.transition(with: self.compassButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.compassButton.isHidden = true
            })
            
        }
    }
    
    @objc private func compassButtonTapped(){
        tgMapView.animate(toRotation: 0, withDuration: easeDuration, with: .cubic)
        
        UIView.animate(withDuration: 0.2) { // convert from degrees to radians
            self.compassButton.imageView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.compassButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(0).toRadians) // rotate the picture
            self.compassButton.alpha = 0
        }
    }
    
    
    @objc private func attributionButtonTapped() {
        self.switchConstraintForAttribution()
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
        
    }
    
    @objc private func legalButtonTapped(){
        guard let url = URL(string: MFTMapView.mapfitRights) else { return }
        let _ = application.openURL(url)
    }
    
    func switchConstraintForAttribution() {
        if attributionButtonBottomConstraint.constant == initialAttributionBottomConstraintConstant  {
            attributionButtonBottomConstraint.constant = pressedAttributionBottomConstraintConstant
            legalButtonBottomConstraint.constant = pressedLegalButtonBottomConstraintConstant
        } else {
            attributionButtonBottomConstraint.constant = initialAttributionBottomConstraintConstant
            legalButtonBottomConstraint.constant = initialLegalButtonBottomConstraintConstant
        }
    }
    
    
    
    
    fileprivate func setBackingVariableForGlobalStyleVar(variable: GlobalStyleVars, to value: Bool) {
        switch variable {
        case GlobalStyleVars.transitOverlay:
            transitOverlayIsShowing = value
        case GlobalStyleVars.bikeOverlay:
            bikeOverlayIsShowing = value
        case GlobalStyleVars.pathOverlay:
            walkingOverlayIsShowing = value
        default: break
        }
    }
    
}

//MARK: - TGMapViewDelegate
extension MFTMapView : TGMapViewDelegate, MapPlaceInfoSelectDelegate {
    
    public func mapView(_ view: MFTMapView, didSelectPlaceInfoView marker: MFTMarker) {
        
        
    }
    

    
    open func mapView(_ mapView: TGMapViewController, didSelectFeature feature: [String : String]?, atScreenPosition position: CGPoint) {
        guard let feature = feature else { return }
        featureSelectDelegate?.mapView(self, didSelectFeature: feature, atScreenPosition: position)
        guard let featureID = feature["uuid"] else { return }
        
        for annotation in currentAnnotations {
            if annotation.key.uuidString == featureID {
                
                
                if feature["type"] == "polygon" {
                    polygonSelectDelegate?.mapView(self, didSelectPolygon: annotation.value as! MFTPolygon, atScreenPosition: position)
                }
                
                
                if feature["type"] == "polyline" {
                    polylineSelectDelegate?.mapView(self, didSelectPolyline: annotation.value as! MFTPolyline, atScreenPosition: position)
                }
            }
        }
        
    }
    
    open func mapView(_ mapView: TGMapViewController, didSelectLabel labelPickResult: TGLabelPickResult?, atScreenPosition position: CGPoint) {
        guard let labelPickResult = labelPickResult else { return }
        labelSelectDelegate?.mapView(self, didSelectLabel: labelPickResult, atScreenPosition: position)
    }
    
    open func mapView(_ mapView: TGMapViewController, didSelectMarker markerPickResult: TGMarkerPickResult?, atScreenPosition position: CGPoint) {
        guard let markerPickResult = markerPickResult else { return }
        
        let tgMarker = markerPickResult.marker
        
        if let marker = currentMarkers[tgMarker] {
            markerSelectDelegate?.mapView(self, didSelectMarker: marker, atScreenPosition: position)
            
            self.placeInfo?.infoView.removeFromSuperview()
            self.placeInfo = nil
            
            if marker.getScreenPosition().x.isNaN || marker.getScreenPosition().y.isNaN {
                return
            }
            
            self.animateTocenter(position: marker.getPosition(), duration: 0.5)
            if !(marker.title == "") || !(marker.subtitle1 == "") || !(marker.subtitle2 == "") {
                createMFTPlaceInfoView(marker: marker)
            }
        }
        return
        
    }
    
    @objc private func createMFTPlaceInfoView(marker: MFTMarker){
        //get custom view from user
        
        if placeInfoAdapter == nil {
            
            let defaultMFTPlaceInfoView = MFTPlaceInfoView()
            self.placeInfo = MFTPlaceInfo(view: defaultMFTPlaceInfoView, marker: marker)
            
            defaultMFTPlaceInfoView.title.text = marker.title
            defaultMFTPlaceInfoView.subtitle1.text = marker.subtitle1
            defaultMFTPlaceInfoView.subtitle2.text = marker.subtitle2
            self.placeInfo?.infoView.frame = CGRect(x:0, y:0, width:351, height:111)
            
            
            
        }else {
            if let customView = placeInfoAdapter?.getMFTPlaceInfoView(marker: marker) {
                self.placeInfo = MFTPlaceInfo(view: customView, marker: marker)
            }
            
        }
        
        if let placeInfo = placeInfo {
            self.tgMapView.view.addSubview(placeInfo.infoView)
            
            placeInfo.infoView.addGestureRecognizer(placeInfoTapGesture)
            placeInfoTapGesture.addTarget(self, action: #selector(placeInfoPress))
            
            let point = marker.getScreenPosition()
            self.placeInfo?.infoView.center = CGPoint(x:point.x, y:point.y - (placeInfo.infoView.frame.height) / 2)
            placeInfo.infoView.isHidden = false
            marker.showAnchor()
            placeInfoTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateMFTPlaceInfoPosition), userInfo: nil, repeats: !placeInfo.infoView.isHidden)
            
        }
        
    }
    
    
    
    @objc private func placeInfoPress(){
        guard let marker = self.placeInfo?.marker else { return }
        placeInfoSelectDelegate?.mapView(self, didSelectPlaceInfoView: marker)
    }
    
    @objc private func updateMFTPlaceInfoPosition(){
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        guard let info = placeInfo else { return }
        
        if info.infoView.isHidden {
            info.marker.restoreIcon()
            if placeInfoTimer.isValid { placeInfoTimer.invalidate() }
            return
        }
        
        
        
        if let marker = placeInfo?.marker {
            if marker.getScreenPosition().x.isNaN {
                placeInfo!.infoView.isHidden = true
                return
            }
            if marker.getScreenPosition().y.isNaN {
                placeInfo!.infoView.isHidden = true
                return
                
            }
            
            marker.showAnchor()
            placeInfo?.infoView.isHidden = false
            placeInfo?.infoView.center = CGPoint(x:marker.getScreenPosition().x, y:marker.getScreenPosition().y - (placeInfo?.infoView.frame.height)! / 2)
        }
    }
    
    
    //MARK: - Gestures
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
        tgMapView.pickLabel(at: location)
        tgMapView.pickMarker(at: location)
        tgMapView.pickFeature(at: location)
        
        guard let recognize = singleTapGestureDelegate?.mapView(self, recognizer: recognizer, shouldRecognizeSingleTapGesture: location) else { return true }
        
        return recognize
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
        singleTapGestureDelegate?.mapView(self, recognizer: recognizer, didRecognizeSingleTapGesture: location)
        
        guard let placeInfo = placeInfo else { return }
        placeInfo.infoView.isHidden = true
        placeInfo.infoView.removeGestureRecognizer(self.placeInfoTapGesture)
        
        
        updateMFTPlaceInfoPosition()
        
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool {
        guard let recognize = doubleTapGestureDelegate?.mapView(self, recognizer: recognizer, shouldRecognizeDoubleTapGesture: location)  else { return true }
        return recognize
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint) {
        doubleTapGestureDelegate?.mapView(self, recognizer: recognizer, didRecognizeDoubleTapGesture: location)
        tgMapView.animate(toPosition: tgMapView.screenPosition(toLngLat: location), withDuration: easeDuration)
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool {
        guard let recognize = longPressGestureDelegate?.mapView(self, recognizer: recognizer, shouldRecognizeLongPressGesture: location) else { return true }
        return recognize
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint) {
        longPressGestureDelegate?.mapView(self, recognizer: recognizer, didRecognizeLongPressGesture: location)
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePanGesture displacement: CGPoint) -> Bool {
        if recognizer.numberOfTouches > 1 {
            return false
        }
        return mapOptions.isPanEnabled
    }
    
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePanGesture location: CGPoint) {
        panDelegate?.mapView(self, didPanMap: location)
        updateMFTPlaceInfoPosition()
        
        
        if self.position.latitude == tgMapView.screenPosition(toLngLat: location).latitude || self.position.longitude == tgMapView.screenPosition(toLngLat: location).longitude{
            recenterButton.setImage(UIImage(named: "reCenter.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }else{
            recenterButton.setImage(UIImage(named: "ReCenter_OFF.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }
    }
    
    
    
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizePinchGesture location: CGPoint) -> Bool {
        
        let pinch = recognizer as! UIPinchGestureRecognizer
        minMaxZoomTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkZoomLevels), userInfo: nil, repeats: true)
        
        if self.zoom > mapOptions.getMaxZoomLevel() && self.zoom * Float(pinch.scale) > mapOptions.getMaxZoomLevel() {
            return false
        }
        
        if self.zoom < mapOptions.getMinZoomLevel() && self.zoom * Float(pinch.scale) < mapOptions.getMinZoomLevel() {
            return false
        }
        
        if pinch.state == .ended {
            minMaxZoomTimer.invalidate()
        }
        
        return mapOptions.isPinchEnabled
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizePinchGesture location: CGPoint) {
        let pinch = recognizer as! UIPinchGestureRecognizer
        
        if pinch.state == .recognized {
            // self.mapOptions.accuracyCircleTimer.fire()
        }
        
        if pinch.state == .ended {
            // self.mapOptions.accuracyCircleTimer.invalidate()
        }
        
        if self.zoom > mapOptions.getMaxZoomLevel() && self.zoom * Float(pinch.scale) > mapOptions.getMaxZoomLevel() {
            setZoom(zoomLevel: mapOptions.getMaxZoomLevel(), duration: 0.123)
        }
        
        if self.zoom < mapOptions.getMinZoomLevel() && self.zoom * Float(pinch.scale) < mapOptions.getMinZoomLevel() {
            setZoom(zoomLevel: mapOptions.getMinZoomLevel(), duration: 0.123)
        }
        
        pinchDelegate?.mapView(self, didPinchMap: location)
        updateMFTPlaceInfoPosition()
        
    }
    
    @objc private func checkZoomLevels(){
        if self.zoom > mapOptions.getMaxZoomLevel() {
            setZoom(zoomLevel: mapOptions.getMaxZoomLevel(), duration: 0.123)
        }
        
        if self.zoom < mapOptions.getMinZoomLevel() {
            setZoom(zoomLevel: mapOptions.getMinZoomLevel(), duration: 0.123)
        }
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeRotationGesture location: CGPoint) -> Bool {
        return mapOptions.isRotateEnabled
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeRotationGesture location: CGPoint) {
        rotateDelegate?.mapView(self, didRotateMap: location)
        
        updateMFTPlaceInfoPosition()
        updateCompass()
        
        if compassButton.alpha != 1 {
            UIView.animate(withDuration: 0.2) {
                self.compassButton.alpha = 1
            }
        }
        
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, shouldRecognizeShoveGesture displacement: CGPoint) -> Bool {
        return mapOptions.isTiltEnabled
    }
    
    open func mapView(_ view: TGMapViewController, recognizer: UIGestureRecognizer, didRecognizeShoveGesture displacement: CGPoint) {
        shoveDelegate?.mapView(self, didShoveMap: displacement)
        
        updateMFTPlaceInfoPosition()
        
    }
    
}



extension MFTMapView {
    //called when Mapview is finished loading
    public func mapView(_ mapView: TGMapViewController, didLoadScene sceneID: Int32, withError sceneError: Error?) {
        
        //We only want to call back on the latest scene load - so we gate here to make sure we only call back on the latest.
        //TODO: For 2.0 we should pass the Error along in the callback block.
        //reDrawAnnotations()
        
        restoreUserMarkers()
        
        if sceneID != latestSceneId {
            return
        }
        if let update = globalSceneUpdates.first {
            //update backing variable if one exists for it
            if let updateValue = Bool(update.value), let updatePath = GlobalStyleVars(rawValue: update.path) {
                setBackingVariableForGlobalStyleVar(variable: updatePath, to: updateValue)
            }
            globalSceneUpdates.remove(at: 0)
            if !globalSceneUpdates.isEmpty {
                let nextUpdate = globalSceneUpdates[0]
                latestSceneId = mapView.updateSceneAsync([nextUpdate])
                // In the event we have more to process, stop processing here.
                return
            }
        }
        
        guard let styleClosure = sceneLoadCallback else { return }
        styleClosure(mapOptions.mapTheme)
        sceneLoadCallback = nil
    }
    
    open func mapViewDidCompleteLoading(_ mapView: TGMapViewController) {
        tileLoadDelegate?.mapViewDidCompleteLoading(self)
    }
    
    
    /**
     Loads the map style asynchronously. Recommended for production apps. Uses the system's current locale.
     - parameter styleSheet: The map style / theme combination to load.
     - parameter onStyleLoaded: Closure called on scene loaded.
     - throws: A MFError `apiKeyNotSet` error if an API Key has not been sent on the MFTManager class.
     */
    internal func loadMapfitThemeAsync(_ theme: MFTMapTheme) throws {
        try loadMapfitStyleAsync(theme, locale: Locale.current)
    }
    
    /**
     Loads the map style asynchronously. Recommended for production apps. Uses the system's current locale.
     - parameter styleSheet: The map style / theme combination to load.
     - parameter onStyleLoaded: Closure called on scene loaded.
     - throws: A MFError `apiKeyNotSet` error if an API Key has not been sent on the MFTManager class.
     */
    internal func loadCustomThemeAsync(_ customPath: String) throws {
        try loadCustomStyleSheetAsync(customPath, locale: Locale.current)
    }
    
    /**
     Loads the map style asynchronously. Recommended for production apps.
     - parameter styleSheet: The map style / theme combination to load.
     - parameter locale: The locale to use for the map's language.
     - parameter onStyleLoaded: Closure called on scene loaded.
     - throws: A MFError `apiKeyNotSet` error if an API Key has not been sent on the MFTManager class.
     */
    
    
    internal func loadMapfitStyleAsync(_ theme: MFTMapTheme, locale: Locale) throws {
        mapOptions.mapTheme = theme
        
        if mapOptions.mapTheme == .day {
            attributionBtn.setImage(UIImage(named: "Watermark_Day_Sm.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }else{
            attributionBtn.setImage(UIImage(named: "Watermark_Night_Sm.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        }
        
        self.locale = locale
        
        if let urlPath = URL(string: theme.rawValue) {
            tgMapView.loadScene(from: urlPath)
            self.reDrawAnnotations()
            
            DispatchQueue.global().async {
                self.tgMapView.httpHandler.downloadRequestAsync(theme.rawValue, completionHandler: { (data, response, error) in
                    if error == nil {
                        let cachedResponse = CachedURLResponse(response: response!, data: data!)
                        URLSessionConfiguration.default.urlCache?.storeCachedResponse(cachedResponse, for: URLRequest(url: urlPath, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10))
                    }
                    
                    
                })
            }
        }
        
        
    }
    
    
    internal func loadCustomStyleSheetAsync(_ path: String, locale: Locale) throws {
        self.locale = locale
        self.mapOptions.mapTheme = .custom
        
        if let urlPath = URL(string: path) {
            tgMapView.loadScene(from: urlPath)
            self.reDrawAnnotations()
        }
        
    }
    
    
    private func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}






extension MFTMapView {
    
    private func setMFTPlaceInfoViewSize() -> CGSize{
        if self.frame == UIScreen.main.bounds {
            return CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.1)
        }
        return  CGSize(width: self.frame.width * 0.5, height: self.frame.height * 0.15)
    }
    
    func setZoomButtonViewSize() -> CGSize{
        if self.frame == UIScreen.main.bounds {
            return CGSize(width: self.frame.width * 0.13, height: self.frame.height * 0.15)
        }
        
        return  CGSize(width: self.toggleStackView.frame.width * 0.5, height: self.toggleStackView.frame.height * 0.15)
    }
    
}


//Scene updates
extension MFTMapView {
    internal func toggle3DBuildings(){
        let update = TGSceneUpdate(path: "global.show_3d_buildings", value: "\(mapOptions.is3DBuildingsEnabled)")
        tgMapView.updateSceneAsync([update])
    }
    
    
    public func updateScene(updates: [MFTSceneUpdate]){
        var tgUpdates = [TGSceneUpdate]()
        
        for update in updates {
            tgUpdates.append(TGSceneUpdate(path: update.path, value: update.value))
        }
        tgMapView.updateSceneAsync(tgUpdates)
    }
}


extension MFTMapView: TGRecognizerDelegate {
    
    
}

extension MFTMapView  {
    internal static func ==(lhs: MFTMapView, rhs: MFTMapView) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


extension MFTMapView: MFTZoomButtonsViewDelegate {
    func plusButtonTapped(_ sender: AnyObject) {
        tgMapView.animate(toZoomLevel:zoom + 1, withDuration: easeDuration, with: .cubic)
    }
    
    func minusButtonTapped(_ sender: AnyObject) {
        tgMapView.animate(toZoomLevel: zoom - 1, withDuration: easeDuration, with: .cubic)
    }
}

//Screen Position to Latlng
extension MFTMapView {
    /**
     Returns a CLLocationCoordinate based on the point provided.
     - parameter point: CGpoint that will be translated into a CLLocationCoordinate2D
     - returns: CLLocationCoordinate of the given point.
     */
   public func screenPositionToLatLng(_ point: CGPoint) -> CLLocationCoordinate2D{
      let screenPosition = tgMapView.screenPosition(toLngLat: point)
        return CLLocationCoordinate2D(latitude: screenPosition.latitude, longitude: screenPosition.longitude)
    
    }
    
    /**
     Returns a point based on the CLLocationCoordinate provided.
     - parameter latLng: CLLocationCoordinate that will be translated into a CGPoint.
     - returns: CGPoint of the given CLLocationCoordinate.
     */
    public func LatLngToScreenPosition(_ latLng: CLLocationCoordinate2D) -> CGPoint{
        let point = tgMapView.lngLat(toScreenPosition: TGGeoPoint(longitude: latLng.longitude, latitude: latLng.latitude))
        return point
    }
    
}





