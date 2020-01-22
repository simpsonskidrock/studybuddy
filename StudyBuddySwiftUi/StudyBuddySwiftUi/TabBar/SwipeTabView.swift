//
//  SwipeTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct SwipeTabView: View {
    @EnvironmentObject var session: SessionStore
    
    @State private var offset: CGFloat = 0
    @State private var index = 0
    let spacing: CGFloat = 10

    @State private var tagsRow1: [String] = []
    @State private var tagsRow2: [String] = []

    @State var flag: Bool = false

    private func initialize() {
        self.session.getProfile(uid: self.session.sessionUser!.uid, handler: { user in
            self.session.sessionUser = user
            self.session.downloadAllUserLists()
            self.setBothTagRows(hashtags: self.session.sessionUser?.hashtags ?? [])
        })
    }

    /* compare two strings by length used for sorting */
    private func shorter(value1: String, value2: String) -> Bool {
        // ... True means value1 precedes value2.
        return value1.count < value2.count
    }

    private func setBothTagRows(hashtags: [String]) {
        tagsRow1 = []
        tagsRow2 = []
        var strArray = hashtags
        strArray.sort(by: shorter)
        for n in 0..<(min(strArray.count, 6)) {
            if (strArray[n].count > 1) {
                if n % 2 == 0 {
                    tagsRow1.append(strArray[n])
                } else {
                    tagsRow2.append( strArray[n])
                }
            }
        }
    
        // print("1Row: \(tagsRow1) \n 2Row: \(tagsRow2) ")
    }
    
    private func close() {
        if (self.index == self.session.otherUsers.count) {
            self.index = 0
            self.offset = 0
        }
    }

    var body: some View {
        VStack {
            Spacer()
            // GPS BUTTON
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
                            Button(action: {
                                self.session.sessionUser?.updateLocation(location: Locations.locationMunichOe)
                                self.session.updateLocationAsCity()
                                self.session.downloadAllUserLists()
                            }) {
                                Text("Oettingenstaße 67, München")
                            }
                            Button(action: {
                                self.session.sessionUser?.updateLocation(location: Locations.locationMunichHgb)
                                self.session.updateLocationAsCity()
                                self.session.downloadAllUserLists()
                            }) {
                                Text("Geschwister-Scholl-Platz 1, München")
                            }
                            Button(action: {
                                self.session.sessionUser?.updateLocation(location: Locations.locationMunichTs)
                                self.session.updateLocationAsCity()
                                self.session.downloadAllUserLists()
                            }) {
                                Text("Theresienstraße 39, München")
                            }
                            Button(action: {
                                self.session.sessionUser?.updateLocation(location: Locations.locationMunichPs)
                                self.session.updateLocationAsCity()
                                self.session.downloadAllUserLists()
                            }) {
                                Text("Pettenkoferstraße 14, München")
                            }
                    }
                    .foregroundColor(.white)
                }
            }
            // TAGS
            VStack {
                HStack {
                    ForEach(tagsRow1, id: \.self) { tag in
                        Text(tag)
//                        HashtagButton(actionWhenInactive: {
//                            self.session.appendFilter(newTag: tag)
//                        }, actionWhenActive: {
//                            self.session.removeFilter(tag: tag)
//                        }) {
//                            Text(tag)
//                        }
                    }
                }
                HStack {
                    ForEach(tagsRow2, id: \.self) { tag in
                        Text(tag)
//                        HashtagButton(actionWhenInactive: {
//                            self.session.appendFilter(newTag: tag)
//                        }, actionWhenActive: {
//                            self.session.removeFilter(tag: tag)
//                        }) {
//                            Text(tag)
//                        }
                    }
                }
            }
            // PROFILES
            GeometryReader { geometry in
                return ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: self.spacing) {
                        ForEach(self.session.otherUsers, id: \.uid) { user in
                            OtherUserView(userModel: user)
                                .frame(width: geometry.size.width)
                        }
                        if (self.session.otherUsers.isEmpty) {
                            NoOtherUsersView()
                        }
                    }
                }
                .content.offset(x: self.offset)
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.session.otherUsers.count - 1 {
                                self.index += 1 // swipe to card on right side
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1 // swipe to card on left side
                            }
                            withAnimation {
                                self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index)
                            }
                        })
                )
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .onAppear(perform: initialize)
            .onDisappear(perform: close)
    }
}
