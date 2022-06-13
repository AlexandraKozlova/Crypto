//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Aleksandra on 13.06.2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() { }
    
    func saveImages(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
        let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. Image name: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, foldeerName: String) -> UIImage? {
        guard
            let url = getUrlForImage(imageName: imageName, folderName: foldeerName),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getUrlForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. Folder name: \(folderName). \(error)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getUrlForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
