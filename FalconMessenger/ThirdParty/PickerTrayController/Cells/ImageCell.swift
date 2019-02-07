//
//  ImageCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 15.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

	fileprivate let videoIndicatorView = UIImageView(image: UIImage(bundledName: "ImageCell-Video"))
	fileprivate let cloudIndicatorView = UIImageView(image: UIImage(bundledName: "ImageCell-Cloud"))
	fileprivate let checkmarkView = UIImageView(image: UIImage(bundledName: "ImageCell-Selected"))

	let imageView: UIImageView = {
			let imageView = UIImageView()
			imageView.contentMode = .scaleAspectFill
			imageView.layer.masksToBounds = true
			imageView.translatesAutoresizingMaskIntoConstraints = false

			return imageView
    }()

    var isVideo = false {
			didSet {
				reloadAccessoryViews()
			}
    }
    
    var isRemote = false {
			didSet {
				reloadAccessoryViews()
			}
    }
    
    override var isSelected: Bool {
			didSet {
				reloadCheckmarkView()
			}
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
			super.init(frame: frame)
			initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
    }
    
    fileprivate func initialize() {
			contentView.addSubview(imageView)
			contentView.addSubview(videoIndicatorView)
			contentView.addSubview(cloudIndicatorView)
			contentView.addSubview(checkmarkView)

			videoIndicatorView.translatesAutoresizingMaskIntoConstraints = false
			cloudIndicatorView.translatesAutoresizingMaskIntoConstraints = false
			checkmarkView.translatesAutoresizingMaskIntoConstraints = false

			let inset: CGFloat = 4
			NSLayoutConstraint.activate([
				imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
				imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
				imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

				videoIndicatorView.widthAnchor.constraint(equalToConstant: videoIndicatorView.image?.size.width ?? 0),
				videoIndicatorView.heightAnchor.constraint(equalToConstant: videoIndicatorView.image?.size.height ?? 0),
				videoIndicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset),
				videoIndicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),

				cloudIndicatorView.widthAnchor.constraint(equalToConstant: cloudIndicatorView.image?.size.width ?? 0),
				cloudIndicatorView.heightAnchor.constraint(equalToConstant: cloudIndicatorView.image?.size.height ?? 0),
				cloudIndicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset),
				cloudIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),

				checkmarkView.widthAnchor.constraint(equalToConstant: checkmarkView.image?.size.width ?? 0),
				checkmarkView.heightAnchor.constraint(equalToConstant: checkmarkView.image?.size.height ?? 0),
				checkmarkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
				checkmarkView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
			])

			reloadAccessoryViews()
			reloadCheckmarkView()
    }
    
    // MARK: - Other Methods
    
    fileprivate func reloadAccessoryViews() {
			videoIndicatorView.isHidden = !isVideo
			cloudIndicatorView.isHidden = !isRemote
    }
    
    fileprivate func reloadCheckmarkView() {
			checkmarkView.isHidden = !isSelected
    }
    
    override func prepareForReuse() {
			super.prepareForReuse()
			imageView.image = nil
			isVideo = false
			isRemote = false
    }
}