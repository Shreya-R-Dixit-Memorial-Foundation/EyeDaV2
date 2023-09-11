//
//  SampleCode.swift
//  This sample code will detect phone pickup and speed.
//
//  Created by Aimen Patel on 8/21/23.


import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Create an instance of CMMotionManager
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    // User's points
    var userPoints: Int = 100 {
        didSet {
            print("User's points: \(userPoints)")
        }
    }
    
    // Timer to track phone usage after being picked up
    var usageTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager
        setupLocationManager()
        
        // Check if accelerometer updates are available
        if motionManager.isAccelerometerAvailable {
            startAccelerometerUpdates()
        } else {
            print("Accelerometer not available")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startAccelerometerUpdates() {
        // Set the accelerometer update interval
        motionManager.accelerometerUpdateInterval = 0.1
        
        // Start receiving updates
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                // Check for significant motion
                if abs(data.acceleration.x) > 0.5 || abs(data.acceleration.y) > 0.5 || abs(data.acceleration.z) > 0.5 {
                    print("Phone was picked up!")
                    self.userPoints -= 10
                    
                    // Start a timer to deduct points for every minute of usage
                    if self.usageTimer == nil {
                        self.usageTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.deductPointsForUsage), userInfo: nil, repeats: true)
                    }
                }
            }
        }
    }
    
    @objc func deductPointsForUsage() {
        userPoints -= 2
    }
    
    // Stop the timer when you no longer need to track the usage
    func stopUsageTracking() {
        usageTimer?.invalidate()
        usageTimer = nil
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let speed = locations.last?.speed {
            // Convert speed from m/s to mph
            let speedInMPH = speed * 2.23694
            if speedInMPH > 50 {
                print("Speed is greater than 50 mph!")
                userPoints -= 10
            }
        }
    }
}
