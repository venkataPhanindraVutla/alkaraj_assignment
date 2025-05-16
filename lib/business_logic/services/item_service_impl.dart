import 'package:alkaraj_assignment/data/models/item.dart';
import 'package:alkaraj_assignment/data/repositories/item_repository.dart';
import 'item_service.dart';

class ItemServiceImpl implements ItemService {
  final ItemRepository _itemRepository;

  ItemServiceImpl(this._itemRepository);

  @override
  Future<Item> createItem(Item item) async {
    return _itemRepository.createItem(item);
  }

  @override
  Future<void> deleteItem(String id) async {
    return _itemRepository.deleteItem(id);
  }

  @override
  Future<Item> getItem(String id) async {
    return _itemRepository.getItem(id);
  }

  @override
  Future<List<Item>> getItems() async {
    return _itemRepository.getItems();
  }

  @override
  Future<Item> updateItem(String id, Item item) async {
    return _itemRepository.updateItem(id, item);
  }
}
