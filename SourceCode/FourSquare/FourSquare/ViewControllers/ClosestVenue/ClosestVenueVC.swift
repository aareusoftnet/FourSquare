//
//  ClosestVenueVC.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Class ClosetVenueVC
class ClosetVenueVC: ParentVC {
    @IBOutlet weak var tableView: UITableView!
    private var locationPermission: LocationPermission?
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
        locationPermission = LocationPermission.showIn(view, uiFor: .requesting) {[weak self] (uiFor, view) in
            guard let self = self else{return}
            switch uiFor {
            case .requesting:
                self.locationPermission?.uiFor = .denied
            case .denied:
                self.locationPermission?.isHidden = true
            default:
                fatalError("ERROR: NO CASE HANDLE")
            }
        }
    }
    
    private func registerNIBs() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
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
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVenueList = tableView.dequeueReusableCell(withIdentifier: VenueList.identifier, for: indexPath) as! VenueList
        cellVenueList.lblAddress.text = indexPath.row % 2 == 0 ? "New Ranip Road, Ahmedabad, Gujarat, IN, 382470" : "Navnirman Bank Bhavan Shrimali Soc, Rasala Marg, Navrangpura, Ahmedabad, Gujarat, IN, 382470, Navnirman Bank Bhavan Shrimali Soc, Rasala Marg, Navrangpura, Ahmedabad, Gujarat, IN, 382470"
        return cellVenueList
    }
}
