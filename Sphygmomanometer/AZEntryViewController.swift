//
//  AZEntryViewController.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/29/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

class AZEntryViewController: UITableViewController {

    @IBOutlet var entries: [UITextField]!

    @IBOutlet weak var segment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        azRequestHealthStoreAccess()
    }

    @IBAction func submit() {
        let data = entries.flatMap { Int($0.text!) }
        guard data.count == 3 else { return }
        AZSphygmomanometerSample(systolic: data[0], diastolic: data[1], pulse: data[2], bodyPosition: AZBodyPossition(rawValue: segment.selectedSegmentIndex)!).store()
        entries.forEach {
            $0.resignFirstResponder()
            $0.text = ""
        }
    }
}
