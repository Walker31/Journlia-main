import 'package:flutter/material.dart';

import '../Models/votes.dart';

class VotesProvider extends ChangeNotifier {
  List<Vote> _votes = []; // Initial list of votes

  // Method to fetch votes (replace with actual data fetch logic)
  Future<void> fetchVotes() async {
    // Simulate fetching data from API or database
    _votes = [
      Vote(
        voteId: '1',
        articleId: '1',
        userId: '1',
        voteType: true,
      ),
      // Add more votes here
    ];
    notifyListeners(); // Notify listeners after data is updated
  }

  // Getter for votes
  List<Vote> get votes => _votes;

  // Method to add a new vote
  void addVote(Vote vote) {
    _votes.add(vote);
    notifyListeners(); // Notify listeners after data is updated
  }

  // Method to update an existing vote
  void updateVote(Vote updatedVote) {
    // Find and update the vote in the list
    final index = _votes.indexWhere((vote) => vote.voteId == updatedVote.voteId);
    if (index != -1) {
      _votes[index] = updatedVote;
      notifyListeners(); // Notify listeners after data is updated
    }
  }

  // Method to delete a vote
  void deleteVote(Vote vote) {
    _votes.remove(vote);
    notifyListeners(); // Notify listeners after data is updated
  }
}
