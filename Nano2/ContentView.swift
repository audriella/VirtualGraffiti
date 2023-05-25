import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @State var selectedImage: UIImage?
    @State var imageUrl: URL?
    @State var showMenu = false
    @State var showImagePicker = false
    @State var showImagePickerCamera = false
    @State var showARView = false
    @State var flatSurfaceFound: Bool = false
    @State var isTextVisible: Bool = true
    @State var buttonIsShowing: Bool = false
    @State var state: ARState = .idle
    @ObservedObject var arViewModel: ARViewModel = ARViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // AR VIEW
            ARViewContainer(flatSurfaceFound: $flatSurfaceFound)
                .environmentObject(arViewModel)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(coordinateSpace: .global) { location in
                    let arView = arViewModel.arView
                    let convertedLocation = arView.convert(location, from: nil)
                    
                    arViewModel.raycastFunc(for: imageUrl, location: convertedLocation) { anchorCount in
                        if anchorCount > 0, state == .imageUploaded {
                            state = .imageEmbedded
                        }
                    }
                    
                }
            
            // BUTTON VIEW ACCORDING STATE
            switch state {
            case .idle:
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                    .opacity(isTextVisible ? 0.5 : 0.0)
                VStack {
                    Spacer()
                    Text("Find flat surface")
                        .foregroundColor(.white)
                    Spacer()
                }
                
            case .flatSurfaceFound:
                VStack {
                    
                    Spacer()
                    Text("Flat surface found!")
                        .foregroundColor(.white)
                    Spacer()
                    AddButtonView(arViewModel: arViewModel, selectedImage: $selectedImage, imageUrl: $imageUrl)
                    //                    if buttonIsShowing {
                    //                    }
                }
            case .imageUploaded:
                CameraButtonView(selectedImage: selectedImage)
                
            case .imageEmbedded:
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RemoveButtonView(removeButtonDidPressed: {
                            arViewModel.arView.scene.anchors.removeAll()
                            state = .idle
                        })
                        Spacer()
                        Button {
                            arViewModel.arView.snapshot(saveToHDR: false) { (image) in
                                let compressedImage = UIImage(data: (image?.pngData())!)
                                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                            }
                        } label: {
                            VStack{
                                ZStack{
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "square.and.arrow.down")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                    //                                        .padding(10)
                                }
                                Text("save")
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        AddButtonView(arViewModel: arViewModel, selectedImage: $selectedImage, imageUrl: $imageUrl)
                            .sheet(isPresented: $showImagePicker, onDismiss: {
                            }) {
                                GetImageView(selectedImage: $selectedImage, imageUrl: $imageUrl)
                            }
                        Spacer()
                    }
                }
            }
            
        }
        .onChange(of: state) { newValue in
            
        }
        .onChange(of: flatSurfaceFound, perform: { newValue in
            if newValue, state == .idle {
                state = .flatSurfaceFound
            }
        })
        .onChange(of: selectedImage) { newValue in
            if newValue != nil, state == .flatSurfaceFound {
                state = .imageUploaded
            }
        }
        
    }
    
    func addButton() {
    }
    
    func doShowImagePicker(){
        showImagePicker = true
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            withAnimation {
                isTextVisible = false
            }
        }
    }
    
    func findFlatSurface() {
        guard let arView = UIApplication.shared.windows.first?.rootViewController?.view as? ARView else {
            return
        }
        
        let raycastQuery = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = raycastQuery.first {
            print("flat surface found")
            let planeEntity = ModelEntity(mesh: .generatePlane(width: 1, depth: 1))
            let transform = Transform(matrix: firstResult.worldTransform)
            planeEntity.transform = transform
            arView.scene.addAnchor(planeEntity as! HasAnchoring)
        }
    }
}
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ARState {
    case idle
    case flatSurfaceFound
    case imageUploaded
    case imageEmbedded
}
