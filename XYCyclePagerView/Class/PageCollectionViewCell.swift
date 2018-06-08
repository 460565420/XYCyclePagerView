//
//  PageCollectionViewCell.swift
//  Property_switf
//
//  Created by xieqilin on 2018/6/8.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

}
