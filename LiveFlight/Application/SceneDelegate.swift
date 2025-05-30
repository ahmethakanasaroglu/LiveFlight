//
//  SceneDelegate.swift
//  a
//
//  Created by Ahmet Hakan Asaroğlu on 19.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = SplashScreenViewController()
        window?.makeKeyAndVisible()
        // tema bilgisi yüklendi altta. kapatıp acsan da app'i nasıl seçtiysen öyle kalır.
        applySavedTheme()
    }
    
    private func applySavedTheme() {
            let isDark = UserDefaults.standard.bool(forKey: "selectedTheme")
            window?.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
}
