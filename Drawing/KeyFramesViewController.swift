//
//  KeyFramesViewController.swift
//  Drawing
//
//  Created by Shannan Hsiao on 11/10/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import UIKit

class KeyFramesViewController: UICollectionViewController
{
    
    //data source
    //let projectKeyframes = project()
    
    //MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //how many cells per section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return number of keyframes (e.g. number of publishers) return keyframes.numberofkeyframes
        return 10
    }
    
//    private struct keyFrameCollection
//    {
//        static let cellIdentifier = "KeyFrameCell"
//    }
//    
//    //dequeues the prototype cell or reusable cell
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell   {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keyFrameCollection.cellIdentifier, for: indexPath) as UICollectionViewCell
//        
//        // Configure the cell
//        
//        return cell
//    }

    
    
}
