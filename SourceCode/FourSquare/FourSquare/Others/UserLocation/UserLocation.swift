//
//  UserLocation.swift
//  FourSquare
//
//  Created by Vipul Patel on 10/01/22.
//

import UIKit
import CoreLocation
import MapKit

//MARK: - Class UserLocation
class UserLocation: NSObject {
    static let shared = UserLocation()
    private weak var controller: UIViewController!
    var locationManger: CLLocationManager = {
        let lm = CLLocationManager()
        lm.activityType = .other
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    var locationPermissionStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    var completionBlock : ((CLAuthorizationStatus?, CLLocation?, NSError?)->())? = nil
}

//MARK: Private function(s)
extension UserLocation {
    
    private func askForPermission() {
        locationManger.requestWhenInUseAuthorization()
    }
}

//MARK: Public function(s)
extension UserLocation {
    
    public func fetchUserLocationForOnce(_ controller: UIViewController, block: ((CLAuthorizationStatus?, CLLocation?, NSError?)->())?) {
        self.controller = controller
        locationManger.delegate = self
        completionBlock = block
        if checkAuthorizationStatus() {
            locationManger.startUpdatingLocation()
        }else{
            completionBlock?(locationPermissionStatus, nil, nil)
        }
    }
    
    public func checkAuthorizationStatus() -> Bool {
        let status = locationPermissionStatus
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            return false
        } else if status == CLAuthorizationStatus.notDetermined {
            askForPermission()
            return false
        } else if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            return true
        }
        return false
    }
    
    public func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}

// MARK: CLLocationManagerDelegate
extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        DispatchQueue.main.async {
            self.completionBlock?(self.locationPermissionStatus, lastLocation, nil)
            manager.stopUpdatingLocation()
            self.completionBlock = nil
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {self.completionBlock?(self.locationPermissionStatus, nil, error as NSError?)}
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManger.startUpdatingLocation()
        }else{
            DispatchQueue.main.async {self.completionBlock?(self.locationPermissionStatus, nil, nil)}
        }
    }
}
