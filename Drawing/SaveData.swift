//
//  SaveData.swift
//  Drawing
//
//  Created by Go, Ian on 11/13/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import Foundation
import UIKit

func saveProject(projectSave: Project){
    let fileManager = FileManager.default
    if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let documentURL = URL(fileURLWithPath: documentPath, isDirectory: true)
        let projectsURL = documentURL.appendingPathComponent("Projects")
        
        if !fileManager.fileExists(atPath: projectsURL.absoluteString){
            do {
                try fileManager.createDirectory(atPath: projectsURL.path, withIntermediateDirectories: true, attributes: nil)
                print("Projects Folder Created")
                let projectURL = projectsURL.appendingPathComponent(projectSave.name)
                
                if !fileManager.fileExists(atPath: projectsURL.absoluteString){
                    do {
                        try fileManager.createDirectory(atPath: projectURL.path, withIntermediateDirectories: true, attributes: nil)
                        print("Project " + projectSave.name + " Folder Created")
                        
                        for (index, image) in projectSave.images.enumerated(){
                            let imageName = projectSave.name + "_\(index).jpg"
                            let imageData = UIImageJPEGRepresentation(image, 1.0)
                            let imagePath = projectURL.appendingPathComponent(imageName)
                            try! imageData?.write(to: imagePath)
                            
                            //fileManager.createFile(atPath: imagePath.path, contents: imageData, attributes: nil)
                            
                            
                            //let testImage = UIImage(contentsOfFile: imagePath.absoluteString)
                            print("saved images")
                            print(imagePath)
                            print(image)
                            print(try fileManager.contentsOfDirectory(at: projectURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles))
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }else{
                    print("Project already Created")
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }else{
            print("Project already Created")
        }
    }
}

func populateProjects() -> [Project]?{
    //access the document directory
    if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let documentURL = URL(fileURLWithPath: documentDirectory, isDirectory: true) //access the document directory path
        let projectDirectory = documentURL.appendingPathComponent("Projects") //create the path for projects in document directory
        
        do {
            let projectURLs = try FileManager.default.contentsOfDirectory(at: projectDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) //get array of project urls within projects folder
            
            print(projectURLs)
            
            var projects: [Project] = []
            for projectURL in projectURLs {
                let imageURLs = try FileManager.default.contentsOfDirectory(at: projectURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) //get array of image urls within image folder
                
                print(imageURLs)
                
                var images: [UIImage] = []
                for imageURL in imageURLs {
                    
                    let imageData = try! Data(contentsOf: imageURL)
                    
                    images.append(UIImage(data: imageData)!) //fill images array with images from path
                    print("image url" + imageURL.absoluteString)
                    
                }
                projects.append(Project(name: projectURL.pathComponents.last ?? "", images: images))
            }
            return projects
        } catch {
            print("failed to open project directory")
            return nil
        }
    } else {
        return nil
    }
}

func clearProjects() {
    //clear projects for testing still working on this
}
    
