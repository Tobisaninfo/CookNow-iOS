//
//  CameraItemViewController.swift
//  CookNow
//
//  Created by Tobias on 08.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit


protocol CameraItemViewDataSource {
    func ingredientNameForItem() -> String?
    func recipeNameForItem() -> String?
    func recipeImageForItem() -> UIImage?
}

protocol CameraItemViewDelegate {
    func shouldShowActivityView() -> Bool
    func didSelectReicpeImage()
}

class CameraItemView: UIView {

    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataSource: CameraItemViewDataSource? {
        didSet {
            reloadData()
        }
    }
    var delegate: CameraItemViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func reloadData() {
        if let delegate = delegate {
            if delegate.shouldShowActivityView() {
                activityIndicator.isHidden = false
                ingredientNameLabel.isHidden = true
                recipeNameLabel.isHidden = true
                recipeImageView.isHidden = true
                labels.forEach {
                    $0.isHidden = true
                }
            } else {
                activityIndicator.isHidden = true
                ingredientNameLabel.isHidden = false
                recipeNameLabel.isHidden = false
                recipeImageView.isHidden = false
                labels.forEach {
                    $0.isHidden = false
                }
                
                ingredientNameLabel.text = dataSource?.ingredientNameForItem()
                recipeNameLabel.text = dataSource?.recipeNameForItem()
                recipeImageView.image = dataSource?.recipeImageForItem()
            }
        }
    }
    
    var view: UIView?
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view?.frame = bounds
        
        // Make the view stretch with containing view
        view?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        if let view = view {
            addSubview(view)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.didSelectReicpeImage()
    }
    
    func loadViewFromNib() -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CameraItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        return view
    }
}
