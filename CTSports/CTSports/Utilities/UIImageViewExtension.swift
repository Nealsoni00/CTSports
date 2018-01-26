//
//  UIImageViewExtension.swift
//  CTSports
//
//  Created by Neal Soni on 12/15/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//
import UIKit
import Foundation


// Add anywhere in your app
extension UIImage {
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context!.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func resizeImage(_ targetSize: CGSize) -> UIImage {
        let image = self
        let aspect = false
        let originRatio = image.size.width / image.size.height;//CGFloat
        let newRatio = targetSize.width / targetSize.height;
        
        var sz: CGSize = CGSize.zero
        
        if (!aspect) {
            sz = targetSize
        }else {
            if (originRatio < newRatio) {
                sz.height = targetSize.height
                sz.width = targetSize.height * originRatio
            }else {
                sz.width = targetSize.width
                sz.height = targetSize.width / originRatio
            }
        }
        let scale: CGFloat = 1.0
        
        sz.width /= scale
        sz.height /= scale
        UIGraphicsBeginImageContextWithOptions(sz, false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
        
//        let image = self
//
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
    }
}
