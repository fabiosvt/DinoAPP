//
//  ProfileView.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

public class ProfileView: UIView {

    public var image: UIImage? {
        didSet {
            if let image = image {
                profileImage.image = image
            }
        }
    }

    private lazy var profileImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleToFill

        return v
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
    }
    
}
