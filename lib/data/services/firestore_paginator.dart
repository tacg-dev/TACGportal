import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacgportal/data/models/attendance_record.dart';

class FirestorePaginator<T> {
  final T Function(DocumentSnapshot doc) converter;

  // query config
  final String collectionPath;
  final String orderByField;
  final int pageSize;

  FirestorePaginator({
    required this.converter,
    required this.collectionPath,
    required this.orderByField,
    required this.pageSize,
  });

  // state
  int currentPage = 1;
  bool hasMoreData = true;

  final _isLoadingController = StreamController<bool>.broadcast();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  final _dataController = StreamController<List<T>>.broadcast();
  Stream<List<T>> get dataStream => _dataController.stream;

  DocumentSnapshot? lastDocument;
  Map<int, DocumentSnapshot> currPage_to_lastDoc = {};

  Future<void> initialize() async {
    // Load first page
    _isLoadingController.sink.add(true);

    currentPage = 1;
    lastDocument = null;
    // Query and emit initial data
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection(collectionPath)
        .orderBy(orderByField, descending: true)
        .limit(pageSize)
        .get();
    if (qSnap.docs.isNotEmpty) {
      lastDocument = qSnap.docs.last;
      final List<T> typedRecords =
          qSnap.docs.map((doc) => converter(doc) as T).toList();
      _dataController.sink.add(typedRecords);
    } else {
      hasMoreData = false;
    }
    _isLoadingController.sink.add(false);
  }

  Future<void> nextPage() async {
    if (currentPage == 1 && lastDocument == null) {
      return initialize();
    }

    if (!hasMoreData) {
      return;
    }
    _isLoadingController.sink.add(true);
    try {
      currPage_to_lastDoc[currentPage] = lastDocument!;
      currentPage++;
      Query query = FirebaseFirestore.instance
          .collection(collectionPath)
          .orderBy(orderByField, descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }
      final QuerySnapshot qSnap = await query.get();
      if (qSnap.docs.isNotEmpty) {
        lastDocument = qSnap.docs.last;
        final List<T> typedRecords =
            qSnap.docs.map((doc) => converter(doc) as T).toList();
        _dataController.sink.add(typedRecords);

        hasMoreData = qSnap.docs.length == pageSize;
      } else {
        hasMoreData = false;
        _dataController.sink.add([]);
      }
    } catch (e) {
      print('Error loading next page: $e');
    } finally {
      _isLoadingController.sink.add(false);
    }
  }

  Future<void> previousPage() async {
  if (currentPage <= 1) {
    return;
  }
  
  _isLoadingController.sink.add(true);
  
  try {
    currentPage--;
    
    Query query;
    
    if (currentPage == 1) {
      // For page 1, don't use a cursor
      lastDocument = null;
      query = FirebaseFirestore.instance
          .collection(collectionPath)
          .orderBy(orderByField, descending: true)
          .limit(pageSize);
    } else {
      // For pages > 1, get the stored cursor
      if (currPage_to_lastDoc.containsKey(currentPage - 1)) {
        // Use the cursor from the end of the previous page
        lastDocument = currPage_to_lastDoc[currentPage - 1]!;
        query = FirebaseFirestore.instance
            .collection(collectionPath)
            .orderBy(orderByField, descending: true)
            .startAfterDocument(lastDocument!)
            .limit(pageSize);
      } else {
        return initialize();
      }
    }
    final QuerySnapshot qSnap = await query.get();
    if (qSnap.docs.isNotEmpty) {
      // If this isn't page 1, update lastDocument for moving forward again
      if (currentPage > 1) {
        lastDocument = qSnap.docs.last;
      }
      
      // Add the records to the stream
      final List<T> typedRecords = qSnap.docs.map((doc) => converter(doc) as T).toList();
      _dataController.sink.add(typedRecords);
      
      // Since we went back, we know there's more data ahead
      hasMoreData = true;
    } else {
      // Empty results (shouldn't happen when going back)
      _dataController.sink.add([]);
    }
  } catch (e) {
    print('Error loading previous page: $e');
  } finally {
    _isLoadingController.sink.add(false);
  }
}

  void dispose() {
    _isLoadingController.close();
    _dataController.close();
  }
}
