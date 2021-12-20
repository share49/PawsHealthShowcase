//
//  Utils.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 8/20/18.
//  Copyright © 2018 Roger Pintó Diaz. All rights reserved.
//

import UIKit

final class Utils {
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func resizeImage(image: UIImage, maxSide: CGFloat) -> UIImage {
        let size = image.size
        var newSize: CGSize
        
        if size.width > size.height && size.width > maxSide {
            let widthRatio = maxSide / size.width
            let height = size.height * widthRatio
            newSize = CGSize(width: maxSide, height: height)
        } else if size.height > size.width && size.height > maxSide {
            let heightRatio = maxSide / size.height
            let width = size.width * heightRatio
            newSize = CGSize(width: width, height: maxSide)
        } else {
            return image
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func refactorFireBaseLink(url: String) -> String {
        return url.replacingOccurrences(of: "https://firebasestorage.googleapis.com/v0/b/faber-8f29b.appspot.com/o/images", with: "")
    }
    
    static func topViewController() -> UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    static func startActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
    }
    
    static func stopActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.alpha = 0
        activityIndicator.stopAnimating()
    }
    
    static func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
        
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
    }
}
