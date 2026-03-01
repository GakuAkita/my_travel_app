import 'package:flutter/widgets.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final GetUserTravelsUseCase _getUserTravelsUseCase;

  TravelSelectViewModel({required GetUserTravelsUseCase getUserTravelsUseCase})
    : _getUserTravelsUseCase = getUserTravelsUseCase;
}
