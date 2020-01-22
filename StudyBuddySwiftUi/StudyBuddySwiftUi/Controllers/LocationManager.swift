//
//  LocationManager.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 03.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
    private var updatedLocation: ((CLLocation)->())?
    
    func requestLocation(_ handler: @escaping (CLLocation)->()) {
        locationManager.startUpdatingLocation()
        updatedLocation = { location in
            handler(location)
            self.locationManager.stopUpdatingLocation()
            self.updatedLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        // print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updatedLocation?(location)
        // print(#function, location)
    }
    
    /**
     * Get distance between two locations
     * location 1 (lat1, long1)
     * location 2 (lat2, long2)
     * returns the distance measured in kilometers
     */
    func getDistance(lat1: Double, long1: Double, lat2: Double, long2: Double) -> Double{
        let locA = CLLocation(latitude: lat1, longitude: long1)
        let locB = CLLocation(latitude: lat2, longitude: long2)
        var distance = (locA.distance(from: locB)).rounded()
        distance = distance/1000 // meters to kilometers
        let maxDistance: Double = 200 // kilometers             // we need the maxDistence because app crashes if the value is to high
        if distance > maxDistance {
            distance = maxDistance
        }
        return distance
    }
}
