//
//  PhotoService.swift
//  ColorCollectionView
//
//  Created by Jeremy Xue on 2020/12/31.
//

import Foundation

class PhotoService {
    
    // MARK: Singletion
    static let shared = PhotoService()
    private init() {}
    
    // MARK: Properties
    private let URLSession: URLSession = .shared
    private let url: URL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
}

// MARK: - Methods
extension PhotoService {
    
    func getPhotos(completionHandler: @escaping ((Result<[Album], Error>) -> Void)) {
        let task = URLSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(APIError.nilData))
                return
            }
            do {
                let albums = try JSONDecoder().decode([Album].self, from: data)
                completionHandler(.success(albums))
            } catch {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - Nested Types
extension PhotoService {
    
    enum APIError: Error {
        case nilData
    }
}

// MARK: - AlbumModel
struct Album: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
