import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var flatSurfaceFound: Bool
    @EnvironmentObject var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.model.arView.session.delegate = context.coordinator
        
        return arViewModel.model.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical]
        
        arViewModel.model.arView.session.run(config, options: [])
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator { status in
            if status {
                flatSurfaceFound = true
            }
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        let callbackForFlatSurfaceFound: ((Bool)-> Void)?
        
        init(callbackForFlatSurfaceFound: ((Bool) -> Void)?) {
            self.callbackForFlatSurfaceFound = callbackForFlatSurfaceFound
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    callbackForFlatSurfaceFound?(true)
                }
                else {
                    callbackForFlatSurfaceFound?(false)
                }
            }
        }
    }
}
