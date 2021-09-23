//
//  SceneDelegate.swift
//  HotelApp
//
//  Created by Ilya Cherkasov on 11.09.2021.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigatoinController = UINavigationController()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigatoinController
        
        let hotelsListViewController = HotelsListBuilder.createHotelsListModule()
        navigatoinController.viewControllers = [hotelsListViewController]
        
        window?.makeKeyAndVisible()
    }
}

