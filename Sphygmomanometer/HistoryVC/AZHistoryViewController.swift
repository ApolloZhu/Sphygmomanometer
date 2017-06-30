//
//  AZHistoryViewController.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/30/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit

class AZHistoryViewController: UITableViewController {

    @IBOutlet var poses: [AZButton]!

    @IBOutlet var dataTypes: [AZButton]!

    private var dates = [DateComponents]()
    private var samples = [[AZSphygmomanometerSample]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        DispatchQueue.global(qos: .userInteractive).async {
            AZSphygmomanometerSample.fetchAll { [weak self] in
                guard let samples = $0, let this = self else { fatalError("\($1!)") }
                for sample in samples {
                    let date = Calendar.current.dateComponents([.year, .month, .day], from: sample.date)
                    if this.dates.contains(date) {
                        this.samples[this.samples.count-1].append(sample)
                    } else {
                        this.dates.append(date)
                        this.samples.append([sample])
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return samples.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(from: dates[section])!
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? AZTableViewCell else { return UITableViewCell() }
        cell.sample = samples[indexPath.section][indexPath.row]
        return cell
    }

}
