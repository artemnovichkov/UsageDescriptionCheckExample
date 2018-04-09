//
//  Copyright © 2018 Artem Novichkov. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)

        switch status {
        case .notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case .authorized:
            // Load calendars
            break
        case .restricted, .denied:
            // show an error
            break
        }
    }

    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event) { accessGranted, error in
            print(accessGranted)
        }
    }
}
