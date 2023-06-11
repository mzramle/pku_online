import 'package:pku_online/data/doctor_repo.dart';
import 'package:pku_online/models/doctor_model.dart';

class SearchController {
  List<DoctorModel> searchDoctors(String query) {
    List<DoctorModel> results = [];

    for (var doctor in doctorMapList) {
      if (doctor['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        results.add(DoctorModel.fromJson(doctor));
      }
    }

    return results;
  }
}
