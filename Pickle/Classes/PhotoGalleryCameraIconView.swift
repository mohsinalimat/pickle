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

internal final class PhotoGalleryCameraIconView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }

    private lazy var imageView: UIImageView = {
        let camera = UIImage(named: "image-picker-camera", in: Bundle(for: type(of: self)), compatibleWith: nil)
        return UIImageView(image: camera)
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = Bundle(for: type(of: self)).localizedString(forKey: "imagePicker.button.camera", value: "", table: nil).uppercased()
        label.font = UIFont.forCameraButton
        label.textColor = UIColor.Palette.gray
        return label
    }()

    private func setUpSubviews() {
        backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(textLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 9.0, *) {
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true

            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        } else {
            addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            ))
            addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: -10
            ))
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:[image]-10-[text]",
                options: [.alignAllCenterX],
                metrics: nil,
                views: ["image": imageView, "text": textLabel]
            ))
        }
    }

}
