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
    var oldText :String? = ""
    var viewModel : FlickerViewModel?
    //    {
    //        didSet {
    //                flickerCollectionView.reloadData()
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = FlickerViewModel()
        loadDataForCollectionView(text: "kittens")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.loadDataForCollectionView(text: searchTextField.text)
        
    }
    
    func loadDataForCollectionView(text: String?) {
        noResultLabel.isHidden = true
        if let searchText = text , oldText != searchText {
            oldText = searchText
            viewModel?.setItemCount(items: 0)
            DispatchQueue.main.async {
                self.flickerCollectionView.reloadData()
            }
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            flickerCollectionView.addSubview(activityIndicator)
            activityIndicator.frame = flickerCollectionView.bounds
            activityIndicator.startAnimating()
            self.viewModel?.getJSONForImagesData(searchtext: searchText, complete: { [weak self] status in
                DispatchQueue.main.asyncAfter(deadline: .now() + 9.0 , execute: {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    if self?.viewModel?.photosCount == 0 {
                        self?.noResultLabel.isHidden = false
                    }
                    else {
                        self?.flickerCollectionView.reloadData()
                    }
                    
                })
            })
        }
    }
}

extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.loadDataForCollectionView(text: searchTextField.text)
        textField.resignFirstResponder()
        textField.text = searchTextField.text
        return true
    }
    
}


extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 10
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

