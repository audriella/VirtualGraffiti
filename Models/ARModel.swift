import ARKit
import RealityKit
import SwiftUI

class ARModel: ObservableObject {
    var selectedImage: UIImage?
    
    private(set) var arView : ARView
    
    init() {
        arView = ARView(frame: .zero)
    }
    
    func raycastFunc(for imageUrl: URL?, location: CGPoint, callback: ((_ anchorCount: Int) -> Void)?) {
        guard arView.scene.anchors.isEmpty else { return }
        guard let imageUrl else { return }
        guard let query = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .vertical) else { return }
        guard let result = arView.session.raycast(query).first else { return }
        
        guard let texture = try? TextureResource.load(contentsOf: imageUrl) else { return }
        let plane = MeshResource.generatePlane(width: 1, depth: 1)
        var material = SimpleMaterial(color: .white, isMetallic: false)
        material.color = SimpleMaterial.BaseColor(texture: MaterialParameters.Texture(texture, sampler: MaterialParameters.Texture.Sampler()))
        
        let modelEntity = ModelEntity(mesh: plane, materials: [material])
        
        let rotation = simd_quatf(angle: .pi/2, axis: [0, 0, 0])
        modelEntity.transform.rotation = rotation
        
        let raycastAnchor = AnchorEntity(world: result.worldTransform)
        
        raycastAnchor.addChild(modelEntity)
        arView.scene.anchors.append(raycastAnchor)
        
        if arView.scene.anchors.count > 0 {
            callback?(arView.scene.anchors.count)
        }
    }
}
