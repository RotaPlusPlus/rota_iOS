//
//  ViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Modified by Hiroki Naganuma 2017/10/22
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit
import BAFluidView
import CoreBluetooth

class HumidityViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{

    let centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!

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

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }

    func centralManagerDidUpdateState(central: CBCentralManager!){

        switch central.state{
        case .PoweredOn:
            println("poweredOn")

            let serviceUUIDs:[AnyObject] = [CBUUID(string: "181A")]
            let lastPeripherals = centralManager.retrieveConnectedPeripheralsWithServices(serviceUUIDs)

            if lastPeripherals.count > 0{
                let device = lastPeripherals.last as CBPeripheral;
                connectingPeripheral = device;
                centralManager.connectPeripheral(connectingPeripheral, options: nil)
            }
            else {
                centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
            }

        default:
            println(central.state)
        }
    }


    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {

        connectingPeripheral = peripheral
        connectingPeripheral.delegate = self
        centralManager.connectPeripheral(connectingPeripheral, options: nil)
    }

    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {

        peripheral.discoverServices(nil)
    }

    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {

        if let actualError = error{

        }
        else {
            for service in peripheral.services as [CBService]!{
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {

        if let actualError = error{

        }else {
            switch characteristic.UUID.UUIDString{
            case "2A37":
                update(heartRateData:characteristic.value)

            default:
                println()
            }
        }
        // update status.humidity in update()
    }

    func update(#humidData:NSData){

        var buffer = [UInt8](count: humidData.length, repeatedValue: 0x00)
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
            println(actualHumidity)
            status.humidity = actualHumidity
        }else {
            println(humidity)
            status.humidity = humidity
        }
    }

    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {

        if let actualError = error{

        }else {
            switch characteristic.UUID.UUIDString{
            case "2A37":
                update(heartRateData:characteristic.value)

            default:
                println()
            }
        }
    }
}

