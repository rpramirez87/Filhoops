//
//  TeamVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
                return cell
            }else {
                return UICollectionViewCell()
            }
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamGameDataCell", for: indexPath) as? TeamGameDataCell {
                return cell
            }else {
                return UICollectionViewCell()
            }
        }
    }
    
//    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if collectionView == self.collectionView {
//            return CGSize(width: 50, height: 50)
//        }else {
//            return CGSize(width: 200, height: 50)
//        }
//      
//    }
}
