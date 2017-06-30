//
//  AZButton.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/30/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

class AZButton: UIButton {

    private func setup() {
//        layer.cornerRadius = 5
//        setTitleColor(.white, for: .normal)
        isSelected = true
        addTarget(self, action: #selector(update), for: .touchUpInside)
    }

    @objc private func update() {
        isSelected = !isSelected
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        removeTarget(self, action: #selector(update), for: .touchUpInside)
    }
}
