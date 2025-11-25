//
//  ServiceSuffixerMacro.swift
//
//
//  Created by Thibaut Schmitt on 08/03/2024.
//

import Alamofire
import Foundation
import PapyrusAlamofire

// Same as @API of Papyrus but instead of adding `API` suffix, add `Service` suffix
@attached(peer, names: suffixed(Service))
public macro Service() = #externalMacro(module: "PapyrusPlugin", type: "APIMacro")
