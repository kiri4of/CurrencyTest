
import UIKit

class TabBarCoordinator {
    var tabBarController = UITabBarController()
    
    func start() {
        let currencyVC = MainScreenBuilder.createCurrencyViewController()
        let favoriteVC = FavoriteScreenBuilder.createFavoriteViewController()
        
        //icons
        currencyVC.tabBarItem = UITabBarItem(title: "Currency", image: AppImages.currencyImage, tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: AppImages.favoriteImage, tag: 1)
        
        tabBarController.viewControllers = [currencyVC,favoriteVC]
        
        //custom
        tabBarController.tabBar.tintColor = AppColors.tabBarTintColor
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = AppColors.tabBarBgColor
    }
    
}


