//
//  NetworkMonitor.swift
//  FourSquare
//
//  Created by Vipul Patel on 18/01/22.
//

import Foundation
import Network


//MARK: - Enum NetworkMonitorNotificationType
class NetworkMonitor {
    static let shared = NetworkMonitor()
    private var status: NWPath.Status = .requiresConnection
    private var validationToast: ValidationToastView?
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    let monitor = NWPathMonitor()
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else{return}
            self.status = path.status
            self.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.validationToast?.animateOut(duration: 0.3, delay: 0.0, completion: {
                        self.validationToast?.removeFromSuperview()
                        self.validationToast = nil
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.validationToast = ValidationToast.shared.showToast("~ It seems to be you have no internet connection, please try to check your mobile data or wifi settings.".localized, autoHide: false)
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
