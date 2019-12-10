//
//  FirebaseListeningView.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 18.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct FirebaseListeningView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func getUser (){
        session.listen()
            }
    
    var body: some View {
        Group {
            if (session.session != nil){

            Text("Hello, User!")
            } else {
            Text("Our authentication screen goes here...")
            }
        }.onAppear(perform: getUser)
    }
}
#if DEBUG
struct FirebaseListeningView_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseListeningView()
            .environmentObject(SessionStore())    }
}
#endif



