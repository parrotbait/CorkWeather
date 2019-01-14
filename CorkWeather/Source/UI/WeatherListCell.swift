//
//  WeatherListCell.swift
//  Cork Weather
//
//  Created by Eddie Long on 09/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import UIKit
import SWLogger
import Proteus_UI

class WeatherListCell: UITableViewCell {
    @IBOutlet weak var weatherLocation: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherMaxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherLoadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var weatherUpdateDate: UILabel!
    
    var viewModel: WeatherCellViewModel?
}

// Allows use of dequeueReusableCell without a string
extension WeatherListCell: ReusableView {}
