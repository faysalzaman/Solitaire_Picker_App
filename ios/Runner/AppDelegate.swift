import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // GMS services
    GMSServices.provideAPIKey("AIzaSyBcdPY1bQKSv0C1lQq-nYb3kBcjANsY3Fk")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
