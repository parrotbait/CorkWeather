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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherViewProtocol {

    @IBOutlet weak var weatherList : UITableView!;
    
    var progressView = MBProgressHUD()
    var geocoder : GMSGeocoder! = nil
    var weatherData = [Weather]()
    
    let weatherBase = "https://openweathermap.org/img/w/%@.png"
    
    fileprivate let WeatherCellIdentifier = "WeatherListCell"
    
    var presenter : WeatherPresenter! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter = WeatherPresenterImpl(view: self, fetcher: WeatherFetcher());
        //(self.weatherList!.collectionViewLayout as! UITableViewFlowLayout).itemSize = CGSize.init(width: UIScreen.main.bounds.width, height: 110)
        
        initialiseMaps()
        //self.weatherList.register(WeatherListCell.self, forCellWithReuseIdentifier: WeatherCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        //
        /*self.pickLocation(location: CLLocationCoordinate2D.init(latitude: 51.8960902, longitude: -8.5330897)) { [weak self] result in
                self!.addressObtained(result: result)
        }*/
        
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        progressView.hide(animated: false)
    }

    func weatherLoadFailed() {
        //weatherDescription.text = "Load Failed";
        progressView.hide(animated: true)
    }
    
    func addressObtained(result : Result<GMSAddress, PickError>) {
        switch result {
        case .success(let address):
            // Add address to list
            let weather = WeatherLocation.init(coordinate: address.coordinate, address: address)
            self.presenter.fetch(weather)
            break
        default:
            break
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCellIdentifier, for: indexPath) as! WeatherListCell
        let weather : Weather = self.weatherData[indexPath.row]
        print ("row \(indexPath.row) weather location \(weather.location.coordinate.latitude) \(weather.location.coordinate.longitude)")
        cell.weatherDescription.text = weather.description;
        cell.weatherLocation.text = weather.location.address.lines.flatMap({$0})?.joined(separator: ", ");
        cell.weatherTemp.text = String(format: "%@", presenter.getUnitAsString(weather.temperature));
        cell.weatherMaxTemp.text = String(format: Strings.get("Max_Temp"), presenter.getUnitAsString(weather.maxTemperature));
        cell.windSpeed.text = String(format: Strings.get("Wind_Speed"), weather.windSpeed);
        cell.weatherIcon.sd_setImage(with: URL(string: String(format: weatherBase, weather.icon)), placeholderImage: nil)
        
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.weatherData.count > 0 ? 1 : 0
    }

    @IBAction func addClicked(sender : UIBarButtonItem) {
        showPicker()
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
            weatherData.remove(at: indexPath.row)
            if (weatherData.isEmpty) {
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    // MARK: UITableViewDelegate
    
    // MARK: WeatherViewProtocol
    
    func weatherLoaded(weather: Weather) {
        progressView.hide(animated: true)
        weatherData.append(weather)
        print ("sizew \(weatherData.count) weather location \(weather.location.coordinate.latitude) \(weather.location.coordinate.longitude)")
        self.weatherList.reloadData()
    }
}

