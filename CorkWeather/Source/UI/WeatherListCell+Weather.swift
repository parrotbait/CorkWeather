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

extension WeatherListCell {
    static func instantiate(_ tableView: UITableView, _ indexPath: IndexPath, _ weather: Weather, _ isLoading: Bool, _ weatherUnit: TemperatureUnit) -> WeatherListCell! {
        let cellId = tableView.dequeueReusableCell(withIdentifier: String(describing: self), for: indexPath)
        guard let cell = cellId as? WeatherListCell else {
            return nil
        }
        cell.weatherLoadingIcon.isHidden = !isLoading
        cell.weatherIcon.isHidden = isLoading
        if isLoading {
            cell.weatherDescription.text = Strings.get("Loading")
            cell.weatherLoadingIcon.startAnimating()
        } else {
            cell.weatherLoadingIcon.stopAnimating()
            cell.weatherDescription.text = weather.description
            cell.weatherIcon.sd_setImage(with: URL(string: String(format: sharedConfig.weatherImageBase, weather.icon)), placeholderImage: nil)
        }
        cell.weatherLocation.text = weather.location.addressLines.flatMap({$0})?.joined(separator: ", ")
        cell.weatherTemp.text = String(format: "%@", weather.temperature.getAsString(forUnit: weatherUnit))
        cell.weatherMaxTemp.text = String(format: Strings.get("Max_Temp"), weather.maxTemperature.getAsString(forUnit: weatherUnit))
        cell.windSpeed.text = String(format: Strings.get("Wind_Speed"), weather.windSpeed)
        cell.weatherUpdateDate.text = weather.updateDate.weatherDateString()
        return cell
    }
}
