//
//  ViewController.swift
//  travellling
//
//  Created by Santosh chaurasia on 26/10/18.
//  Copyright © 2018 Santosh chaurasia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flickerCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField : UITextField!
    @IBOutlet weak var noResultLabel: UILabel!
 
    var viewModel : FlickerViewModel?
        {
            didSet {
                if viewModel != nil {
                    self.flickerCollectionView.reloadData()
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = FlickerViewModel()
        noResultLabel.bringSubview(toFront: self.view)
        //loadDataForCollectionView(text: "kittens")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    func loadDataForCollectionView(text: String?) {
        //imageCache.removeAllObjects()
        noResultLabel.isHidden = true
        if let searchText = text , searchText.count > 0 {
            viewModel?.photosData.removeAll()
            viewModel?.setItemCount(items: 0)
            self.flickerCollectionView.reloadData()
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            flickerCollectionView.addSubview(activityIndicator)
            activityIndicator.frame = flickerCollectionView.bounds
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .background).async {
                self.viewModel?.getJSONForImagesData(searchtext: searchText, complete: { [weak self] status in
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        if status {
                            self?.viewModel?.photosCount == 0 ? self?.noResultLabel.isHidden = false : self?.flickerCollectionView.reloadData()
                        }
                        else {
                            let alert = UIAlertController(title: "Error", message: "Network or server error occured", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self?.present(alert, animated: false, completion: nil)
                        }
                    }
                })
            }
        }
    }
}

extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.loadDataForCollectionView(text: searchTextField.text)
        textField.text = searchTextField.text
        textField.resignFirstResponder()
        return true
    }
    
    
}


extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = flickerCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FlickerCollectionViewCell
        cell.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.5, 0.5, 0.5, 1.0])
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor=UIColor.white
        
        if let photo  = viewModel?.photoDataAt(indexPath: indexPath)
        {
            cell.configure(photoData:photo)
        }
        else {
            cell.flickerCellImage.image = UIImage(named: "uber")
        }
        return cell
    }
    
    
}

