// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Vest90Days is Ownable {

	address VvvTokenContractAddrss ;

	struct employeeData{
		string name;
		address owner;
		uint256 startTime;
		uint256 endTime;
		uint256 tokensVested;
		bool exists;
		bool hasExited;
	}

	mapping(address => employeeData) perEmployeeData;
	address[] empList;

	event NewEmployee(address indexed, uint256 startTime);
	event VestedTokens(address indexed, uint256 nTokens);
	event EmployeeExit(address indexed, uint256 endTime);

	constructor( address _addr ) {
		VvvTokenContractAddrss = _addr;
	}

	function startNewEmployee( address _employeeAddress, string memory _name ) public onlyOwner {
		employeeData memory newEmployee;
		newEmployee.name = _name;
		newEmployee.owner = _employeeAddress;
		newEmployee.startTime = block.timestamp;
		newEmployee.exists = true;
		perEmployeeData[_employeeAddress] = newEmployee;
		empList.push(_employeeAddress);
		emit NewEmployee(_employeeAddress, block.timestamp);
	}

	function employeeExit( address _employeeAddress ) public onlyOwner {
		employeeData memory emp;
		emp = perEmployeeData[_employeeAddress];
		if ( emp.exists ) {
			emp.hasExited = true;
			emp.endTime = block.timestamp;
		}
		perEmployeeData[_employeeAddress] = emp;
		emit EmployeeExit(_employeeAddress, block.timestamp);
	}

	function calculateVesting (address _anEmployee ) public onlyOwner {
		uint256 nTokens;
		// TODO calculate.
		// TODO use address of ERC777 to transfer tokens to _anEmployee
		emit VestedTokens(_anEmployee, nTokens);
	}

	function vestedTokens ( address _anEmployee ) public view returns ( uint256 ) {
		employeeData memory emp;
		emp = perEmployeeData[_anEmployee];
		if ( emp.exists ) {
			return emp.tokensVested;
		}
		return 0;
	}



	// List Employees by address
	function nEmployees() public view returns ( uint256 ) {
		return( empList.length );
	}
	function getName ( uint256 nth ) public view returns ( string memory ) {
		require(nth >= 0  && nth < empList.length, "nth out of range.");
		address a;
		a = empList[nth];
		employeeData memory emp;
		emp = perEmployeeData[a];
		if ( emp.exists ) {
			return emp.name;
		}
		return ( "" );
	}
	function getStartTime ( uint256 nth ) public view returns ( uint256 ) {
		require(nth >= 0  && nth < empList.length, "nth out of range.");
		address a;
		a = empList[nth];
		employeeData memory emp;
		emp = perEmployeeData[a];
		if ( emp.exists ) {
			return emp.startTime;
		}
		return ( 0 );
	}

	// TODO - add other accessor functions for data.

}
