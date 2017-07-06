//
//  BorderedView.swift
//  CookNow
//
//  Created by Tobias on 06.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class BorderView: UIView {

    @IBInspectable var borderColor: UIColor?
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        self.layer.backgroundColor = self.backgroundColor?.cgColor
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }

}
