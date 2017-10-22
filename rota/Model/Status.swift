//
//  status.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import Foundation

enum Rank: String {
    case Normal = "OK"
    case Careful = "Drink Water"
    case Dangerous = "Go to hospital"
}

class Status {
    var humidity: Double
    var rank: Rank {
        if self.humidity > 0.5 {
            return .Normal
        }
        else if self.humidity > 0.3 {
            return .Careful
        }
        else {
            return .Dangerous
        }
    }
    
    init(humidity: Double) {
        self.humidity = humidity
    }
}
