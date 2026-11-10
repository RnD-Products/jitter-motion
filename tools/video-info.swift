// Prints duration, size and frame rate of a video.
// Build: swiftc -O video-info.swift -o video-info
// Run:   ./video-info /path/to/video.mp4
import AVFoundation
let a = AVURLAsset(url: URL(fileURLWithPath: CommandLine.arguments[1]))
let sem = DispatchSemaphore(value: 0)
Task {
  let d = try await a.load(.duration)
  let t = try await a.loadTracks(withMediaType: .video).first!
  let s = try await t.load(.naturalSize); let f = try await t.load(.nominalFrameRate)
  print("dur", d.seconds, "size", s, "fps", f); sem.signal()
}
sem.wait()
