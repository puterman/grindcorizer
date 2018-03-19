//
//  Copyright © 2018 Puterman. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBAction func recordVideoTapped() {
        launchImagePicker(camera: true)
    }

    @IBAction func importVideoTapped() {
        launchImagePicker(camera: false)
    }

    private func launchImagePicker(camera: Bool) {
        let sourceType: UIImagePickerControllerSourceType = camera ? .camera : .photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(sourceType) == false {
            print("ImagePicker source type not available: \(sourceType)")
        }


        // FIXME: available media types etc.

        let cameraController = UIImagePickerController()
        cameraController.sourceType = sourceType
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = self

        present(cameraController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let path = info["UIImagePickerControllerMediaURL"]
        print("Finished picking media with file: \(path)")

        dismiss(animated: true, completion: nil)
    }
}
