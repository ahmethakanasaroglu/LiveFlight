import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        updateAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = false
        
        let homeVC = HomeScreenViewController()
        let favoritesVC = FavoritesViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        viewControllers = [homeNav, favoritesNav, settingsNav]
        
        updateAppearance() // İlk yükleme sırasında güncelleme
    }
    
    private func updateAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            tabBar.backgroundColor = .black
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .white
            
            for item in tabBar.items ?? [] {
                item.image = item.image?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
            }
        } else {
            tabBar.backgroundColor = .white
            tabBar.tintColor = .blue
            tabBar.unselectedItemTintColor = .blue
            
            for item in tabBar.items ?? [] {
                item.image = item.image?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
            }
        }
    }
}
