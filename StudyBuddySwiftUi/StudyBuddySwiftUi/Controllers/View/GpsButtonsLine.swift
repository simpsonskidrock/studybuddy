//
//  GpsButtonsLine.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 23.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct GpsButtonsLine: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        HStack {
            Button(action: {
                self.session.searchWithGPS.toggle()
                self.session.sessionUser?.updateGpsUsage(gpsUsage: self.session.searchWithGPS)
                self.session.updateGpsUsage()
                self.session.downloadAllUserLists()
            }) {
                HStack {
                    if (self.session.searchWithGPS) {
                        Image(systemName: "location")
                        Text("GPS-Search active").fontWeight(.semibold)
                    } else {
                        Image(systemName: "location.slash")
                        Text("GPS-Search disabled - tap to activate").fontWeight(.semibold)
                    }
                }
            }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
            if self.session.sessionUser?.gpsUsage ?? false {
                Spacer()
                Image(systemName: "globe")
                    .contextMenu {
                        Button(action: {
                            self.session.updateLocation()
                            self.session.downloadAllUserLists()
                        }) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("My location")
                        }
                        LocationButton(buttonText: "Oettingenstaße 67, München", location: Locations.locationMunichOe)
                        LocationButton(buttonText: "Geschwister-Scholl-Platz 1, München", location: Locations.locationMunichHgb)
                        LocationButton(buttonText: "Theresienstraße 39, München", location: Locations.locationMunichTs)
                        LocationButton(buttonText: "Pettenkoferstraße 14, München", location: Locations.locationMunichPs)
                }.foregroundColor(.white)
            }
        }
    }
}
