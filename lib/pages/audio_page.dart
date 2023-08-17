import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
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

      List<String> files = result.items.map((item) => item.name).toList();

      setState(() {
        audioFiles = files;
      });
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Audio Player',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: audioFiles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFileName = audioFiles[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        audioFileName,
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () => playAudio(audioFileName),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> playAudio(String audioFileName) async {
    // Implement your audio playing logic here
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Audio Player',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: AudioPage(),
  ));
}
