import 'package:collection/collection.dart';
import 'package:alkaraj_assignment/data/models/item.dart';
import 'package:alkaraj_assignment/data/repositories/item_repository.dart';
import 'item_service.dart';
import '../../data/local_database/database_helper.dart';

class ItemServiceImpl implements ItemService {
  final ItemRepository _itemRepository;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  ItemServiceImpl(this._itemRepository);

  @override
  Future<Item> createItem(Item item) async {
    final createdItem = await _itemRepository.createItem(item);
    await _databaseHelper.insertTask(createdItem);
    return createdItem;
  }

  @override
  Future<void> deleteItem(String id) async {
    await _itemRepository.deleteItem(id);
    await _databaseHelper.deleteTask(id);
  }

  @override
  Future<Item> getItem(String id) async {
    // Try to get from cache first
    final cachedItems = await _databaseHelper.getTasks();
    final cachedItem = cachedItems.firstWhereOrNull(
      (item) => item.id == id,
    );
    if (cachedItem != null) {
      return cachedItem;
    }
    // If not in cache, get from repository and cache it
    final item = await _itemRepository.getItem(id);
    await _databaseHelper.insertTask(item);
    return item;
  }

  @override
  Future<List<Item>> getItems() async {
    // Try to get from cache first
    final cachedItems = await _databaseHelper.getTasks();
    if (cachedItems.isNotEmpty) {
      return cachedItems;
    }
    // If cache is empty, get from repository and cache the results
    final items = await _itemRepository.getItems();
    await _databaseHelper.deleteAllTasks(); // Clear old cache
    for (final item in items) {
      await _databaseHelper.insertTask(item);
    }
    return items;
  }

  @override
  Future<Item> updateItem(String id, Item item) async {
    final updatedItem = await _itemRepository.updateItem(id, item);
    await _databaseHelper.updateTask(updatedItem);
    return updatedItem;
  }

  @override
  Future<void> cacheItems(List<Item> items) async {
    await _databaseHelper.deleteAllTasks();
    for (final item in items) {
      await _databaseHelper.insertTask(item);
    }
  }

  @override
  Future<List<Item>> getCachedItems() async {
    return _databaseHelper.getTasks();
  }

  @override
  Future<void> cacheItem(Item item) async {
    await _databaseHelper.insertTask(item);
  }

  @override
  Future<void> deleteCachedItem(String id) async {
    await _databaseHelper.deleteTask(id);
  }

  @override
  Future<void> deleteAllCachedItems() async {
    await _databaseHelper.deleteAllTasks();
  }
}
