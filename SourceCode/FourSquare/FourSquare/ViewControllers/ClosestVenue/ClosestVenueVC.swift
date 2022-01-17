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
        showIndicatorInCenter()
        UserLocation.shared.fetchUserLocationForOnce(self) {[weak self](locationPermissionStatus, location, error) in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.locationPermission?.isHidden = locationPermissionStatus == .authorizedWhenInUse || locationPermissionStatus == .authorizedAlways
                self.locationPermission?.uiFor = locationPermissionStatus == .denied || locationPermissionStatus == .restricted ? .denied : .requesting
                print(#function + " : ", location ?? "nil")
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
            isEmpty = false
        }
    }
}

//MARK: API(s)
extension ClosetVenueVC {
    
    func closestVenues(_ location: CLLocation) {
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
                if let localResponse = response {
                    print("Failure: ", localResponse)
                }else if let localError = error {
                    print("Failure: ", localError)
                }
            }
        }
    }
    
    func prepareDatas(_ jsonResonse: Any?) {
        if let toDictionary = jsonResonse as? NSDictionary,
            let results = toDictionary["results"] as? [NSDictionary] {
            print(#function + " : ", results.count)
            results.forEach { dictionary in
                let id = dictionary.getStringValue(forKey: "fsq_id")
                let objVenue = Venue.addUpdateEntity(key: "id", value: id)
                objVenue.initWith(dictionary)
                arrOfVenues.append(objVenue)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //fetchStoredVenues()
            isEmpty = arrOfVenues.isEmpty
            tableView.isHidden = false
            hideIndicatorFromCenter()
        }
    }
    
    func fetchStoredVenues() {
        arrOfVenues = Venue.fetchDataFromEntity(predicate: nil, sortDescs: [NSSortDescriptor(key: "distance", ascending: true)])
        isEmpty = arrOfVenues.isEmpty
        tableView.isHidden = false
        hideIndicatorFromCenter()
    }
}
