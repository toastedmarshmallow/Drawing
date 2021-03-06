//
//  ViewController.swift
//  Drawing
//
//  Created by Shannan Hsiao on 11/2/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var canvasView: UIView!
    @IBOutlet weak var keyFramesViewController: UICollectionView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gridView: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var magentaButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var canvas: UIImageView!
    var image: UIImage!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0

    @IBOutlet weak var imageView: UIImageView!
    
    var detailProject: Project? //detailed project to work on  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyFramesViewController.delegate = self
        keyFramesViewController.dataSource = self
        keyFramesViewController.backgroundColor = UIColor.clear
        
        print("this is the project \(detailProject)")
        
        drawInitialImage()
    
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        
        if let touch = touches.first{
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint){
        
        let midPoint=self.midPoint(p0: fromPoint, p1: toPoint)
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(4)
        context?.addQuadCurve(to: midPoint,control: fromPoint)

        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor)
        
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    
    func midPoint(p0:CGPoint,p1:CGPoint)->CGPoint
    {
        let x=(p0.x+p1.x)/2
        let y=(p0.y+p1.y)/2
        return CGPoint(x: x, y: y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = true
        
        if !swiped{
            drawLines(fromPoint:  lastPoint, toPoint: lastPoint)
        }
    }
    
    @IBAction func addNewKeyFrame(_ sender: UIButton) {
        
        detailProject!.images.append(self.imageView.image!)
        self.imageView.image = nil
        
        //save project
        //saveProject(projectSave: detailProject)

        self.keyFramesViewController.reloadData()
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    
    @IBAction func pickedColor(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            (red,green,blue) = (0.82, 0.01, 0.11)
        case 1:
            (red,green,blue) = (0.49, 0.83, 0.13)
        case 2:
            (red,green,blue) = (0.74, 0.06, 0.88)
        case 3:
            (red,green,blue) = (0.97, 0.91, 0.11)
        case 4:
            (red,green,blue) = (0.29, 0.56, 0.89)
        case 5:
            (red,green,blue) = (0.0, 0.0, 0.0)
        case 6:
            (red,green,blue) = (1.0, 1.0, 1.0)
        default:
            print("done")
        }
        
        
    }
    
    
    @IBAction func openCamera(_ sender: UIButton) {
        print("here")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("here2")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Collection View Controller Code
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if detailProject != nil {
            return detailProject!.images.count + 1
        } else {
            return 1 
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //we may need to do some additional logic here: if cell is new then show a blank canvas and point the cell to display the canvas, else if the cell is selected then show the selected color (teal outline), else show light gray outline.
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewKeyFrame", for: indexPath)
            
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1.0).cgColor
            
            return cell
        } else {
            let cell = keyFramesViewController.dequeueReusableCell(withReuseIdentifier: "KeyFrameCell", for: indexPath) as! KeyFrameCollectionViewCell
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.keyFrameImageCell.image = detailProject!.images[indexPath.row - 1]

    
            // cell.firstKeyFrame.image = ...
            
            return cell
        }
    }
    
    func drawInitialImage() {
        let origin = CGPoint(x: view.center.x - image.size.width / 2, y: view.center.y - image.size.height / 2)
        UIGraphicsBeginImageContext(self.view.frame.size)
        image.draw(in: CGRect(x: origin.x, y: origin.y, width: image.size.width, height: image.size.height))
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }


}

