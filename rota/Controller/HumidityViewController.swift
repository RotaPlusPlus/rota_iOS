//
//  ViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit
import BAFluidView
import CoreBluetooth

class HumidityViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    var status = Status(humidity: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messageLabel.text = status.rank.rawValue
        humidityLabel.text = String(status.humidity) + " %"
        
        let waveHeight = status.humidity / 100
        let animeView = BAFluidView(frame: self.view.frame, startElevation: waveHeight as NSNumber)
        animeView?.fill(to: waveHeight as NSNumber)
        animeView?.strokeColor = .white
        
        if status.rank == .normal {
            animeView?.fillColor = UIColor(red: 18/255, green: 97/255, blue: 101/255, alpha: 1.0)
        }
        else if status.rank == .careful {
            animeView?.fillColor = UIColor(red: 244/255, green: 191/255, blue: 31/255, alpha: 1.0)
        }
        else if status.rank == .dangerous {
            animeView?.fillColor = UIColor(red: 233/255, green: 68/255, blue: 28/255, alpha: 1.0)
        }
        view.addSubview(animeView!)
        view.sendSubview(toBack: animeView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //  WRITEME
        // status.humidity = ここ！！！
        
    }

}

