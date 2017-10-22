//
//  MainTabViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 各タブのViewControllerを取得する
        let names = ["Humidity", "Dialogue"]
        setViewControllers(names.map { UIStoryboard(name: $0, bundle: nil).instantiateInitialViewController()! }, animated: false)
        tabBar.items![0].selectedImage = UIImage(named: "humidIcon.png")
        tabBar.items![1].selectedImage = UIImage(named: "doctorIcon.png")
    }
}
