import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Hold and Record", destination: HoldAndRecordView())
                    .foregroundColor(.white)
                    .padding()

                NavigationLink("Truncate", destination: TruncateView())
                    .foregroundColor(.white)
                    .padding()
                
                NavigationLink("Segment", destination: SegmentView())
                    .foregroundColor(.white)
                    .padding()
                
                NavigationLink("Files", destination: FilesView())
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))) // Dark background
            .navigationTitle("OMT Recording")
        }
    }
}

struct FilesView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Old Testament")) {
                    ForEach(oldTestamentBooks, id: \.self) { book in
                        NavigationLink(destination: AudioFilesView(book: book)) {
                            HStack {
                                Text(book)
                                Spacer()
                                Image(systemName: chapterFullyCommunityChecked(book) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(chapterFullyCommunityChecked(book) ? .green : .red)
                            }
                        }
                    }
                }
                
                Section(header: Text("New Testament")) {
                    ForEach(newTestamentBooks, id: \.self) { book in
                        NavigationLink(destination: AudioFilesView(book: book)) {
                            HStack {
                                Text(book)
                                Spacer()
                                Image(systemName: chapterFullyCommunityChecked(book) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(chapterFullyCommunityChecked(book) ? .green : .red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Files")
        }
    }
    
    private func chapterFullyCommunityChecked(_ book: String) -> Bool {
        // Check if all audio files in the chapter are community checked
        let totalFiles = audioFiles(for: book).count
        let checkedFiles = checkedFiles(for: book).count
        return totalFiles == checkedFiles
    }
    
    private func audioFiles(for book: String) -> [String] {
        // Placeholder function: Replace with actual data source
        return ["Audio 1", "Audio 2", "Audio 3"] // Example files
    }
    
    private func checkedFiles(for book: String) -> Set<String> {
        // Placeholder function: Replace with actual data source
        // Simulating checked files
        return ["Audio 1", "Audio 2"] // Example checked files
    }
    
    private var oldTestamentBooks: [String] = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy" // ... other books
    ]
    
    private var newTestamentBooks: [String] = [
        "Matthew", "Mark", "Luke", "John", "Acts" // ... other books
    ]
}

struct AudioFilesView: View {
    var book: String
    
    @State private var checkedFiles: Set<String> = []
    @State private var selectedFile: String? // Track selected file for navigation
    @State private var presentingCheckView = false
    @State private var fileToCheck: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Note: Checkmark means community checked, red X means not checked.")
                    .font(.subheadline)
                    .padding()
                
                List {
                    ForEach(audioFiles(for: book), id: \.self) { file in
                        HStack {
                            Text(file)
                            Spacer()
                            
                            Button(action: {
                                toggleCheck(for: file)
                            }) {
                                Image(systemName: checkedFiles.contains(file) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(checkedFiles.contains(file) ? .green : .red)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                selectedFile = file // Set the selected file for navigation
                            }) {
                                Label("Edit", systemImage: "pencil")
                                    .foregroundColor(.yellow)
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                fileToCheck = file
                                presentingCheckView = true
                            }) {
                                Label("Check", systemImage: "person.3.fill")
                                    .foregroundColor(.green)
                            }
                            .tint(.green)
                        }
                    }
                }
                
                Text(chapterFullyCommunityChecked ? "This Chapter is Fully Community Checked!" : "This Chapter is Not Fully Community Checked")
                    .foregroundColor(chapterFullyCommunityChecked ? .green : .red)
                    .padding()
                
                Button(action: {
                    shareAllChapters()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
            }
            .navigationTitle(book)
            .onAppear {
                print("Checked files in the moment: \(checkedFiles)")
            }
            .onChange(of: checkedFiles) { _ in
                print("Checked files updated: \(checkedFiles)")
            }
            .background(
                NavigationLink(
                    destination: SegmentView(),
                    isActive: Binding<Bool>(
                        get: { selectedFile != nil },
                        set: { isActive in if !isActive { selectedFile = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
            .sheet(isPresented: $presentingCheckView) {
                CommunityCheckView(file: "Dummy File") // Always pass a dummy file
            }
        }
    }
    
    private func audioFiles(for book: String) -> [String] {
        // Replace with actual data source
        return ["Chapter 1", "Chapter 2", "Chapter 3"] // Example chapters
    }
    
    private func toggleCheck(for file: String) {
        if checkedFiles.contains(file) {
            checkedFiles.remove(file)
        } else {
            checkedFiles.insert(file)
        }
    }
    
    private var chapterFullyCommunityChecked: Bool {
        let totalFiles = audioFiles(for: book).count
        let checkedFilesCount = checkedFiles.count
        return totalFiles > 0 && checkedFilesCount == totalFiles
    }
    
    private func shareAllChapters() {
        // Placeholder for sharing functionality
        print("Sharing all chapters for \(book)")
    }
}

import SwiftUI

import SwiftUI

struct CommunityCheckView: View {
    var file: String
    
    @State private var note: String = ""
    @State private var notes: [(timestamp: String, note: String)] = []
    @State private var currentTime: String = "00:00" // Placeholder for current time
    
    var body: some View {
        VStack {
            // Displaying the file name passed to the view
            Text("Community Check for \(file)")
                .font(.headline)
                .padding()
            
            // Dummy Audio Player Section
            Text("Audio Player")
                .font(.headline)
                .padding()
            
            // Timestamp Display
            Text("Current Time: \(currentTime)")
                .padding()
            
            // Note TextField
            TextField("Add a note", text: $note)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Add Note Button
            Button(action: {
                addNote()
            }) {
                Text("Add Note")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
            // List of Notes
            List(notes, id: \.timestamp) { note in
                HStack {
                    Text(note.timestamp)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(note.note)
                        .font(.body)
                }
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .padding()
        .navigationTitle("Community Check")
    }
    
    private func addNote() {
        let newNote = (timestamp: currentTime, note: note)
        notes.append(newNote)
        note = "" // Clear the text field after adding a note
    }
}

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var onUpdate: (TimeInterval) -> Void
    
    init(onUpdate: @escaping (TimeInterval) -> Void) {
        self.onUpdate = onUpdate
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle playback finished
    }
}

struct SegmentView: View {
    @State private var isRecording = false
    @State private var statusText: String = "Status: Ready to record"
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var segments: [URL] = []
    @State private var audioURL: URL?
    @State private var nonSilentSegments: [CMTimeRange] = []
    @State private var combinedAudioURL: URL?

    @State private var silenceThreshold: Float = -10.0 // dB threshold for silence detection
    @State private var minimumSilenceDuration: TimeInterval = 1.0 // minimum silence duration (seconds)

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                        Text(statusText)
                            .foregroundColor(isRecording ? .red : .white)
                            .padding()
                        
                        Button(action: {
                            if isRecording {
                                stopRecording()
                            } else {
                                startRecording()
                            }
                        }) {
                            Text(isRecording ? "Stop Recording" : "Press to Record")
                                .frame(width: 200, height: 200)
                                .background(isRecording ? Color.red : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(100)
                        }
                        
                        // Add HStack for side-by-side buttons
                        HStack {
                            Button("Segment") {
                                Task {
                                    await segmentAndPlay()
                                }
                            }
                            .disabled(audioURL == nil)
                            .foregroundColor(.white)
                            .padding()
                            
                            Button("Play/Pause") {
                                playAllSegments()
                            }
                            .disabled(segments.isEmpty)
                            .foregroundColor(.white)
                            .padding()
                        }
                
                List {
                    ForEach(segments.indices, id: \.self) { index in
                        let segmentURL = segments[index]
                        VStack {
                            Text("Segment \(index + 1)")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center) // Center the text
                                .padding()
                        }
                        .background(Color.gray.opacity(0.3)) // Background color to make the box more visible
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners for the box
                        .onTapGesture {
                            playSegment(at: segmentURL)
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                recordOverSegment(at: index)
                            }) {
                                Label("Re-Record", systemImage: "mic")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteSegment(at: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                // Clear All, Settings, and Share buttons in a horizontal row at the bottom
                HStack {
                    Button("Clear All") {
                        clearAllSegments()
                    }
                    .disabled(segments.isEmpty)
                    .foregroundColor(.red)
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: SegmentSettingsView(silenceThreshold: $silenceThreshold, minimumSilenceDuration: $minimumSilenceDuration)) {
                        Text("Edit Settings")
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button("Share") {
                        shareSegments()
                    }
                    .disabled(segments.isEmpty)
                    .foregroundColor(.blue)
                    .padding()
                }
                .padding()
            }
            .onAppear(perform: setupAudioSession)
            .navigationTitle("Segment")
        }
    }

    private func clearAllSegments() {
        segments.removeAll()
        statusText = "All segments cleared"
    }

    private func shareSegments() {
            guard let url = combinedAudioURL else {
                statusText = "Status: No combined audio to share"
                return
            }
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true, completion: nil)
            }
        }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
            statusText = "Status: Failed to set up audio session"
        }
    }

    private func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioURL = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.record()
            isRecording = true
            statusText = "Status: Recording..."
        } catch {
            statusText = "Status: Failed to start recording"
            print("Could not start recording: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        statusText = "Status: Stopped Recording"
    }

    private func segmentAndPlay() async {
        guard let url = audioURL,
              FileManager.default.fileExists(atPath: url.path),
              let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64,
              fileSize > 0 else {
            statusText = "Status: No valid recording found"
            return
        }

        let asset = AVAsset(url: url)
        let composition = AVMutableComposition()

        do {
            let audioTracks = try await asset.loadTracks(withMediaType: .audio)
            guard let assetTrack = audioTracks.first else {
                statusText = "Status: Failed to load asset track"
                return
            }

            let trackDuration = try await asset.load(.duration)
            guard let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                statusText = "Status: Failed to add track to composition"
                return
            }

            try track.insertTimeRange(CMTimeRange(start: .zero, duration: trackDuration), of: assetTrack, at: .zero)

            // Store nonSilentSegments for use in segment and play
            nonSilentSegments = try await truncateSilence(from: track, duration: trackDuration)

            // Export each segment
            let exportGroup = DispatchGroup()
            segments.removeAll()

            for (index, timeRange) in nonSilentSegments.enumerated() {
                let segmentURL = FileManager.default.temporaryDirectory.appendingPathComponent("segment_\(index)_\(Date().timeIntervalSince1970).m4a")
                exportGroup.enter()

                exportAudio(from: composition, timeRange: timeRange, to: segmentURL) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.segments.append(segmentURL)
                        }
                    } else {
                        print("Failed to export segment at \(segmentURL)")
                    }
                    exportGroup.leave()
                }
            }

            exportGroup.notify(queue: .main) {
                self.statusText = "Status: Segmentation complete and ready to play"
            }
        } catch {
            statusText = "Status: Error during segmentation"
            print("Error during segmentation: \(error)")
        }
    }

    private func truncateSilence(from track: AVMutableCompositionTrack, duration: CMTime) async throws -> [CMTimeRange] {
        let asset = AVAsset(url: audioURL!)
        let assetDuration = try await asset.load(.duration)
        let trackDuration = CMTimeGetSeconds(assetDuration)

        var nonSilentSegments: [CMTimeRange] = []
        var currentSegmentStart = CMTime.zero
        var isSilent = false
        var silentDuration: TimeInterval = 0
        let silenceThreshold = self.silenceThreshold // dB threshold for silence detection
        let minimumSilenceDuration = self.minimumSilenceDuration // minimum silence duration (seconds)
        let sampleRate: Double = 44100.0 // Default sample rate

        let assetReader = try AVAssetReader(asset: asset)
        let outputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMBitDepthKey: 16
        ]

        guard let assetTrack = asset.tracks(withMediaType: .audio).first else {
            throw NSError(domain: "SegmentViewErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Audio track not found in asset"])
        }

        let trackOutput = AVAssetReaderTrackOutput(track: assetTrack, outputSettings: outputSettings)
        assetReader.add(trackOutput)
        assetReader.startReading()

        while let sampleBuffer = trackOutput.copyNextSampleBuffer() {
            guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
                continue
            }

            var lengthAtOffset: Int = 0
            var totalLength: Int = 0
            var dataPointer: UnsafeMutablePointer<Int8>? = nil

            let status = CMBlockBufferGetDataPointer(blockBuffer, atOffset: 0, lengthAtOffsetOut: &lengthAtOffset, totalLengthOut: &totalLength, dataPointerOut: &dataPointer)
            
            if status == noErr, let dataPointer = dataPointer {
                let numSamples = totalLength / MemoryLayout<Int16>.size
                let samples = dataPointer.withMemoryRebound(to: Int16.self, capacity: numSamples) {
                    Array(UnsafeBufferPointer(start: $0, count: numSamples))
                }

                for sample in samples {
                    let amplitude = abs(Float(sample) / Float(Int16.max)) // Normalized amplitude

                    if amplitude < pow(10, silenceThreshold / 20) {
                        silentDuration += 1.0 / sampleRate
                        if silentDuration >= minimumSilenceDuration && !isSilent {
                            let segmentEnd = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                            let timeRange = CMTimeRange(start: currentSegmentStart, end: segmentEnd)
                            nonSilentSegments.append(timeRange)

                            isSilent = true
                            currentSegmentStart = segmentEnd
                        }
                    } else {
                        silentDuration = 0
                        if isSilent {
                            currentSegmentStart = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                            isSilent = false
                        }
                    }
                }
            }

            CMSampleBufferInvalidate(sampleBuffer)
        }

        if !isSilent {
            let timeRange = CMTimeRange(start: currentSegmentStart, duration: CMTimeSubtract(duration, currentSegmentStart))
            nonSilentSegments.append(timeRange)
        }

        // Debug: Print segment ranges
        for segment in nonSilentSegments {
            print("Segment: \(segment)")
        }

        return nonSilentSegments
    }

    private func exportAudio(from composition: AVMutableComposition, timeRange: CMTimeRange, to outputURL: URL, completion: @escaping (Bool) -> Void) {
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session")
            completion(false)
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        exportSession.timeRange = timeRange

        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(true)
            } else {
                print("Export failed with status: \(exportSession.status)")
                completion(false)
            }
        }
    }
    private func pauseCurrentAudioIfPlaying() {
            if let player = audioPlayer, player.isPlaying {
                player.pause()
                statusText = "Status: Paused current audio"
            }
        }
    
    private func playSegment(at url: URL) {
        pauseCurrentAudioIfPlaying()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            statusText = "Status: Playing segment..."
        } catch {
            print("Failed to play segment: \(error)")
            statusText = "Status: Failed to play segment"
        }
    }

    private func playAllSegments() {
        if audioPlayer?.isPlaying == true {
            // If audio is currently playing, pause it and return early
            audioPlayer?.pause()
            statusText = "Status: Audio paused."
            return
        }
        
        // Proceed with combining and playing segments
        let exportGroup = DispatchGroup()
        let combinedURL = FileManager.default.temporaryDirectory.appendingPathComponent("combined_\(Date().timeIntervalSince1970).m4a")

        let composition = AVMutableComposition()
        let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

        var insertTime = CMTime.zero

        for url in segments {
            let asset = AVAsset(url: url)
            guard let assetTrack = asset.tracks(withMediaType: .audio).first else { continue }
            let duration = asset.duration

            do {
                try track?.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: assetTrack, at: insertTime)
                insertTime = CMTimeAdd(insertTime, duration)
            } catch {
                print("Failed to insert time range: \(error)")
            }
        }

        exportGroup.enter()
        exportAudio(from: composition, timeRange: CMTimeRange(start: .zero, duration: insertTime), to: combinedURL) { success in
            if success {
                DispatchQueue.main.async {
                    self.combinedAudioURL = combinedURL // Store the URL
                    self.playCombinedAudio(at: combinedURL)
                }
            } else {
                print("Failed to export combined audio")
                DispatchQueue.main.async {
                    self.statusText = "Status: Failed to export combined audio"
                }
            }
            exportGroup.leave()
        }
    }

    private func playCombinedAudio(at url: URL) {
        pauseCurrentAudioIfPlaying()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            statusText = "Status: Playing all segments..."
        } catch {
            print("Failed to play combined audio: \(error)")
            statusText = "Status: Failed to play all segments"
        }
    }

    private func recordOverSegment(at index: Int) {
        pauseCurrentAudioIfPlaying()
        guard index < segments.count else {
            print("Index out of range")
            return
        }

        let segmentURL = segments[index]
        let segmentFileName = segmentURL.deletingPathExtension().lastPathComponent
        let newSegmentURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(segmentFileName)_overwrite.m4a")

        // Setup the audio recorder with the new URL
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: newSegmentURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            statusText = "Status: Overwriting segment..."

            // Stop recording after a fixed time for the sake of this example
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.stopRecording()
                self.replaceSegment(at: index, with: newSegmentURL)
            }
        } catch {
            statusText = "Status: Failed to start recording"
            print("Could not start recording: \(error)")
        }
    }

    private func replaceSegment(at index: Int, with newURL: URL) {
        pauseCurrentAudioIfPlaying()
        guard index < segments.count else {
            print("Index out of range")
            return
        }

        do {
            // Remove old segment file
            try FileManager.default.removeItem(at: segments[index])
            // Replace with new segment
            segments[index] = newURL
            statusText = "Status: Segment overwritten"
        } catch {
            print("Error replacing segment: \(error)")
            statusText = "Status: Error replacing segment"
        }
    }

    private func deleteSegment(at index: Int) {
        pauseCurrentAudioIfPlaying()
        guard index < segments.count else {
            print("Index out of range")
            return
        }

        do {
            try FileManager.default.removeItem(at: segments[index])
            segments.remove(at: index)
            statusText = "Status: Segment deleted"
        } catch {
            print("Failed to delete segment: \(error)")
            statusText = "Status: Failed to delete segment"
        }
    }
}

struct SegmentSettingsView: View {
    @Binding var silenceThreshold: Float
    @Binding var minimumSilenceDuration: TimeInterval

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Silence Threshold (dB)")) {
                    Slider(value: $silenceThreshold, in: -100...0, step: 1) {
                        Text("Silence Threshold")
                    }
                    Text("\(silenceThreshold, specifier: "%.1f") dB")
                }

                Section(header: Text("Minimum Silence Duration (seconds)")) {
                    Slider(value: $minimumSilenceDuration, in: 0...5, step: 0.1) {
                        Text("Minimum Silence Duration")
                    }
                    Text("\(minimumSilenceDuration, specifier: "%.1f") seconds")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView()
    }
}

struct HoldAndRecordView: View {
    @State private var isRecording = false
    @State private var recordings: [URL] = []
    @State private var statusText: String = "Status: Ready to Record"
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var finalAudioURL: URL?

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(statusText)
                    .foregroundColor(isRecording ? .red : .white)
                    .padding()

                Button(action: {}) {
                    Text(isRecording ? "Recording..." : "Hold to Record")
                        .frame(width: 200, height: 200)
                        .background(isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isRecording {
                                startRecording()
                            }
                        }
                        .onEnded { _ in
                            if isRecording {
                                stopRecording()
                            }
                        }
                )

                Text("Recordings: \(recordings.count)")
                    .foregroundColor(.white)
                    .padding()

                Button("Stitch Audio") {
                    Task {
                        await stitchAudio()
                    }
                }
                .disabled(recordings.count < 2)
                .foregroundColor(.white)
                .padding()

                Button("Play Stitched Audio", action: playAudio)
                    .disabled(finalAudioURL == nil)
                    .foregroundColor(.white)
                    .padding()

                Button("Clear Recordings", action: clearRecordings)
                    .disabled(recordings.isEmpty)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .onAppear(perform: setupAudioSession)
        .navigationTitle("Hold and Record")
    }

    private func setupAudioSession() {
        Task {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try audioSession.setActive(true)
            } catch {
                print("Failed to set up audio session: \(error)")
                statusText = "Status: Failed to set up audio session"
            }
        }
    }

    private func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
            statusText = "Status: Recording..."
        } catch {
            statusText = "Status: Failed to start recording"
            print("Could not start recording: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        statusText = "Status: Stopped Recording"
        
        if let url = audioRecorder?.url {
            recordings.append(url)
        }
    }

    private func stitchAudio() async {
        guard recordings.count >= 2 else {
            statusText = "Status: Need at least 2 recordings to stitch"
            return
        }

        let composition = AVMutableComposition()
        var insertTime = CMTime.zero

        do {
            for url in recordings {
                let asset = AVAsset(url: url)
                let audioTracks = try await asset.loadTracks(withMediaType: .audio)
                guard let assetTrack = audioTracks.first else {
                    statusText = "Status: Failed to load asset track"
                    return
                }
                let duration = try await asset.load(.duration)

                let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                try track?.insertTimeRange(CMTimeRange(start: .zero, duration: duration),
                                           of: assetTrack,
                                           at: insertTime)
                insertTime = CMTimeAdd(insertTime, duration)
            }

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let stitchedAudioURL = documentsPath.appendingPathComponent("stitched_audio_\(Date().timeIntervalSince1970).m4a")

            guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
                statusText = "Status: Failed to create export session"
                return
            }

            exportSession.outputURL = stitchedAudioURL
            exportSession.outputFileType = .m4a

            await exportSession.export()

            switch exportSession.status {
            case .completed:
                self.finalAudioURL = stitchedAudioURL
                self.statusText = "Status: Audio stitched successfully"
                print("Stitched audio successfully: \(stitchedAudioURL)")
            case .failed:
                self.statusText = "Status: Failed to stitch audio"
                print("Export failed: \(String(describing: exportSession.error?.localizedDescription))")
            case .cancelled:
                self.statusText = "Status: Stitching cancelled"
                print("Export cancelled")
            default:
                self.statusText = "Status: Unknown error during stitching"
                print("Export failed with unknown error")
            }
        } catch {
            statusText = "Status: Error during stitching"
            print("Error during stitching: \(error)")
        }
    }

    private func playAudio() {
        guard let url = finalAudioURL else {
            statusText = "Status: No stitched audio to play"
            print("No stitched audio URL found")
            return
        }

        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: url.path) {
                statusText = "Status: File does not exist at path"
                print("File does not exist at path: \(url.path)")
                return
            }

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            statusText = "Status: Playing stitched audio"
            print("Playing stitched audio: \(url)")
        } catch let error as NSError {
            statusText = "Status: Failed to play audio"
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    private func clearRecordings() {
        recordings.removeAll()
        finalAudioURL = nil
        statusText = "Status: Recordings cleared"
        
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error while deleting audio files: \(error)")
        }
    }
}

import AVFoundation
import SwiftUI

struct TruncateView: View {
    @State private var isRecording = false
    @State private var statusText: String = "Status: Ready to record"
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var silenceThreshold: Float = -50.0 // dB threshold for silence detection
    @State private var minimumSilenceDuration: TimeInterval = 1.0 // minimum silence duration (seconds)
    @State private var truncateToLength: TimeInterval = 5.0 // final length after truncation
    @State private var processedAudioURL: URL?
    
    @State private var showSettings = false // To show the settings view

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(statusText)
                    .foregroundColor(isRecording ? .red : .white)
                    .padding()

                Button(action: {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                }) {
                    Text(isRecording ? "Stop Recording" : "Press to Record")
                        .frame(width: 200, height: 200)
                        .background(isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }

                Button("Truncate and Play") {
                    Task {
                        await truncateAndPlay()
                    }
                }
                .disabled(processedAudioURL == nil)
                .foregroundColor(.white)
                .padding()

                Button("Settings") {
                    showSettings = true
                }
                .foregroundColor(.white)
                .padding()

                .sheet(isPresented: $showSettings) {
                    TruncateSettingsView(silenceThreshold: $silenceThreshold, minimumSilenceDuration: $minimumSilenceDuration)
                }
            }
        }
        .onAppear(perform: setupAudioSession)
        .navigationTitle("Truncate")
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
            statusText = "Status: Failed to set up audio session"
        }
    }

    private func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
            statusText = "Status: Recording..."
        } catch {
            statusText = "Status: Failed to start recording"
            print("Could not start recording: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        statusText = "Status: Stopped Recording"
        processAudioFile()
    }

    private func processAudioFile() {
        guard let url = audioRecorder?.url else {
            statusText = "Status: No recording found"
            return
        }

        let asset = AVAsset(url: url)
        let composition = AVMutableComposition()

        guard let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            statusText = "Status: Failed to create composition track"
            return
        }

        guard let assetTrack = asset.tracks(withMediaType: .audio).first else {
            statusText = "Status: No audio track found in recording"
            return
        }

        do {
            // Insert the full audio track
            try compositionTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetTrack, at: .zero)

            // Perform silence detection and truncation
            let truncatedComposition = try truncateSilence(from: compositionTrack, silenceThreshold: silenceThreshold, minimumSilenceDuration: minimumSilenceDuration)
            
            // Export the processed file
            exportProcessedAudio(from: truncatedComposition)
        } catch {
            statusText = "Status: Failed to process audio"
            print("Error: \(error)")
        }
    }

    private func truncateSilence(from track: AVMutableCompositionTrack, silenceThreshold: Float, minimumSilenceDuration: TimeInterval) throws -> AVMutableComposition {
        let composition = AVMutableComposition()

        // Get the original audio track
        let asset = track.asset!
        let trackDuration = CMTimeGetSeconds(track.timeRange.duration)
        
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            throw NSError(domain: "AudioError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No audio track found in asset"])
        }
        
        // Set up an AVAssetReader to read audio samples
        let assetReader = try AVAssetReader(asset: asset)
        
        let outputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMBitDepthKey: 16
        ]
        
        let trackOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: outputSettings)
        assetReader.add(trackOutput)
        assetReader.startReading()
        
        // Set up variables for detecting silence
        var currentSegmentStart = CMTime.zero
        var nonSilentSegments: [CMTimeRange] = []
        var silentDuration: TimeInterval = 0
        var isSilent = false
        var sampleRate = 44100.0 // Default sample rate
        
        if let formatDescription = audioTrack.formatDescriptions.first {
            let audioDescription = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription as! CMFormatDescription)?.pointee
        }
        
        // Read through the samples and analyze their amplitude
        while let sampleBuffer = trackOutput.copyNextSampleBuffer() {
            guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
                continue
            }
            
            // Get the sample data
            var length = 0
            var dataPointer: UnsafeMutablePointer<Int8>?
            CMBlockBufferGetDataPointer(blockBuffer, atOffset: 0, lengthAtOffsetOut: nil, totalLengthOut: &length, dataPointerOut: &dataPointer)
            
            if let dataPointer = dataPointer {
                let numSamples = length / MemoryLayout<Int16>.size
                
                // Bind the memory of the data pointer to Int16
                let samples = dataPointer.withMemoryRebound(to: Int16.self, capacity: numSamples) { bufferPointer in
                    UnsafeBufferPointer(start: bufferPointer, count: numSamples)
                }
                
                // Analyze each sample for amplitude
                for sample in samples {
                    let amplitude = abs(Float(sample) / Float(Int16.max)) // Normalized amplitude
                    
                    if amplitude < pow(10, silenceThreshold / 20) {
                        silentDuration += 1.0 / sampleRate
                        if silentDuration >= minimumSilenceDuration && !isSilent {
                            // Mark the previous segment as non-silent
                            let segmentEnd = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                            let timeRange = CMTimeRange(start: currentSegmentStart, end: segmentEnd)
                            nonSilentSegments.append(timeRange)
                            
                            isSilent = true
                            currentSegmentStart = segmentEnd
                        }
                    } else {
                        silentDuration = 0
                        if isSilent {
                            // Start a new non-silent segment
                            currentSegmentStart = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                            isSilent = false
                        }
                    }
                }
            }
            
            CMSampleBufferInvalidate(sampleBuffer)
        }
        
        // Handle the last non-silent segment
        if !isSilent {
            let timeRange = CMTimeRange(start: currentSegmentStart, duration: CMTime(seconds: trackDuration - CMTimeGetSeconds(currentSegmentStart), preferredTimescale: 600))
            nonSilentSegments.append(timeRange)
        }
        
        // Build a new composition with only the non-silent parts
        let newTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        for segment in nonSilentSegments {
            try newTrack?.insertTimeRange(segment, of: track, at: newTrack?.timeRange.end ?? .zero)
        }
        
        return composition
    }

    private func exportProcessedAudio(from composition: AVMutableComposition) {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("processed_\(Date().timeIntervalSince1970).m4a")

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            statusText = "Status: Failed to create export session"
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a

        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                case .completed:
                    self.processedAudioURL = outputURL
                    self.statusText = "Status: Audio processed and ready"
                case .failed:
                    self.statusText = "Status: Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")"
                case .cancelled:
                    self.statusText = "Status: Export cancelled"
                default:
                    self.statusText = "Status: Export ended with status: \(exportSession.status.rawValue)"
                }
            }
        }
    }

    private func truncateAndPlay() async {
        guard let url = processedAudioURL else {
            statusText = "Status: No processed audio to play"
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            statusText = "Status: Playing processed audio"
        } catch {
            statusText = "Status: Failed to play audio: \(error.localizedDescription)"
            print("Failed to play audio: \(error)")
        }
    }
}

struct TruncateSettingsView: View {
    @Binding var silenceThreshold: Float
    @Binding var minimumSilenceDuration: TimeInterval

    var body: some View {
        VStack {
            Text("Truncate Silence Settings")
                .font(.headline)
                .padding()

            HStack {
                Text("Silence Threshold (dB)")
                Slider(value: $silenceThreshold, in: -60...0, step: 5)
                    .padding()
                Text("\(silenceThreshold, specifier: "%.0f") dB")
                    .frame(width: 50)
            }

            HStack {
                Text("Minimum Silence Duration")
                Slider(value: $minimumSilenceDuration, in: 0.5...5.0, step: 0.5)
                    .padding()
                Text("\(minimumSilenceDuration, specifier: "%.1f") sec")
                    .frame(width: 50)
            }

            Spacer()

            Button("Done") {
                // Dismiss the settings view
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            .foregroundColor(.blue)
            .padding()
        }
        .padding()
    }
}
