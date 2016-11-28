//
//  RoundButton.swift
//  Social-Network
//
//  Created by Ron Ramirez on 11/20/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        //Opacity of the layer's shadow
        layer.shadowOpacity = 0.8
        //Blur radius
        layer.shadowRadius = 5.0
        //Off sets in the layer's shadows
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
