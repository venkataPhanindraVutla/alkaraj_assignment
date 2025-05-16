import '../../data/models/item.dart';

abstract class ItemService {
  Future<Item> createItem(Item item);
  Future<List<Item>> getItems();
  Future<Item> getItem(String id);
  Future<Item> updateItem(String id, Item item);
  Future<void> deleteItem(String id);
}