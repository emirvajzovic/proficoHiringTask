//
//  StandardImageLoadingService.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import UIKit

final class StandardImageLoadingService: ImageLoadingService {
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw ImageLoadingError.invalidUrl }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw ImageLoadingError.imageDecodingFailed
        }
        imageCache.setObject(image, forKey: urlString as NSString)
        
        return image
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) throws -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { throw ImageLoadingError.invalidUrl }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            completion(image)
        }
        task.resume()
        return task
    }
}
