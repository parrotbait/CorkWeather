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

    @IBOutlet weak var weatherTableView : UITableView!;
    
    var progressView = MBProgressHUD()
    var geocoder : GMSGeocoder! = nil
    
    let weatherBase = "https://openweathermap.org/img/w/%@.png"
    
    fileprivate let WeatherCellIdentifier = "WeatherListCell"
    
    var presenter : WeatherPresenter! = nil;
    
    var loadingWeather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter = WeatherPresenterImpl(view: self, fetcher: WeatherFetcher(), database: DatabaseFirebase());
        presenter.loadList()
        
        let barButton = UIButton.init(type: .infoLight)
        barButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem.init(customView: barButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        progressView.show(animated: true)
        
        initialiseMapsApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: IBActions
    
    @IBAction func addClicked(sender : UIBarButtonItem) {
        showPicker()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfWeatherItems()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfWeatherItems() > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCellIdentifier, for: indexPath) as! WeatherListCell
        let weather : Weather = self.presenter.getWeatherAtIndex(index: indexPath.row)!
        Log.d("test \(weather.location.coordinate.latitude)")
        Log.i ("row \(indexPath.row) weather location \(weather.location.coordinate.latitude) \(weather.location.coordinate.longitude)", "MainVC")
        let isLoading = loadingWeather.contains(weather)
        cell.weatherLoadingIcon.isHidden = !isLoading
        cell.weatherIcon.isHidden = isLoading
        if isLoading {
            cell.weatherDescription.text = Strings.get("Loading");
            cell.weatherLoadingIcon.startAnimating()
        } else {
            cell.weatherLoadingIcon.stopAnimating()
            cell.weatherDescription.text = weather.description;
            cell.weatherIcon.sd_setImage(with: URL(string: String(format: weatherBase, weather.icon)), placeholderImage: nil)
        }
        cell.weatherLocation.text = weather.location.addressLines.flatMap({$0})?.joined(separator: ", ");
        cell.weatherTemp.text = String(format: "%@", presenter.getUnitAsString(weather.temperature));
        cell.weatherMaxTemp.text = String(format: Strings.get("Max_Temp"), presenter.getUnitAsString(weather.maxTemperature));
        cell.windSpeed.text = String(format: Strings.get("Wind_Speed"), weather.windSpeed);
        cell.weatherUpdateDate.text = weather.updateDate.weatherDateString()
        
        return cell
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
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: WeatherViewProtocol
    
    func weatherItemLoaded(result: WeatherItemResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let weather):
            
            if let index = loadingWeather.index(of: weather) {
                loadingWeather.remove(at: index)
            }
            
            // TODO: Only refresh the correct row
            self.weatherTableView.reloadData()
            break;
        case .failure(let error):
            Log.w("Failed to load weather with error: \(error)")
            showWeatherFetchFailure(reason: error)
            break;
        }
    }
    
    func databaseLoaded(result: DatabaseResult) {
        progressView.hide(animated: true)
        switch result {
        case .success(let weatherList):
            for weather in weatherList {
                
                if !loadingWeather.contains(weather) {
                    loadingWeather.append(weather)
                }
                
                // TODO: Add loading indicator
                self.presenter.fetch(weather.location) { [weak self] result in
                    self?.weatherItemLoaded(result: result)
                }
            }
            self.weatherTableView.reloadData()
            break;
        case .failure(let errorType):
            Log.w("Failed to load weather with error: \(errorType)")
            showWeatherListLoadFailure(reason: errorType)
            break;
        }
    }
    
    // MARK: Misc
    
    
    func weatherLocationObtained(result : PickResult) {
        switch result {
        case .success(let location):
            // Add address to list
            self.presenter.fetch(location) { [weak self] result in
                self?.weatherItemLoaded(result: result)
            }
            break
        case .failure(let error):
            progressView.hide(animated: true)
            showWeatherPickError(reason: error)
            break
        }
    }
    
    func showInfo() {
        performSegue(withIdentifier: "ShowInfo", sender: self);
    }
}

