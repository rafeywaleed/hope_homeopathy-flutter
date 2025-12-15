class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final int age;
  final String gender;
  final String? bloodGroup;
  final String mobileNumber;
  final String? email;
  final String? abhaAddress;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.age,
    required this.gender,
    this.bloodGroup,
    required this.mobileNumber,
    this.email,
    this.abhaAddress,
  });

  String get fullName => '$firstName $lastName';

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: map['dob'],
      age: map['age'],
      gender: map['gender'],
      bloodGroup: map['bloodGroup'],
      mobileNumber: map['mobileNumber'],
      email: map['email'],
      abhaAddress: map['abhaAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'mobileNumber': mobileNumber,
      'email': email,
      'abhaAddress': abhaAddress,
    };
  }
}

class PatientSelectionService {
  static final PatientSelectionService _instance =
      PatientSelectionService._internal();

  factory PatientSelectionService() {
    return _instance;
  }

  PatientSelectionService._internal();

  final List<Patient> patients = [
    Patient(
      id: 'P001',
      firstName: 'John',
      lastName: 'Doe',
      dob: DateTime(1990, 5, 15),
      age: 34,
      gender: 'Male',
      bloodGroup: 'O+',
      mobileNumber: '9876543210',
      email: 'johndoe@example.com',
      abhaAddress: 'john.doe@abha',
    ),
    Patient(
      id: 'P002',
      firstName: 'Jane',
      lastName: 'Smith',
      dob: DateTime(1985, 8, 22),
      age: 39,
      gender: 'Female',
      bloodGroup: 'A+',
      mobileNumber: '9876543210',
      email: 'janesmith@example.com',
      abhaAddress: 'jane.smith@abha',
    ),
    Patient(
      id: 'P003',
      firstName: 'Robert',
      lastName: 'Johnson',
      dob: DateTime(1978, 3, 10),
      age: 46,
      gender: 'Male',
      bloodGroup: 'B+',
      mobileNumber: '9876543210',
      email: 'robert@example.com',
      abhaAddress: 'robert.johnson@abha',
    ),
  ];

  void addPatient(Patient patient) {
    patients.add(patient);
  }
}
