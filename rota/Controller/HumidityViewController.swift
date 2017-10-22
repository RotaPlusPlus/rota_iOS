//
//  ViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Modified by Hiroki Naganuma 2017/10/22
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit
import CoreBluetooth
import BAFluidView

class HumidityViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral!

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    var animeView: BAFluidView!
    var status = Status(humidity: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animeView = BAFluidView(frame: self.view.frame, startElevation: status.humidity/100 as NSNumber)
        animeView?.strokeColor = .white
        messageLabel.layer.borderColor = UIColor.white.cgColor
        messageLabel.layer.borderWidth = 1.0
        view.addSubview(animeView!)
        
        view.sendSubview(toBack: animeView!)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        updateUIs()
    }
    
    
    private func updateUIs() {
        updateLabel()
        updateWaveHeight()
        updateWaveAndLabelColor()
    }
    
    private func updateLabel() {
        messageLabel.text = status.rank.rawValue
        humidityLabel.text = String(status.humidity) + " %"
    }
    
    private func updateWaveHeight() {
        let waveHeight = status.humidity / 100
        animeView.fill(to: waveHeight as NSNumber)
    }
    
    private func updateWaveAndLabelColor() {
        if status.rank == .normal {
            colorChange(color: UIColor.rotaDeepBlue)
        }
        else if status.rank == .careful {
            colorChange(color: UIColor.rotaYellow)
        }
        else if status.rank == .dangerous {
            colorChange(color: UIColor.rotaRed)
        }
    }
    
    private func colorChange(color: UIColor) {
        animeView?.fillColor = color
        humidityLabel.textColor = color
        messageLabel.textColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
}

extension HumidityViewController {

    func centralManagerDidUpdateState(_ central: CBCentralManager){

        switch central.state{
        case .poweredOn:
            print("poweredOn")

            let serviceUUIDs:[AnyObject] = [CBUUID(string: "181B")]
            let lastPeripherals = centralManager.retrieveConnectedPeripherals(withServices: serviceUUIDs as! [CBUUID] )

            if lastPeripherals.count > 0{
                let device = lastPeripherals.last as! CBPeripheral;
                connectingPeripheral = device;
                centralManager.connect(connectingPeripheral, options: nil)
            }
            else {
                centralManager.scanForPeripherals(withServices: serviceUUIDs as? [CBUUID], options: nil)
            }

        default:
            print(central.state)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectingPeripheral = peripheral
        connectingPeripheral.delegate = self
        centralManager.connect(connectingPeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connect success!")
        let serviceUUIDs:[AnyObject] = [CBUUID(string: "181B")]
        connectingPeripheral.discoverServices(serviceUUIDs as! [CBUUID])
    }
    
}

//　ペリフェラル側
extension HumidityViewController {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{
            print("error")
            return
        }
        print("\(services.count)個のサービスを発見。\(services)")
        
        let characteristicUUIDs: [AnyObject] = [CBUUID(string: "2A3B")]
        connectingPeripheral.discoverCharacteristics(characteristicUUIDs as! [CBUUID],
                                           for: (peripheral.services?.first)!)
    }
    
    /// キャラクタリスティクス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        print("discover characteristics!")
        print(service.characteristics)
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        peripheral.setNotifyValue(true,
                                  for: (service.characteristics?.first)!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("update characteristics value")
        peripheral.setNotifyValue(true, for: characteristic)
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        update(humidData:characteristic.value! as NSData)
    }
    
}

extension HumidityViewController {
    
    func update(humidData:NSData){
        
        var buffer = [UInt8](repeating: 0x00, count: humidData.length)
        humidData.getBytes(&buffer, length: buffer.count)
        
        var humidity:UInt16?
        if (buffer.count >= 2){
            if (buffer[0] & 0x01 == 0){
                humidity = UInt16(buffer[1]);
            }else {
                humidity = UInt16(buffer[1]) << 8
                humidity =  humidity! | UInt16(buffer[2])
            }
        }
        
        if let actualHumidity = humidity{
            print(actualHumidity)
            status.humidity = Double(actualHumidity)
        }else {
            print(humidity)
            status.humidity = Double(humidity!)
        }
        
        updateUIs()
    }
    
}
