//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Travis Gillespie on 7/20/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!

    init(filePathURL: NSURL!, title: String!){
        self.filePathURL = filePathURL
        self.title = title
    }

}
