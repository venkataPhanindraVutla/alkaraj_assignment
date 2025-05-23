import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemRepository {
  final CollectionReference itemsRef = FirebaseFirestore.instance.collection(
    'items',
  );

  Future<Item> createItem(Item item) async {
    try {
      DocumentReference docRef = await itemsRef.add(item.toJson());
      DocumentSnapshot snapshot = await docRef.get();
      return Item.fromJson({
        'id': docRef.id,
        ...snapshot.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  Future<List<Item>> getItems() async {
    try {
      QuerySnapshot snapshot = await itemsRef.get();
      return snapshot.docs
          .map(
            (doc) => Item.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<Item> getItem(String id) async {
    try {
      DocumentSnapshot doc = await itemsRef.doc(id).get();
      if (doc.exists) {
        return Item.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      } else {
        throw Exception('Item not found');
      }
    } catch (e) {
      throw Exception('Failed to load item: $e');
    }
  }

  Future<Item> updateItem(String id, Item item) async {
    try {
      await itemsRef.doc(id).update(item.toJson());
      DocumentSnapshot updatedDoc = await itemsRef.doc(id).get();
      return Item.fromJson({
        'id': id,
        ...updatedDoc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await itemsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}
