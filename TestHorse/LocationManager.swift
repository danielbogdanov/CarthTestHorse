//
//  LocationManager.swift
//  TestHorse
//
//  Created by Daniel Bogdanov on 13.05.19.
//  Copyright © 2019 Daniel Bogdanov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : CLLocationManager {
    
    let locationManager = CLLocationManager()
    func enableBasicLocationServices() {
        locationManager.delegate = self as! CLLocationManagerDelegate
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
}
    
    
}



