//
//  WeatherListCell+Weather.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import SWLogger
import Proteus_Core
import Proteus_UI

extension WeatherListCell {
    func load(_ isLoading: Bool) {
        //self.weatherLoadingIcon.isHidden = !isLoading
        //self.weatherIcon.isHidden = isLoading
        if isLoading {
            self.weatherDescription.text = Strings.get("Loading")
            self.weatherLoadingIcon.startAnimating()
        } else {
            self.weatherLoadingIcon.stopAnimating()
            self.weatherDescription.text = viewModel!.description
            self.weatherIcon.sd_setImage(with: URL(string: String(format: sharedConfig.weatherImageBase, viewModel!.icon)), placeholderImage: nil)
        }
        self.weatherLocation.text = viewModel!.locationText
        self.weatherTemp.text = viewModel!.temperature
        self.weatherMaxTemp.text = viewModel!.maxTemperature
        self.windSpeed.text = viewModel!.windSpeed
        self.weatherUpdateDate.text = viewModel!.date
    }
}
