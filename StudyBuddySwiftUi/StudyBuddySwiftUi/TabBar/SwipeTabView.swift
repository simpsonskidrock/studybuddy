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
        })
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
            GpsButtonsLine()
            // TAGS
            HStack {
                ScrollView (.horizontal) {
                    HStack {
                        ForEach(self.session.activeFilterTags + self.session.inactiveFilterTags, id: \.self) { tag in
                            HashtagButton(actionWhenInactive: {
                                self.session.updateFilter(tag: tag)
                            }, actionWhenActive: {
                                self.session.updateFilter(tag: tag)
                            }) {
                                Text(tag)
                            }
                        }
                    }.padding()
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
