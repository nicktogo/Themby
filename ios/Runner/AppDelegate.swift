import Flutter
import UIKit
import CoreText

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register Chinese font for subtitle rendering
    registerChineseFont()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerChineseFont() {
    guard let fontPath = Bundle.main.path(forResource: "subfont", ofType: "ttf") else {
      return
    }

    let fontURL = URL(fileURLWithPath: fontPath)
    var registrationError: Unmanaged<CFError>?

    CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &registrationError)
  }

}
