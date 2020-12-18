//
//  UIImage+Inverted.swift
//  github-profile
//
//  Created by Master Paulo on 12/16/20.
//

import UIKit

extension UIImage {
    func inverseImage(cgResult: Bool) -> UIImage? {
        let coreImage = self.ciImage
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return nil }
        if cgResult {
            return UIImage(cgImage: CIContext(options: nil).createCGImage(result, from: result.extent)!)
        }
        return UIImage(ciImage: result)
    }
    
    func invertedImage() -> UIImage? {
        
        let startImage = CIImage(image: self)

        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(startImage, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { return nil }
            return UIImage(ciImage: outputImage)
        }
        return nil
    }
}
