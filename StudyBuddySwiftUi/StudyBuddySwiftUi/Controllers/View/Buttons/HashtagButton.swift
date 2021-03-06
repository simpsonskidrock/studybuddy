//
// Created by Lorenz on 21.01.20.
// Copyright (c) 2020 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

// author: Lorenz
// Extend button so it acts like a toggleable button that changes background color when it's activated / deactivated

struct HashtagButton<Label>: View where Label: View {
    
    private let actionWhenInactive: () -> ()
    private let actionWhenActive: () -> ()
    private let label: () -> Label
    
    init(actionWhenInactive: @escaping () -> (), actionWhenActive: @escaping () -> (), label: @escaping () -> Label) {
        self.actionWhenActive = actionWhenActive
        self.actionWhenInactive = actionWhenInactive
        self.label = label
    }
    
    @State private var active: Bool = false
    var body: some View {
        
        Button(action: {
            if self.active {
                self.actionWhenActive()
                self.active = false
            } else {
                self.actionWhenInactive()
                self.active = true
            }
        }) {
            label()
                .foregroundColor(active ? .black : .white)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 5).fill(active ? Color(.lightGray) : Color(.gray)))
                .shadow(color: active ? Color(.white) : Color(.black), radius: 3)
        }
    }
}
