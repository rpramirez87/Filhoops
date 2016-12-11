//
//  LoadingScreenVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class LoadingScreenVC : UIViewController, HolderViewDelegate {
    
    var holderView = HolderView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 60.0)
        label.textAlignment = NSTextAlignment.center
        label.text = "Filhoops"
        label.transform = label.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(),
                       animations: ({
                        label.transform = label.transform.scaledBy(x: 4.0, y: 4.0)
                       }), completion: { finished in
                        self.performSegue(withIdentifier: "goToPlayerOfTheWeekVC", sender: nil)
        })
    }
    
    
   }

