//
//  MISPhotoViewController.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/25/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

class MISPhotoViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet var scrollview:UIScrollView!
    @IBOutlet var imageView: UIImageView?
    
    var viewModel: MISPhotoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = self.viewModel?.photo.name
        
        let size = self.viewModel!.image.size
        self.imageView?.image = self.viewModel?.image
        self.scrollview.contentSize = size
        
        
        self.setZoomScale()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setZoomScale()
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func setZoomScale() {
        let imageViewSize = self.imageView!.bounds.size
        let scrollViewSize = self.scrollview.bounds.size
        let widthRatio = scrollViewSize.width / imageViewSize.width
        let heightRatio = scrollViewSize.height / imageViewSize.height
        
        self.scrollview.minimumZoomScale = min(widthRatio, heightRatio)
        self.scrollview.zoomScale = max(widthRatio, heightRatio)
        
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = self.imageView!.frame.size
        let scrollViewSize = self.scrollview.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
