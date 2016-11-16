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
    var homeVC: HomeViewController?
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    var detailProject: Project? //detailed project to work on  
    var selectedCellIndexRow = 0
    var currentCellIndexRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyFramesViewController.delegate = self
        keyFramesViewController.dataSource = self
        keyFramesViewController.backgroundColor = UIColor.clear
        
        print("this is the project \(detailProject)")

        drawInitialImage()
        nameTextField.text = detailProject!.name
    
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    //Touch Canvas Logic
    
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
    
    func drawInitialImage() {
        let origin = CGPoint(x: view.center.x - image.size.width / 2, y: view.center.y - image.size.height / 2)
        UIGraphicsBeginImageContext(self.view.frame.size)
        image.draw(in: CGRect(x: origin.x, y: origin.y, width: image.size.width, height: image.size.height))
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //Button Logic
    
    @IBAction func openCamera(_ sender: UIButton) {
        print("here")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        deleteProject(projectDelete: detailProject!)
        saveProject(projectSave: detailProject!)
        if let homeVC = self.homeVC {
            if populateProjects() != nil {
                print("hello")
                homeVC.projects = populateProjects()!
            } else {
                homeVC.projects = []
            }
            homeVC.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewKeyFrame(_ sender: UIButton) {
        detailProject!.images.append(self.imageView.image!)
        self.imageView.image = nil
        
        //save project
        saveProject(projectSave: detailProject!)
        self.keyFramesViewController.reloadData()
    }
    

    @IBAction func didPressPlayButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToAnimation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnimationViewController
        
        destinationVC.projectToAnimate = self.detailProject
    }
    
    @IBAction func didPressDeleteFrame(_ sender: UIButton) {
        deleteProjectFrame(deleteFrameIndexRow: currentCellIndexRow - 1)
        
        if detailProject!.images.count == 0 {
            self.imageView.image = UIImage(named: "whiteCanvas.png")
        } else {
            self.imageView.image = detailProject!.images[currentCellIndexRow - 1]
        }
        keyFramesViewController.reloadData()
    }
    
    @IBAction func didEndEditingNameField(_ sender: UITextField) {
        deleteProject(projectDelete: detailProject!)
        detailProject!.name = nameTextField.text!
        saveProject(projectSave: detailProject!)
    }
    
    //Collection View Controller Code
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if detailProject != nil {
            if detailProject!.images == [] {
                return 1
            } else {
                return detailProject!.images.count + 1
            }
        } else {
            return 1 
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //we may need to do some additional logic here: if cell is new then show a blank canvas and point the cell to display the canvas, else if the cell is selected then show the selected color (teal outline), else show light gray outline.
        
        if detailProject!.images == [] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewKeyFrame", for: indexPath)
            
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1.0).cgColor
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewKeyFrame", for: indexPath)
                
                if indexPath.row == currentCellIndexRow {
                    cell.layer.borderWidth = 2.0
                    cell.layer.borderColor = UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1.0).cgColor
                } else {
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                }
            
                return cell
            } else {
                let cell = keyFramesViewController.dequeueReusableCell(withReuseIdentifier: "KeyFrameCell", for: indexPath) as! KeyFrameCollectionViewCell
                
                if indexPath.row == currentCellIndexRow {
                    cell.layer.borderWidth = 2.0
                    cell.layer.borderColor = UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1.0).cgColor
                } else {
                    cell.layer.borderWidth = 1.0
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                }
    
                cell.keyFrameImageCell.image = detailProject!.images[indexPath.row - 1]

                return cell
            }
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentCellIndexRow != 0 {
            editProjectFrame(editFrameIndexRow: currentCellIndexRow, frame: self.imageView.image!)
        }

        if indexPath.row == 0 {
            self.imageView.image = UIImage(named: "blankCanvas.png")
        }else{
            self.imageView.image = detailProject!.images[indexPath.row - 1]
        }
        
        currentCellIndexRow = indexPath.row
        
        collectionView.reloadData()
    }
    
// Utility methods for editing and deleted project images array
    func editProjectFrame(editFrameIndexRow: Int, frame: UIImage){
        detailProject!.images[editFrameIndexRow - 1] = frame
    }
    
    func deleteProjectFrame(deleteFrameIndexRow: Int){
        detailProject!.images.remove(at: deleteFrameIndexRow)
    }
}

