import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

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

  // void playAudio(String audioFileName) async {
  //   try {
  //     String downloadUrl = await FirebaseStorage.instance
  //         .ref()
  //         .child('Audios/$audioFileName')
  //         .getDownloadURL();

  //     // Use audioPlayer to play audio from URL
  //     int result = await audioPlayer.play(downloadUrl);

  //     if (result == 1) {
  //       print('Audio played');
  //     } else {
  //       print('Error playing audio');
  //     }
  //   } catch (e) {
  //     print('Error playing audio');
  //   }
  // }

  // Future<void> playAudio(String audioFileName) async {
  //   audioPlayer.stop();
  //   String audioFilePath = await loadAudioToLocalCache(audioFileName);
  //   int result = await audioPlayer.play(audioFilePath, isLocal: true);

  //   if (result == 1) {
  //     print('Audio playing');
  //   } else {
  //     print('Error playing audio');
  //   }
  // }

  // Future<String> loadAudioToLocalCache(String audioFileName) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   File audioFile = File('$tempPath/$audioFileName');

  //   if (!audioFile.existsSync()) {
  //     String url = await audioCache.load(audioFileName);
  //     final response = await HttpClient().getUrl(Uri.parse(url));
  //     final bytes = await response.close();
  //     await audioFile.writeAsBytes(await bytes.toList());
  //   }
  //   return audioFile.path;
  // }

  // Future<void> playAudio(String audioFileName) async {
  //   try {
  //     Reference audioRef =
  //         FirebaseStorage.instance.ref().child('Audios/$audioFileName');

  //     // Download the audio file to temp directory
  //     Directory tempDir = await getTemporaryDirectory();
  //     File tempFile = File('${tempDir.path}/$audioFileName');
  //     if (!tempFile.existsSync()) {
  //       await audioRef.writeToFile(tempFile);
  //     }

  //     // Play audio file with AudioCache
  //     await audioCache.play(tempFile.path);
  //   } catch (e) {
  //     print('Error playing audio: $e');
  //   }
  // }

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
      ),
      body: audioFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                final audioFileName = audioFiles[index];
                return ListTile(
                  title: Text(audioFileName),
                  // onTap: () => playAudio(audioFileName),
                );
              },
            ),
    );
  }
}
