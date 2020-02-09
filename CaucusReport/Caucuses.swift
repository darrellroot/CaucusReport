//
//  Caucuses.swift
//  CaucusReport
//
//  Created by Darrell Root on 2/8/20.
//  Copyright © 2020 net.networkmom. All rights reserved.
//

import Foundation

enum Caucuses: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
    
    case nevadaDemocrat = "Nevada Democratic Caucus"
    case genericDemocrat = "Other Democratic Caucus"
    case genericRepublican = "Other Republican Caucus"
    case generic = "Generic Caucus"
}
