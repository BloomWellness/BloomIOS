

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func makeBloomShawDown() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
    }
}

extension UIImageView {
    func loadGIF(asset: String) {
        // Ensure the GIF can be loaded from the assets catalog
        guard let asset = NSDataAsset(name: asset) else {
            print("Error: GIF could not be loaded")
            return
        }
        
        guard let source = CGImageSourceCreateWithData(asset.data as CFData, nil) else {
            return
        }

        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }

        // Set the images for animation
        self.animationImages = images
        self.animationDuration = Double(images.count) / 10.0 // Adjust as needed
        self.startAnimating()
    }
}

extension UIViewController {
    
    func createViewControllFromStoryboard(id: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}


struct Helper {
   static func getCurrentISO8601Date() -> String {
       let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]  // Includes timezone and fractional seconds
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}

