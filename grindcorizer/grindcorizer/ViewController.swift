//
//  Copyright © 2018 Puterman. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var slider: UISlider!
    @IBOutlet var playButton: UIButton!

    var videoPath: String?
    var audioPath: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isHidden = true
        slider.isHidden = true
        slider.value = 0
    }

    var editor: VideoEditorTest?

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }
    
    @IBAction func playButtonTapped() {
        guard let videoPath = self.videoPath,
            let audioPath = self.audioPath else {
                return
        }

        editor = VideoEditorTest(withVideoPath: videoPath, audioPath: audioPath, value: slider.value)
        let player = editor?.player()
        if player != nil {
            presentPlayer(player!)
        }
    }
    
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

    func presentPlayer(_ player: AVPlayer) {
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = player

        present(avPlayerController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let path = info["UIImagePickerControllerMediaURL"] as? URL else {
            return
        }
        guard let audioPath = Bundle.main.path(forResource: "Your_Marginally_Talented_Photographer_Girlfriend_-_06_-_Picking_Up_a_Bingo_Chip", ofType: "mp3") else {
            return
        }

        dismiss(animated: true, completion: nil)

        print("Finished picking media with file: \(path)")

        playButton.isHidden = false
        slider.isHidden = false

        self.videoPath = path.absoluteString
        self.audioPath = audioPath
    }
}
