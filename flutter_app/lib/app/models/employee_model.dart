class EmployeeModel {
  String jobTitle; // ← add
  String employeeId; // ← add
  String title;

  String firstName;
  String fatherName;
  String grandfatherName;
  String lastName;

  String motherFirstName;
  String motherLastName;

  String homeAddress;

  bool primaryMailing;

  String pan;
  String nationalId;
  String dateOfBirth;
  String bloodGroup;
  String country;
  String gender;
  String maritalStatus;
  String religion;
  String ethnicity;

  String phone;
  String email;
  String communicationAccount;
  String communicationPreference;

  EmployeeModel({
    required this.jobTitle, // ← add
    required this.employeeId, // ← add
    required this.title,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.lastName,
    required this.motherFirstName,
    required this.motherLastName,
    required this.homeAddress,
    required this.primaryMailing,
    required this.pan,
    required this.nationalId,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.country,
    required this.gender,
    required this.maritalStatus,
    required this.religion,
    required this.ethnicity,
    required this.phone,
    required this.email,
    required this.communicationAccount,
    required this.communicationPreference,
  });
}
