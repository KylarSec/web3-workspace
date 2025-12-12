// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract StudentDetails {

    // A Data type to storing Student Details.
    struct Student {
        uint256 Admission_number; // Unique admission ID for each student
        string Name; // Full name of the Student
        uint256 Roll_number; // Roll number of the student
        uint256 Class; // Class in which student currently studying
        string Section; 
        bool dues; // Whether the student has pending dues (true = has dues)
    }

    // Am Array To Store all Student to the list.
    Student[] public ListOfStudents;

    // Mapping admission number → student record
    mapping(uint256 => Student) public GetStudentDetail;

    // Store a New Student
    function store(
        uint256 _Admission_number,
        string memory _Name,
        uint256 _Roll_number,
        uint256 _Class,
        string memory _Section,
        bool _dues
        ) public {
        
        // Create a new Student Struct in memory
        Student memory newStudent = Student(
            _Admission_number,
            _Name,
            _Roll_number,
            _Class,
            _Section,
            _dues
            );

        // save that new student struct to the array or list
        ListOfStudents.push(newStudent);
        
        // Save student in the mapping for quick lookup by admission number
        GetStudentDetail[_Admission_number] = newStudent;
    }

    // Get Student Detail by Admission number.
    function StudentDetail(uint256 _AdmissionNumber) view public returns(Student memory) {
        return GetStudentDetail[_AdmissionNumber];     
        }

}