import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalia/Widgets/base_scaffold.dart';

class LogPage extends StatefulWidget {
  final Map<String, DateTime> errorLogs;
  final Map<String, DateTime> debugLogs;

  const LogPage({
    super.key,
    required this.errorLogs,
    required this.debugLogs,
  });

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  bool showDebugLogs = false;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Journalia",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Caveat',
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  showDebugLogs = false;
                });
              },
              icon: const Icon(Icons.error),
              tooltip: 'Show Error Logs',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  showDebugLogs = true;
                });
              },
              icon: const Icon(Icons.bug_report),
              tooltip: 'Show Debug Logs',
            ),
          ],
        ),
        body: ListView(
          children: [
            _buildLogSection(
              'Logs',
              showDebugLogs ? widget.debugLogs : widget.errorLogs,
              showDebugLogs ? Colors.blue : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSection(
      String title, Map<String, DateTime> logs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: color,
          height: 0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final logEntry = logs.entries.elementAt(index);
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logEntry.key,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(logEntry.value),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class LogData {
  static Map<String, DateTime> errorLogs = {};
  static Map<String, DateTime> debugLogs = {};

  static void addErrorLog(String logEntry) {
    errorLogs[logEntry] = DateTime.now();
  }

  static void addDebugLog(String logEntry) {
    debugLogs[logEntry] = DateTime.now();
  }

  static void clearLogs() {
    errorLogs.clear();
    debugLogs.clear();
  }
}
