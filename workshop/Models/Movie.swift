//
//  Movie.swift
//  workshop
//
//  Created by Twiscode on 25/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    var id: Int = 0
    var title: String = ""
    var overview: String = ""
    var posterPath: String = ""
    var releaseDate: Date!
    
    convenience init(id: Int, title: String, overview: String, posterPath: String, releaseDate: Date?) {
        self.init()
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}
