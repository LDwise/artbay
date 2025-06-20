//
//  SellView.swift
//  artbay
//
//  Created by user on 20/6/2025.
//

import SwiftUI
import SwiftData

struct SellView: View {
    @State private var selectedTab = 0
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var title = ""
    @State private var itemDescription = ""
    @State private var selectedCategory = "Painting"
    @State private var categories = ["Painting", "Sculpture", "Photography", "Digital"]
    @State private var basePrice = ""
    @State private var priceIncrement = ""
    @State private var spacePrice = ""
    @State private var timeUnit = "Hour"
    let timeUnits = ["Hour", "Day", "Week", "Month"]
    // Static demo data (for preview only, not for upload)
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "plus.square.on.square")
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                    Text("Sell")
                        .font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.top, 8)
                // Picker
                Picker("Sell Type", selection: $selectedTab) {
                    Text("Art Work").tag(0)
                    Text("Space").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 4)
                // Form
                ScrollView {
                    VStack(spacing: 18) {
                        // Image upload
                        Section(header: Text("Upload Image").font(.headline)) {
                            Button(action: { showImagePicker = true }) {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .cornerRadius(12)
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                                            .frame(height: 150)
                                        Text("Tap to select image")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        // Title
                        Section(header: Text("Title").font(.headline)) {
                            TextField("Enter title", text: $title)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                        // Description
                        Section(header: Text("Description").font(.headline)) {
                            TextEditor(text: $itemDescription)
                                .frame(height: 80)
                                .padding(6)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                        // Category
                        Section(header: Text("Category").font(.headline)) {
                            Picker("Select Category", selection: $selectedCategory) {
                                ForEach(categories, id: \ .self) { cat in
                                    Text(cat)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(6)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        // Price settings
                        if selectedTab == 0 {
                            // Art Work auction
                            Section(header: Text("Auction Settings").font(.headline)) {
                                TextField("Base Price ($)", text: $basePrice)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                TextField("Add Price per Bid ($)", text: $priceIncrement)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                            }
                        } else {
                            // Space rental
                            Section(header: Text("Rental Settings").font(.headline)) {
                                TextField("Price ($)", text: $spacePrice)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                Picker("Time Unit", selection: $timeUnit) {
                                    ForEach(timeUnits, id: \ .self) { unit in
                                        Text("per \(unit)")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.top, 4)
                            }
                        }
                        // Submit button
                        Button(action: { /* No upload, static data only */ }) {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentColor"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
                    .padding(.vertical, 8)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

// Simple UIKit image picker wrapper for SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    SellView()
}
