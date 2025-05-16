import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart';
import '../services/item_service_impl.dart';

// Events
abstract class ItemEvent {}

class LoadItems extends ItemEvent {}

class AddItem extends ItemEvent {
  final Item item;
  AddItem(this.item);
}

class UpdateItem extends ItemEvent {
  final String id;
  final Item item;
  UpdateItem(this.id, this.item);
}

class DeleteItem extends ItemEvent {
  final String id;
  DeleteItem(this.id);
}

// States
abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  ItemLoaded(this.items);
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}

class ItemOperationSuccess extends ItemState {
  final String message;
  ItemOperationSuccess(this.message);
}

class ItemOperationFailure extends ItemState {
  final String error;
  ItemOperationFailure(this.error);
}

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemServiceImpl _itemService;

  ItemBloc(this._itemService) : super(ItemInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      final items = await _itemService.getItems();
      emit(ItemLoaded(items));
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter<ItemState> emit) async {
    try {
      await _itemService.createItem(event.item);
      emit(ItemOperationSuccess('Task added successfully!'));
      // After adding, reload items to update the UI
      add(LoadItems());
    } catch (e) {
      emit(ItemOperationFailure('Failed to add task: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateItem(UpdateItem event, Emitter<ItemState> emit) async {
    try {
      await _itemService.updateItem(event.id, event.item);
      emit(ItemOperationSuccess('Task updated successfully!'));
      // After updating, reload items to update the UI
      add(LoadItems());
    } catch (e) {
      emit(ItemOperationFailure('Failed to update task: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<ItemState> emit) async {
    try {
      await _itemService.deleteItem(event.id);
      emit(ItemOperationSuccess('Task deleted successfully!'));
      // After deleting, reload items to update the UI
      add(LoadItems());
    } catch (e) {
      emit(ItemOperationFailure('Failed to delete task: ${e.toString()}'));
    }
  }
}
