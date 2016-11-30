//
//  CircleView.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/28/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
