//
//  MFTLocationProvider.swift
//  Mapfit
//
//  Created by Zain N. on 3/15/18.
//

import Foundation
import CoreLocation



public protocol LocationManagerProtocol : class {
    var delegate: LocationManagerDelegate? { get set }
    var currentLocation: CLLocation? { get set }
    var coreLocationManager: CLLocationManager? { get set }
    func requestAlwaysAuthorization()
    func requestWhenInUseAuthorization()
    func isInUseAuthorized() -> Bool
    func isAlwaysAuthorized() -> Bool
    func refreshCurrentLocation() -> CLLocation?
    func requestLocationUpdates()
    func startUpdatingLocation()
    func removeLocationUpdates()
    func startUpdatingHeading()
    func stopUpdatingHeading()
    func canEnableBackgroundLocationUpdates() -> Bool
    func enableBackgroundLocationUpdates(forType activityType: CLActivityType, desiredAccuracy: CLLocationAccuracy, pausesLocationAutomatically: Bool) -> Bool
}

/// LocationManagerDelegate Protocol
@objc public protocol LocationManagerDelegate {
    
    /// The user authorized the application to receive location updates
    @objc optional func authorizationDidSucceed()
    
    /// The user denied the application from receiving location updates.
    @objc optional func authorizationDenied()
    
    /// The user is restricted from authorizing the application for location updates. This is normally due to parental control lockout.
    @objc optional func authorizationRestricted()
    
    /**
     The device received a new location.
     
     - parameter location: The new location.
     */
    @objc optional func locationDidUpdate(_ location: CLLocation)
}


class MFTLocationProvider: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {

    internal var coreLocationManager: CLLocationManager? = CLLocationManager()

    /// The last received known good location
    internal var currentLocation: CLLocation?
    
    /// The delegate to receive the location authorization and status callbacks
    var delegate: LocationManagerDelegate?
    
    override public init(){
        super.init()
        coreLocationManager?.delegate = self
    }
    
    /// Request the user give the application location access at all times.
    internal func requestAlwaysAuthorization() {
        coreLocationManager?.requestAlwaysAuthorization()
    }
    
    /// Request the user give the application location access only when in the foreground.
    internal func requestWhenInUseAuthorization() {
        coreLocationManager?.requestWhenInUseAuthorization()
    }
    
    /**
     Asks the location subsystem if we're currently authorized for location access while in foreground.
     
     - returns: Whether or not the application is authorized.
     */
    internal func isInUseAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? true :  false
    }
    
    /**
     Asks the location subsystem if we're currently authorized for location access at all times.
     
     - returns: Whether or not the application is authorized.
     */
    internal func isAlwaysAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    /**
     Asks the location subsystem if we're able to receive background location updates. This should be checked every startup because the user can disable it externally in settings.
     
     - returns: Whether or not the application is able to receive background location updates.
     */
    internal func canEnableBackgroundLocationUpdates() -> Bool {
        if UIApplication.shared.backgroundRefreshStatus != .available { return false }
        return isAlwaysAuthorized()
    }
    
    /**
     Enables background location updates to be received. This requires additional parameters in your apps Info.plist be set, which is different depending on the version of iOS you are linking against. Please consult Apple's most current documentation on the matter, or reference our sample application for an example.
     
     - parameter activityType: The core location activity type that we're requesting background location updates for.
     - parameter desiredAccuracy: Controls what systems (GPS, Wi-Fi, Cellular, iBeacon, etc.) are involved with updating locations.
     - parameter pausesAutomatically: Whether or not certain activity types will pause sending updates dynamically. Examples include navigation activities will not send updates when the user has not moved significantly.
     - returns: True if enabled, or false if we can't enable due to system restrictions
     */
    

    
    internal func enableBackgroundLocationUpdates(forType activityType: CLActivityType, desiredAccuracy: CLLocationAccuracy, pausesLocationAutomatically: Bool) -> Bool {
        if !canEnableBackgroundLocationUpdates() { return false }
        coreLocationManager?.activityType = activityType
        coreLocationManager?.desiredAccuracy = desiredAccuracy
        coreLocationManager?.pausesLocationUpdatesAutomatically = pausesLocationAutomatically
        coreLocationManager?.allowsBackgroundLocationUpdates = true
        coreLocationManager?.startUpdatingLocation()
        coreLocationManager?.startUpdatingHeading()
        return true
    }
    
    /// Disables background location updates. If you want to continue receiving foreground location updates, you must call startUpdatingLocation() again.
    internal func disableBackgroundLocationUpdates() {
        coreLocationManager?.allowsBackgroundLocationUpdates = false
        coreLocationManager?.stopUpdatingHeading()
        coreLocationManager?.stopUpdatingLocation()
    }
    
    /**
     Refreshes the stored current location and also returns it to the caller
     
     -returns: The most current location the location system has, or nil if it has no current location.
     */
    internal func refreshCurrentLocation() -> CLLocation? {
        if CLLocationManager.locationServicesEnabled() &&
            (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            currentLocation = coreLocationManager?.location
            return coreLocationManager?.location
        }
        return nil
    }
    
    /// The difference between this function and `refreshCurrentLocation()` is `requestLocation()` immediately returns and will serve the location via the delegate
    internal func requestLocationUpdates() {
        coreLocationManager?.requestLocation()
    }
    
    /// Starts the location manager callbacks for location updates
    internal func startUpdatingLocation() {
        coreLocationManager?.startUpdatingLocation()
    }
    
    /// Stops the location manager callbacks
    internal func removeLocationUpdates() {
        coreLocationManager?.stopUpdatingLocation()
    }
    
    /// Begin tracking heading
    internal func startUpdatingHeading() {
        coreLocationManager?.startUpdatingHeading()
    }
    
    // Stop tracking heading
    internal func stopUpdatingHeading() {
        coreLocationManager?.stopUpdatingHeading()
    }
    
    //MARK: - CLLocationManagerDelegate
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            delegate?.authorizationDidSucceed?()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            delegate?.authorizationDidSucceed?()
        case .denied:
            delegate?.authorizationDenied?()
        case .restricted:
            delegate?.authorizationRestricted?()
        default:
            print("Not Authorized")
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            delegate?.locationDidUpdate?(location)
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error from location manager: \(error)")
    }

    
}
