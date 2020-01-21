//
//  WaitForAutoLogin.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 21.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct WaitForAutoLogin: View {
    @EnvironmentObject var session: SessionStore
    
    @State private var gotAllData: Bool = false
    
    private func initialize() {
        if (self.session.sessionUser == nil) {
            self.session.listen(handler: { user in
                self.session.sessionUser = user
                self.session.hashtags = user.hashtags ?? ""
                self.session.searchWithGPS = self.session.sessionUser?.gpsUsage ?? false
                if self.session.sessionUser?.gpsUsage ?? false {
                    self.session.updateLocation()
                }
                self.gotAllData = true
            })
        }
    }
    
    private func leaveView() {
        self.gotAllData = false
    }
    
    var body: some View {
        VStack {
            if self.gotAllData {
                GeneralTabView()
            } else {
                Color.lmuGreen
                    .edgesIgnoringSafeArea(.vertical)
                    .overlay(
                        VStack {
                            Spacer()
                            Image("fountainicon").animation(.interpolatingSpring(stiffness: 20, damping: 0.5))
                            Text("loading data...").foregroundColor(.white)
                            Spacer()
                    })
            }
        }.onAppear(perform: initialize)
            .onDisappear(perform: leaveView)
    }
}
