//
//  PhotoItemCell.swift
//  FlickrViperTest
//
//  Created by Sagar on 8/6/17.
//  Copyright © 2017 Sagar. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell, ReuseIdentifierProtocol{
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        self.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
}
