//
//  ViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit
import BAFluidView

class HumidityViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    var status = Status()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        status.getHumidity()
        messageLabel.text = status.rank.rawValue
        let animeView = BAFluidView(frame: self.view.frame,startElevation: 0.4)
        view.addSubview(animeView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

