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

    private func initialize() {
        self.session.getProfile(uid: self.session.sessionUser!.uid, handler: { user in
            self.session.sessionUser = user
            self.session.downloadAllUserLists()
            self.setBothTagRows(hashtagsAsString: self.session.myHashtags)
        })
    }

    /* compare two strins by length Used for sorting */
    private func shorter(value1: String, value2: String) -> Bool {
        // ... True means value1 precedes value2.
        return value1.count < value2.count
    }

    private func setBothTagRows(hashtagsAsString: String?) {
        tagsRow1 = []
        tagsRow2 = []
        if let newTags = hashtagsAsString {
            var strArray = newTags.components(separatedBy: " ")
            strArray.sort(by: shorter)
            for n in 0..<(min(strArray.count, 6)) {
                if (strArray[n].count > 1) {
                    if n % 2 == 0 {
                        tagsRow1.append(strArray[n])
                    } else {
                        tagsRow2.append(strArray[n])
                    }
                }
            }
        }
        print("1Row: \(tagsRow1) \n 2Row: \(tagsRow2) ")
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
            Button(action: {
                self.session.searchWithGPS.toggle()
                self.session.sessionUser?.updateGpsUsage(gpsUsage: self.session.searchWithGPS)
                self.session.updateGpsUsage()
            }) {
                HStack {
                    if (self.session.searchWithGPS) {
                        Image(systemName: "location")
                        Text("GPS active").fontWeight(.semibold)
                    } else {
                        Image(systemName: "location.slash")
                        Text("No GPS").fontWeight(.semibold)
                    }
                }
            }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
            // TAGS
            VStack {
                HStack {
                    ForEach(tagsRow1, id: \.self) { tag in
                        Button(action: {
                            self.session.appendFilter(newTag: tag)
                        }) {
                            Text("#\(tag)")
                                .background(Color.lmuDarkGrey)
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                        }
                    }
                }
                HStack {
                    ForEach(tagsRow2, id: \.self) { tag in
                        Button(action: {
                            self.session.appendFilter(newTag: tag)
                        }) {
                            Text("#\(tag)")
                                .background(Color.lmuDarkGrey)
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                        }
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
