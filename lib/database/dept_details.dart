class Department {
  final int rollNo;
  final String name;

  Department(this.rollNo, this.name);
}

List<Department> departments = [
  Department(101, "Architecture"),
  Department(102, "CHEM"),
  Department(103, "CIVIL"),
  Department(106, "CSE"),
  Department(107, "EEE"),
  Department(108, "ECE"),
  Department(110, "ICE"),
  Department(111, "MECH"),
  Department(112, "MME"),
  Department(114, "PROD"),
];


class DepartmentManager {
  final List<Department> _departments; // Use private list for encapsulation

  DepartmentManager() : _departments = departments; // Initialize with data

  void addDepartment(int rollNo, String name) {
    if (_departments.indexWhere((department) => department.rollNo == rollNo) != -1) {
      throw Exception('Department with roll number $rollNo already exists.');
    }
    _departments.add(Department(rollNo, name));
  }

  Department? getDepartment(int rollNo) {
    return _departments.firstWhere((department) => department.rollNo == rollNo);
  }
}

class Years {
  final int rollNo;
  final String year;

  Years(this.rollNo, this.year);
}

List<Years> year = [
  Years(123, "1st Year"),
  Years(122, "2nd Year"),
  Years(121, "3rd Year"),
  Years(120, "4th Year"),
];


class YearManager {
  final List<Years> _year; // Use private list for encapsulation

  YearManager() : _year = year; // Initialize with data

  void addYear(int rollNo, String year) {
    if (_year.indexWhere((department) => department.rollNo == rollNo) != -1) {
      throw Exception('Department with roll number $rollNo already exists.');
    }
    _year.add(Years(rollNo, year));
  }

  Years? getYear(int rollNo) {
    return _year.firstWhere((year) => year.rollNo == rollNo);
}

}