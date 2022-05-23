-- schema definition for Campers, Activities, and Registration

CREATE TABLE Campers 
	(
	cid NUMBER(6),
	cname VARCHAR(20),
	age NUMBER(2),
	zipcode NUMBER(5),
	PRIMARY KEY (cid)
	);

CREATE TABLE Activities (	
	aid NUMBER(6),
	aname VARCHAR(50),
	price REAL,
	capacity NUMBER(6),
	PRIMARY KEY (aid)
	);

CREATE TABLE Registration (
	cid NUMBER(6),
	aid NUMBER(6),
	PRIMARY KEY (cid,aid),
	FOREIGN KEY (cid) REFERENCES Campers (cid),
	FOREIGN KEY (aid) REFERENCES Activities (aid)
	);


