//
//  SearchTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchTabView: View {
    
    var body: some View {
        VStack {
            Text("Hallo")
        }.padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchTabView()
                .environment(\.colorScheme, .light)
            SearchTabView()
                .environment(\.colorScheme, .dark)
        }
    }
}

