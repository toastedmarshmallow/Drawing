//
//  ViewController.swift
//  Drawing
//
//  Created by Shannan Hsiao on 11/2/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var magentaButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

