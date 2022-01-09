//
//  RFAlertView.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

public class RFAlertView: UIView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    
    let nibName = "RFAlertView"
    var contentView: UIView!
    
    var timer: Timer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public func set(image: UIImage) {
        self.iconImage.image = image
    }
    
    public func set(headline text: String) {
        self.headingLabel.text = text
    }
    
    func setupView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        headingLabel.text = ""
    }
    
    public override func didMoveToSuperview() {
        
        self.contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.contentView.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.contentView.transform = CGAffineTransform.identity
            self.contentView.alpha = 1.0
        }, completion: { (_) in
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.removeThisView), userInfo: nil, repeats: false)
        })
    }
    
    @objc func removeThisView() {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.contentView.alpha = 0.0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
}
