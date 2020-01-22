//
// Created by admin on 22.01.20.
// Copyright (c) 2020 Annika Jung. All rights reserved.
//

import Foundation

struct TagFilter {
    let tag: String
    var active: Bool = false

    // TODO remove before release, only used for testing
    init(tag: String) {
        self.tag = tag
        if (tag == "debug") {
            active = true
        }
    }
}