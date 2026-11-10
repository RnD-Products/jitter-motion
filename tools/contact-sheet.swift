// Makes a labelled contact sheet (5 columns) of video frames.
// Build: swiftc -O contact-sheet.swift -o contact-sheet
// Run:   ./contact-sheet <video> <out.png> <step seconds> <end seconds> [start seconds]
// Example: ./contact-sheet Scene.mp4 sheet.png 0.05 2.2 1.4
import AVFoundation
import AppKit
let args = CommandLine.arguments
let a = AVURLAsset(url: URL(fileURLWithPath: args[1]))
let out = args[2]; let step = Double(args[3])!; let end = Double(args[4])!; let start = args.count > 5 ? Double(args[5])! : 0
let g = AVAssetImageGenerator(asset: a); g.appliesPreferredTrackTransform = true
g.requestedTimeToleranceBefore = .zero; g.requestedTimeToleranceAfter = .zero
g.maximumSize = CGSize(width: 480, height: 480)
var imgs: [(Double, CGImage)] = []
var t = start
while t <= end + 0.0001 { if let i = try? g.copyCGImage(at: CMTime(seconds: t, preferredTimescale: 600), actualTime: nil) { imgs.append((t, i)) }; t += step }
let cols = 5; let w = imgs[0].1.width; let h = imgs[0].1.height
let rows = (imgs.count + cols - 1) / cols
let W = cols * w, H = rows * (h + 24)
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.setFillColor(CGColor(red: 1, green: 0, blue: 1, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: W, height: H))
let gc = NSGraphicsContext(cgContext: ctx, flipped: false); NSGraphicsContext.current = gc
for (k, (tt, im)) in imgs.enumerated() {
  let c = k % cols, r = k / cols
  let y = H - (r + 1) * (h + 24)
  ctx.draw(im, in: CGRect(x: c * w, y: y, width: w, height: h))
  NSString(string: String(format: "%.2fs", tt)).draw(at: NSPoint(x: c * w + 4, y: y + h + 4), withAttributes: [.font: NSFont.boldSystemFont(ofSize: 16), .foregroundColor: NSColor.white])
}
let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print(imgs.count)
