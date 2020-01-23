//
//  LocationButton.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 23.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct LocationButton: View {
    @EnvironmentObject var session: SessionStore
    
    let buttonText: String
    let location: LocationModel
    
    var body: some View {
        Button(action: {
            self.session.sessionUser?.updateLocation(location: self.location)
            self.session.updateLocationAsCity()
            self.session.downloadAllUserLists()
        }) {
            Text(self.buttonText)
        }
    }
}
