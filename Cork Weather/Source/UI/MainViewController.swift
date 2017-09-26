//
//  ViewController.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import GoogleMaps
import SWLogger

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherViewProtocol {

    @IBOutlet weak var weatherList : UITableView!;
    
    var progressView = MBProgressHUD()
    var geocoder : GMSGeocoder! = nil
    
    let weatherBase = "https://openweathermap.org/img/w/%@.png"
    
    fileprivate let WeatherCellIdentifier = "WeatherListCell"
    
    var presenter : WeatherPresenter! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter = WeatherPresenterImpl(view: self, fetcher: WeatherFetcher(), database: DatabaseFirebase());
        presenter.loadList()
        
        initialiseMapsApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        progressView.show(animated: true)
    }

    func weatherLocationObtained(result : PickResult) {
        switch result {
        case .success(let location):
            // Add address to list
            self.presenter.fetch(location)
            break
        case .failure(let error):
            progressView.hide(animated: true)
            showWeatherPickError(reason: error)
            break
        }
    }
    
    // MARK: IBActions
    
    @IBAction func addClicked(sender : UIBarButtonItem) {
        showPicker()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfWeatherItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCellIdentifier, for: indexPath) as! WeatherListCell
        let weather : Weather = self.presenter.getWeatherAtIndex(index: indexPath.row)!
        Log.d("test \(weather.location.coordinate.latitude)")
        Log.i ("row \(indexPath.row) weather location \(weather.location.coordinate.latitude) \(weather.location.coordinate.longitude)", "MainVC")
        cell.weatherDescription.text = weather.description;
        cell.weatherLocation.text = weather.location.addressLines.flatMap({$0})?.joined(separator: ", ");
        cell.weatherTemp.text = String(format: "%@", presenter.getUnitAsString(weather.temperature));
        cell.weatherMaxTemp.text = String(format: Strings.get("Max_Temp"), presenter.getUnitAsString(weather.maxTemperature));
        cell.windSpeed.text = String(format: Strings.get("Wind_Speed"), weather.windSpeed);
        cell.weatherIcon.sd_setImage(with: URL(string: String(format: weatherBase, weather.icon)), placeholderImage: nil)
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfWeatherItems() > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.presenter.removeWeatherAtIndex(index: indexPath.row)
            if (self.presenter.numberOfWeatherItems() == 0) {
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: WeatherViewProtocol
    
    func  weatherItemLoaded(result: WeatherItemResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let _):
            self.weatherList.reloadData()
            break;
        case .failure(let error):
            Log.w("Failed to load weather with error: \(error)")
            showWeatherFetchFailure(reason: error)
            break;
        }
    }
    
    func appLoaded(result: DatabaseResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let _):
            self.weatherList.reloadData()
            break;
        case .failure(let errorType):
            Log.w("Failed to load weather with error: \(errorType)")
            showWeatherListLoadFailure(reason: errorType)
            break;
        }
    }
}

