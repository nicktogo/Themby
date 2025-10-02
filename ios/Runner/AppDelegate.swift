import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Configure the audio session to allow media playback in silent mode
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        print("Failed to set audio session category.")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
