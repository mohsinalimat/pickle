//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import UIKit
import Photos

internal final class PhotoGalleryCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    // MARK: - Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let overlayView = UIView()
    private let tagLabel = PhotoGalleryTagLabel()

    private var taggedText: String? {
        didSet {
            if let text = taggedText {
                overlayView.isHidden = false
                tagLabel.text = text
            } else {
                overlayView.isHidden = true
            }
        }
    }

    private var imageRequestID: PHImageRequestID?

    // MARK: - UITableViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        imageRequestID.map(PHCachingImageManager.default().cancelImageRequest)
        imageRequestID = nil
        taggedText = nil
        imageView.image = nil
    }

    // MARK: -

    internal func configure(with asset: PHAsset, taggedText: String? = nil, configuration: ImagePickerConfigurable?) {
        let size = CGSize(
            width: frame.width * UIScreen.main.scale,
            height: frame.height * UIScreen.main.scale
        )

        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true

        imageRequestID = PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {
            if let image = $0.0 {
                self.imageView.image = image
            }
        }

        if let color = configuration?.selectedImageOverlayColor {
            overlayView.backgroundColor = color
        }
        if let textAttributes = configuration?.imageTagTextAttributes {
            tagLabel.textAttributes = textAttributes
        }
        self.taggedText = taggedText
    }

    private func setUpSubviews() {
        contentView.backgroundColor = UIColor.lightGray
        overlayView.backgroundColor = UIColor.Palette.blue.withAlphaComponent(0.3)

        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        overlayView.addSubview(tagLabel)

        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        overlayView.frame = contentView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 9.0, *) {
            tagLabel.widthAnchor.constraint(equalTo: tagLabel.heightAnchor).isActive = true
            tagLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 10).isActive = true
            tagLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -10).isActive = true
        } else {
            tagLabel.addConstraint(NSLayoutConstraint(
                item: tagLabel,
                attribute: .width,
                relatedBy: .equal,
                toItem: tagLabel,
                attribute: .height,
                multiplier: 1,
                constant: 0
            ))
            overlayView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[tag]-10-|",
                options: [],
                metrics: nil,
                views: ["tag": tagLabel]
            ))
            overlayView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[tag]",
                options: [],
                metrics: nil,
                views: ["tag": tagLabel]
            ))
        }
    }

}
