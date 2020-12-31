//
//  CacheImageView.swift
//  ColorCollectionView
//
//  Created by Jeremy Xue on 2020/12/31.
//

import UIKit

class CacheImageView: UIImageView {
    
    private static var imageCache = NSCache<AnyObject, AnyObject>()
    private(set) var imageURL: URL?
    
    func setImage(with url: URL) {
        self.image = nil
        self.imageURL = url
        guard let object = CacheImageView.imageCache.object(forKey: url as AnyObject),
              let cacheImage = object as? UIImage else {
            sendImageRequest(from: url)
            return
        }
        self.image = cacheImage
    }
    
    private func sendImageRequest(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self.imageURL == url {
                        self.image = image
                    }
                    CacheImageView.imageCache.setObject(image, forKey: url as AnyObject)
                }
            }
        }.resume()
    }
}
