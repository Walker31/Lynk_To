import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:llm_noticeboard/Api/messages.dart';
import 'package:llm_noticeboard/database/user_details.dart';
import 'package:llm_noticeboard/models/chat_model.dart';
import 'package:llm_noticeboard/models/message_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var _groupId="";

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  late String groupId;

  ChatPage(this.groupId, {Key? key}) : super(key: key) {
    _groupId = groupId;
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late StreamController<ChatMessageModel> _chatMessagesStreamController;
  late Stream _chatMessagesStream;
  final List<ChatMessageModel> _allMessagesContainedInTheStream = [];
  final TextEditingController _messageController = TextEditingController();
  late String loginRollNo="108121001";
  bool isIconButtonSelected = false;
  // Initialize logger instance
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    final userDetails = Provider.of<UserProvider>(context, listen: false).userDetails;
    if (userDetails != null) {
      loginRollNo = userDetails.rollNo;
    }
    _chatMessagesStreamController = StreamController<ChatMessageModel>.broadcast();
    _chatMessagesStream = _chatMessagesStreamController.stream;
    
    _fetchMessages();
  }

  @override
  void dispose() {
    // Close the stream controller when the widget is disposed
    _chatMessagesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_groupId)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatMessagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _allMessagesContainedInTheStream.length,
                    itemBuilder: (context, index) {
                      // Format the timestamp to display in AM/PM format
                      String formattedTimestamp = DateFormat('hh:mm a').format(
                          _allMessagesContainedInTheStream[index].timestamp);
            
                      return Column(
                        crossAxisAlignment: _allMessagesContainedInTheStream[index].rollno == loginRollNo
                            ? CrossAxisAlignment.end // Align messages to the right if rollno matches loginRollNo
                            : CrossAxisAlignment.start, // Align messages to the left for other rollnos
                        children: [
                          ListTile(
                          title: Row(
                            mainAxisAlignment: _allMessagesContainedInTheStream[index].rollno == loginRollNo
                                ? MainAxisAlignment.end // Align roll number to the right if it's the current user's message
                                : MainAxisAlignment.start, // Align roll number to the left for other messages
                            children: [
                              Text(
                                _allMessagesContainedInTheStream[index].rollno,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          dense: true,
                          tileColor: Colors.transparent, // Optional: Adjust tile color as needed
                          horizontalTitleGap: 0, // Optional: Adjust horizontal gap between title and leading widget
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4), // Optional: Adjust the density of the ListTile
                        ),

                          Row(
                            mainAxisAlignment: _allMessagesContainedInTheStream[index].rollno == loginRollNo
                                ? MainAxisAlignment.end // Align message to the right if rollno matches loginRollNo
                                : MainAxisAlignment.start, // Align message to the left for other rollnos
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(_allMessagesContainedInTheStream[index].rollno == loginRollNo ? 20 : 0),
                                    topRight: Radius.circular(_allMessagesContainedInTheStream[index].rollno != loginRollNo ? 20 : 0),
                                    bottomLeft: const Radius.circular(20),
                                    bottomRight: const Radius.circular(20),
                                  ),
                                  color: _allMessagesContainedInTheStream[index].rollno == loginRollNo
                                      ? Colors.blue.shade400 // Color for messages sent by current user
                                      : Colors.grey.shade400, // Default color for other messages
                                ),
                                child: Text(
                                  _allMessagesContainedInTheStream[index].message!,
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              _allMessagesContainedInTheStream[index].rollno == loginRollNo ? 0 : 20,
                              0,
                              _allMessagesContainedInTheStream[index].rollno != loginRollNo ? 0 : 20,
                              10,
                            ),
                            child: Text(
                              formattedTimestamp,
                              textAlign: _allMessagesContainedInTheStream[index].rollno == loginRollNo
                                  ? TextAlign.end // Align timestamp to the right if rollno matches loginRollNo
                                  : TextAlign.start, // Align timestamp to the left for other rollnos
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No messages yet"));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.black), // Change text color to black
                    decoration: const InputDecoration(
                      hintText: "Type a message....",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.lock),
                  color: isIconButtonSelected ? Theme.of(context).primaryColor : Colors.grey,
                  onPressed: (){
                      setState(() {
                    logger.d(isIconButtonSelected);
                    isIconButtonSelected = !isIconButtonSelected;
                    logger.d(isIconButtonSelected); // Toggle selection status
                  });
                  },
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _sendMessage(loginRollNo),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
                    ),
          ),
        ],
      ),
      
    );
  }

  // Function to fetch messages
  void _fetchMessages() async {
    try {
      List<MessageModel>? messages = await Message().getMessages();
      if (messages != null) {
        List<ChatMessageModel> chatMessages = messages.map((message) {
          return ChatMessageModel(
            rollno: message.rollno.toString(),
            message: message.message,
            timestamp: message.timestamp, // Assuming timestamp is in ISO 8601 format
          );
        }).toList();
        if (mounted) {
          _allMessagesContainedInTheStream.clear(); // Clear existing messages
          _allMessagesContainedInTheStream.addAll(chatMessages);
          _chatMessagesStreamController.addStream(Stream.fromIterable(chatMessages));
        }
      }
    } catch (e) {
      logger.e('Error fetching messages: $e'); // Log error with level "error"
    }
  }

  // Function to send message
  // Function to send message
void _sendMessage(String loginRollNo) async {
  String message = _messageController.text;
  DateTime timestamp = DateTime.now().toLocal(); // Current timestamp
  String rollno= loginRollNo;
  // Replace with actual login roll number
  int statusCode = await Message().postMessage(rollno, message, timestamp);

  Message messageInstance = Message();

  if(isIconButtonSelected){
    messageInstance.script(message); // Call script method using the instance
  }

  if (statusCode == 201) {
    // Create a new ChatMessageModel object
    ChatMessageModel newMessage = ChatMessageModel(
      rollno: loginRollNo,
      message: message,
      timestamp: timestamp,
    );

    // Add the new message to the stream controller
    setState(() {
      _allMessagesContainedInTheStream.add(newMessage);
    });
    _chatMessagesStreamController.add(newMessage);

    // Clear the message input field
    _messageController.clear();
  } else {
    logger.w('Failed to send message'); // Log warning
  }
}

}
