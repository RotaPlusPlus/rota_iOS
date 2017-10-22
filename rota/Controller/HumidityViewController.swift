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
    var animeView: BAFluidView!
    var status = Status(humidity: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messageLabel.text = status.rank.rawValue
        humidityLabel.text = String(status.humidity) + " %"
        
        let waveHeight = status.humidity / 100
        animeView = BAFluidView(frame: self.view.frame, startElevation: waveHeight as NSNumber)
        animeView?.fill(to: waveHeight as NSNumber)
        animeView?.strokeColor = .white
        
        if status.rank == .normal {
            colorChange(color: UIColor.rotaBlue)
        }
        else if status.rank == .careful {
            colorChange(color: UIColor.rotaYellow)
        }
        else if status.rank == .dangerous {
            colorChange(color: UIColor.rotaRed)
        }
        view.addSubview(animeView!)
        view.sendSubview(toBack: animeView!)
    }
    
    func colorChange(color: UIColor) {
        animeView?.fillColor = color
        humidityLabel.textColor = color
        messageLabel.textColor = color
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

