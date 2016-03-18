
-- Turn safe updates off 
SET SQL_SAFE_UPDATES=0; 

CREATE TABLE Payments (
    PaymentID  		 integer (11) 	  NOT NULL AUTO_INCREMENT , 
    PaymentDateTime  datetime 		  NOT NULL,
    BasketNum        varchar(30)      NOT NULL DEFAULT 0,
    Order_No         integer (11)     NULL,
    InvoiceNum       varchar(20)      NOT NULL DEFAULT 0,
    CardType         varchar(50)      NULL,
    CardNumber       varchar(50)      NULL,
    NameOnCard       varchar(150)     NULL,
    EncryptedCard    varchar(255)     NULL,
    Amount           double           NOT NULL DEFAULT 0,
    Captured         tinyint (1) 	  NOT NULL DEFAULT 0,
    ID_Tag			 varchar (35)	  NULL,
	PRIMARY KEY (PaymentID),
	INDEX `Payments_BasketNum_Idx` (BasketNum),
	INDEX `Payments_ID_Tag_Idx` (`ID_Tag`),
	INDEX `Payments_Order_No_Idx` (`Order_No`),
    INDEX `Payments_Captured_Idx` (`Captured`)
);


ALTER TABLE Order_No ADD COLUMN TermsUsed LONGTEXT NULL;
ALTER TABLE Order_No ADD COLUMN OriginalTotal double DEFAULT '0' NOT NULL;
ALTER TABLE Order_No ADD COLUMN LastTransactNum varchar(50) NULL;

UPDATE Order_No SET OriginalTotal = OrderTotal, LastTransactNum = TransactNum;

ALTER TABLE OrderSettings ADD PayPalMethod varchar(25) NULL;
ALTER TABLE OrderSettings ADD PayPalServer varchar(100) NULL;

UPDATE OrderSettings SET PayPalMethod = 'Standard', PayPalServer = 'live';

ALTER TABLE OrderSettings ADD PDT_Token varchar(100) NULL;

ALTER TABLE OrderSettings ADD UseCRESecure tinyint (1) NOT NULL DEFAULT 0;

ALTER TABLE ShipSettings ADD ID_Tag varchar (35) NULL;

UPDATE CCProcess SET ID = 1;

INSERT INTO CCProcess
	(CCServer,Transtype,Username,Password,Setting1,Setting2,Setting3)
	VALUES ('https://api.sandbox.paypal.com/2.0/', 'Sale', NULL, NULL, NULL, NULL, 'PayPalExpress');

INSERT INTO CCProcess
	(CCServer,Transtype,Username,Password,Setting1,Setting2,Setting3)
	VALUES ('TEST', '', NULL, NULL, NULL, NULL, 'CRESecure');
	
		
INSERT INTO Permissions
	(Group_ID,Name,BitValue) VALUES (5,'Place Orders as Customer',1024);
	
INSERT INTO MailText 
	(MailText_Name, MailText_Subject, MailText_Message, System, MailAction)
	VALUES
	('Order Refund',
	'%SiteName% Order Refund', 
	'<p>%MergeContent%</p><p>Please shop with us again!</p><p>%Merchant%</p>',
	1,
	'OrderRefund' );

UPDATE USPSMethods SET Code = 'Standard Post' WHERE Code = 'Parcel Post';
UPDATE USPSMethods SET Code = 'First-Class Mail Parcel' WHERE Code = 'First-Class Mail Package' OR Code = 'First-Class';
UPDATE USPSMethods SET Code = 'Priority Mail 2-Day' WHERE Code = 'Priority Mail';
UPDATE USPSMethods SET Code = 'Standard Post' WHERE Code = 'Parcel Post';
UPDATE USPSMethods SET Code = 'Priority Mail Express 1-Day' WHERE Code = 'Express Mail';
UPDATE USPSMethods SET Code = 'Priority Mail Express International' WHERE Code = 'Express Mail International' OR CODE = 'Express Mail International (EMS)';
UPDATE USPSMethods SET Code = 'First-Class Package International Service**' WHERE Code = 'First-Class Mail International Package' OR  Code = 'First-Class Mail International';
UPDATE USPSMethods SET Code = 'Global Express Guaranteed (GXG)**' WHERE Code = 'Global Express Guaranteed (GXG)' OR Code = 'Global Express Guaranteed';

INSERT INTO USPSMethods (Name, Used, Code, Type, Priority)
VALUES ('Express Mail Sunday/Holiday Delivery',0,'Priority Mail Express 1-Day Sunday/Holiday Delivery','Domestic',2);

DELETE FROM USPSMethods WHERE Code = 'Express Mail PO to Addressee';
DELETE FROM USPSMethods WHERE Code = 'Express Mail PO to PO';
DELETE FROM USPSMethods WHERE Code = 'First-Class Mail Flat';
DELETE FROM USPSMethods WHERE Code = 'Priority Mail Flat-Rate Box';
DELETE FROM USPSMethods WHERE Code = 'Bound Printed Matter';
DELETE FROM USPSMethods WHERE Code = 'Express Mail International (EMS) Flat Rate Envelope';
DELETE FROM USPSMethods WHERE Code = 'Priority Mail International Flat Rate Envelope';
DELETE FROM USPSMethods WHERE Code = 'Priority Mail International Flat Rate Box';

INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'AX', 'Aland Islands', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'AQ', 'Antarctica', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'KM', 'Comoros', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'CU', 'Cuba', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'GG', 'Guernsey', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'IQ', 'Iraq', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'JE', 'Jersey', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'ME', 'Madeira', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'TA', 'Tahiti', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'TL', 'Timor Leste', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'UI', 'Union Island', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'VR', 'Virgin Gorda', 1, 0, 0);
INSERT INTO Countries (Abbrev, Name, AllowUPS, Shipping, AddShipAmount) 
VALUES ( 'WL', 'Wales', 1, 0, 0);

UPDATE Countries SET Name = 'Democratic Rep. of Congo' WHERE Abbrev = 'CD';
UPDATE Countries SET Name = 'Congo' WHERE Abbrev = 'CG';
UPDATE Countries SET Name = 'N. Mariana Islands' WHERE Abbrev = 'MP';
UPDATE Countries SET Name = 'Western Samoa' WHERE Abbrev = 'WS';
UPDATE Countries SET Name = 'St. Barthelemy' WHERE Abbrev = 'NT';
UPDATE Countries SET Name = 'St. Croix' WHERE Abbrev = 'SX';
UPDATE Countries SET Name = 'St. John' WHERE Abbrev = 'UV';
UPDATE Countries SET Name = 'St. Thomas' WHERE Abbrev = 'VL';
UPDATE Countries SET Abbrev = 'IE', Name = 'Ireland' WHERE Abbrev = 'IR';
UPDATE Countries SET Name = 'United Kingdom' WHERE Abbrev = 'GB';
UPDATE Countries SET Abbrev = 'CS' WHERE Abbrev = 'YU';

DELETE FROM Countries WHERE Abbrev = 'BL';
DELETE FROM Countries WHERE Abbrev = 'CE';
DELETE FROM Countries WHERE Abbrev = 'CB';
DELETE FROM Countries WHERE Abbrev = 'TP';
DELETE FROM Countries WHERE Abbrev = 'EN';
DELETE FROM Countries WHERE Abbrev = 'YT';
DELETE FROM Countries WHERE Abbrev = 'NR';
DELETE FROM Countries WHERE Abbrev = 'NT';
DELETE FROM Countries WHERE Abbrev = 'NU';
DELETE FROM Countries WHERE Abbrev = 'PN';
DELETE FROM Countries WHERE Abbrev = 'ST';
DELETE FROM Countries WHERE Abbrev = 'SO';
DELETE FROM Countries WHERE Abbrev = 'GS';
DELETE FROM Countries WHERE Abbrev = 'PM';
DELETE FROM Countries WHERE Abbrev = 'SD';
DELETE FROM Countries WHERE Abbrev = 'SJ';
DELETE FROM Countries WHERE Abbrev = 'TK';
DELETE FROM Countries WHERE Abbrev = 'UM';
DELETE FROM Countries WHERE Abbrev = 'SU';
DELETE FROM Countries WHERE Abbrev = 'EH';
DELETE FROM Countries WHERE Abbrev = 'ZR';

INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (270, 'AF', 'Afghanistan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (271, 'FM', 'Micronesia, Federated States');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (272, 'PR', 'Puerto Rico');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (273, 'AM', 'Armenia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (274, 'AO', 'Angola');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (275, 'AQ', 'Antarctica');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (276, 'AZ', 'Azerbaijan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (277, 'AO', 'Angola');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (278, 'BT', 'Bhutan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (279, 'BV', 'Bouvet Island');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (280, 'CC', 'Cocos (Keeling) Islands');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (281, 'CU', 'Cuba');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (282, 'CX', 'Christmas Island');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (283, 'EH', 'Western Sahara');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (284, 'FK', 'Falkland Islands');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (285, 'FM', 'Micronesia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (286, 'FX', 'France, Metropolitan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (287, 'GS', 'South Georgia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (288, 'HM', 'Heard & McDonald Islands');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (289, 'IO', 'British Indian Ocean Territory');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (290, 'IQ', 'Iraq');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (291, 'KM', 'Comoros');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (292, 'MN', 'Mongolia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (293, 'NR', 'Nauru');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (294, 'NU', 'Niue');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (295, 'SD', 'Sudan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (296, 'SH', 'St. Helena');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (297, 'SJ', 'Svalbard & Jan Mayen Islands');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (298, 'SM', 'San Marino');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (299, 'SO', 'Somalia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (300, 'ST', 'Sao Tome & Principe');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (301, 'TF', 'French Southern Territories');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (302, 'TK', 'Tokelau');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (303, 'TM', 'Turkmenistan');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (304, 'TP', 'East Timor');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (305, 'UM', 'United States Minor Outlying Islands');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (306, 'VA', 'Vatican City State');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (307, 'YE', 'Yemen');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (308, 'YT', 'Mayotte');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (309, 'YU', 'Yugoslavia');
INSERT INTO USPSCountries (ID, Abbrev, Name) 
VALUES (310, 'ZR', 'Zaire');

UPDATE USPSCountries SET Name = 'American Samoa' WHERE Abbrev = 'AS';
UPDATE USPSCountries SET Name = 'Guam' WHERE Abbrev = 'GU';
UPDATE USPSCountries SET Name = 'Marshall Islands' WHERE Abbrev = 'MH';
UPDATE USPSCountries SET Name = 'Northern Mariana Islands' WHERE Abbrev = 'MP';
UPDATE USPSCountries SET Name = 'Palau' WHERE Abbrev = 'PW';
UPDATE USPSCountries SET Name = 'Congo' WHERE Abbrev = 'CG';
UPDATE USPSCountries SET Name = 'Cook Islands' WHERE Abbrev = 'CK';
UPDATE USPSCountries SET Name = 'United Kingdom (Great Britain)' WHERE Abbrev = 'CK';
UPDATE USPSCountries SET Name = 'St. Kitts and Nevis' WHERE Abbrev = 'KN';
UPDATE USPSCountries SET Name = 'Kosrae' WHERE Abbrev = 'KO';
UPDATE USPSCountries SET Name = 'Lao People''s Democratic Republic' WHERE Abbrev = 'LA';
UPDATE USPSCountries SET Name = 'Monaco' WHERE Abbrev = 'MC';
UPDATE USPSCountries SET Name = 'Madeira' WHERE Abbrev = 'ME';
UPDATE USPSCountries SET Name = 'Myanmar' WHERE Abbrev = 'MM';
UPDATE USPSCountries SET Name = 'Norfolk Island' WHERE Abbrev = 'NF';
UPDATE USPSCountries SET Name = 'Ponape' WHERE Abbrev = 'PO';
UPDATE USPSCountries SET Name = 'Rota' WHERE Abbrev = 'RT';
UPDATE USPSCountries SET Name = 'Russian Federation' WHERE Abbrev = 'RU';
UPDATE USPSCountries SET Name = 'Slovakia' WHERE Abbrev = 'SK';
UPDATE USPSCountries SET Name = 'Saipan' WHERE Abbrev = 'SP';
UPDATE USPSCountries SET Name = 'Saba' WHERE Abbrev = 'SS';
UPDATE USPSCountries SET Name = 'Taiwan' WHERE Abbrev = 'TA';
UPDATE USPSCountries SET Name = 'St. Martin' WHERE Abbrev = 'TB';
UPDATE USPSCountries SET Name = 'Truk' WHERE Abbrev = 'TU';
UPDATE USPSCountries SET Name = 'St. John' WHERE Abbrev = 'UV';
UPDATE USPSCountries SET Name = 'U.S. Virgin Islands' WHERE Abbrev = 'VI';
UPDATE USPSCountries SET Name = 'Wales' WHERE Abbrev = 'WL';
UPDATE USPSCountries SET Name = 'Yap' WHERE Abbrev = 'YA';

DELETE FROM USPSCountries WHERE Abbrev = 'AP';
DELETE FROM USPSCountries WHERE Abbrev = 'BL';
DELETE FROM USPSCountries WHERE Abbrev = 'CE';
DELETE FROM USPSCountries WHERE Abbrev = 'EN';
DELETE FROM USPSCountries WHERE Abbrev = 'EU';
DELETE FROM USPSCountries WHERE Abbrev = 'MB';
DELETE FROM USPSCountries WHERE Abbrev = 'NB';
DELETE FROM USPSCountries WHERE Abbrev = 'NN';
DELETE FROM USPSCountries WHERE Abbrev = 'NT';
DELETE FROM USPSCountries WHERE Abbrev = 'SF';
DELETE FROM USPSCountries WHERE Abbrev = 'VL';
DELETE FROM USPSCountries WHERE Abbrev = 'WK';


-- Turn safe updates on 
SET SQL_SAFE_UPDATES=1; 
