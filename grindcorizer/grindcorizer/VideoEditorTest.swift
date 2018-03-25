//
//  VideoEditorTest.swift
//  grindcorizer
//
//  Created by Linus Akerlund on 2018-03-23.
//  Copyright © 2018 Puterman. All rights reserved.
//

import AVFoundation

class VideoEditorTest {
    let videoPath: String
    let audioPath: String

    init(withVideoPath videoPath: String, audioPath: String) {
        self.videoPath = videoPath
        self.audioPath = audioPath
    }

    func player() -> AVPlayer? {
        let composition = AVMutableComposition()
        let _videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: 1)
        let _audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: 1337)

        guard let videoTrack = _videoTrack, let audioTrack = _audioTrack else {
            print("track is nil")
            return nil
        }

        let videoAsset = AVAsset(url: URL(fileURLWithPath: videoPath))
        let audioAsset = AVAsset(url: URL(fileURLWithPath: audioPath))

        let _videoAssetTrack = videoAsset.tracks(withMediaType: .video).first
        let _audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first

        guard let videoAssetTrack = _videoAssetTrack, let audioAssetTrack = _audioAssetTrack else {
            print("track is nil")
            return nil
        }

        let duration = min(videoAssetTrack.timeRange.duration, audioAssetTrack.timeRange.duration)

        let seconds = duration.seconds
        let halfDuration = CMTime(seconds: seconds/2.0, preferredTimescale: 30)

        do {
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, halfDuration), of: videoAssetTrack, at: kCMTimeZero)
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, halfDuration), of: videoAssetTrack, at: halfDuration)
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, duration), of: audioAssetTrack, at: kCMTimeZero)
        } catch(let e) {
            print("exception: \(e)")
            return nil
        }
        
/*
        let firstVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        firstVideoCompositionInstruction.timeRange = videoAssetTrack.timeRange
        let firstVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoAssetTrack)
        firstVideoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: kCMTimeZero)
        firstVideoCompositionInstruction.layerInstructions = [ firstVideoLayerInstruction ]
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [ firstVideoCompositionInstruction ]
        videoComposition.renderSize = videoAssetTrack.naturalSize
        videoComposition.frameDuration = CMTimeMake(1, 30);
*/

        /*
        let _exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        guard let exportSession = _exportSession else {
            print("error creating export session")
            return
        }

        var _outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        _outputURL?.appendPathComponent("videotest")
        _outputURL?.appendPathExtension(".mov")

        guard let outputURL = _outputURL else {
            print("failed to create output URL")
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = composition
*/

        let playerItem = AVPlayerItem(asset: composition)
        let player = AVPlayer(playerItem: playerItem)

        return player
    }
}
