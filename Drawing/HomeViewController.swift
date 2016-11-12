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
    var fadeTransition: FadeTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Once you can fetch projects, change to:
        // return projects.count + 1
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewProject", for: indexPath)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExistingProject", for: indexPath) as! ProjectCollectionViewCell
            
            //once fetch the projects, then change text to number of items
            //e.g. cell.titleLabel.text = project.titleForItemAtIndexPAth(indexPath)
            cell.titleLabel.text = "Hello"
            
            //once fetch the projects, then change the image to first key frame in the array
            //e.g. cell.firstKeyFrame.image = project.projectForItemAtIndexPAth(indexPath)
            cell.firstKeyFrame.image = #imageLiteral(resourceName: "Monster 1")
            
            imageToMove = cell.firstKeyFrame.image
            
            return cell
        }
    }
    
    //MARK - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if the prototype cell == new project, then just do the segue
        if indexPath.row == 0 {
            performSegue(withIdentifier: "newProjectSegue", sender: nil)
        }
        //else pass in the project to prepare for segway
//        let project = project.projectForItemAtIndexPath(indexPath: NSIndexPath)
//        self.performSegue(withIdentifier: showViewController, sender: project)
    }

    
    // MARK: - prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //settig up the destination view controller to be first in the nav controller
        let navVC = segue.destination as! UINavigationController
        let destinationViewController = navVC.viewControllers.first as! ViewController
        
        print("I'm about to go!")
        destinationViewController.modalPresentationStyle = .custom
        fadeTransition = FadeTransition()
        print("222")
        fadeTransition.duration = 4.0
        destinationViewController.transitioningDelegate = fadeTransition

        
//        if segue.identifier == "showViewController"{
//            let project = sender as! project
//            destinationViewController.image = imageToMove
//            destinationViewController.project = project
//            print("hello")
//        } 
//
//
    }


}
