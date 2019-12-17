//
//  SwipeView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct SwipeView: View {
    @State private var offset: CGFloat = 0
    @State private var index = 0
    @EnvironmentObject var session: CommunicationStore


    var users: [UserModel]
    let spacing: CGFloat = 10

    init(users: [UserModel]) {
        self.users = users
        // debug()
    }

    // TODO remove this method before production
    mutating func debug() {
        print("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _")
        users.forEach { user in
            print(user.toString())
        }
        print("- - - - - - - - - - - - - - - - - -")
        print("removing dups...")
        let unique = Array(Set(users))
        users = unique
        print("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _")
        users.forEach { user in
            print(user.toString())
        }
        print("- - - - - - - - - - - - - - - - - -")
    }

    var body: some View {
        GeometryReader { geometry in
            return ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: self.spacing) {
                    ForEach(self.users, id: \.uid) { user in
                        OtherUserView(userModel: user)
                            .frame(width: geometry.size.width)
                        //getUserView(user: user) .frame(width: geometry.size.width)
                    }
                    if (self.users.isEmpty) {
                        Text("no other users yet").background(Color.lmuLightGrey.edgesIgnoringSafeArea(.vertical))
                            .foregroundColor(.orange)
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
                            if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.users.count - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                            withAnimation {
                                self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index)
                            }
                        })
                )
        }
    }
}
