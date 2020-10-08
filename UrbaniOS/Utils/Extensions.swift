//
//  Extensions.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

enum ViewCorners {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    
    var corner: CACornerMask {
        switch self {
        case .topRight: return .layerMaxXMaxYCorner
        case .topLeft: return .layerMinXMaxYCorner
        case .bottomLeft: return .layerMinXMinYCorner
        case .bottomRight: return .layerMaxXMaxYCorner
        }
    }
}


extension UIView {
    @discardableResult
    class func fromNib<T>() -> T where T: UIView {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func roundedCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize = PHImageManagerMaximumSize) {
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: nil) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            default:
                self.contentMode = .scaleAspectFit
            }
            self.image = image
        }
    }
}

extension Collection where Iterator.Element == UIImage {
    func combineLeftToRight() -> UIImage? {
        var dimensions = CGSize(width: 0.0, height: 0.0)
        for image in self {
            dimensions.width += Swift.max(dimensions.width, image.size.width)
            dimensions.height = Swift.max(dimensions.height, image.size.height)
        }

        UIGraphicsBeginImageContext(dimensions)

        var lastX = CGFloat(0.0)
        for image in self {
            image.draw(in: CGRect(x: lastX, y: 0, width: image.size.width, height: dimensions.height))
            lastX += image.size.width
        }

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }
}

extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage, let ref = cgImage.cropping(to: rect) else { return nil }
        return UIImage(cgImage: ref)
    }
    
     func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}

extension UIScrollView {
    var visibleRect: CGRect {
        let scale = 1 / self.zoomScale
        return CGRect(x: self.contentOffset.x * scale, y: self.contentOffset.y * scale, width: self.bounds.size.width * scale, height: self.bounds.size.height * scale)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIViewController {
    func showSimpleAlertPopup(title: String? = nil, message: String, buttonTitle: String = "Ok", buttonAction: (DefaultBlock)? = nil) {
        Utils.showSimpleAlertView(withTitle: title, withText: message, withButtonTitle: buttonTitle, buttonAction: buttonAction, onViewController: self)
    }
}

extension UITableView {
    func appendRow(inSection section: Int = 0, count: Int = 1, with animation: UITableView.RowAnimation = .none) {
        let nbRows = self.numberOfRows(inSection: section) - 1
        let indices = (nbRows...(nbRows + count))
        self.beginUpdates()
        self.insertRows(at: indices.map({ IndexPath(row: $0, section: section) }), with: animation)
        self.endUpdates()
    }
}

extension String {
    func sizeOfString(usingFont font: UIFont, maxWidth: CGFloat = .infinity, maxHeight: CGFloat = .infinity) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        
        let constraintBox = CGSize(width: maxWidth, height: maxHeight)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        
        return rect.size
    }
}

extension URL {
    func imageFromVideo(at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: self)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return UIImage(cgImage: thumbnailImageRef)
    }
}

extension IndexPath {
    static var zero: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
}
