import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tip.dart';

class TipState {
  final List<Tip> allTips;
  final List<String> savedTipIds;
  final List<Tip> filteredTips;
  final String searchQuery;

  TipState({
    required this.allTips,
    required this.savedTipIds,
    required this.filteredTips,
    required this.searchQuery,
  });

  factory TipState.initial() {
    return TipState(
      allTips: [],
      savedTipIds: [],
      filteredTips: [],
      searchQuery: '',
    );
  }

  List<Tip> get savedTips {
    return allTips.where((tip) => savedTipIds.contains(tip.id)).toList();
  }

  TipState copyWith({
    List<Tip>? allTips,
    List<String>? savedTipIds,
    List<Tip>? filteredTips,
    String? searchQuery,
  }) {
    return TipState(
      allTips: allTips ?? this.allTips,
      savedTipIds: savedTipIds ?? this.savedTipIds,
      filteredTips: filteredTips ?? this.filteredTips,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TipNotifier extends StateNotifier<TipState> {
  // StreamController для избранного
  final StreamController<List<Tip>> _savedTipsController = StreamController<List<Tip>>.broadcast();

  TipNotifier() : super(TipState.initial());

  Stream<List<Tip>> get savedTipsStream => _savedTipsController.stream;

  void loadTips(List<Tip> tips) {
    state = state.copyWith(
      allTips: tips,
      filteredTips: tips,
    );
    _notifySavedTipsChanged();
  }

  void loadSavedTips(List<String> savedTipIds) {
    for (final id in savedTipIds) {
      if (!state.savedTipIds.contains(id)) {
        final newSavedIds = [...state.savedTipIds, id];
        state = state.copyWith(savedTipIds: newSavedIds);
      }
    }
    _notifySavedTipsChanged();
  }

  void searchTips(String query) {
    final filtered = state.allTips.where((tip) =>
    tip.name.toLowerCase().contains(query.toLowerCase()) ||
        tip.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    state = state.copyWith(
      searchQuery: query,
      filteredTips: filtered,
    );
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      filteredTips: state.allTips,
    );
  }

  void addSavedTip(String tipId) {
    if (!state.savedTipIds.contains(tipId)) {
      final newSavedIds = [...state.savedTipIds, tipId];
      state = state.copyWith(savedTipIds: newSavedIds);
      _notifySavedTipsChanged();
    }
  }

  void removeSavedTip(String tipId) {
    final newSavedIds = state.savedTipIds.where((id) => id != tipId).toList();
    state = state.copyWith(savedTipIds: newSavedIds);
    _notifySavedTipsChanged();
  }

  void toggleSavedTip(String tipId) {
    if (state.savedTipIds.contains(tipId)) {
      removeSavedTip(tipId);
    } else {
      addSavedTip(tipId);
    }
  }

  void _notifySavedTipsChanged() {
    _savedTipsController.add(state.savedTips);
  }

  void dispose() {
    _savedTipsController.close();
  }
}