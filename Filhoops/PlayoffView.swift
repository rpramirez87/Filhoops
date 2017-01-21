//
//  PlayoffView.swift
//  Filhoops
//
//  Created by Ron Ramirez on 1/20/17.
//  Copyright © 2017 Mochi Apps. All rights reserved.
//

import UIKit

class PlayoffView: UIView {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //1
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        //2
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 20.0, y: 20.0))
        ctx.addLine(to: CGPoint(x: 40.0, y: 20.0))
        ctx.addLine(to: CGPoint(x: 40.0, y: 40.0))
        ctx.setLineWidth(5)
        
        //3
        //ctx.closePath()
        ctx.strokePath()
    }
 

}


