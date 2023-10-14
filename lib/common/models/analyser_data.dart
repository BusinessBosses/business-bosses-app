import 'for_data_picker.dart';

class AnalyserData {
  static List<ForDataPicker> industries = <ForDataPicker>[
    ForDataPicker(value: 'Medical'),
    ForDataPicker(value: 'Education'),
    ForDataPicker(value: 'Software Engineering'),
  ];
  static List<ForDataPicker> education = <ForDataPicker>[
    ForDataPicker(value: 'Teaching'),
    ForDataPicker(value: 'Education Administrator'),
    ForDataPicker(value: 'School Counseling'),
    ForDataPicker(value: 'School Social Work'),
    ForDataPicker(value: 'High School Teachers'),
    ForDataPicker(value: 'Elementary School Teachers'),
    ForDataPicker(value: 'Kindergarten Teachers'),
    ForDataPicker(value: 'Middle School Teachers'),
    ForDataPicker(value: 'Special Education Teachers'),
    ForDataPicker(value: 'Postsecondary Teacher'),
    ForDataPicker(value: 'Postsecondary Education Administrator'),
    ForDataPicker(value: 'Curriculum Developer'),
    ForDataPicker(value: 'Schools Counselor'),
  ];

  static List<ForDataPicker> medical = <ForDataPicker>[
    ForDataPicker(value: 'Athletic trainer'),
    ForDataPicker(value: 'Audiologist'),
    ForDataPicker(value: 'Cardiac sonographer'),
    ForDataPicker(value: 'Cardiovascular invasive specialist'),
    ForDataPicker(value: 'Cardiovascular perfusionist'),
    ForDataPicker(value: 'Central service technician'),
    ForDataPicker(value: 'Child life specialist'),
    ForDataPicker(value: 'Cytogenetic technologist'),
    ForDataPicker(value: 'Cytotechnologist'),
    ForDataPicker(value: 'Diagnostic medical sonographer'),
    ForDataPicker(value: 'Dietitian'),
    ForDataPicker(value: 'Emergency medicine paramedic'),
    ForDataPicker(value: 'Genetic counselor'),
    ForDataPicker(value: 'Health information manager'),
    ForDataPicker(value: 'Hemodialysis technician'),
    ForDataPicker(value: 'Medical physicist'),
    ForDataPicker(value: 'Medical social worker'),
    ForDataPicker(value: 'Nurse'),
    ForDataPicker(value: 'Orthoptist'),
    ForDataPicker(value: 'Pathologists\' assistant'),
    ForDataPicker(value: 'Pharmacist'),
  ];

  static List<ForDataPicker> softwareEngineering = <ForDataPicker>[
    ForDataPicker(value: 'Applications developer'),
    ForDataPicker(value: 'Cyber security analyst'),
    ForDataPicker(value: 'Game developer'),
    ForDataPicker(value: 'Information systems manager'),
    ForDataPicker(value: 'IT consultant'),
    ForDataPicker(value: 'Multimedia programmer'),
    ForDataPicker(value: 'Web developer'),
    ForDataPicker(value: 'Web designer'),
    ForDataPicker(value: 'Software engineer'),
    ForDataPicker(value: 'Software quality assurance engineer'),
    ForDataPicker(value: 'Application analyst'),
    ForDataPicker(value: 'Database administrator'),
    ForDataPicker(value: 'Forensic computer analyst'),
    ForDataPicker(value: 'IT technical support officer'),
    ForDataPicker(value: 'Software tester'),
    ForDataPicker(value: 'Sound designer'),
    ForDataPicker(value: 'Systems analyst'),
  ];

  static List<ForDataPicker> professions = <ForDataPicker>[
    ForDataPicker(
      value: 'Marketing & advertising',
    ),
    ForDataPicker(
      value: 'Restuarant & Food',
    ),
    ForDataPicker(
      value: 'Education & Coaching',
    ),
    ForDataPicker(
      value: 'Recruiting & Jobs',
    ),
    ForDataPicker(
      value: 'Books & Publications',
    ),
    ForDataPicker(
      value: 'Packaging & Gifts',
    ),
    ForDataPicker(
      value: 'Construction & Real Estate',
    ),
    //
    // new ForDataPicker(value: 'Web designer'),
    // new ForDataPicker(value: 'Software engineer'),
    // new ForDataPicker(value: 'Software quality assurance engineer'),
    // new ForDataPicker(value: 'Application analyst'),
    // new ForDataPicker(value: 'Database administrator'),
    // new ForDataPicker(value: 'Forensic computer analyst'),
    // new ForDataPicker(value: 'IT technical support officer'),
    // new ForDataPicker(value: 'Software tester'),
    // new ForDataPicker(value: 'Sound designer'),
    // new ForDataPicker(value: 'Systems analyst'),
  ];

  static List<ForDataPicker> getIndustryField(String val) {
    if (val == industries[0].value) {
      return professions;
    } else if (val == industries[1].value) {
      return professions;
    } else {
      return professions;
    }
  }
}
