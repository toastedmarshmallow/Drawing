//
//  FadeTransition.swift
//  transitionDemo
//
//  Created by Timothy Lee on 11/4/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//  
//  Edited by Shannan Hsiao on 11/12/16 for Drawing app
//

import UIKit

class FadeTransition: BaseTransition {
    var tempView: UIImageView!
    var tempFrame: CGRect!
    var tempPoint: CGPoint!
    var finalFrame: CGRect!
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //setting up the from view controller
        let navigationController = fromViewController as! UINavigationController
        let selectedController = navigationController.viewControllers.first as! HomeViewController
        let homeViewController = selectedController
        
        //setting up the to view controller
        let toNavigationController = toViewController as! UINavigationController
        let toSelectedController = toNavigationController.viewControllers.first as! ViewController
        let canvasViewController = toSelectedController
        finalFrame = canvasViewController.view.frame

        //tempView = to the first Key Frame; we're also passing the coordinates so we know where to grow the view from
        tempView = UIImageView()
        tempView.image = homeViewController.imageToMove
        tempFrame = homeViewController.coordinatesToPassOn
        print(tempFrame)
        
        //gets us the center of the image as a point
        let x = -(tempFrame.minX/2)
        let y = -(tempFrame.minY/2)
        tempPoint = CGPoint(x: x, y: y)
        print(tempPoint)
        
        tempView.frame = tempFrame!
        tempView.contentMode = homeViewController.selectedImageView.contentMode
        tempView.clipsToBounds = homeViewController.selectedImageView.clipsToBounds
        
        //move the image to the final View Controller
        canvasViewController.view.addSubview(tempView)
        
        containerView.center = tempView.center
        canvasViewController.view.alpha = 0
        canvasViewController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        UIView.animate(withDuration: duration, animations: {
            print("in Fade Controller")
            
            canvasViewController.view.alpha = 1
            canvasViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            containerView.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
            self.tempView.frame = canvasViewController.imageView.frame
            canvasViewController.imageView.isHidden = true
            
            //canvasViewController.canvas.image = self.tempView.image
            //canvasViewController.canvas.frame = self.tempView.frame


        }) { (finished: Bool) -> Void in
            canvasViewController.imageView.isHidden = false
            self.tempView.removeFromSuperview()
            self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        fromViewController.view.alpha = 1
        fromViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            fromViewController.view.alpha = 0

        }) { (finished: Bool) -> Void in
            self.finish()
        }
    }
}
