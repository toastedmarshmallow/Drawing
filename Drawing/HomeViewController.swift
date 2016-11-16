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
    
    var projects: [Project] = []
    var selectedProject: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
                var curProject = Project(name: "stick", images: [])
                curProject.name = "Stick"
        
                curProject.images.append(UIImage(named: "MaiaProject")!)
                curProject.images.append(UIImage(named: "DeleteIcon")!)
        
                var cur2Project = Project(name: "stickme", images: [])
                cur2Project.images.append(UIImage(named: "DeleteIcon")!)
        
                print(curProject)
        
                saveProject(projectSave: curProject)
                saveProject(projectSave: cur2Project)
        
        //If projects is nil
        if populateProjects() != nil {
            projects = populateProjects()!
        } else {
            projects = []
        }
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
        if let projects = populateProjects() {
            return projects.count + 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0
        {
            print("I'm the new project")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewProject", for: indexPath)
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExistingProject", for: indexPath)
            return cell
        } else {
            print("I'm an existing project")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExistingProject", for: indexPath) as! ProjectCollectionViewCell
            
            let currentProject = projects[indexPath.row - 1] //get the project for cell, -1 to make room for new project cell
            
            
            //once fetch the projects, then change text to number of items
            //e.g. cell.titleLabel.text = project.titleForItemAtIndexPAth(indexPath)
            let numFrames = currentProject.images.count
            cell.titleLabel.text = "\(numFrames) Drawings"
            
            //once fetch the projects, then change the image to first key frame in the array
            //e.g. cell.firstKeyFrame.image = project.projectForItemAtIndexPAth(indexPath)
            let firstFrame = currentProject.images[0]
        
            selectedImageView = cell.firstKeyFrame
            cell.firstKeyFrame.image = firstFrame
            cell.firstKeyFrame.contentMode = UIViewContentMode.scaleAspectFit
            imageToMove = cell.firstKeyFrame.image
            
            return cell
        }
    }
    
    //MARK - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("im on fire")
        
        if indexPath.row == 0 {
            var blankProject = Project(name: "", images: [])
            blankProject.untitled()
            imageToMove = blankProject.images[0]
            print(indexPath.row)
        } else {
            selectedProject = projects[indexPath.row - 1]
            imageToMove = selectedProject.images[0]
            print(indexPath.row)
        }
 
        //replace nil with project below
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
       // transitioningDelegate.openingFrame = frameToOpenFrom
        coordinatesToPassOn = frameToOpenFrom

        performSegue(withIdentifier: "showViewController", sender: nil)
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
        destinationViewController.detailProject = selectedProject


    }


}
