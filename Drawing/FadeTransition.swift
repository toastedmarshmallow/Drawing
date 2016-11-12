//
//  FadeTransition.swift
//  transitionDemo
//
//  Created by Timothy Lee on 11/4/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FadeTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        let navigationController = fromViewController as! UINavigationController
        let selectedController = navigationController.viewControllers.first as! HomeViewController
        let homeViewController = selectedController
        
        let toNavigationController = toViewController as! UINavigationController
        let toSelectedController = toNavigationController.viewControllers.first as! ViewController
        let canvasViewcontroller = toSelectedController


        let tempView = UIImageView()
        tempView.image = homeViewController.imageToMove
        let tempframe = homeViewController.coordinatesToPassOn
        
        tempView.frame = tempframe!
        tempView.contentMode = homeViewController.selectedImageView.contentMode
        tempView.clipsToBounds = homeViewController.selectedImageView.clipsToBounds
        toViewController.view.addSubview(tempView)
        
        canvasViewcontroller.view.alpha = 0
        canvasViewcontroller.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: duration, animations: {
            print("in Fade Controller")
            canvasViewcontroller.view.alpha = 1
            canvasViewcontroller.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }) { (finished: Bool) -> Void in
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
