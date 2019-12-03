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
        self.locationManager.startUpdatingLocation()
        
       }
    
    @Published var lastLocation: CLLocation? {
           willSet {
               objectWillChange.send()
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
        manager.startUpdatingLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           self.lastLocation = location
           print(#function, location)
       }
  
    }
}
