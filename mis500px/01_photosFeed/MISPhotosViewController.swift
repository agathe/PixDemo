//
//  ViewController.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/23/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

let defaultOffset = 44

class MISPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let cellIdentifierLarge = "LargeCell"
    
    var viewModel: MISPhotosViewModel!
    let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .Minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.autocorrectionType = .No
        return bar
        }()
    
    let searchBarCancelButton: UIButton = {
       let button = UIButton(type: .Custom)
        button.setTitle("Reset", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)

        return button
    }()
    
    let searchView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"

        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.setupSearchBar()
        
        self.viewModel!.data.didChange.addHandler(self, handler: MISPhotosViewController.dataDidChange)
        self.viewModel!.isLoadingMore.didChange.addHandler(self, handler: MISPhotosViewController.isLoadingDidChange)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewModel?.fetchNextPhotos()
        self.searchView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width), height: defaultOffset)
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
        return self.viewModel!.count()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.viewModel!.numberOfSections()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierLarge, forIndexPath: indexPath) as! MISPhotoCollectionViewCell
        cell.setDataObject(self.viewModel!.data.get()[indexPath.row])
        if indexPath.row == 0 {
            cell.setFirstCell(true)
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = self.viewModel!.data.get()[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MISPhotoCollectionViewCell
        let image = cell.imageView.image
        if let image = image {
            let viewModel = MISPhotoViewModel(model, image)
            
            let storyboard = UIStoryboard(name: "photo", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("photoVC") as! MISPhotoViewController
            viewController.viewModel = viewModel
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
}

// MARK: collection layout delegate

extension MISPhotosViewController {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width = self.view.bounds.width ?? 200
            let height = width * 9 / 16
            return CGSize(width: width, height: height + CGFloat(indexPath.row == 0 ? defaultOffset : 0))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
}


// MARK: infinite scrolling

extension MISPhotosViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let indices = self.collectionView?.indexPathsForVisibleItems()
        let more = self.viewModel?.needsMoreData(indices?.last) ?? false
        if  more {
            self.viewModel?.fetchNextPhotos()
        }
        
        if self.searchBar.isFirstResponder(){
            self.searchBar.resignFirstResponder()
        }
    }
}

// MARK: search bar

extension MISPhotosViewController {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.viewModel?.setQuery(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
     func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.viewModel?.resetQuery()
        searchBar.resignFirstResponder()
    }
    
    func resetSearch(){
        self.searchBar.text = nil
        self.searchBarCancelButtonClicked(self.searchBar)
    }
    
    func isLoadingDidChange(oldValue: Bool, newValue: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.searchBar.userInteractionEnabled = !newValue
            self.searchBarCancelButton.enabled = !newValue
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = newValue
        }
    }
    
    func setupSearchBar() {
        self.searchView.addSubview(self.searchBar)
        self.searchView.addSubview(self.searchBarCancelButton)
        self.collectionView?.addSubview(self.searchView)
        self.searchBar.delegate = self
        let viewDict = ["search": self.searchBar, "reset":self.searchBarCancelButton]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-8@200-[search]-8@200-[reset]-8@200-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        let vConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0@200-[search]-0@200-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        let vConstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0@200-[reset]-0@200-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        self.searchView.addConstraints(hConstraints + vConstraints1 + vConstraints2)
        self.searchBarCancelButton.addTarget(self, action: Selector("resetSearch"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.collectionView?.contentOffset = CGPoint(x: 0, y: defaultOffset)
   
    }
}
