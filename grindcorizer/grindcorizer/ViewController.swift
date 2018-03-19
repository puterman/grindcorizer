//
//  Copyright © 2018 Puterman. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBAction func recordVideoTapped() {
        launchVideoRecorder()
    }


    private func launchVideoRecorder() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            print("Camera not available...")
        }

        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as String]
        cameraController.allowsEditing = false
        cameraController.delegate = self

        present(cameraController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

    }
}
