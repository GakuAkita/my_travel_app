import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_traveler.dart';

import '../../../../../data/model/traveler/traveler_core/traveler_core.dart';

class AddEditExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;

  late final List<TravelerBasic> _groupMembers;
  late final List<SelectedTraveler> _travelersOption;
  late final List<TravelerCore> _participants;

  bool _isError = false;

  bool get isError => _isError;

  AddEditExpenseViewModel({
    String? expenseId,
    required ExpenseRepository expenseRepository,
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
  }) : _expenseRepository = expenseRepository,
       _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore {
    if (!_expenseStore.storeInitialized ||
        !_travelScopeStore.storeInitialized) {
      /* UIの通り道でブロックしているのでここに来ることはまずない */
      print("Store is not initialized!");
      _isError = true;
    }

    final groupMembersState = _travelScopeStore.allGroupMembers;
    _groupMembers =
        groupMembersState.hasData
            ? groupMembersState.data!.entries
                .map((entry) => entry.value)
                .toList()
            : [];
    final participantsState = _travelScopeStore.participants;
    _participants =
        participantsState.hasData
            ? participantsState.data!.entries
                .map((entry) => entry.value)
                .toList()
            : [];
    /* Addだったら、全部チェックにする */

    /* Editだったら、initialExpenseのreimbursedByにチェックする */
  }

  @override
  void dispose() {
    print("AddEditExpenseViewModel(${hashCode}) was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
