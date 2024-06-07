import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smarthomeui/pages/settings_page.dart';
import 'dart:io';

=======
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeui/util/open_ai_model.dart';
import 'package:smarthomeui/pages/settings_page.dart';
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322

class ChatGPTPage extends StatefulWidget {
  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

<<<<<<< HEAD

class _ChatGPTPageState extends State<ChatGPTPage> with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _message = '';
  List<Messages> _historyList = [];
  TextEditingController messageTextController = TextEditingController();
  final String _googleCloudKey = 'YOUR_GOOGLE_CLOUD_KEY';
  final String _firebaseKey = 'YOUR_FIREBASE_KEY';
  final String _dialogflowSessionId = 'YOUR_DIALOGFLOW_SESSION_ID';
  final String _dialogflowProjectId = 'YOUR_DIALOGFLOW_PROJECT_ID';
  final String _serviceAccountPath = 'path/to/your/service-account-file.json';

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  Future<void> _uploadVoiceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      try {
        await FirebaseStorage.instance
            .ref('voice_files/$fileName')
            .putFile(file);

        String fileUrl = await FirebaseStorage.instance
            .ref('voice_files/$fileName')
            .getDownloadURL();

        _processVoiceFile(fileUrl);
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  Future<void> _processVoiceFile(String fileUrl) async {
    var response = await http.post(
      Uri.parse('https://your-cloud-function-url/trainTTSModel'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_googleCloudKey'
      },
      body: jsonEncode({'audioUrl': fileUrl}),
    );

    if (response.statusCode == 200) {
      print('Voice file processed successfully');
    } else {
      print('Failed to process voice file');
    }
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) => setState(() {
          _message = val.recognizedWords;
          _historyList.add(Messages(role: "user", content: _message));
        }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
    setState(() {
      _historyList.add(Messages(role: "assistant", content: text));
    });
  }

  Future<void> _synthesizeText(String text) async {
    var response = await http.post(
      Uri.parse('https://your-cloud-function-url/synthesizeText'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_googleCloudKey'
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      var audioContent = jsonDecode(response.body)['audioContent'];
      await _playAudioContent(audioContent);
      print('Text synthesized successfully');
    } else {
      print('Failed to synthesize text');
    }
  }

  Future<void> _playAudioContent(String audioContent) async {
    // 오디오 재생 로직을 추가합니다. 예를 들어, 오디오 파일을 생성하고 재생합니다.
    // 여기서는 예제를 위해 단순히 로그를 출력합니다.
    print('Playing audio content: $audioContent');
  }

  static const String _kStrings = "청안 대화공간";
=======
class _ChatGPTPageState extends State<ChatGPTPage> with TickerProviderStateMixin {
  TextEditingController messageTextController = TextEditingController();
  final List<Messages> _historyList = List.empty(growable: true);



  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        apiKey = prefs.getString('apiKey');
      });
    }
  }

  String? apiKey;
  String streamText = "";
  final http.Client _httpClient = http.Client();

  static const String _kStrings = "청안 AI챗봇";
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  String get _currentString => _kStrings;

  ScrollController scrollController = ScrollController();
  late Animation<int> _characterCount;
  late AnimationController animationController;

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  setupAnimations() {
    animationController = AnimationController(
<<<<<<< HEAD
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
=======
        vsync: this, duration: const Duration(milliseconds: 2500));
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
    _characterCount = StepTween(begin: 0, end: _currentString.length).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (mounted && animationController.status == AnimationStatus.completed) {
            animationController.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (mounted && animationController.status == AnimationStatus.dismissed) {
            animationController.forward();
          }
        });
      }
    });

    animationController.forward();
  }

<<<<<<< HEAD
=======
  Stream<String> requestChatStream(String text) async* {
    if (apiKey == null || apiKey!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('API Key is missing. Please set it in settings.')),
        );
      }
      return;
    }

    ChatCompletionModel openAiModel = ChatCompletionModel(
      model: "gpt-3.5-turbo",
      messages: [
        Messages(
          role: "system",
          content: "You are a helpful assistant.",
        ),
        ..._historyList,
        Messages(
          role: "user",
          content: text,
        ),
      ],
      stream: true,
    );

    final url = Uri.https("api.openai.com", "/v1/chat/completions");
    final request = http.Request("POST", url)
      ..headers.addAll({
        "Authorization": "Bearer $apiKey",
        "Content-Type": 'application/json; charset=UTF-8',
        "Connection": "keep-alive",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      });
    request.body = jsonEncode(openAiModel.toJson());

    final resp = await _httpClient.send(request);

    if (resp.statusCode == 200) {
      final byteStream = resp.stream.asyncExpand(
            (event) => Rx.timer(event, const Duration(milliseconds: 50)),
      );

      var respText = "";

      await for (final byte in byteStream) {
        try {
          var decoded = utf8.decode(byte, allowMalformed: false);
          if (decoded.contains('"content":')) {
            final strings = decoded.split("data: ");
            for (final string in strings) {
              final trimmedString = string.trim();
              if (trimmedString.isNotEmpty && !trimmedString.endsWith("[DONE]")) {
                final map = jsonDecode(trimmedString) as Map;
                final choices = map["choices"] as List;
                final delta = choices[0]["delta"] as Map;
                if (delta["content"] != null) {
                  final content = delta["content"] as String;
                  respText += content;
                  if (mounted) {
                    setState(() {
                      streamText = respText;
                    });
                  }
                  yield content;
                }
              }
            }
          }
        } catch (e) {
          print(e.toString());
        }
      }

      if (respText.isNotEmpty) {
        if (mounted) {
          setState(() {});
          _scrollDown();
        }
      }
    } else {
      print('Failed to get response: ${resp.statusCode}');
      print(await resp.stream.bytesToString());
    }
  }

  @override
  void initState() {
    super.initState();
    setupAnimations();
    _loadApiKey();
  }

>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  @override
  void dispose() {
    messageTextController.dispose();
    scrollController.dispose();
<<<<<<< HEAD
=======
    animationController.dispose();  // 애니메이션 컨트롤러 해제
    _httpClient.close(); // HTTP 클라이언트를 닫아 모든 진행 중인 요청을 취소
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
    super.dispose();
  }

  Future clearChat() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("새로운 대화의 시작"),
        content: const Text("신규 대화를 생성하시겠어요?"),
        actions: [
          TextButton(
<<<<<<< HEAD
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) {
                setState(() {
                  messageTextController.clear();
                  _historyList.clear();
                });
              }
            },
            child: const Text("네"),
          ),
=======
              onPressed: () {
                Navigator.of(context).pop();
                if (mounted) {
                  setState(() {
                    messageTextController.clear();
                    _historyList.clear();
                  });
                }
              },
              child: const Text("네"))
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
        ],
      ),
    );
  }

<<<<<<< HEAD
  Stream<String> requestChatStream(String text) async* {
    final serviceAccount = jsonDecode(await File(_serviceAccountPath).readAsString());
    final projectId = _dialogflowProjectId;
    final sessionId = _dialogflowSessionId;
    final languageCode = 'ko'; // 한국어 설정

    final response = await http.post(
      Uri.parse('https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/$sessionId:detectIntent'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${serviceAccount['access_token']}',
      },
      body: jsonEncode({
        'queryInput': {
          'text': {
            'text': text,
            'languageCode': languageCode,
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['queryResult']['fulfillmentText'];
      yield result;
    } else {
      throw Exception('Failed to load response');
    }
  }

=======
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Center(child: Text('청안 대화공간')),
=======
        title: Center(child: Text('청안 AI챗봇')),
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 돌아가기
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.all(16),
=======
          padding: const EdgeInsets.all(16.0),
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Card(
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text("히스토리"),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage()),
                            );
                          },
                          child: const ListTile(
                            title: Text("설정"),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            clearChat();
                          },
                          child: const ListTile(
                            title: Text("새로운 채팅"),
                          ),
                        )
                      ];
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _historyList.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _characterCount,
                          builder: (BuildContext context, Widget? child) {
                            String text = _currentString.substring(
                                0, _characterCount.value);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$text",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xFFE5FEFF),
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                      : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        if (_historyList[index].role == "user") {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                const CircleAvatar(),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("User"),
                                      Text(_historyList[index].content),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.teal,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
<<<<<<< HEAD
                                    const Text("응답STT"),
=======
                                    const Text("청안 AI챗봇"),
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
                                    Text(_historyList[index].content)
                                  ],
                                ))
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
<<<<<<< HEAD
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      onPressed: _startListening,
                    ),
=======
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(),
                        ),
                        child: TextField(
                          controller: messageTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Message"),
                        ),
                      ),
                    ),
                    IconButton(
<<<<<<< HEAD
                      icon: Icon(Icons.upload_file),
                      onPressed: _uploadVoiceFile,
                    ),
                    IconButton(
=======
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
                      iconSize: 42,
                      onPressed: () async {
                        if (messageTextController.text.isEmpty) {
                          return;
                        }
                        setState(() {
                          _historyList.add(
                            Messages(
                                role: "user",
                                content: messageTextController.text.trim()),
                          );
                          _historyList.add(
                              Messages(role: "assistant", content: ""));
                        });
                        try {
                          var text = "";
                          final stream = requestChatStream(
                              messageTextController.text.trim());
                          await for (final textChunk in stream) {
                            text += textChunk;
                            setState(() {
                              _historyList.last =
                                  _historyList.last.copyWith(content: text);
                              _scrollDown();
                            });
                          }
                          messageTextController.clear();
<<<<<<< HEAD
                          _synthesizeText(text);
=======
                          streamText = "";
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_up),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
<<<<<<< HEAD



class Messages {
  final String role;
  final String content;

  Messages({required this.role, required this.content});

  Messages copyWith({String? role, String? content}) {
    return Messages(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}

=======
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
