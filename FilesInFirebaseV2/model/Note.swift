//
// Created by Martin Løseth Jensen on 2019-03-26.
// Copyright (c) 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class Note {
    var text: String
    var imageName: String
    var image: UIImage?

    init(text: String, imageName: String, image: UIImage? = nil) {
        self.text = text
        self.imageName = imageName
    }
}
