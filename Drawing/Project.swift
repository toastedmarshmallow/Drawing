//
//  Project.swift
//  Zoetrope
//
//  Created by Go, Ian on 11/3/16.
//  Copyright © 2016 Go, Ian. All rights reserved.
//

import Foundation
import UIKit



struct Project {
    var name: String
    var images: [UIImage]
    
    mutating func untitled() {
        if populateProjects() != nil {
            let savedProjects = populateProjects()!
            var untitledProjectsCount = 0
            for project in savedProjects{
                let projectName = project.name
                if projectName.contains("My Project"){
                    untitledProjectsCount += 1
                }
            }
            
            if untitledProjectsCount == 0 {
                self.name = "My Project"
            } else {
                self.name = "My Project \(untitledProjectsCount)"
            }
        }else{
            self.name = "My Project"
        }

        //self.images.append(UIImage(named: "whiteCanvas.png")!)
    }
}
