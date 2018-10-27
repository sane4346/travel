//
//  ViewController.swift
//  travellling
//
//  Created by Santosh chaurasia on 26/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var flickerCollectionView: UICollectionView!
    
    var viewModel = FlickerViewModel() {
        didSet {
                flickerCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.main.async {
            self.viewModel.getJSONForImagesData(searchtext: "kittens", complete: { [weak self] status in
                if status {
                    self?.viewModel.fetchImagesFromServer()
                }
            })
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }

}

extension ViewController : UISearchBarDelegate {
    private func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        flickerCollectionView.addSubview(activityIndicator)
        activityIndicator.frame = flickerCollectionView.bounds
        activityIndicator.startAnimating()
        
        viewModel.getJSONForImagesData(searchtext: searchText, complete: { [weak self] status in
            if status {
                self?.viewModel.fetchImagesFromServer()
                self?.flickerCollectionView.reloadData()
            }
            activityIndicator.removeFromSuperview()
            searchBar.resignFirstResponder()
        })
        
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getResultsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = flickerCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FlickerCollectionViewCell
        cell.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.5, 0.5, 0.5, 1.0])
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        
        if let image  = viewModel.imageAt(indexPath: indexPath)
        {
            cell.flickerCellImage.image = image
        }
        else {
            cell.flickerCellImage.image = UIImage(named: "uber")
        }
        return cell
    }
    
    
}

