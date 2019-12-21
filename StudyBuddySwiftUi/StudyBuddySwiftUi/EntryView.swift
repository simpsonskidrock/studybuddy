//
//  EntryView.swift
//  StudyBuddySwiftUi
//
//  Created by admin on 18.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct EntryView: View {

    @State var isShown: Bool
    @EnvironmentObject var session: CommunicationStore

    var body: some View {
        Group {
            if (session.isLoggedIn()) {
                GeneralTabView(isShown: $isShown)
            } else {
                LoginView(isShown: $isShown)
            }
        }
    }
}

