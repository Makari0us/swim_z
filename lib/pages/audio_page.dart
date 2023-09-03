import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late List<Reference> audioFiles;
  late AudioPlayer _audioPlayer;
  int? currentlyPlayingIndex; // Index of currently playing audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    audioFiles = [];
    initializeFirebaseApp();
    fetchAudioFiles();
  }

  Future<void> initializeFirebaseApp() async {
    await Firebase.initializeApp();
  }

  Future<void> fetchAudioFiles() async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('Audios');
      ListResult result = await storageRef.listAll();

      setState(() {
        audioFiles = result.items;
      });
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  Future<void> playAudio(int index, String audioFileName) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('Audios');
      Reference audioRef = storageRef.child(audioFileName);

      if (currentlyPlayingIndex != null && currentlyPlayingIndex == index) {
        // If the same audio is already playing, pause it
        await _audioPlayer.pause();
        setState(() {
          currentlyPlayingIndex = null; // Reset currentlyPlayingIndex
        });
      } else {
        // If a different audio is playing or nothing is playing, play the selected audio
        await _audioPlayer.setUrl(await audioRef.getDownloadURL());
        await _audioPlayer.play();
        setState(() {
          currentlyPlayingIndex = index;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Audios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade50],
          ),
        ),
        child: audioFiles.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFile = audioFiles[index];
                  final isPlaying = currentlyPlayingIndex == index;
                  final cardColor = isPlaying ? Colors.blue[800] : Colors.blue;
                  return Card(
                    color: cardColor,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        audioFile.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => playAudio(index, audioFile.name),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
