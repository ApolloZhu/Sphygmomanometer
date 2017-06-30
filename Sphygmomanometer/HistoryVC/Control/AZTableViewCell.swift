//
//  AZTableViewCell.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/30/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

class AZTableViewCell: UITableViewCell {
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var poseLabel: UILabel!
    @IBOutlet private weak var bloodPressureLabel: UILabel!
    @IBOutlet private weak var pulseLabel: UILabel!

    public var sample: AZSphygmomanometerSample! {
        didSet {
            timeLabel.text = DateFormatter.localizedString(from: sample.date, dateStyle: .none, timeStyle: .short)
            poseLabel.text = "\(sample.bodyPosition)"
            bloodPressureLabel.text = "\(sample.systolic)/\(sample.diastolic)\nmmHg"
            pulseLabel.text = "❤️ \(sample.pulse)"
        }
    }
}
