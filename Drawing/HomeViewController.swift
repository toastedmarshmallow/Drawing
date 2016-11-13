//
//  homeViewController.swift
//  Drawing
//
//  Created by Shannan Hsiao on 11/8/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageToMove:UIImage!
    var coordinatesToPassOn: CGRect!
    var fadeTransition: FadeTransition!
    var selectedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Once you can fetch projects, change to:
        // return projects.count + 1
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0
        {
            print("I'm the new project")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewProject", for: indexPath)
            return cell
        } else {
            print("I'm an existing project")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExistingProject", for: indexPath) as! ProjectCollectionViewCell
            
            //once fetch the projects, then change text to number of items
            //e.g. cell.titleLabel.text = project.titleForItemAtIndexPAth(indexPath)
            cell.titleLabel.text = "Hello"
            
            //once fetch the projects, then change the image to first key frame in the array
            //e.g. cell.firstKeyFrame.image = project.projectForItemAtIndexPAth(indexPath)
            selectedImageView = cell.firstKeyFrame
            cell.firstKeyFrame.image = #imageLiteral(resourceName: "Monster 1")
            imageToMove = cell.firstKeyFrame.image
            
            return cell
        }
    }
    
    //MARK - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let project = projects.projectForItemAtIndexPath(indexPath)
        //replace nil with project below
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
       // transitioningDelegate.openingFrame = frameToOpenFrom
        coordinatesToPassOn = frameToOpenFrom
        performSegue(withIdentifier: "newProjectSegue", sender: nil)
    }

    
    // MARK: - prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //setting up the destination view controller to be first in the nav controller
        let navVC = segue.destination as! UINavigationController
        let destinationViewController = navVC.viewControllers.first as! ViewController
        
        print("I'm about to go!")
        navVC.modalPresentationStyle = .custom
        fadeTransition = FadeTransition()
        fadeTransition.duration = 0.8
        navVC.transitioningDelegate = fadeTransition
        
        destinationViewController.image = imageToMove


    }


}
