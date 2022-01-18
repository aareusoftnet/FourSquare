//
//  ClosestVenueVC.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import CoreLocation
import UIKit

//MARK: - Class ClosetVenueVC
class ClosetVenueVC: ParentVC {
    @IBOutlet weak var tableView: UITableView!
    private var locationPermission: LocationPermission?
    private var isEmpty: Bool = true {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: .leastNonzeroMagnitude, left: .leastNonzeroMagnitude, bottom: isEmpty ? .leastNonzeroMagnitude : Screen.safeAreaInsets.bottom, right: .leastNonzeroMagnitude)
            tableView.reloadData()
        }
    }
    private var arrOfVenues: [Venue] = []
    private var validationToast: ValidationToastView?
}

//MARK: UIViewController method(s)
extension ClosetVenueVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
    }
}

//MARK: UIRelated(s)
extension ClosetVenueVC {
    
    private func prepareUIs() {
        setUpLocationPermissionUIs()
        registerNIBs()
    }
        
    private func setUpLocationPermissionUIs() {
        let permissionStatus = UserLocation.shared.locationPermissionStatus
        if permissionStatus == .authorizedAlways  || permissionStatus == .authorizedWhenInUse {
            locationPermission?.isHidden = true
            fetchUserCurrentLocation()
        }else{
            locationPermission = LocationPermission.showIn(view, uiFor: permissionStatus == .notDetermined ? .requesting : .denied) {[weak self] (uiFor, view) in
                guard let self = self else{return}
                switch uiFor {
                case .requesting:
                    self.fetchUserCurrentLocation()
                case .denied:
                    UserLocation.shared.openSettings()
                default:
                    fatalError("ERROR: NO CASE HANDLE")
                }
            }
        }
    }
    
    private func fetchUserCurrentLocation() {
        UserLocation.shared.fetchUserLocationForOnce(self) {[weak self](locationPermissionStatus, location, error) in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.locationPermission?.isHidden = locationPermissionStatus == .authorizedWhenInUse || locationPermissionStatus == .authorizedAlways
                self.locationPermission?.uiFor = locationPermissionStatus == .denied || locationPermissionStatus == .restricted ? .denied : .requesting
                if let localLocation = location {
                    self.closestVenues(localLocation)
                }else{
                    self.hideIndicatorFromCenter()
                }
            }
        }
    }
    
    private func registerNIBs() {
        tableView.register(EmptyList.nib, forCellReuseIdentifier: EmptyList.identifier)
        tableView.register(VenueList.nib, forCellReuseIdentifier: VenueList.identifier)
    }
}

//MARK: UITableView method(s)
extension ClosetVenueVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmpty ? 1 : arrOfVenues.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isEmpty ? tableView.bounds.height : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return isEmpty ? tableView.bounds.height : 112
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEmpty {
            let cellEmptyList = tableView.dequeueReusableCell(withIdentifier: EmptyList.identifier, for: indexPath) as! EmptyList
            cellEmptyList.delegate = self
            return cellEmptyList
        }else{
            let cellVenueList = tableView.dequeueReusableCell(withIdentifier: VenueList.identifier, for: indexPath) as! VenueList
            cellVenueList.objVenue = arrOfVenues[indexPath.row]
            return cellVenueList
        }
    }
}

//MARK: UITableView method(s)
extension ClosetVenueVC: UserActionDelegate {
    
    func didTapOn(_ text: String?, cell: UITableViewCell?) {
        if text == "~Try again".localized {
            tableView.isHidden = true
            setUpLocationPermissionUIs()
        }
    }
}

//MARK: API(s)
extension ClosetVenueVC {
    
    func closestVenues(_ location: CLLocation) {
        if NetworkMonitor.shared.isReachable {
            showIndicatorInCenter()
            APICall.shared.getClosestVenues([
                "ll" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
                "radius": "2500",
                "sort": "DISTANCE",
                "limit": "50"
            ]) {[weak self] (responseType, response, error) in
                guard let self = self else{return}
                switch responseType {
                case .success:
                    self.prepareDatas(response)
                case .failure:
                    self.hideIndicatorFromCenter()
                    if let localResponse = response as? NSDictionary,
                        let message = localResponse["message"] as? String {
                        self.showValidationMessage(message, autoHide: true)
                    }else if let localError = error {
                        self.showValidationMessage(localError.localizedDescription, autoHide: true)
                    }
                }
            }
        }else{
            fetchStoredVenues()
        }
    }
    
    func prepareDatas(_ jsonResonse: Any?) {
        arrOfVenues = []
        if let toDictionary = jsonResonse as? NSDictionary,
            let results = toDictionary["results"] as? [NSDictionary] {
            results.forEach { dictionary in
                let id = dictionary.getStringValue(forKey: "fsq_id")
                let objVenue = Venue.addUpdateEntity(key: "id", value: id)
                objVenue.initWith(dictionary)
                arrOfVenues.append(objVenue)
            }
            isEmpty = arrOfVenues.isEmpty
            tableView.isHidden = false
            hideIndicatorFromCenter()
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func fetchStoredVenues() {
        arrOfVenues = Venue.fetchDataFromEntity(predicate: nil, sortDescs: [NSSortDescriptor(key: "distance", ascending: true)])
        isEmpty = arrOfVenues.isEmpty
        tableView.isHidden = false
        hideIndicatorFromCenter()
    }
}

//MARK: Utility
extension ClosetVenueVC {
    
    func showValidationMessage(_ message: String, autoHide: Bool) {
        validationToast = ValidationToast.shared.showToast(message, autoHide: autoHide)
    }
    
    func hideValidationMessage() {
        validationToast?.animateOut(duration: 0.3, delay: 0.0, completion: {
            self.validationToast?.removeFromSuperview()
            self.validationToast = nil
        })
    }
}
