//
//  status.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import Foundation

enum Rank: String {
    case normal = "OK"
    case careful = "Drink Water"
    case dangerous = "Go to hospital"
}

class Status {
    var humidity: Double
    var rank: Rank {
        if self.humidity > 50 {
            return .normal
        }
        else if self.humidity > 30 {
            return .careful
        }
        else {
            return .dangerous
        }
    }
    
    init(humidity: Double) {
        self.humidity = humidity
    }
}
