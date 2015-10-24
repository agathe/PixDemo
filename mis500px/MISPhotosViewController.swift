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
        self.edgesForExtendedLayout = UIRectEdge.None

        self.viewModel!.data.didChange.addHandler(self, handler: MISPhotosViewController.dataDidChange)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewModel?.fetchNextPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataDidChange(oldValue: [MISPhotoModel], newValue: [MISPhotoModel]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView?.reloadData()
        }
        
    }

}



// MARK: collection delegate

extension MISPhotosViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel!.data.get().count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierLarge, forIndexPath: indexPath) as! MISPhotoCollectionViewCell
        cell.setDataObject(self.viewModel!.data.get()[indexPath.row])
        return cell
    }
}

// MARK: collection layout delegate

extension MISPhotosViewController {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width = self.view.bounds.width ?? 200
            let height = width * 9 / 16
            return CGSize(width: width, height: height)
    }
}