// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Ecole {
    enum CertificationStatus {
        NotCertified,
        Certified
    }

    struct Eleve {
        string Nom;
        string prenom;
        uint256 Note;
        CertificationStatus status;
        uint id;
    }

    uint public Elevecount;
    address public owner;
    uint public EleveCertifie;

    Eleve[] public Eleves;

    event StudentAdded(string Nom, string prenom, uint256 Note, CertificationStatus status, uint id);
    event StudentsCertified(uint count);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function AddStudent(string memory Nom, string memory prenom, uint256 Note) public onlyOwner {
        require(Note >= 0 && Note <= 20, "Marks should be between 0 and 20");
        
        CertificationStatus status;
        if (Note >= 10) {
            status = CertificationStatus.Certified;
            EleveCertifie++;
        } else {
            status = CertificationStatus.NotCertified;
        }

        Eleve memory newEtud = Eleve(Nom, prenom, Note, status, Elevecount);
        Eleves.push(newEtud);
        Elevecount++;

        emit StudentAdded(Nom, prenom, Note, status, Elevecount - 1);
    }

    function setlist() public onlyOwner {
        uint count;
        for (uint i = 0; i < Elevecount; i++) {
            if (Eleves[i].status == CertificationStatus.Certified) {
                count++;
            }
        }
        EleveCertifie = count;
        emit StudentsCertified(count);
    }

    function getStudent(uint id) public view returns (string memory, string memory, uint256, CertificationStatus) {
        require(id < Elevecount, "Student with this id does not exist");

        Eleve memory student = Eleves[id];
        return (student.Nom, student.prenom, student.Note, student.status);
    }
}
