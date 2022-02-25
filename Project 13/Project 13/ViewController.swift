//
//  ViewController.swift
//  Project 13
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/25.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate {
    var imageView: UIImageView!
    var intensityLabel: UILabel!
    var slider: UISlider!
    var changeFilterButton: UIButton!
    var saveButton: UIButton!

    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        view.addSubview(imageView)

        intensityLabel = UILabel()
        intensityLabel.text = "Intensity: "
        view.addSubview(intensityLabel)

        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        view.addSubview(slider)

        changeFilterButton = UIButton()
        changeFilterButton.setTitle("Change Filter", for: .normal)
        changeFilterButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(changeFilterButton)

        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(saveButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 450),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            intensityLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            intensityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            slider.leftAnchor.constraint(equalTo: intensityLabel.rightAnchor, constant: 10),
            slider.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            slider.widthAnchor.constraint(equalToConstant: 262),
            changeFilterButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            changeFilterButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            saveButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 10)
        ])

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")

        changeFilterButton.addTarget(self, action: #selector(changeFilter), for: .touchDown)
        slider.addTarget(self, action: #selector(applyProcessing), for: .touchDragInside)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
    }

    @objc func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(slider.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(slider.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(slider.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2,
                                            y: currentImage.size.height / 2),
                                   forKey: kCIInputCenterKey)
        }

        if let cgimg = context.createCGImage(currentFilter.outputImage!,
                                             from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }

    @objc func changeFilter() {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)

        ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone",
         "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]
            .forEach { ac.addAction(UIAlertAction(title: $0, style: .default, handler: setFilter)) }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @objc func save(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!",
                                       message: "Your altered image has been saved to your photos.",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        dismiss(animated: true)

        currentImage = image
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
}

