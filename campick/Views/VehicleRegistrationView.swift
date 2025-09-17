import SwiftUI
import PhotosUI

struct VehicleImage: Identifiable, Hashable {
    let id = UUID()
    var image: UIImage
    var isMain: Bool = false
}

struct VehicleType {
    let value: String
    let label: String
    let iconName: String
}

struct VehicleRegistrationView: View {
    @State private var vehicleImages: [VehicleImage] = []
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var mileage: String = ""
    @State private var vehicleType: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var showingVehicleTypePicker = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var errors: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss

    let vehicleTypes = [
        VehicleType(value: "motorhome", label: "모터홈", iconName: "bus"),
        VehicleType(value: "trailer", label: "트레일러", iconName: "truck.box"),
        VehicleType(value: "pickup", label: "픽업캠퍼", iconName: "car"),
        VehicleType(value: "van", label: "캠핑밴", iconName: "car.side"),
        VehicleType(value: "suv", label: "SUV 캠퍼", iconName: "car.fill"),
        VehicleType(value: "compact", label: "소형 캠퍼", iconName: "car.compact")
    ]

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.043, green: 0.129, blue: 0.102)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        imageUploadSection
                        mileageSection
                        vehicleTypeSection
                        priceSection
                        descriptionSection
                        submitButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingVehicleTypePicker) {
            vehicleTypePickerSheet
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotosPicker(
                selection: $selectedPhotos,
                maxSelectionCount: 10 - vehicleImages.count,
                matching: .images
            ) {
                Text("갤러리에서 선택")
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView { image in
                addImage(image)
            }
        }
        .onChange(of: selectedPhotos) { _, newPhotos in
            loadSelectedPhotos(newPhotos)
        }
    }

    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 32, height: 32)

                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
            }

            Spacer()

            Text("차량 매물 등록")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Color.clear
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var titleSection: some View {
        VStack(spacing: 4) {
            Text("매물 정보 입력")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text("차량 정보와 이미지를 등록해주세요")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 8)
    }

    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("차량 이미지")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text("\(vehicleImages.count)/10")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(vehicleImages) { vehicleImage in
                    imageItemView(vehicleImage)
                }

                if vehicleImages.count < 10 {
                    addImageButtons
                }
            }

            if let error = errors["images"] {
                Text(error)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
        }
    }

    private func imageItemView(_ vehicleImage: VehicleImage) -> some View {
        ZStack {
            Image(uiImage: vehicleImage.image)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .cornerRadius(8)

            if vehicleImage.isMain {
                VStack {
                    HStack {
                        Text("메인")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .cornerRadius(4)

                        Spacer()
                    }

                    Spacer()
                }
                .padding(4)
            }

            VStack {
                HStack {
                    Spacer()

                    VStack(spacing: 4) {
                        if !vehicleImage.isMain {
                            Button(action: { setMainImage(vehicleImage) }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(width: 20, height: 20)

                                    Image(systemName: "star")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        Button(action: { deleteImage(vehicleImage) }) {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)

                                Image(systemName: "xmark")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(4)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var addImageButtons: some View {
        HStack(spacing: 8) {
            Button(action: { showingImagePicker = true }) {
                VStack(spacing: 4) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.6))

                    Text("갤러리")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
            }

            Button(action: { showingCamera = true }) {
                VStack(spacing: 4) {
                    Image(systemName: "camera")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.6))

                    Text("촬영")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
            }
        }
    }

    private var mileageSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("주행거리")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(errors["mileage"] != nil ? Color.red : Color.white.opacity(0.2), lineWidth: 1)
                    )

                HStack {
                    TextField("주행거리를 입력하세요", text: $mileage)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .keyboardType(.numberPad)
                        .onChange(of: mileage) { _, newValue in
                            mileage = formatNumber(newValue)
                        }

                    Text("km")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 48)

            if let error = errors["mileage"] {
                Text(error)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
        }
    }

    private var vehicleTypeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("차량 종류")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            Button(action: { showingVehicleTypePicker = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(errors["vehicleType"] != nil ? Color.red : Color.white.opacity(0.2), lineWidth: 1)
                        )

                    HStack {
                        if let selectedType = vehicleTypes.first(where: { $0.value == vehicleType }) {
                            Image(systemName: selectedType.iconName)
                                .foregroundColor(.orange)
                                .font(.system(size: 14))

                            Text(selectedType.label)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        } else {
                            Text("차량 종류를 선택하세요")
                                .foregroundColor(.white.opacity(0.4))
                                .font(.system(size: 14))
                        }

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 12)
                }
                .frame(height: 48)
            }

            if let error = errors["vehicleType"] {
                Text(error)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
        }
    }

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("가격")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(errors["price"] != nil ? Color.red : Color.white.opacity(0.2), lineWidth: 1)
                    )

                HStack {
                    TextField("가격을 입력하세요", text: $price)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .keyboardType(.numberPad)
                        .onChange(of: price) { _, newValue in
                            price = formatNumber(newValue)
                        }

                    Text("만원")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 48)

            if let error = errors["price"] {
                Text(error)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("차량 설명")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(errors["description"] != nil ? Color.red : Color.white.opacity(0.2), lineWidth: 1)
                    )

                if description.isEmpty {
                    Text("차량의 상태, 특징, 옵션 등을 자세히 설명해주세요")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                }

                TextEditor(text: $description)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .background(Color.clear)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .onChange(of: description) { _, newValue in
                        if newValue.count > 500 {
                            description = String(newValue.prefix(500))
                        }
                    }
            }
            .frame(height: 120)

            HStack {
                if let error = errors["description"] {
                    Text(error)
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                } else {
                    Spacer()
                }

                Text("\(description.count)/500")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }

    private var submitButton: some View {
        Button(action: handleSubmit) {
            LinearGradient(
                colors: [Color.orange, Color.orange.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 48)
            .cornerRadius(8)
            .overlay(
                Text("매물 등록하기")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            )
        }
        .padding(.top, 8)
    }

    private var vehicleTypePickerSheet: some View {
        NavigationView {
            ZStack {
                Color(red: 0.043, green: 0.129, blue: 0.102)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ForEach(vehicleTypes, id: \.value) { type in
                        Button(action: {
                            vehicleType = type.value
                            errors["vehicleType"] = nil
                            showingVehicleTypePicker = false
                        }) {
                            HStack {
                                Image(systemName: type.iconName)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 16))
                                    .frame(width: 24)

                                Text(type.label)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.05))
                        }
                        .buttonStyle(PlainButtonStyle())

                        if type.value != vehicleTypes.last?.value {
                            Divider()
                                .background(Color.white.opacity(0.1))
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle("차량 종류 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("닫기") {
                showingVehicleTypePicker = false
            })
        }
        .preferredColorScheme(.dark)
    }

    private func formatNumber(_ value: String) -> String {
        let numbers = value.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let number = Int(numbers), number > 0 {
            return formatter.string(from: NSNumber(value: number)) ?? numbers
        }
        return ""
    }

    private func loadSelectedPhotos(_ items: [PhotosPickerItem]) {
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            addImage(uiImage)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
        selectedPhotos.removeAll()
    }

    private func addImage(_ image: UIImage) {
        let newImage = VehicleImage(image: image, isMain: vehicleImages.isEmpty)
        vehicleImages.append(newImage)
        errors["images"] = nil
    }

    private func deleteImage(_ vehicleImage: VehicleImage) {
        if let index = vehicleImages.firstIndex(where: { $0.id == vehicleImage.id }) {
            vehicleImages.remove(at: index)

            if vehicleImage.isMain && !vehicleImages.isEmpty {
                vehicleImages[0].isMain = true
            }
        }
    }

    private func setMainImage(_ vehicleImage: VehicleImage) {
        for i in vehicleImages.indices {
            vehicleImages[i].isMain = vehicleImages[i].id == vehicleImage.id
        }
    }

    private func validateForm() -> Bool {
        var newErrors: [String: String] = [:]

        if vehicleImages.isEmpty {
            newErrors["images"] = "최소 1장의 이미지를 등록해주세요"
        }

        if mileage.isEmpty {
            newErrors["mileage"] = "주행거리를 입력해주세요"
        } else if let mileageNumber = Int(mileage.replacingOccurrences(of: ",", with: "")), mileageNumber <= 0 {
            newErrors["mileage"] = "올바른 주행거리를 입력해주세요"
        }

        if vehicleType.isEmpty {
            newErrors["vehicleType"] = "차량 종류를 선택해주세요"
        }

        if price.isEmpty {
            newErrors["price"] = "가격을 입력해주세요"
        } else if let priceNumber = Int(price.replacingOccurrences(of: ",", with: "")), priceNumber <= 0 {
            newErrors["price"] = "올바른 가격을 입력해주세요"
        }

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["description"] = "차량 설명을 입력해주세요"
        } else if description.trimmingCharacters(in: .whitespacesAndNewlines).count < 10 {
            newErrors["description"] = "차량 설명은 10자 이상 입력해주세요"
        }

        errors = newErrors
        return newErrors.isEmpty
    }

    private func handleSubmit() {
        guard validateForm() else { return }

        let formData = [
            "images": vehicleImages.map { image in
                [
                    "id": image.id.uuidString,
                    "isMain": image.isMain
                ]
            },
            "mileage": Int(mileage.replacingOccurrences(of: ",", with: "")) ?? 0,
            "vehicleType": vehicleType,
            "price": Int(price.replacingOccurrences(of: ",", with: "")) ?? 0,
            "description": description.trimmingCharacters(in: .whitespacesAndNewlines)
        ]

        print("Vehicle registration data:", formData)

        // Show success message and dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    var onImageTaken: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageTaken(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    VehicleRegistrationView()
}