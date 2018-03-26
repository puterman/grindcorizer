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
    let value: Float

    init(withVideoPath videoPath: String, audioPath: String, value: Float) {
        self.videoPath = videoPath
        self.audioPath = audioPath
        self.value = value
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

        let totalDuration = min(videoAssetTrack.timeRange.duration, audioAssetTrack.timeRange.duration)
        var spentTime = CMTimeMake(0, totalDuration.timescale)

        let minimumSlice = totalDuration.timescale / 10
        let maximumSlice = totalDuration.timescale * 5

        while spentTime.value < totalDuration.value {
            var duration = totalDuration
            if value > 0.01 {
                let invertedValue = 1.0 - value
                let randVal = Float(drand48() + 0.5)
                let val = max(invertedValue * randVal * Float(maximumSlice - minimumSlice), Float(minimumSlice))
                duration = CMTimeMake(Int64(val), totalDuration.timescale)
            }

            do {
                let maxStartTime = UInt32(totalDuration.value - duration.value)
                let offset = Int64(arc4random_uniform(maxStartTime))
                try videoTrack.insertTimeRange(CMTimeRangeMake(CMTimeMake(offset, totalDuration.timescale), duration), of: videoAssetTrack, at: spentTime)
            } catch(let e) {
                print("Exception: \(e)")
                return nil
            }

            spentTime.value += duration.value
        }

        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, totalDuration), of: audioAssetTrack, at: kCMTimeZero)
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
