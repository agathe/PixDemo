//
//  ViewController.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/23/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit



class MISPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellIdentifierLarge = "LargeCell"
    var viewModel: MISPhotosViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "500 px"
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// MARK: collection delegate

extension MISPhotosViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel!.data.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierLarge, forIndexPath: indexPath) as! MISPhotoCollectionViewCell
        cell.setDataObject(self.viewModel!.data[indexPath.row])
        return cell
    }
}

// MARK: collection layout delegate

extension MISPhotosViewController {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: self.view.bounds.width ?? 200, height: 200)
    }
}