//
//  NoMatchesOrLikesView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 24.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct NoMatchesOrLikesView: View {
    
    var body: some View {
        HStack{
            Spacer()
            Text("No likes or matches yet")
            Spacer()
        }
    }
}

struct NoMatchesOrLikesView_Previews: PreviewProvider {
    static var previews: some View {
        NoMatchesOrLikesView()
    }
}
