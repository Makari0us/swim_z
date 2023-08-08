import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late List<String> audioFiles;
  late AudioPlayer audioPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache();
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

      List<String> files = [];
      for (var item in result.items) {
        files.add(item.name);
      }

      setState(() {
        audioFiles = files;
      });
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  // ... Other methods (playAudio and loadAudioToLocalCache) can remain unchanged ...

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio'),
        backgroundColor: Colors.blueGrey, // Change the app bar color
      ),
      body: audioFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                final audioFileName = audioFiles[index];
                return ListTile(
                  title: Text(
                    audioFileName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  tileColor: index % 2 == 0
                      ? Colors.grey.shade200
                      : Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  // Add onTap to play audio here if you decide to uncomment playAudio method
                  // onTap: () => playAudio(audioFileName),
                );
              },
            ),
    );
  }
}
