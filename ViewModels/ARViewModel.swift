//
//  ARViewModel.swift
//  Nano2
//
//  Created by Audriella Ruth Jim  on 23/05/23.
//

import Foundation
import RealityKit

class ARViewModel: ObservableObject {
    @Published var model: ARModel = ARModel()
    
    var arView: ARView {
        model.arView
    }
    
    func raycastFunc(for imageUrl: URL?, location: CGPoint, callback: ((_ anchorCount: Int) -> Void)?) {
        model.raycastFunc(for: imageUrl, location: location, callback: callback)
    }
}
