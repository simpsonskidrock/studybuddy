//
//  LocationModel.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 19.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct LocationModel: Hashable {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double, longitude: Double) {
        self.setLatitude(latitude: latitude)
        self.setLogitude(longitude: longitude)
    }
    
    private mutating func setLatitude(latitude: Double) {
        self.latitude = latitude
    }
    
    private mutating func setLogitude(longitude: Double) {
        self.longitude = longitude
    }
}
