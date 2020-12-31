//
//  ViewController.swift
//  ColorCollectionView
//
//  Created by Jeremy Xue on 2020/12/31.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    private var albums: [Album] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: Outlets
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let length = UIScreen.main.bounds.width / 4
        layout.itemSize = CGSize(width: length, height: length)
        layout.minimumInteritemSpacing = .leastNormalMagnitude
        layout.minimumLineSpacing = .leastNormalMagnitude
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbums()
    }
    
    // MARK: Setting Methods
    private func getAlbums() {
        PhotoService.shared.getPhotos { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self.albums = albums
                case .failure(let error):
                    self.alert(title: "Get Albums Error",
                               message: error.localizedDescription)
                }
            }
        }
    }
    
    private func alert(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier,
                                                      for: indexPath) as! ColorCollectionViewCell
        let album = albums[indexPath.row]
        cell.idLabel.text = "\(album.albumId)"
        cell.titleLabel.text = album.title
        cell.backgroundImageView.setImage(with: album.thumbnailUrl)
        return cell
    }
}
