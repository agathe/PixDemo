//
//  ViewController.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/23/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

class MISPhotosViewController: UICollectionViewController {

    var viewModel: MISPhotosViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "500 px"
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// MARK: collection delegate

extension MISPhotosViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0 //self.viewModel!.data.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}