//
//  ViewController.swift
//  accelerometer
//
//  Created by Gregory Foster on 10/26/16.
//  Copyright © 2016 Gregory Foster. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
  
  let manager = CMMotionManager()
  let motionStream = MotionStream()
  var touchRecognizer: UILongPressGestureRecognizer?
  var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
  var touchLocation = CGPoint(x: -2, y: -2)
  
  required init() {
    super.init(nibName: nil, bundle: nil)
    touchRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapped(_:)))
    touchRecognizer?.minimumPressDuration = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGestureRecognizer(touchRecognizer!);
    
    // register background task
    registerBackgroundTask()
    
    // Start tracking motion.
    startMotionUpdates()
  }
  
  func tapped(_ gestureRecognizer: UILongPressGestureRecognizer) {
    if (gestureRecognizer.state == .began) {
      let nonnormal = gestureRecognizer.location(in: self.view)
      touchLocation = CGPoint(x: (nonnormal.x / UIScreen.main.bounds.width) * 2 - 1,
                              y: (nonnormal.y / UIScreen.main.bounds.height) * 2 - 1)
      print(touchLocation)
    }
    if (gestureRecognizer.state == .ended) {
      touchLocation = CGPoint(x:-2, y:-2)
    }
  }
  
  func registerBackgroundTask() {
    backgroundTask = UIApplication.shared.beginBackgroundTask {
      print("Starting background task");
    }
    assert(backgroundTask != UIBackgroundTaskInvalid)
    print("Background task registered");
  }
  
  func startMotionUpdates() {
    // Capture gyro data
    manager.startGyroUpdates(to: OperationQueue.main, withHandler: {gyroData, error in
      if let data = gyroData {
        self.motionStream.addGyro(time: data.timestamp,
        x: CGFloat(data.rotationRate.x),
        y: CGFloat(data.rotationRate.y),
        z: CGFloat(data.rotationRate.z),
        point: self.touchLocation)
        
      }
    })
    // Capture accel data
    manager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: {accelData, error in
      if let data = accelData {
        self.motionStream.addAccel(time: data.timestamp,
        x: CGFloat(data.acceleration.x),
        y: CGFloat(data.acceleration.y),
        z: CGFloat(data.acceleration.z),
        point: self.touchLocation)
      }
    })
  }

}

