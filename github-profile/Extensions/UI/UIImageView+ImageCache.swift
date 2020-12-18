//
//  UIImageView+ImageCache.swift
//  test-app
//
//  Created by John Paulo on 03/04/2020.
//

import UIKit

private let queue = DispatchQueue.global(qos: .background)
private let semaphore = DispatchSemaphore(value: 1)

extension UIImageView {

    /// Load image from URL with caching
    ///
    /// - Parameters:
    ///   - urlString: Image URL string
    ///   - inverted: Flag to invet the image's color
    ///   - completion: Completion handler
    public func loadImage(fromURL url: String, inverted: Bool = false, completion: (()->Void)? = nil) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let targetImage = inverted ? image.invertedImage() : image
                    self.image = targetImage
                    completion?()
                }
            }
            else {
                // TODO: Improve image loading. Images tend to load randomly if scrolling very fast
                DispatchQueue.main.async {
                    self.image = UIImage()
                }
                
                // Apply network request queueing
                queue.async {
                    semaphore.wait()
                    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                        defer {
                            semaphore.signal()
                        }
                        if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                            
                            // Cacher response data
                            let cachedData = CachedURLResponse(response: response, data: data)
                            cache.storeCachedResponse(cachedData, for: request)
                            
                            DispatchQueue.main.async {
                                let targetImage = inverted ? image.invertedImage() : image
                                self.transitionTo(image: targetImage, completion: completion)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.image = nil
                            }
                        }
                    }).resume()
                }
            }
        }
    }
    
    /// Animate transition of showing new image
    ///
    /// - Parameters:
    ///   - image: New image
    ///   - completion: Completion handler
    public func transitionTo(image: UIImage?, completion: (()->Void)? = nil) {
        UIView.transition(with: self,
                          duration: 0.4,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
                          },
                          completion: { _ in
                            completion?()
                          }
        )
        
    }
}
