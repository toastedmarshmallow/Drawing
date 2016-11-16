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
    
    //Monster Selection
    
    @IBOutlet weak var monsterView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    var currentMonster: UIImageView!
    
    @IBOutlet weak var monster1: UIImageView!
    @IBOutlet weak var monster2: UIImageView!
    @IBOutlet weak var monster3: UIImageView!
    @IBOutlet weak var monster4: UIImageView!
    @IBOutlet weak var monster5: UIImageView!
    
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
        
        //set up the profile picture
        profileButton.setImage(UIImage(named: "Monster 1C"), for: UIControlState.normal)
        createCircle(monster1)
        currentMonster = monster1
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
    
    @IBAction func tapProfile(_ sender: AnyObject) {
        
        if monsterView.frame.minX == 123{
            UIView.animate(withDuration: 0.7, animations: {() -> Void in self.monsterView.transform = CGAffineTransform(translationX: -901, y: 0)}, completion: nil)
            
        }else {
            UIView.animate(withDuration: 0.9, animations: {() -> Void in self.monsterView.transform = CGAffineTransform(translationX: 1024, y: 0)}, completion: nil)
        }
    }
    
    
    
    @IBAction func didSelectMonster(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            profileButton.setImage(UIImage(named: "Monster 1C"), for: UIControlState.normal)
            createCircle(monster1)
            swapMonster()
            monster1.image = #imageLiteral(resourceName: "Monster 1A")
            bounceOnTap(monster1)
            currentMonster = monster1
        case 1:
            profileButton.setImage(UIImage(named: "Monster 2C"), for: UIControlState.normal)
            createCircle(monster2)
            swapMonster()
            monster2.image = #imageLiteral(resourceName: "Monster 2B")
            bounceOnTap(monster2)
            removeCircle(currentMonster)
            currentMonster = monster2
        case 2:
            profileButton.setImage(UIImage(named: "Monster 3C"), for: UIControlState.normal)
            createCircle(monster3)
            swapMonster()
            monster3.image = #imageLiteral(resourceName: "Monster 3B")
            bounceOnTap(monster3)
            removeCircle(currentMonster)
            currentMonster = monster3
        case 3:
            profileButton.setImage(UIImage(named: "Monster 4C"), for: UIControlState.normal)
            createCircle(monster4)
            swapMonster()
            monster4.image = #imageLiteral(resourceName: "Monster 4B")
            bounceOnTap(monster4)
            removeCircle(currentMonster)
            currentMonster = monster4
        case 4:
            profileButton.setImage(UIImage(named: "Monster 5C"), for: UIControlState.normal)
            createCircle(monster5)
            swapMonster()
            monster5.image = #imageLiteral(resourceName: "Monster 5B")
            bounceOnTap(monster5)
            removeCircle(currentMonster)
            currentMonster = monster5
        default:
            print("done")
        }

        
    }
    
    func  bounceOnTap(_ image: UIImageView){
        image.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        image.transform = .identity
            },
                       completion: nil)
    }
    
    func swapMonster(){
        if currentMonster == monster1{
            monster1.image = #imageLiteral(resourceName: "Monster 1B")
        }else if currentMonster == monster2{
            monster2.image = #imageLiteral(resourceName: "Monster 2")
        }else if currentMonster == monster3{
            monster3.image = #imageLiteral(resourceName: "Monster 3")
        }else if currentMonster == monster4{
            monster4.image = #imageLiteral(resourceName: "Monster 4")
        }else if currentMonster == monster5{
            monster5.image = #imageLiteral(resourceName: "Monster 5")
        }else{
            return
        }
    }
    
    func createCircle(_ image: UIImageView){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: image.frame.width/2,y: image.frame.height/2), radius: CGFloat(62), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1.0).cgColor

        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        image.layer.addSublayer(shapeLayer)
    }

    func removeCircle(_ image: UIImageView){
        image.layer.sublayers?.removeAll()

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
