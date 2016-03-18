
---- Table structure for table `AccessKeys` 
----

CREATE TABLE 	[AccessKeys] (
				[AccessKey_ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(50) NOT NULL,
				[Keyring] NVARCHAR(50) NULL,
				[System] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [AccessKeys_PK]  PRIMARY KEY  CLUSTERED  ([AccessKey_ID])
				); 

---- Table structure for table `Account` 
----

CREATE TABLE 	[Account] (
				[Account_ID] INT IDENTITY(1,1) ,
				[User_ID] INT NULL  DEFAULT 0,
				[Customer_ID] INT NOT NULL  DEFAULT 0,
				[Account_Name] NVARCHAR(50) NOT NULL,
				[Type1] NVARCHAR(50) NOT NULL,
				[Description] NTEXT NULL,
				[Policy] NTEXT NULL,
				[Logo] NVARCHAR(50) NULL,
				[Rep] NVARCHAR(50) NULL,
				[Terms] NVARCHAR(50) NULL,
				[LastUsed] DATETIME NULL,
				[Directory_Live] BIT NOT NULL  DEFAULT 0,
				[Web_URL] NVARCHAR(75) NULL,
				[Dropship_Email] NVARCHAR(100) NULL,
				[PO_Text] NVARCHAR(50) NULL,
				[Map_URL] NTEXT NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Account_PK]  PRIMARY KEY  CLUSTERED  ([Account_ID])
				); 
 CREATE  INDEX [Account_Account_Customer_ID_Idx] ON [Account] ([Customer_ID]);
 CREATE  INDEX [Account_Account_ID_Tag_Idx] ON [Account] ([ID_Tag]);
 CREATE  INDEX [Account_Account_User_ID_Idx] ON [Account] ([User_ID]);

---- Table structure for table `Affiliates` 
----

CREATE TABLE 	[Affiliates] (
				[Affiliate_ID] INT IDENTITY(1,1) ,
				[AffCode] INT NOT NULL  DEFAULT 0,
				[AffPercent] FLOAT NOT NULL  DEFAULT 0,
				[Aff_Site] NVARCHAR(255) NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Affiliates_PK]  PRIMARY KEY  CLUSTERED  ([Affiliate_ID])
				); 
 CREATE  INDEX [Affiliates_Affiliates_AffCode_Idx] ON [Affiliates] ([AffCode]);
 CREATE  INDEX [Affiliates_Affiliates_ID_Tag_Idx] ON [Affiliates] ([ID_Tag]);

---- Table structure for table `CCProcess` 
----

CREATE TABLE 	[CCProcess] (
				[ID] INT IDENTITY(1,1) ,
				[CCServer] NVARCHAR(150) NULL,
				[Transtype] NVARCHAR(75) NULL,
				[Username] NVARCHAR(75) NULL,
				[Password] NVARCHAR(75) NULL,
				[Setting1] NVARCHAR(75) NULL,
				[Setting2] NVARCHAR(75) NULL,
				[Setting3] NVARCHAR(75) NULL,
				CONSTRAINT [CCProcess_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `Customers` 
----

CREATE TABLE 	[Customers] (
				[Customer_ID] INT IDENTITY(1,1) ,
				[User_ID] INT NOT NULL  DEFAULT 0,
				[FirstName] NVARCHAR(50) NOT NULL,
				[LastName] NVARCHAR(150) NOT NULL,
				[Company] NVARCHAR(150) NULL,
				[Address1] NVARCHAR(150) NOT NULL,
				[Address2] NVARCHAR(150) NULL,
				[City] NVARCHAR(150) NOT NULL,
				[County] NVARCHAR(50) NULL,
				[State] NVARCHAR(50) NOT NULL,
				[State2] NVARCHAR(50) NULL,
				[Zip] NVARCHAR(50) NOT NULL,
				[Country] NVARCHAR(50) NOT NULL,
				[Phone] NVARCHAR(50) NULL,
				[Phone2] NVARCHAR(50) NULL,
				[Fax] NVARCHAR(50) NULL,
				[Email] NVARCHAR(150) NULL,
				[Residence] BIT NOT NULL  DEFAULT 1,
				[LastUsed] DATETIME NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Customers_PK]  PRIMARY KEY  CLUSTERED  ([Customer_ID])
				); 
 CREATE  INDEX [Customers_Customers_ID_Tag_Idx] ON [Customers] ([ID_Tag]);
 CREATE  INDEX [Customers_Customers_User_ID_Idx] ON [Customers] ([User_ID]);

---- Table structure for table `Discounts` 
----

CREATE TABLE 	[Discounts] (
				[Discount_ID] INT IDENTITY(1,1) ,
				[Type1] INT NOT NULL  DEFAULT 1,
				[Type2] INT NOT NULL  DEFAULT 1,
				[Type3] INT NOT NULL  DEFAULT 0,
				[Type4] INT NOT NULL  DEFAULT 0,
				[Type5] INT NOT NULL  DEFAULT 0,
				[Coup_Code] NVARCHAR(50) NULL,
				[OneTime] BIT NOT NULL  DEFAULT 0,
				[Name] NVARCHAR(255) NOT NULL,
				[Display] NVARCHAR(255) NULL,
				[Amount] FLOAT NOT NULL  DEFAULT 0,
				[MinOrder] FLOAT NOT NULL  DEFAULT 0,
				[MaxOrder] FLOAT NOT NULL  DEFAULT 0,
				[StartDate] DATETIME NULL,
				[EndDate] DATETIME NULL,
				[AccessKey] INT NULL  DEFAULT 0,
				CONSTRAINT [Discounts_PK]  PRIMARY KEY  CLUSTERED  ([Discount_ID])
				); 
 CREATE  INDEX [Discounts_Discounts_AccessKey_Idx] ON [Discounts] ([AccessKey]);
 CREATE  INDEX [Discounts_Discounts_Coup_Code_Idx] ON [Discounts] ([Coup_Code]);

---- Table structure for table `Users` 
----

CREATE TABLE 	[Users] (
				[User_ID] INT IDENTITY(1,1) ,
				[Username] NVARCHAR(50) NOT NULL,
				[Password] NVARCHAR(50) NOT NULL,
				[Email] NVARCHAR(50) NULL,
				[EmailIsBad] BIT NOT NULL  DEFAULT 0,
				[EmailLock] NVARCHAR(50) NULL,
				[Subscribe] BIT NOT NULL  DEFAULT 0,
				[Customer_ID] INT NOT NULL  DEFAULT 0,
				[ShipTo] INT NOT NULL  DEFAULT 0,
				[Group_ID] INT NOT NULL  DEFAULT 0,
				[Account_ID] INT NULL  DEFAULT 0,
				[Affiliate_ID] INT NULL  DEFAULT 0,
				[Basket] NVARCHAR(30) NULL,
				[Birthdate] DATETIME NULL,
				[CardisValid] BIT NOT NULL  DEFAULT 0,
				[CardType] NVARCHAR(50) NULL,
				[NameonCard] NVARCHAR(75) NULL,
				[CardNumber] NVARCHAR(50) NULL,
				[CardExpire] DATETIME NULL,
				[CardZip] NVARCHAR(50) NULL,
				[EncryptedCard] NVARCHAR(75) NULL,
				[CurrentBalance] INT NULL  DEFAULT 0,
				[LastLogin] DATETIME NULL,
				[Permissions] NVARCHAR(255) NULL,
				[AdminNotes] NTEXT NULL,
				[Disable] BIT NOT NULL  DEFAULT 0,
				[LoginsTotal] INT NULL  DEFAULT 0,
				[LoginsDay] INT NULL  DEFAULT 0,
				[FailedLogins] INT NULL  DEFAULT 0,
				[LastAttempt] DATETIME NULL,
				[Created] DATETIME NULL,
				[LastUpdate] DATETIME NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Users_PK]  PRIMARY KEY  CLUSTERED  ([User_ID])
				); 
 CREATE  INDEX [Users_Users_Account_ID_Idx] ON [Users] ([Account_ID]);
 CREATE  INDEX [Users_Users_Affiliate_ID_Idx] ON [Users] ([Affiliate_ID]);
 CREATE  INDEX [Users_Users_Customer_ID_Idx] ON [Users] ([Customer_ID]);
 CREATE  INDEX [Users_Users_Group_ID_Idx] ON [Users] ([Group_ID]);
 CREATE  INDEX [Users_Users_ID_Tag_Idx] ON [Users] ([ID_Tag]);

---- Table structure for table `Certificates` 
----

CREATE TABLE 	[Certificates] (
				[Cert_ID] INT IDENTITY(1,1) ,
				[Cert_Code] NVARCHAR(50) NOT NULL,
				[Cust_Name] NVARCHAR(255) NULL,
				[CertAmount] FLOAT NOT NULL  DEFAULT 0,
				[InitialAmount] FLOAT NULL  DEFAULT 0,
				[StartDate] DATETIME NULL,
				[EndDate] DATETIME NULL,
				[Valid] BIT NOT NULL  DEFAULT 0,
				[Order_No] INT NULL  DEFAULT 0,
				CONSTRAINT [Certificates_PK]  PRIMARY KEY  NONCLUSTERED  ([Cert_ID])
				); 
 CREATE  INDEX [Certificates_Certificates_Cert_Code_Idx] ON [Certificates] ([Cert_Code]);

---- Table structure for table `CatCore` 
----

CREATE TABLE 	[CatCore] (
				[CatCore_ID] INT NOT NULL  DEFAULT 0,
				[Catcore_Name] NVARCHAR(50) NOT NULL,
				[PassParams] NVARCHAR(150) NULL,
				[Template] NVARCHAR(50) NOT NULL,
				[Category] BIT NOT NULL  DEFAULT 0,
				[Products] BIT NOT NULL  DEFAULT 0,
				[Features] BIT NOT NULL  DEFAULT 0,
				[Page] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [CatCore_PK]  PRIMARY KEY  NONCLUSTERED  ([CatCore_ID])
				); 

---- Table structure for table `States` 
----

CREATE TABLE 	[States] (
				[Abb] NVARCHAR(2) NOT NULL,
				[Name] NVARCHAR(50) NOT NULL,
				CONSTRAINT [States_PK]  PRIMARY KEY  CLUSTERED  ([Abb])
				); 

---- Table structure for table `Countries` 
----

CREATE TABLE 	[Countries] (
				[ID] INT IDENTITY(1,1) ,
				[Abbrev] NVARCHAR(2) NOT NULL,
				[Name] NVARCHAR(100) NOT NULL,
				[AllowUPS] BIT NOT NULL  DEFAULT 0,
				[Shipping] INT NOT NULL  DEFAULT 0,
				[AddShipAmount] FLOAT NOT NULL  DEFAULT 0,
				CONSTRAINT [Countries_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 
 CREATE  UNIQUE  INDEX [Countries_Countries_Abbrev_Idx] ON [Countries] ([Abbrev]);
 CREATE  INDEX [Countries_Countries_Shipping_Idx] ON [Countries] ([Shipping]);

---- Table structure for table `TaxCodes` 
----

CREATE TABLE 	[TaxCodes] (
				[Code_ID] INT IDENTITY(1,1) ,
				[CodeName] NVARCHAR(50) NOT NULL,
				[DisplayName] NVARCHAR(50) NULL,
				[CalcOrder] INT NULL  DEFAULT 0,
				[Cumulative] BIT NOT NULL  DEFAULT 0,
				[TaxAddress] NVARCHAR(25) NULL,
				[TaxAll] BIT NOT NULL  DEFAULT 0,
				[TaxRate] FLOAT NULL  DEFAULT 0,
				[TaxShipping] BIT NOT NULL  DEFAULT 0,
				[ShowonProds] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [TaxCodes_PK]  PRIMARY KEY  CLUSTERED  ([Code_ID])
				); 

---- Table structure for table `CreditCards` 
----

CREATE TABLE 	[CreditCards] (
				[ID] INT IDENTITY(1,1) ,
				[CardName] NVARCHAR(50) NOT NULL,
				[Used] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [CreditCards_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `CustomMethods` 
----

CREATE TABLE 	[CustomMethods] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(50) NULL,
				[Amount] FLOAT NOT NULL  DEFAULT 0,
				[Used] BIT NOT NULL  DEFAULT 0,
				[Priority] INT NULL  DEFAULT 0,
				[Domestic] BIT NOT NULL  DEFAULT 0,
				[International] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [CustomMethods_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 
 CREATE  INDEX [CustomMethods_CustomMethods_Used_Idx] ON [CustomMethods] ([Used]);

---- Table structure for table `CustomShipSettings` 
----

CREATE TABLE 	[CustomShipSettings] (
				[Setting_ID] INT IDENTITY(1,1) ,
				[ShowShipTable] BIT NOT NULL  DEFAULT 0,
				[MultPerItem] BIT NOT NULL  DEFAULT 0,
				[CumulativeAmounts] BIT NOT NULL  DEFAULT 0,
				[MultMethods] BIT NOT NULL  DEFAULT 0,
				[Debug] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [CustomShipSettings_PK]  PRIMARY KEY  CLUSTERED  ([Setting_ID])
				); 

---- Table structure for table `Order_No` 
----

CREATE TABLE 	[Order_No] (
				[Order_No] INT IDENTITY(1,1) ,
				[Filled] BIT NOT NULL  DEFAULT 0,
				[Process] BIT NOT NULL  DEFAULT 0,
				[Void] BIT NULL  DEFAULT 0,
				[InvDone] BIT NOT NULL  DEFAULT 0,
				[Customer_ID] INT NOT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				[Card_ID] INT NULL  DEFAULT 0,
				[ShipTo] INT NULL  DEFAULT 0,
				[DateOrdered] DATETIME NOT NULL,
				[OrderTotal] FLOAT NOT NULL  DEFAULT 0,
				[Tax] FLOAT NOT NULL  DEFAULT 0,
				[ShipType] NVARCHAR(75) NULL,
				[Shipping] FLOAT NOT NULL  DEFAULT 0,
				[Freight] INT NOT NULL  DEFAULT 0,
				[Comments] NVARCHAR(255) NULL,
				[AuthNumber] NVARCHAR(50) NULL,
				[InvoiceNum] NVARCHAR(75) NULL,
				[TransactNum] NVARCHAR(50) NULL,
				[Shipper] NVARCHAR(50) NULL,
				[Tracking] NVARCHAR(255) NULL,
				[Giftcard] NVARCHAR(255) NULL,
				[Delivery] NVARCHAR(50) NULL,
				[OrderDisc] FLOAT NOT NULL  DEFAULT 0,
				[Credits] FLOAT NOT NULL  DEFAULT 0,
				[AddonTotal] FLOAT NOT NULL  DEFAULT 0,
				[Coup_Code] NVARCHAR(50) NULL,
				[Cert_Code] NVARCHAR(50) NULL,
				[Affiliate] INT NULL,
				[Referrer] NVARCHAR(255) NULL,
				[CustomText1] NVARCHAR(255) NULL,
				[CustomText2] NVARCHAR(255) NULL,
				[CustomText3] NVARCHAR(50) NULL,
				[CustomSelect1] NVARCHAR(100) NULL,
				[CustomSelect2] NVARCHAR(100) NULL,
				[DateFilled] DATETIME NULL,
				[PayPalStatus] NVARCHAR(30) NULL,
				[Reason] NTEXT NULL,
				[OfflinePayment] NVARCHAR(50) NULL,
				[PO_Number] NVARCHAR(30) NULL,
				[Notes] NTEXT NULL,
				[Admin_Updated] DATETIME NULL,
				[Admin_Name] NVARCHAR(50) NULL,
				[AdminCredit] FLOAT NOT NULL  DEFAULT 0,
				[AdminCreditText] NVARCHAR(50) NULL,
				[Printed] INT NOT NULL  DEFAULT 0,
				[Status] NVARCHAR(50) NULL,
				[Paid] BIT NOT NULL  DEFAULT 0,
				[CodesSent] BIT NOT NULL  DEFAULT 0,
				[ID_Tag] NVARCHAR(35) NULL,
				[TermsUsed] NTEXT NULL,
				[OriginalTotal] FLOAT NOT NULL  DEFAULT 0,
				[LastTransactNum] NVARCHAR(50) NULL,
				CONSTRAINT [Order_No_PK]  PRIMARY KEY  NONCLUSTERED  ([Order_No]), 
				CONSTRAINT [Order_No_Customers_Order_No_FK] FOREIGN KEY ("Customer_ID") REFERENCES "Customers" ( "Customer_ID" ) 
				); 
 CREATE  INDEX [Order_No_Order_No_Coup_Code_Idx] ON [Order_No] ([Coup_Code]);
 CREATE  INDEX [Order_No_Order_No_Customer_ID_Idx] ON [Order_No] ([Customer_ID]);
 CREATE  INDEX [Order_No_Order_No_User_ID_Idx] ON [Order_No] ([User_ID]);
 CREATE  INDEX [Order_No_Order_No_ID_Tag_Idx] ON [Order_No] ([ID_Tag]);

---- Table structure for table `Colors` 
----

CREATE TABLE 	[Colors] (
				[Color_ID] INT IDENTITY(1,1) ,
				[Bgcolor] NVARCHAR(10) NULL,
				[Bgimage] NVARCHAR(100) NULL,
				[MainTitle] NVARCHAR(10) NULL,
				[MainText] NVARCHAR(10) NULL,
				[MainLink] NVARCHAR(10) NULL,
				[MainVLink] NVARCHAR(10) NULL,
				[BoxHBgcolor] NVARCHAR(10) NULL,
				[BoxHText] NVARCHAR(10) NULL,
				[BoxTBgcolor] NVARCHAR(10) NULL,
				[BoxTText] NVARCHAR(10) NULL,
				[InputHBgcolor] NVARCHAR(10) NULL,
				[InputHText] NVARCHAR(10) NULL,
				[InputTBgcolor] NVARCHAR(10) NULL,
				[InputTText] NVARCHAR(10) NULL,
				[OutputHBgcolor] NVARCHAR(10) NULL,
				[OutputHText] NVARCHAR(10) NULL,
				[OutputTBgcolor] NVARCHAR(10) NULL,
				[OutputTText] NVARCHAR(10) NULL,
				[OutputTAltcolor] NVARCHAR(10) NULL,
				[OutputTHighlight] NVARCHAR(10) NULL,
				[LineColor] NVARCHAR(10) NULL,
				[HotImage] NVARCHAR(50) NULL,
				[SaleImage] NVARCHAR(50) NULL,
				[NewImage] NVARCHAR(50) NULL,
				[MainLineImage] NVARCHAR(50) NULL,
				[MinorLineImage] NVARCHAR(50) NULL,
				[Palette_Name] NVARCHAR(50) NULL,
				[FormReq] NVARCHAR(10) NULL,
				[LayoutFile] NVARCHAR(50) NULL,
				[FormReqOB] NVARCHAR(10) NULL,
				[PassParam] NVARCHAR(100) NULL,
				CONSTRAINT [Colors_PK]  PRIMARY KEY  CLUSTERED  ([Color_ID])
				); 

---- Table structure for table `Groups` 
----

CREATE TABLE 	[Groups] (
				[Group_ID] INT NOT NULL,
				[Name] NVARCHAR(50) NOT NULL,
				[Description] NTEXT NULL,
				[Permissions] NVARCHAR(255) NULL,
				[Wholesale] BIT NOT NULL  DEFAULT 0,
				[Group_Code] NVARCHAR(20) NULL,
				[TaxExempt] BIT NOT NULL  DEFAULT 0,
				[ShipExempt] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Groups_PK]  PRIMARY KEY  NONCLUSTERED  ([Group_ID])
				); 
CREATE  INDEX [Groups_Groups_Name_Idx] ON [Groups] ([Name]);

---- Table structure for table `Products` 
----

CREATE TABLE 	[Products] (
				[Product_ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(255) NOT NULL,
				[Short_Desc] NTEXT NULL,
				[Long_Desc] NTEXT NULL,
				[SKU] NVARCHAR(50) NULL,
				[Vendor_SKU] NVARCHAR(50) NULL,
				[Retail_Price] FLOAT NULL  DEFAULT 0,
				[Base_Price] FLOAT NOT NULL  DEFAULT 0,
				[Wholesale] FLOAT NOT NULL  DEFAULT 0,
				[Dropship_Cost] FLOAT NULL  DEFAULT 0,
				[Weight] FLOAT NULL  DEFAULT 0,
				[Shipping] BIT NOT NULL  DEFAULT 1,
				[TaxCodes] NVARCHAR(50) NULL,
				[AccessKey] INT NULL  DEFAULT 0,
				[Sm_Image] NVARCHAR(100) NULL,
				[Lg_Image] NVARCHAR(255) NULL,
				[Enlrg_Image] NVARCHAR(100) NULL,
				[Sm_Title] NVARCHAR(100) NULL,
				[Lg_Title] NVARCHAR(100) NULL,
				[PassParam] NVARCHAR(100) NULL,
				[Color_ID] INT NULL,
				[Display] BIT NOT NULL  DEFAULT 1,
				[Priority] INT NOT NULL  DEFAULT 9999,
				[NumInStock] INT NULL  DEFAULT 0,
				[ShowOrderBox] BIT NOT NULL  DEFAULT 0,
				[ShowPrice] BIT NOT NULL  DEFAULT 1,
				[ShowDiscounts] BIT NOT NULL  DEFAULT 1,
				[ShowPromotions] BIT NOT NULL  DEFAULT 0,
				[Highlight] BIT NOT NULL  DEFAULT 0,
				[NotSold] BIT NOT NULL  DEFAULT 0,
				[Reviewable] BIT NOT NULL  DEFAULT 0,
				[UseforPOTD] BIT NOT NULL  DEFAULT 0,
				[Sale] BIT NOT NULL  DEFAULT 0,
				[Hot] BIT NOT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				[OptQuant] INT NOT NULL  DEFAULT 0,
				[Reorder_Level] INT NULL  DEFAULT 0,
				[Min_Order] INT NULL  DEFAULT 0,
				[Mult_Min] BIT NOT NULL  DEFAULT 0,
				[Sale_Start] DATETIME NULL,
				[Sale_End] DATETIME NULL,
				[Discounts] NVARCHAR(255) NULL,
				[Promotions] NVARCHAR(255) NULL,
				[Account_ID] INT NULL  DEFAULT 0,
				[Mfg_Account_ID] INT NULL  DEFAULT 0,
				[Prod_Type] NVARCHAR(50) NULL,
				[Content_URL] NVARCHAR(75) NULL,
				[MimeType] NVARCHAR(50) NULL,
				[Access_Count] INT NULL  DEFAULT 0,
				[Num_Days] INT NULL  DEFAULT 0,
				[Access_Keys] NVARCHAR(50) NULL,
				[Recur] BIT NOT NULL  DEFAULT 0,
				[Recur_Product_ID] INT NULL  DEFAULT 0,
				[VertOptions] BIT NOT NULL  DEFAULT 0,
				[Metadescription] NVARCHAR(255) NULL,
				[Keywords] NVARCHAR(255) NULL,
				[TitleTag] NVARCHAR(255) NULL,
				[GiftWrap] BIT NOT NULL  DEFAULT 0,
				[Availability] NVARCHAR(75) NULL,
				[Freight_Dom] FLOAT NULL  DEFAULT 0,
				[Freight_Intl] FLOAT NULL  DEFAULT 0,
				[Pack_Width] FLOAT NULL  DEFAULT 0,
				[Pack_Height] FLOAT NULL  DEFAULT 0,
				[Pack_Length] FLOAT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				[Goog_Brand] NVARCHAR(100) NULL,
				[Goog_Condition] NVARCHAR(100) NULL,
				[Goog_Expire] DATETIME NULL,
				[Goog_Prodtype] NVARCHAR(100) NULL,
				CONSTRAINT [Products_PK]  PRIMARY KEY  CLUSTERED  ([Product_ID]), 
				CONSTRAINT [Products_Colors_Products_FK] FOREIGN KEY ("Color_ID") REFERENCES "Colors" ( "Color_ID" )
				); 
 CREATE  INDEX [Products_Products_AccessKey_Idx] ON [Products] ([AccessKey]);
 CREATE  INDEX [Products_Products_Account_ID_Idx] ON [Products] ([Account_ID]);
 CREATE  INDEX [Products_Products_Highlight_Idx] ON [Products] ([Highlight]);
 CREATE  INDEX [Products_Products_NumInStock_Idx] ON [Products] ([NumInStock]);
 CREATE  INDEX [Products_Products_Recur_Product_ID_Idx] ON [Products] ([Recur_Product_ID]);
 CREATE  INDEX [Products_Products_User_ID_Idx] ON [Products] ([User_ID]);
 CREATE  INDEX [Products_Colors_Products_FK] ON [Products] ([Color_ID]);

---- Table structure for table `Categories` 
----

CREATE TABLE 	[Categories] (
				[Category_ID] INT IDENTITY(1,1) ,
				[Parent_ID] INT NOT NULL  DEFAULT 0,
				[CatCore_ID] INT NOT NULL  DEFAULT 1,
				[Name] NVARCHAR(255) NOT NULL,
				[Short_Desc] NTEXT NULL,
				[Long_Desc] NTEXT NULL,
				[Sm_Image] NVARCHAR(100) NULL,
				[Lg_Image] NVARCHAR(100) NULL,
				[Sm_Title] NVARCHAR(100) NULL,
				[Lg_Title] NVARCHAR(100) NULL,
				[PassParam] NVARCHAR(100) NULL,
				[AccessKey] INT NULL  DEFAULT 0,
				[CColumns] INT NULL,
				[PColumns] INT NULL,
				[Display] BIT NOT NULL  DEFAULT 1,
				[ProdFirst] BIT NOT NULL  DEFAULT 0,
				[Priority] INT NOT NULL  DEFAULT 9999,
				[Highlight] BIT NOT NULL  DEFAULT 0,
				[ParentIDs] NVARCHAR(50) NULL,
				[ParentNames] NVARCHAR(2000) NULL,
				[Sale] BIT NOT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				[Color_ID] INT NULL,
				[Metadescription] NVARCHAR(255) NULL,
				[Keywords] NVARCHAR(255) NULL,
				[TitleTag] NVARCHAR(255) NULL,
				CONSTRAINT [Categories_PK]  PRIMARY KEY  CLUSTERED  ([Category_ID]), 
				CONSTRAINT [Categories_CatCore_Categories_FK] FOREIGN KEY ("CatCore_ID") REFERENCES "CatCore" ( "CatCore_ID" ), 
				CONSTRAINT [Categories_Colors_Categories_FK] FOREIGN KEY ("Color_ID") REFERENCES "Colors" ( "Color_ID" )
); 
 CREATE  INDEX [Categories_Categories_CatCore_ID_Idx] ON [Categories] ([CatCore_ID]);
 CREATE  INDEX [Categories_Category_Color_ID_Idx] ON [Categories] ([Color_ID]);
 CREATE  INDEX [Categories_Category_Parent_ID_Idx] ON [Categories] ([Parent_ID]);
ALTER TABLE [Categories] CHECK CONSTRAINT [Categories_CatCore_Categories_FK];
ALTER TABLE [Categories] CHECK CONSTRAINT [Categories_Colors_Categories_FK];

---- Table structure for table `Features` 
----

CREATE TABLE 	[Features] (
				[Feature_ID] INT IDENTITY(1,1) ,
				[User_ID] INT NULL  DEFAULT 0,
				[Feature_Type] NVARCHAR(50) NULL,
				[Name] NVARCHAR(125) NOT NULL,
				[Author] NVARCHAR(50) NULL,
				[Copyright] NVARCHAR(50) NULL,
				[Display] BIT NOT NULL  DEFAULT 0,
				[Approved] BIT NOT NULL  DEFAULT 0,
				[Start] DATETIME NULL,
				[Expire] DATETIME NULL,
				[Priority] INT NULL  DEFAULT 9999,
				[AccessKey] INT NULL  DEFAULT 0,
				[Highlight] BIT NOT NULL  DEFAULT 0,
				[Display_Title] BIT NOT NULL  DEFAULT 0,
				[Reviewable] BIT NOT NULL  DEFAULT 0,
				[Sm_Title] NVARCHAR(150) NULL,
				[Sm_Image] NVARCHAR(150) NULL,
				[Short_Desc] NTEXT NULL,
				[Lg_Title] NVARCHAR(150) NULL,
				[Lg_Image] NVARCHAR(150) NULL,
				[Long_Desc] NTEXT NULL,
				[PassParam] NVARCHAR(150) NULL,
				[Color_ID] INT NULL,
				[Created] DATETIME NULL,
				[Metadescription] NVARCHAR(255) NULL,
				[Keywords] NVARCHAR(255) NULL,
				[TitleTag] NVARCHAR(255) NULL,
				CONSTRAINT [Features_PK]  PRIMARY KEY  NONCLUSTERED  ([Feature_ID]), 
				CONSTRAINT [Features_Colors_Features_FK] FOREIGN KEY ("Color_ID") REFERENCES "Colors" ( "Color_ID" ), 
				CONSTRAINT [Features_Users_Features_FK] FOREIGN KEY ("User_ID") REFERENCES "Users" ( "User_ID" ) 
				); 
 CREATE  INDEX [Features_Features_AccessKey_Idx] ON [Features] ([AccessKey]);
 CREATE  INDEX [Features_Features_Color_ID_Idx] ON [Features] ([Color_ID]);
 CREATE  INDEX [Features_Features_User_ID_Idx] ON [Features] ([User_ID]);

---- Table structure for table `Feature_Item` 
----

CREATE TABLE 	[Feature_Item] (
				[Feature_Item_ID] INT IDENTITY(1,1) ,
				[Feature_ID] INT NOT NULL,
				[Item_ID] INT NOT NULL,
				CONSTRAINT [Feature_Item_PK]  PRIMARY KEY  CLUSTERED  ([Feature_Item_ID]), 
				CONSTRAINT [Feature_Item_Features_Feature_Item_FK] FOREIGN KEY ("Feature_ID") REFERENCES "Features" ( "Feature_ID" ), 
				CONSTRAINT [Feature_Item_Features_Feature_Item_FK_2] FOREIGN KEY ("Item_ID") REFERENCES "Features" ( "Feature_ID" )
				); 
 CREATE  INDEX [Feature_Item_Feature_Item_Feature_ID_Idx] ON [Feature_Item] ([Feature_ID]);
 CREATE  INDEX [Feature_Item_Feature_Item_Item_ID_Idx] ON [Feature_Item] ([Item_ID]);

---- Table structure for table `Feature_Product` 
----

CREATE TABLE 	[Feature_Product] (
				[Feature_Product_ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[Feature_ID] INT NOT NULL,
				CONSTRAINT [Feature_Product_PK]  PRIMARY KEY  CLUSTERED  ([Feature_Product_ID]), 
				CONSTRAINT [Feature_Product_Features_Feature_Product_FK] FOREIGN KEY ("Feature_ID") REFERENCES "Features" ( "Feature_ID" ), 
				CONSTRAINT [Feature_Product_Products_Feature_Product_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" ) 
				); 
 CREATE  INDEX [Feature_Product_Feature_Product_Feature_ID_Idx] ON [Feature_Product] ([Feature_ID]);
 CREATE  INDEX [Feature_Product_Feature_Product_Product_ID_Idx] ON [Feature_Product] ([Product_ID]);
---- Table structure for table `Feature_Category` 
----

CREATE TABLE 	[Feature_Category] (
				[Feature_Category_ID] INT IDENTITY(1,1) ,
				[Feature_ID] INT NOT NULL,
				[Category_ID] INT NOT NULL,
				CONSTRAINT [Feature_Category_PK]  PRIMARY KEY  CLUSTERED  ([Feature_Category_ID]), 
				CONSTRAINT [Feature_Category_Categories_Feature_Category_FK] FOREIGN KEY ("Category_ID") REFERENCES "Categories" ( "Category_ID" ), 
				CONSTRAINT [Feature_Category_Features_Feature_Category_FK] FOREIGN KEY ("Feature_ID") REFERENCES "Features" ( "Feature_ID" ) 
				); 
 CREATE  INDEX [Feature_Category_Feature_Category_Category_ID_Idx] ON [Feature_Category] ([Category_ID]);
 CREATE  INDEX [Feature_Category_Feature_Category_Feature_ID_Idx] ON [Feature_Category] ([Feature_ID]);

---- Table structure for table `Product_Category` 
----

CREATE TABLE 	[Product_Category] (
				[ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[Category_ID] INT NOT NULL,
				CONSTRAINT [Product_Category_PK]  PRIMARY KEY  NONCLUSTERED  ([ID]), 
				CONSTRAINT [Product_Category_Categories_Product_Category_FK] FOREIGN KEY ("Category_ID") REFERENCES "Categories" ( "Category_ID" ), 
				CONSTRAINT [Product_Category_Products_Product_Category_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [Product_Category_Product_Category_Category_ID_Idx] ON [Product_Category] ([Category_ID]);
 CREATE  INDEX [Product_Category_Product_Category_Product_ID_Idx] ON [Product_Category] ([Product_ID]);

---- Table structure for table `FedExMethods` 
----

CREATE TABLE 	[FedExMethods] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(75) NULL,
				[Used] BIT NOT NULL  DEFAULT 0,
				[Shipper] NVARCHAR(10) NULL,
				[Code] NVARCHAR(75) NULL,
				[Priority] INT NULL  DEFAULT 0,CONSTRAINT [FedExMethods_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 
 CREATE  INDEX [FedExMethods_FedExMethods_Code_Idx] ON [FedExMethods] ([Code]);
 CREATE  INDEX [FedExMethods_FedExMethods_Used_Idx] ON [FedExMethods] ([Used]);

---- Table structure for table `FedEx_Dropoff` 
----

CREATE TABLE 	[FedEx_Dropoff] (
				[FedEx_Code] NVARCHAR(30) NOT NULL,
				[Description] NVARCHAR(50) NULL,
				CONSTRAINT [FedEx_Dropoff_PK]  PRIMARY KEY  CLUSTERED  ([FedEx_Code])
				); 

---- Table structure for table `FedEx_Packaging` 
----

CREATE TABLE 	[FedEx_Packaging] (
				[FedEx_Code] NVARCHAR(20) NOT NULL,
				[Description] NVARCHAR(50) NULL,
				CONSTRAINT [FedEx_Packaging_PK]  PRIMARY KEY  CLUSTERED  ([FedEx_Code])
				); 

---- Table structure for table `FedEx_Settings` 
----

CREATE TABLE 	[FedEx_Settings] (
				[Fedex_ID] INT IDENTITY(1,1) ,
				[AccountNo] NVARCHAR(20) NULL,
				[MeterNum] NVARCHAR(20) NULL,
				[MaxWeight] INT NULL  DEFAULT 0,
				[UnitsofMeasure] NVARCHAR(20) NULL,
				[Dropoff] NVARCHAR(20) NULL,
				[Packaging] NVARCHAR(20) NULL,
				[OrigZip] NVARCHAR(20) NULL,
				[OrigState] NVARCHAR(75) NULL,
				[OrigCountry] NVARCHAR(10) NULL,
				[Debug] BIT NOT NULL  DEFAULT 0,
				[UseGround] BIT NOT NULL  DEFAULT 0,
				[UseExpress] BIT NOT NULL  DEFAULT 0,
				[Logging] BIT NOT NULL  DEFAULT 0,
				[UserKey] NVARCHAR(75) NULL,
				[Password] NVARCHAR(75) NULL,
				[UseSmartPost] BIT NOT NULL  DEFAULT 0,
				[AddInsurance] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [FedEx_Settings_PK]  PRIMARY KEY  CLUSTERED  ([Fedex_ID])
				); 

---- Table structure for table `GiftRegistry` 
----

CREATE TABLE 	[GiftRegistry] (
				[GiftRegistry_ID] INT IDENTITY(1,1) ,
				[User_ID] INT NOT NULL  DEFAULT 0,
				[Registrant] NVARCHAR(75) NULL,
				[OtherName] NVARCHAR(50) NULL,
				[GiftRegistry_Type] NVARCHAR(50) NULL,
				[Event_Date] DATETIME NULL,
				[Event_Name] NVARCHAR(50) NULL,
				[Event_Descr] NVARCHAR(255) NULL,
				[Private] BIT NOT NULL  DEFAULT 0,
				[Order_Notification] BIT NOT NULL  DEFAULT 0,
				[Live] BIT NOT NULL  DEFAULT 0,
				[Approved] BIT NOT NULL  DEFAULT 0,
				[City] NVARCHAR(150) NULL,
				[State] NVARCHAR(50) NULL,
				[Created] DATETIME NULL,
				[Expire] DATETIME NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [GiftRegistry_PK]  PRIMARY KEY  CLUSTERED  ([GiftRegistry_ID]), 
				CONSTRAINT [GiftRegistry_Users_GiftRegistry_FK] FOREIGN KEY ("User_ID") REFERENCES "Users" ( "User_ID" )
				); 
 CREATE  INDEX [GiftRegistry_GiftRegistry_User_ID_Idx] ON [GiftRegistry] ([User_ID]);
 CREATE  INDEX [GiftRegistry_GiftRegistry_ID_Tag_Idx] ON [GiftRegistry] ([ID_Tag]);
ALTER TABLE [GiftRegistry] CHECK CONSTRAINT [GiftRegistry_Users_GiftRegistry_FK];

---- Table structure for table `GiftItems` 
----

CREATE TABLE 	[GiftItems] (
				[GiftItem_ID] INT IDENTITY(1,1) ,
				[GiftRegistry_ID] INT NOT NULL,
				[Product_ID] INT NOT NULL  DEFAULT 0,
				[Options] NTEXT NULL,
				[Addons] NTEXT NULL,
				[AddonMultP] FLOAT NULL  DEFAULT 0,
				[AddonNonMultP] FLOAT NULL  DEFAULT 0,
				[AddonMultW] FLOAT NULL  DEFAULT 0,
				[AddonNonMultW] FLOAT NULL  DEFAULT 0,
				[OptPrice] FLOAT NOT NULL  DEFAULT 0,
				[OptWeight] FLOAT NOT NULL  DEFAULT 0,
				[OptQuant] INT NOT NULL  DEFAULT 0,
				[OptChoice] INT NOT NULL  DEFAULT 0,
				[OptionID_List] NVARCHAR(255) NULL,
				[ChoiceID_List] NVARCHAR(255) NULL,
				[SKU] NVARCHAR(100) NULL,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				[Weight] FLOAT NOT NULL  DEFAULT 0,
				[Quantity_Requested] INT NOT NULL  DEFAULT 0,
				[Quantity_Purchased] INT NOT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				CONSTRAINT [GiftItems_PK]  PRIMARY KEY  CLUSTERED  ([GiftItem_ID]), 
				CONSTRAINT [GiftItems_GiftRegistry_GiftItems_FK] FOREIGN KEY ("GiftRegistry_ID") REFERENCES "GiftRegistry" ( "GiftRegistry_ID" ), 
				CONSTRAINT [GiftItems_Products_GiftItems_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [GiftItems_GiftItems_GiftRegistry_ID_Idx] ON [GiftItems] ([GiftRegistry_ID]);
 CREATE  INDEX [GiftItems_GiftItems_Product_ID_Idx] ON [GiftItems] ([Product_ID]);

---- Table structure for table `Giftwrap` 
----

CREATE TABLE 	[Giftwrap] (
				[Giftwrap_ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(60) NOT NULL,
				[Short_Desc] NTEXT NULL,
				[Sm_Image] NVARCHAR(150) NULL,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				[Weight] FLOAT NOT NULL  DEFAULT 0,
				[Priority] INT NOT NULL  DEFAULT 0,
				[Display] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Giftwrap_PK]  PRIMARY KEY  CLUSTERED  ([Giftwrap_ID])
				); 

---- Table structure for table `ProdGrpPrice` 
----

CREATE TABLE 	[ProdGrpPrice] (
				[Product_ID] INT NOT NULL,
				[GrpPrice_ID] INT NOT NULL,
				[Group_ID] INT NOT NULL,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				CONSTRAINT [ProdGrpPrice_PK]  PRIMARY KEY  CLUSTERED  ([Product_ID],[GrpPrice_ID]), 
				CONSTRAINT [ProdGrpPrice_Groups_ProdGrpPrice_FK] FOREIGN KEY ("Group_ID") REFERENCES "Groups" ( "Group_ID" ), 
				CONSTRAINT [ProdGrpPrice_Products_ProdGrpPrice_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [ProdGrpPrice_ProdGrpPrice_Group_ID_Idx] ON [ProdGrpPrice] ([Group_ID]);
 CREATE  INDEX [ProdGrpPrice_ProdGrpPrice_Product_ID_Idx] ON [ProdGrpPrice] ([Product_ID]);

---- Table structure for table `IntShipTypes` 
----

CREATE TABLE 	[IntShipTypes] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(50) NOT NULL,
				[Used] BIT NOT NULL  DEFAULT 0,
				[Code] NVARCHAR(10) NOT NULL,
				[Priority] INT NULL  DEFAULT 0,
				CONSTRAINT [IntShipTypes_PK]  PRIMARY KEY  NONCLUSTERED  ([ID])
				); 

---- Table structure for table `Intershipper` 
----

CREATE TABLE 	[Intershipper] (
				[ID] INT IDENTITY(1,1) ,
				[Password] NVARCHAR(50) NULL,
				[Residential] BIT NOT NULL  DEFAULT 0,
				[Pickup] NVARCHAR(5) NOT NULL,
				[UnitsofMeasure] NVARCHAR(10) NOT NULL,
				[MaxWeight] INT NULL  DEFAULT 0,
				[Carriers] NVARCHAR(50) NOT NULL,
				[UserID] NVARCHAR(100) NULL,
				[Classes] NVARCHAR(100) NULL,
				[MerchantZip] NVARCHAR(20) NULL,
				[Logging] BIT NOT NULL  DEFAULT 0,
				[Debug] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Intershipper_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `LocalTax` 
----

CREATE TABLE 	[LocalTax] (
				[Local_ID] INT IDENTITY(1,1) ,
				[Code_ID] INT NOT NULL  DEFAULT 0,
				[ZipCode] NVARCHAR(20) NOT NULL,
				[Tax] FLOAT NOT NULL  DEFAULT 0,
				[EndZip] NVARCHAR(20) NULL,
				[TaxShip] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [LocalTax_PK]  PRIMARY KEY  CLUSTERED  ([Local_ID]), 
				CONSTRAINT [LocalTax_TaxCodes_LocalTax_FK] FOREIGN KEY ("Code_ID") REFERENCES "TaxCodes" ( "Code_ID" )
				); 
 CREATE  INDEX [LocalTax_LocalTax_Code_ID_Idx] ON [LocalTax] ([Code_ID]);
 CREATE  INDEX [LocalTax_LocalTax_ZipCode_Idx] ON [LocalTax] ([ZipCode]);
 
---- Table structure for table `Locales` 
----

CREATE TABLE 	[Locales] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(30) NOT NULL,
				[CurrExchange] NVARCHAR(50) NULL,
				CONSTRAINT [Locales_PK]  PRIMARY KEY  NONCLUSTERED  ([ID])
				); 
 CREATE  UNIQUE  INDEX [Locales_Locales_Name_Idx] ON [Locales] ([Name]);

---- Table structure for table `MailText` 
----

CREATE TABLE 	[MailText] (
				[MailText_ID] INT IDENTITY(1,1) ,
				[MailText_Name] NVARCHAR(50) NULL,
				[MailText_Message] NTEXT NULL,
				[MailText_Subject] NVARCHAR(75) NULL,
				[MailText_Attachment] NVARCHAR(255) NULL,
				[System] BIT NOT NULL  DEFAULT 0,
				[MailAction] NVARCHAR(50) NULL,
				CONSTRAINT [MailText_PK]  PRIMARY KEY  NONCLUSTERED  ([MailText_ID])
				); 

---- Table structure for table `Memberships` 
----

CREATE TABLE 	[Memberships] (
				[Membership_ID] INT IDENTITY(1,1) ,
				[User_ID] INT NULL  DEFAULT 0,
				[Order_ID] INT NULL,
				[Product_ID] INT NULL  DEFAULT 0,
				[Membership_Type] NVARCHAR(50) NULL,
				[AccessKey_ID] NVARCHAR(50) NULL,
				[Start] DATETIME NULL,
				[Time_Count] INT NULL  DEFAULT 0,
				[Access_Count] INT NULL  DEFAULT 0,
				[Expire] DATETIME NULL,
				[Valid] BIT NOT NULL  DEFAULT 0,
				[Date_Ordered] DATETIME NULL,
				[Access_Used] INT NULL  DEFAULT 0,
				[Recur] BIT NOT NULL  DEFAULT 0,
				[Recur_Product_ID] INT NULL  DEFAULT 0,
				[Suspend_Begin_Date] DATETIME NULL,
				[Next_Membership_ID] INT NULL  DEFAULT 0,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Memberships_PK]  PRIMARY KEY  CLUSTERED  ([Membership_ID]), 
				CONSTRAINT [Memberships_Users_Memberships_FK] FOREIGN KEY ("User_ID") REFERENCES "Users" ( "User_ID" )
				); 
 CREATE  INDEX [Memberships_Memberships_AccessKey_ID_Idx] ON [Memberships] ([AccessKey_ID]);
 CREATE  INDEX [Memberships_Memberships_Next_Membership_ID_Idx] ON [Memberships] ([Next_Membership_ID]);
 CREATE  INDEX [Memberships_Memberships_Recur_Product_ID_Idx] ON [Memberships] ([Recur_Product_ID]);
 CREATE  INDEX [Memberships_Memberships_User_ID_Idx] ON [Memberships] ([User_ID]);
 CREATE  INDEX [Memberships_Memberships_ID_Tag_Idx] ON [Memberships] ([ID_Tag]);

---- Table structure for table `OrderSettings` 
----

CREATE TABLE 	[OrderSettings] (
				[ID] INT IDENTITY(1,1) ,
				[AllowInt] BIT NOT NULL  DEFAULT 0,
				[AllowOffline] BIT NOT NULL  DEFAULT 0,
				[OnlyOffline] BIT NOT NULL  DEFAULT 0,
				[OfflineMessage] NTEXT NULL,
				[CCProcess] NVARCHAR(50) NULL,
				[AllowPO] BIT NOT NULL  DEFAULT 0,
				[EmailAdmin] BIT NOT NULL  DEFAULT 0,
				[EmailUser] BIT NOT NULL  DEFAULT 0,
				[EmailAffs] BIT NOT NULL  DEFAULT 0,
				[EmailDrop] BIT NOT NULL  DEFAULT 0,
				[OrderEmail] NVARCHAR(100) NULL,
				[DropEmail] NVARCHAR(100) NULL,
				[EmailDropWhen] NVARCHAR(15) NOT NULL,
				[Giftcard] BIT NOT NULL  DEFAULT 0,
				[Delivery] BIT NOT NULL  DEFAULT 0,
				[Coupons] BIT NOT NULL  DEFAULT 0,
				[Backorders] BIT NOT NULL  DEFAULT 0,
				[BaseOrderNum] INT NOT NULL  DEFAULT 0,
				[StoreCardInfo] BIT NOT NULL  DEFAULT 0,
				[UseCVV2] BIT NOT NULL  DEFAULT 0,
				[MinTotal] INT NOT NULL  DEFAULT 0,
				[NoGuests] BIT NOT NULL  DEFAULT 0,
				[UseBilling] BIT NOT NULL  DEFAULT 0,
				[UsePayPal] BIT NOT NULL  DEFAULT 0,
				[PayPalEmail] NVARCHAR(100) NULL,
				[PayPalLog] BIT NOT NULL  DEFAULT 0,
				[CustomText1] NVARCHAR(255) NULL,
				[CustomText2] NVARCHAR(255) NULL,
				[CustomText3] NVARCHAR(255) NULL,
				[CustomSelect1] NVARCHAR(100) NULL,
				[CustomSelect2] NVARCHAR(100) NULL,
				[CustomChoices1] NTEXT NULL,
				[CustomChoices2] NTEXT NULL,
				[CustomText_Req] NVARCHAR(50) NULL,
				[CustomSelect_Req] NVARCHAR(50) NULL,
				[AgreeTerms] NTEXT NULL,
				[Giftwrap] BIT NOT NULL  DEFAULT 0,
				[ShowBasket] BIT NOT NULL  DEFAULT 1,
				[SkipAddressForm] BIT NOT NULL  DEFAULT 0,
				[PayPalMethod] NVARCHAR(25) NULL,
				[UseCRESecure] BIT NOT NULL  DEFAULT 0,
				[PDT_Token] NVARCHAR(100) NULL,
				[PayPalServer] NVARCHAR(100) NULL,
				CONSTRAINT [OrderSettings_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `Order_Items` 
----

CREATE TABLE 	[Order_Items] (
				[Order_No] INT NOT NULL,
				[Item_ID] INT NOT NULL,
				[Product_ID] INT NOT NULL  DEFAULT 0,
				[Options] NTEXT NULL,
				[Addons] NTEXT NULL,
				[AddonMultP] FLOAT NULL  DEFAULT 0,
				[AddonNonMultP] FLOAT NULL  DEFAULT 0,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				[Quantity] INT NOT NULL  DEFAULT 0,
				[OptPrice] FLOAT NOT NULL  DEFAULT 0,
				[SKU] NVARCHAR(50) NULL,
				[OptQuant] INT NOT NULL  DEFAULT 0,
				[OptChoice] INT NULL,
				[OptionID_List] NVARCHAR(255) NULL,
				[ChoiceID_List] NVARCHAR(255) NULL,
				[DiscAmount] FLOAT NULL,
				[Disc_Code] NVARCHAR(50) NULL,
				[PromoAmount] FLOAT NULL  DEFAULT 0,
				[PromoQuant] INT NULL  DEFAULT 0,
				[Promo_Code] NVARCHAR(50) NULL,
				[Name] NVARCHAR(255) NULL,
				[Dropship_Account_ID] INT NULL,
				[Dropship_Qty] INT NULL  DEFAULT 0,
				[Dropship_SKU] NVARCHAR(50) NULL,
				[Dropship_Cost] FLOAT NULL  DEFAULT 0,
				[Dropship_Note] NVARCHAR(75) NULL,
				CONSTRAINT [Order_Items_PK]  PRIMARY KEY  NONCLUSTERED  ([Order_No],[Item_ID]), 
				CONSTRAINT [Order_Items_Order_No_Orders_FK] FOREIGN KEY ("Order_No") REFERENCES "Order_No" ( "Order_No" )
				); 
 CREATE  INDEX [Order_Items_Order_Items_Disc_Code_Idx] ON [Order_Items] ([Disc_Code]);
 CREATE CLUSTERED INDEX [Order_Items_Order_Items_Order_No_Idx] ON [Order_Items] ([Order_No]);
 CREATE  INDEX [Order_Items_Order_Items_Product_ID_Idx] ON [Order_Items] ([Product_ID]);
 CREATE  INDEX [Order_Items_Order_Items_Promo_Code_Idx] ON [Order_Items] ([Promo_Code]);
ALTER TABLE [Order_Items] CHECK CONSTRAINT [Order_Items_Order_No_Orders_FK];

---- Table structure for table `Order_PO` 
----

CREATE TABLE 	[Order_PO] (
				[Order_PO_ID] INT IDENTITY(1,1) ,
				[Order_No] INT NOT NULL,
				[PO_No] NVARCHAR(30) NOT NULL,
				[Account_ID] INT NOT NULL  DEFAULT 0,
				[PrintDate] DATETIME NULL,
				[Notes] NVARCHAR(255) NULL,
				[PO_Status] NVARCHAR(50) NULL,
				[PO_Open] BIT NOT NULL  DEFAULT 0,
				[ShipDate] DATETIME NULL,
				[Shipper] NVARCHAR(50) NULL,
				[Tracking] NVARCHAR(50) NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Order_PO_PK]  PRIMARY KEY  NONCLUSTERED  ([Order_PO_ID]), 
				CONSTRAINT [Order_PO_Order_No_Order_PO_FK] FOREIGN KEY ("Order_No") REFERENCES "Order_No" ( "Order_No" )
				); 
 CREATE  INDEX [Order_PO_Order_PO_Account_ID_Idx] ON [Order_PO] ([Account_ID]);
 CREATE CLUSTERED INDEX [Order_PO_Order_PO_Order_No_Idx] ON [Order_PO] ([Order_No]);
 CREATE  INDEX [Order_PO_Order_PO_ID_Tag_Idx] ON [Order_PO] ([ID_Tag]);

---- Table structure for table `OrderTaxes` 
----

CREATE TABLE 	[OrderTaxes] (
				[Order_No] INT NOT NULL  DEFAULT 0,
				[Code_ID] INT NOT NULL  DEFAULT 0,
				[ProductTotal] FLOAT NOT NULL  DEFAULT 0,
				[CodeName] NVARCHAR(50) NULL,
				[AddressUsed] NVARCHAR(20) NULL,
				[AllUserTax] FLOAT NOT NULL  DEFAULT 0,
				[StateTax] FLOAT NOT NULL  DEFAULT 0,
				[CountyTax] FLOAT NOT NULL  DEFAULT 0,
				[LocalTax] FLOAT NOT NULL  DEFAULT 0,
				[CountryTax] FLOAT NOT NULL  DEFAULT 0,
				CONSTRAINT [OrderTaxes_PK]  PRIMARY KEY  NONCLUSTERED  ([Order_No],[Code_ID]), 
				CONSTRAINT [OrderTaxes_Order_No_OrderTaxes_FK] FOREIGN KEY ("Order_No") REFERENCES "Order_No" ( "Order_No" ), 
				CONSTRAINT [OrderTaxes_TaxCodes_OrderTaxes_FK] FOREIGN KEY ("Code_ID") REFERENCES "TaxCodes" ( "Code_ID" )
				); 
 CREATE CLUSTERED INDEX [OrderTaxes_OrderTaxes_Order_No_Idx] ON [OrderTaxes] ([Order_No]);
 CREATE  INDEX [OrderTaxes_TaxCodes_OrderTaxes_FK] ON [OrderTaxes] ([Code_ID]);
 
---- Table structure for table `CardData` 
----

CREATE TABLE 	[CardData] (
				[ID] INT IDENTITY(1,1) ,
				[Customer_ID] INT NOT NULL  DEFAULT 0,
				[CardType] NVARCHAR(50) NOT NULL,
				[NameonCard] NVARCHAR(150) NOT NULL,
				[CardNumber] NVARCHAR(50) NOT NULL,
				[Expires] NVARCHAR(50) NOT NULL,
				[EncryptedCard] NVARCHAR(100) NULL,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [CardData_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [CardData_Customers_CardData_FK] FOREIGN KEY ("Customer_ID") REFERENCES "Customers" ( "Customer_ID" )
				); 
 CREATE  INDEX [CardData_CardData_Customer_ID_Idx] ON [CardData] ([Customer_ID]);
 CREATE  INDEX [CardData_CardData_ID_Tag_Idx] ON [CardData] ([ID_Tag]);

---- Table structure for table `Discount_Categories` 
----

CREATE TABLE 	[Discount_Categories] (
				[ID] INT IDENTITY(1,1) ,
				[Discount_ID] INT NOT NULL,
				[Category_ID] INT NOT NULL,
				CONSTRAINT [Discount_Categories_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [Discount_Categories_Categories_Discount_Categories_FK] FOREIGN KEY ("Category_ID") REFERENCES "Categories" ( "Category_ID" ), 
				CONSTRAINT [Discount_Categories_Discounts_Discount_Categories_FK] FOREIGN KEY ("Discount_ID") REFERENCES "Discounts" ( "Discount_ID" )
				); 
 CREATE  INDEX [Discount_Categories_Discount_Categories_Category_ID_Idx] ON [Discount_Categories] ([Category_ID]);
 CREATE  INDEX [Discount_Categories_Discount_Categories_Discount_ID_Idx] ON [Discount_Categories] ([Discount_ID]);

---- Table structure for table `Payments` 
----

CREATE TABLE 	[Payments] (
				[PaymentID] INT IDENTITY(1,1) ,
				[PaymentDateTime] DATETIME NOT NULL,
				[BasketNum] NVARCHAR(30) NOT NULL  DEFAULT N'0',
				[Order_No] INT NULL,
				[InvoiceNum] NVARCHAR(20) NOT NULL  DEFAULT N'0',
				[CardType] NVARCHAR(50) NULL,
				[CardNumber] NVARCHAR(50) NULL,
				[NameOnCard] NVARCHAR(150) NULL,
				[EncryptedCard] NVARCHAR(255) NULL,
				[Amount] FLOAT NOT NULL  DEFAULT 0,
				[Captured] BIT NOT NULL  DEFAULT 0,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [Payments_PK]  PRIMARY KEY  CLUSTERED  ([PaymentID])
				); 
 CREATE  INDEX [Payments_Payments_BasketNum_Idx] ON [Payments] ([BasketNum]);
 CREATE  INDEX [Payments_Payments_ID_Tag_Idx] ON [Payments] ([ID_Tag]);
 CREATE  INDEX [Payments_Payments_Order_No_Idx] ON [Payments] ([Order_No]);
 CREATE  INDEX [Payments_Payments_Captured_Idx] ON [Payments] ([Captured]);

---- Table structure for table `Permission_Groups` 
----

CREATE TABLE 	[Permission_Groups] (
				[Group_ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(20) NOT NULL,
				CONSTRAINT [Permission_Groups_PK]  PRIMARY KEY  NONCLUSTERED  ([Group_ID])
				); 

---- Table structure for table `Permissions` 
----

CREATE TABLE 	[Permissions] (
				[ID] INT IDENTITY(1,1) ,
				[Group_ID] INT NOT NULL,
				[Name] NVARCHAR(30) NOT NULL,
				[BitValue] INT NULL  DEFAULT 0,CONSTRAINT [Permissions_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [Permissions_Permission_Groups_Permissions_FK] FOREIGN KEY ("Group_ID") REFERENCES "Permission_Groups" ( "Group_ID" )
				); 
 CREATE  INDEX [Permissions_Permissions_Group_ID_Idx] ON [Permissions] ([Group_ID]);

---- Table structure for table `PickLists` 
----

CREATE TABLE 	[PickLists] (
				[Picklist_ID] INT IDENTITY(1,1) ,
				[Feature_Type] NTEXT NULL,
				[Acc_Rep] NTEXT NULL,
				[Acc_Type1] NTEXT NULL,
				[Acc_Descr1] NTEXT NULL,
				[Product_Availability] NTEXT NULL,
				[Shipping_Status] NTEXT NULL,
				[PO_Status] NTEXT NULL,
				[GiftRegistry_Type] NTEXT NULL,
				[Review_Editorial] NTEXT NULL,
				CONSTRAINT [PickLists_PK]  PRIMARY KEY  CLUSTERED  ([Picklist_ID])
				); 

---- Table structure for table `ProdAddons` 
----

CREATE TABLE 	[ProdAddons] (
				[Addon_ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[Standard_ID] INT NOT NULL,
				[Prompt] NVARCHAR(100) NULL,
				[AddonDesc] NVARCHAR(100) NULL,
				[AddonType] NVARCHAR(10) NULL,
				[Display] BIT NOT NULL  DEFAULT 1,
				[Priority] INT NOT NULL  DEFAULT 9999,
				[Price] FLOAT NULL  DEFAULT 0,
				[Weight] FLOAT NULL  DEFAULT 0,
				[ProdMult] BIT NOT NULL  DEFAULT 0,
				[Required] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [ProdAddons_PK]  PRIMARY KEY  CLUSTERED  ([Addon_ID]), 
				CONSTRAINT [ProdAddons_Products_ProdAddons_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [ProdAddons_ProdAddons_Product_ID_Idx] ON [ProdAddons] ([Product_ID]);
 CREATE  INDEX [ProdAddons_ProdAddons_Standard_ID_Idx] ON [ProdAddons] ([Standard_ID]);

---- Table structure for table `ProdDisc` 
----

CREATE TABLE 	[ProdDisc] (
				[Product_ID] INT NOT NULL,
				[ProdDisc_ID] INT NOT NULL,
				[Wholesale] BIT NOT NULL  DEFAULT 0,
				[QuantFrom] INT NOT NULL  DEFAULT 0,
				[QuantTo] INT NOT NULL  DEFAULT 0,
				[DiscountPer] FLOAT NOT NULL  DEFAULT 0,
				CONSTRAINT [ProdDisc_PK]  PRIMARY KEY  CLUSTERED  ([Product_ID],[ProdDisc_ID]), 
				CONSTRAINT [ProdDisc_Products_ProdDisc_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [ProdDisc_ProdDisc_Product_ID_Idx] ON [ProdDisc] ([Product_ID]);
ALTER TABLE [ProdDisc] CHECK CONSTRAINT [ProdDisc_Products_ProdDisc_FK];

---- Table structure for table `Promotions` 
----

CREATE TABLE 	[Promotions] (
				[Promotion_ID] INT IDENTITY(1,1) ,
				[Type1] INT NOT NULL  DEFAULT 1,
				[Type2] INT NOT NULL  DEFAULT 1,
				[Type3] INT NOT NULL  DEFAULT 0,
				[Type4] INT NOT NULL  DEFAULT 0,
				[Coup_Code] NVARCHAR(50) NULL,
				[OneTime] BIT NOT NULL  DEFAULT 0,
				[Name] NVARCHAR(255) NOT NULL,
				[Display] NVARCHAR(255) NULL,
				[Amount] FLOAT NOT NULL  DEFAULT 0,
				[QualifyNum] FLOAT NOT NULL  DEFAULT 0,
				[DiscountNum] FLOAT NOT NULL  DEFAULT 0,
				[Multiply] BIT NOT NULL  DEFAULT 0,
				[StartDate] DATETIME NULL,
				[EndDate] DATETIME NULL,
				[Disc_Product] INT NOT NULL  DEFAULT 0,
				[Add_DiscProd] BIT NOT NULL  DEFAULT 0,
				[AccessKey] INT NULL  DEFAULT 0,
				CONSTRAINT [Promotions_PK]  PRIMARY KEY  CLUSTERED  ([Promotion_ID])
				); 
 CREATE  INDEX [Promotions_Promotions_AccessKey_Idx] ON [Promotions] ([AccessKey]);
 CREATE  INDEX [Promotions_Promotions_Coup_Code_Idx] ON [Promotions] ([Coup_Code]);

---- Table structure for table `Product_Options` 
----

CREATE TABLE 	[Product_Options] (
				[Option_ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[Std_ID] INT NOT NULL  DEFAULT 0,
				[Prompt] NVARCHAR(50) NULL,
				[OptDesc] NVARCHAR(50) NULL,
				[ShowPrice] NVARCHAR(10) NULL,
				[Display] BIT NOT NULL  DEFAULT 0,
				[Priority] INT NULL  DEFAULT 0,
				[TrackInv] BIT NOT NULL  DEFAULT 0,
				[Required] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Product_Options_PK]  PRIMARY KEY  CLUSTERED  ([Option_ID]), 
				CONSTRAINT [Product_Options_Products_Product_Options_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [Product_Options_Product_Options_Product_ID_Idx] ON [Product_Options] ([Product_ID]);
 CREATE  INDEX [Product_Options_Product_Options_Std_ID_Idx] ON [Product_Options] ([Std_ID]);

---- Table structure for table `Prod_CustomFields` 
----

CREATE TABLE 	[Prod_CustomFields] (
				[Custom_ID] INT NOT NULL,
				[Custom_Name] NVARCHAR(50) NULL,
				[Custom_Display] BIT NOT NULL  DEFAULT 0,
				[Google_Use] BIT NOT NULL  DEFAULT 0,
				[Google_Code] NVARCHAR(50) NULL,
				CONSTRAINT [Prod_CustomFields_PK]  PRIMARY KEY  CLUSTERED  ([Custom_ID])
				); 

---- Table structure for table `Prod_CustInfo` 
----

CREATE TABLE 	[Prod_CustInfo] (
				[Product_ID] INT NOT NULL,
				[Custom_ID] INT NOT NULL,
				[CustomInfo] NVARCHAR(150) NULL,
				CONSTRAINT [Prod_CustInfo_PK]  PRIMARY KEY  NONCLUSTERED  ([Product_ID],[Custom_ID]), 
				CONSTRAINT [Prod_CustInfo_Products_Prod_CustInfo_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" ), 
				CONSTRAINT [Prod_CustInfo_Prod_CustomFields_Prod_CustInfo_FK] FOREIGN KEY ("Custom_ID") REFERENCES "Prod_CustomFields" ( "Custom_ID" )
				); 
 CREATE CLUSTERED INDEX [Prod_CustInfo_Prod_CustInfo_Product_ID_Idx] ON [Prod_CustInfo] ([Product_ID]);
 CREATE  INDEX [Prod_CustInfo_Prod_CustomFields_Prod_CustInfo_FK] ON [Prod_CustInfo] ([Custom_ID]);
 
---- Table structure for table `ProductReviews` 
----

CREATE TABLE 	[ProductReviews] (
				[Review_ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[User_ID] INT NULL  DEFAULT 0,
				[Anonymous] BIT NOT NULL  DEFAULT 0,
				[Anon_Name] NVARCHAR(50) NULL,
				[Anon_Loc] NVARCHAR(50) NULL,
				[Anon_Email] NVARCHAR(75) NULL,
				[Editorial] NVARCHAR(50) NULL,
				[Title] NVARCHAR(75) NOT NULL,
				[Comment] NTEXT NOT NULL,
				[Rating] INT NOT NULL  DEFAULT 0,
				[Recommend] BIT NOT NULL  DEFAULT 0,
				[Posted] DATETIME NOT NULL,
				[Updated] DATETIME NULL,
				[Approved] BIT NOT NULL  DEFAULT 0,
				[NeedsCheck] BIT NOT NULL  DEFAULT 0,
				[Helpful_Total] INT NOT NULL  DEFAULT 0,
				[Helpful_Yes] INT NOT NULL  DEFAULT 0,
				CONSTRAINT [ProductReviews_PK]  PRIMARY KEY  NONCLUSTERED  ([Review_ID]), 
				CONSTRAINT [ProductReviews_Products_ProductReviews_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [ProductReviews_ProductReviews_Posted_Idx] ON [ProductReviews] ([Posted]);
 CREATE CLUSTERED INDEX [ProductReviews_ProductReviews_Product_ID_Idx] ON [ProductReviews] ([Product_ID]);
 CREATE  INDEX [ProductReviews_ProductReviews_Rating_Idx] ON [ProductReviews] ([Rating]);
 CREATE  INDEX [ProductReviews_ProductReviews_User_ID_Idx] ON [ProductReviews] ([User_ID]);

---- Table structure for table `ProductReviewsHelpful` 
----

CREATE TABLE 	[ProductReviewsHelpful] (
				[Helpful_ID] NVARCHAR(35) NOT NULL,
				[Product_ID] INT NOT NULL,
				[Review_ID] INT NOT NULL,
				[Helpful] BIT NOT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				[Date_Stamp] DATETIME NULL,
				[IP] NVARCHAR(30) NULL,
				CONSTRAINT [ProductReviewsHelpful_PK]  PRIMARY KEY  NONCLUSTERED  ([Helpful_ID]), 
				CONSTRAINT [ProductReviewsHelpful_Products_ProductReviewsHelpful_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [ProductReviewsHelpful_ProductReviewsHelpful_IP_Idx] ON [ProductReviewsHelpful] ([IP]);
 CREATE CLUSTERED INDEX [ProductReviewsHelpful_ProductReviewsHelpful_Product_ID_Idx] ON [ProductReviewsHelpful] ([Product_ID]);
 CREATE  INDEX [ProductReviewsHelpful_ProductReviewsHelpful_Review_ID_Idx] ON [ProductReviewsHelpful] ([Review_ID]);
 CREATE  INDEX [ProductReviewsHelpful_ProductReviewsHelpful_User_ID_Idx] ON [ProductReviewsHelpful] ([User_ID]);

---- Table structure for table `Product_Images` 
----

CREATE TABLE 	[Product_Images] (
				[Product_Image_ID] INT NOT NULL,
				[Product_ID] INT NOT NULL,
				[Image_File] NVARCHAR(150) NOT NULL,
				[Gallery] NVARCHAR(50) NULL,
				[File_Size] INT NULL  DEFAULT 0,
				[Caption] NVARCHAR(100) NULL,
				[Priority] INT NULL  DEFAULT 0,
				CONSTRAINT [Product_Images_PK]  PRIMARY KEY  NONCLUSTERED  ([Product_Image_ID]), 
				CONSTRAINT [Product_Images_Products_Product_Images_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE CLUSTERED INDEX [Product_Images_Product_Images_Product_ID_Idx] ON [Product_Images] ([Product_ID]);

---- Table structure for table `Product_Item` 
----

CREATE TABLE 	[Product_Item] (
				[Product_Item_ID] INT IDENTITY(1,1) ,
				[Product_ID] INT NOT NULL,
				[Item_ID] INT NOT NULL,
				CONSTRAINT [Product_Item_PK]  PRIMARY KEY  NONCLUSTERED  ([Product_Item_ID]), 
				CONSTRAINT [Product_Item_Products_Product_Item_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" ), 
				CONSTRAINT [Product_Item_Products_Product_Item_FK_2] FOREIGN KEY ("Item_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [Product_Item_Product_Item_Item_ID_Idx] ON [Product_Item] ([Item_ID]);
 CREATE  INDEX [Product_Item_Product_Item_Product_ID_Idx] ON [Product_Item] ([Product_ID]);

---- Table structure for table `ProdOpt_Choices` 
----

CREATE TABLE 	[ProdOpt_Choices] (
				[Option_ID] INT NOT NULL  DEFAULT 0,
				[Choice_ID] INT NOT NULL  DEFAULT 0,
				[ChoiceName] NVARCHAR(150) NULL,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				[Weight] FLOAT NOT NULL  DEFAULT 0,
				[SKU] NVARCHAR(50) NULL,
				[NumInStock] INT NULL  DEFAULT 0,
				[Display] BIT NOT NULL  DEFAULT 0,
				[SortOrder] INT NULL  DEFAULT 0,
				CONSTRAINT [ProdOpt_Choices_PK]  PRIMARY KEY  NONCLUSTERED  ([Option_ID],[Choice_ID]), 
				CONSTRAINT [ProdOpt_Choices_Product_Options_ProdOpt_Choices_FK] FOREIGN KEY ("Option_ID") REFERENCES "Product_Options" ( "Option_ID" )
				); 
 CREATE CLUSTERED INDEX [ProdOpt_Choices_ProdOpt_Choices_Option_ID_Idx] ON [ProdOpt_Choices] ([Option_ID]);

---- Table structure for table `Promotion_Qual_Products` 
----

CREATE TABLE 	[Promotion_Qual_Products] (
				[ID] INT IDENTITY(1,1) ,
				[Promotion_ID] INT NOT NULL,
				[Product_ID] INT NOT NULL,
				CONSTRAINT [Promotion_Qual_Products_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [Promotion_Qual_Products_Products_Promotion_Qual_Products_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" ), 
				CONSTRAINT [Promotion_Qual_Products_Promotions_Promotion_Qual_Products_FK] FOREIGN KEY ("Promotion_ID") REFERENCES "Promotions" ( "Promotion_ID" )
				); 
 CREATE  INDEX [Promotion_Qual_Products_Promotion_Qual_Products_Product_ID_Idx] ON [Promotion_Qual_Products] ([Product_ID]);
 CREATE  INDEX [Promotion_Qual_Products_Promotion_Qual_Products_Promotion_ID_Idx] ON [Promotion_Qual_Products] ([Promotion_ID]);

---- Table structure for table `WishList` 
----

CREATE TABLE 	[WishList] (
				[User_ID] INT NOT NULL,
				[ListNum] INT NOT NULL  DEFAULT 1,
				[ItemNum] INT NOT NULL  DEFAULT 0,
				[ListName] NVARCHAR(50) NULL,
				[Product_ID] INT NOT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				[NumDesired] INT NULL  DEFAULT 0,
				[Comments] NVARCHAR(255) NULL,
				CONSTRAINT [WishList_PK]  PRIMARY KEY  NONCLUSTERED  ([User_ID],[ListNum],[ItemNum]), 
				CONSTRAINT [WishList_Products_WishList_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" ), 
				CONSTRAINT [WishList_Users_WishList_FK] FOREIGN KEY ("User_ID") REFERENCES "Users" ( "User_ID" )
				); 
 CREATE  INDEX [WishList_WishList_Product_ID_Idx] ON [WishList] ([Product_ID]);
 CREATE CLUSTERED INDEX [WishList_WishList_User_ID_Idx] ON [WishList] ([User_ID]);

---- Table structure for table `Discount_Groups` 
----

CREATE TABLE 	[Discount_Groups] (
				[ID] INT IDENTITY(1,1) ,
				[Discount_ID] INT NOT NULL,
				[Group_ID] INT NOT NULL,
				CONSTRAINT [Discount_Groups_PK]  PRIMARY KEY  NONCLUSTERED  ([ID]), 
				CONSTRAINT [Discount_Groups_DiscountsDiscount_Groups] FOREIGN KEY ("Discount_ID") REFERENCES "Discounts" ( "Discount_ID" ), 
				CONSTRAINT [Discount_Groups_Groups_Discount_Groups_FK] FOREIGN KEY ("Group_ID") REFERENCES "Groups" ( "Group_ID" )
				); 
 CREATE  INDEX [Discount_Groups_Discount_Groups_Discount_ID_Idx] ON [Discount_Groups] ([Discount_ID]);
 CREATE  INDEX [Discount_Groups_Discount_Groups_Group_ID_Idx] ON [Discount_Groups] ([Group_ID]);

---- Table structure for table `Discount_Products` 
----

CREATE TABLE 	[Discount_Products] (
				[ID] INT IDENTITY(1,1) ,
				[Discount_ID] INT NOT NULL,
				[Product_ID] INT NOT NULL,
				CONSTRAINT [Discount_Products_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [Discount_Products_Discounts_Discount_Products_FK] FOREIGN KEY ("Discount_ID") REFERENCES "Discounts" ( "Discount_ID" ), 
				CONSTRAINT [Discount_Products_Products_Discount_Products_FK] FOREIGN KEY ("Product_ID") REFERENCES "Products" ( "Product_ID" )
				); 
 CREATE  INDEX [Discount_Products_Discount_Products_Discount_ID_Idx] ON [Discount_Products] ([Discount_ID]);
 CREATE  INDEX [Discount_Products_Discount_Products_Product_ID_Idx] ON [Discount_Products] ([Product_ID]);

---- Table structure for table `Promotion_Groups` 
----

CREATE TABLE 	[Promotion_Groups] (
				[ID] INT IDENTITY(1,1) ,
				[Promotion_ID] INT NOT NULL,
				[Group_ID] INT NOT NULL,
				CONSTRAINT [Promotion_Groups_PK]  PRIMARY KEY  CLUSTERED  ([ID]), 
				CONSTRAINT [Promotion_Groups_Groups_Promotion_Groups_FK] FOREIGN KEY ("Group_ID") REFERENCES "Groups" ( "Group_ID" ), 
				CONSTRAINT [Promotion_Groups_Promotions_Promotion_Groups_FK] FOREIGN KEY ("Promotion_ID") REFERENCES "Promotions" ( "Promotion_ID" )
				); 
 CREATE  INDEX [Promotion_Groups_Promotion_Groups_Group_ID_Idx] ON [Promotion_Groups] ([Group_ID]);
 CREATE  INDEX [Promotion_Groups_Promotion_Groups_Promotion_ID_Idx] ON [Promotion_Groups] ([Promotion_ID]);

---- Table structure for table `Settings` 
----

CREATE TABLE 	[Settings] (
				[SettingID] INT IDENTITY(1,1) ,
				[SiteName] NVARCHAR(50) NULL,
				[SiteLogo] NVARCHAR(100) NULL,
				[Merchant] NTEXT NULL,
				[HomeCountry] NVARCHAR(100) NULL,
				[MerchantEmail] NVARCHAR(150) NULL,
				[Webmaster] NVARCHAR(150) NULL,
				[DefaultImages] NVARCHAR(100) NULL,
				[FilePath] NVARCHAR(150) NULL,
				[MimeTypes] NVARCHAR(255) NULL,
				[MoneyUnit] NVARCHAR(50) NULL,
				[WeightUnit] NVARCHAR(50) NULL,
				[SizeUnit] NVARCHAR(50) NULL,
				[InvLevel] NVARCHAR(50) NULL,
				[ShowInStock] BIT NOT NULL  DEFAULT 0,
				[OutofStock] BIT NOT NULL  DEFAULT 1,
				[ShowRetail] BIT NOT NULL  DEFAULT 1,
				[ItemSort] NVARCHAR(50) NULL,
				[Wishlists] BIT NOT NULL  DEFAULT 0,
				[OrderButtonText] NVARCHAR(50) NULL,
				[OrderButtonImage] NVARCHAR(100) NULL,
				[AllowWholesale] BIT NOT NULL  DEFAULT 0,
				[UseVerity] BIT NOT NULL  DEFAULT 0,
				[CollectionName] NVARCHAR(50) NULL,
				[CColumns] INT NOT NULL  DEFAULT 0,
				[PColumns] INT NOT NULL  DEFAULT 0,
				[MaxProds] INT NOT NULL  DEFAULT 9999,
				[ProdRoot] INT NULL  DEFAULT 0,
				[CachedProds] BIT NOT NULL  DEFAULT 0,
				[FeatureRoot] INT NULL  DEFAULT 0,
				[MaxFeatures] INT NULL  DEFAULT 0,
				[Locale] NVARCHAR(30) NULL,
				[CurrExchange] NVARCHAR(30) NULL,
				[CurrExLabel] NVARCHAR(30) NULL,
				[Color_ID] INT NULL  DEFAULT 0,
				[Metadescription] NVARCHAR(255) NULL,
				[Keywords] NVARCHAR(255) NULL,
				[Email_Server] NVARCHAR(255) NULL,
				[Email_Port] INT NULL  DEFAULT 0,
				[Admin_New_Window] BIT NOT NULL  DEFAULT 0,
				[UseSES] BIT NOT NULL  DEFAULT 0,
				[Default_Fuseaction] NVARCHAR(50) NULL,
				[Editor] NVARCHAR(20) NULL,
				[ProductReviews] BIT NOT NULL  DEFAULT 0,
				[ProductReview_Approve] BIT NOT NULL  DEFAULT 0,
				[ProductReview_Flag] BIT NOT NULL  DEFAULT 0,
				[ProductReview_Add] INT NOT NULL  DEFAULT 1,
				[ProductReview_Rate] BIT NOT NULL  DEFAULT 1,
				[ProductReviews_Page] INT NOT NULL  DEFAULT 4,
				[FeatureReviews] BIT NOT NULL  DEFAULT 0,
				[FeatureReview_Add] INT NOT NULL  DEFAULT 1,
				[FeatureReview_Flag] BIT NOT NULL  DEFAULT 0,
				[FeatureReview_Approve] BIT NOT NULL  DEFAULT 1,
				[GiftRegistry] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Settings_PK]  PRIMARY KEY  CLUSTERED  ([SettingID])
				); 

---- Table structure for table `ShipSettings` 
----

CREATE TABLE 	[ShipSettings] (
				[ID] INT IDENTITY(1,1) ,
				[ShipType] NVARCHAR(50) NULL,
				[ShipBase] FLOAT NOT NULL  DEFAULT 0,
				[MerchantZip] NVARCHAR(10) NULL,
				[InStorePickup] BIT NOT NULL  DEFAULT 0,
				[AllowNoShip] BIT NOT NULL  DEFAULT 0,
				[NoShipMess] NTEXT NULL,
				[NoShipType] NVARCHAR(50) NULL,
				[ShipHand] FLOAT NOT NULL  DEFAULT 0,
				[Freeship_Min] INT NULL  DEFAULT 0,
				[Freeship_ShipIDs] NVARCHAR(50) NULL,
				[ShowEstimator] BIT NOT NULL  DEFAULT 0,
				[ShowFreight] BIT NOT NULL  DEFAULT 0,
				[UseDropShippers] BIT NOT NULL  DEFAULT 0,
				[ID_Tag] NVARCHAR(35) NULL,
				CONSTRAINT [ShipSettings_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `Shipping` 
----

CREATE TABLE 	[Shipping] (
				[ID] INT IDENTITY(1,1) ,
				[MinOrder] FLOAT NOT NULL  DEFAULT 0,
				[MaxOrder] FLOAT NOT NULL  DEFAULT 0,
				[Amount] FLOAT NOT NULL  DEFAULT 0,
				CONSTRAINT [Shipping_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 

---- Table structure for table `StateTax` 
----

CREATE TABLE 	[StateTax] (
				[Tax_ID] INT IDENTITY(1,1) ,
				[Code_ID] INT NOT NULL  DEFAULT 0,
				[State] NVARCHAR(2) NOT NULL,
				[TaxRate] FLOAT NOT NULL  DEFAULT 0,
				[TaxShip] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [StateTax_PK]  PRIMARY KEY  CLUSTERED  ([Tax_ID]), 
				CONSTRAINT [StateTax_States_StateTax_FK] FOREIGN KEY ("State") REFERENCES "States" ( "Abb" ), 
				CONSTRAINT [StateTax_TaxCodes_StateTax_FK] FOREIGN KEY ("Code_ID") REFERENCES "TaxCodes" ( "Code_ID" )
				); 
 CREATE  INDEX [StateTax_StateTax_Code_ID_Idx] ON [StateTax] ([Code_ID]);
 CREATE  INDEX [StateTax_StateTax_State_Idx] ON [StateTax] ([State]);

---- Table structure for table `Counties` 
----

CREATE TABLE 	[Counties] (
				[County_ID] INT IDENTITY(1,1) ,
				[Code_ID] INT NOT NULL  DEFAULT 0,
				[State] NVARCHAR(2) NOT NULL,
				[Name] NVARCHAR(50) NOT NULL,
				[TaxRate] FLOAT NOT NULL  DEFAULT 0,
				[TaxShip] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [Counties_PK]  PRIMARY KEY  CLUSTERED  ([County_ID]), 
				CONSTRAINT [Counties_States_Counties_FK] FOREIGN KEY ("State") REFERENCES "States" ( "Abb" ), 
				CONSTRAINT [Counties_TaxCodes_Counties_FK] FOREIGN KEY ("Code_ID") REFERENCES "TaxCodes" ( "Code_ID" )
				); 
 CREATE  INDEX [Counties_Counties_Code_ID_Idx] ON [Counties] ([Code_ID]);
 CREATE  INDEX [Counties_Counties_State_Idx] ON [Counties] ([State]);

---- Table structure for table `StdAddons` 
----

CREATE TABLE 	[StdAddons] (
				[Std_ID] INT IDENTITY(1,1) ,
				[Std_Name] NVARCHAR(50) NOT NULL,
				[Std_Prompt] NVARCHAR(100) NOT NULL,
				[Std_Desc] NVARCHAR(100) NULL,
				[Std_Type] NVARCHAR(10) NOT NULL,
				[Std_Display] BIT NOT NULL  DEFAULT 0,
				[Std_Price] FLOAT NOT NULL  DEFAULT 0,
				[Std_Weight] FLOAT NOT NULL  DEFAULT 0,
				[Std_ProdMult] BIT NOT NULL  DEFAULT 0,
				[Std_Required] BIT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				CONSTRAINT [StdAddons_PK]  PRIMARY KEY  NONCLUSTERED  ([Std_ID])
				); 
 CREATE  INDEX [StdAddons_StdAddons_User_ID_Idx] ON [StdAddons] ([User_ID]);

---- Table structure for table `StdOptions` 
----

CREATE TABLE 	[StdOptions] (
				[Std_ID] INT IDENTITY(1,1) ,
				[Std_Name] NVARCHAR(50) NOT NULL,
				[Std_Prompt] NVARCHAR(50) NOT NULL,
				[Std_Desc] NVARCHAR(50) NULL,
				[Std_ShowPrice] NVARCHAR(10) NOT NULL,
				[Std_Display] BIT NOT NULL  DEFAULT 0,
				[Std_Required] BIT NOT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				CONSTRAINT [StdOptions_PK]  PRIMARY KEY  NONCLUSTERED  ([Std_ID])
				); 
 CREATE  INDEX [StdOptions_StdOptions_User_ID_Idx] ON [StdOptions] ([User_ID]);

---- Table structure for table `StdOpt_Choices` 
----

CREATE TABLE 	[StdOpt_Choices] (
				[Std_ID] INT NOT NULL,
				[Choice_ID] INT NOT NULL,
				[ChoiceName] NVARCHAR(150) NULL,
				[Price] FLOAT NOT NULL  DEFAULT 0,
				[Weight] FLOAT NOT NULL  DEFAULT 0,
				[Display] BIT NOT NULL  DEFAULT 0,
				[SortOrder] INT NULL  DEFAULT 0,
				CONSTRAINT [StdOpt_Choices_PK]  PRIMARY KEY  NONCLUSTERED  ([Std_ID],[Choice_ID]), 
				CONSTRAINT [StdOpt_Choices_StdOptions_StdOpt_Choices_FK] FOREIGN KEY ("Std_ID") REFERENCES "StdOptions" ( "Std_ID" )
				); 
 CREATE CLUSTERED INDEX [StdOpt_Choices_StdOpt_Choices_Std_ID_Idx] ON [StdOpt_Choices] ([Std_ID]);

---- Table structure for table `CountryTax` 
----

CREATE TABLE 	[CountryTax] (
				[Tax_ID] INT IDENTITY(1,1) ,
				[Code_ID] INT NOT NULL  DEFAULT 0,
				[Country_ID] INT NOT NULL  DEFAULT 0,
				[TaxRate] FLOAT NOT NULL  DEFAULT 0,
				[TaxShip] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [CountryTax_PK]  PRIMARY KEY  CLUSTERED  ([Tax_ID]), 
				CONSTRAINT [CountryTax_Countries_CountryTax_FK] FOREIGN KEY ("Country_ID") REFERENCES "Countries" ( "ID" ), 
				CONSTRAINT [CountryTax_TaxCodes_CountryTax_FK] FOREIGN KEY ("Code_ID") REFERENCES "TaxCodes" ( "Code_ID" )
				); 
 CREATE  INDEX [CountryTax_CountryTax_Code_ID_Idx] ON [CountryTax] ([Code_ID]);
 CREATE  INDEX [CountryTax_CountryTax_Country_ID_Idx] ON [CountryTax] ([Country_ID]);

---- Table structure for table `TempBasket` 
----

CREATE TABLE 	[TempBasket] (
				[Basket_ID] NVARCHAR(60) NOT NULL,
				[BasketNum] NVARCHAR(30) NOT NULL,
				[Product_ID] INT NOT NULL,
				[Options] NVARCHAR(2000) NULL,
				[Addons] NVARCHAR(2000) NULL,
				[AddonMultP] FLOAT NULL  DEFAULT 0,
				[AddonNonMultP] FLOAT NULL  DEFAULT 0,
				[AddonMultW] FLOAT NULL  DEFAULT 0,
				[AddonNonMultW] FLOAT NULL  DEFAULT 0,
				[OptPrice] FLOAT NOT NULL  DEFAULT 0,
				[OptWeight] FLOAT NOT NULL  DEFAULT 0,
				[SKU] NVARCHAR(100) NULL,
				[Price] FLOAT NULL  DEFAULT 0,
				[Weight] FLOAT NULL  DEFAULT 0,
				[Quantity] INT NULL  DEFAULT 0,
				[OptQuant] INT NOT NULL  DEFAULT 0,
				[OptChoice] INT NULL  DEFAULT 0,
				[OptionID_List] NVARCHAR(255) NULL,
				[ChoiceID_List] NVARCHAR(255) NULL,
				[GiftItem_ID] INT NULL  DEFAULT 0,
				[Discount] INT NULL  DEFAULT 0,
				[DiscAmount] FLOAT NULL  DEFAULT 0,
				[Disc_Code] NVARCHAR(50) NULL,
				[QuantDisc] FLOAT NULL  DEFAULT 0,
				[Promotion] INT NULL  DEFAULT 0,
				[PromoAmount] FLOAT NULL  DEFAULT 0,
				[PromoQuant] INT NULL  DEFAULT 0,
				[Promo_Code] NVARCHAR(50) NULL,
				[DateAdded] DATETIME NULL,
				CONSTRAINT [TempBasket_PK]  PRIMARY KEY  CLUSTERED  ([Basket_ID])
				); 
 CREATE  INDEX [TempBasket_TempBasket_BasketNum_Idx] ON [TempBasket] ([BasketNum]);
 CREATE  INDEX [TempBasket_TempBasket_Product_ID_Idx] ON [TempBasket] ([Product_ID]);

---- Table structure for table `TempCustomer` 
----

CREATE TABLE 	[TempCustomer] (
				[TempCust_ID] NVARCHAR(30) NOT NULL,
				[FirstName] NVARCHAR(50) NULL,
				[LastName] NVARCHAR(100) NULL,
				[Company] NVARCHAR(150) NULL,
				[Address1] NVARCHAR(150) NULL,
				[Address2] NVARCHAR(150) NULL,
				[City] NVARCHAR(150) NULL,
				[County] NVARCHAR(50) NULL,
				[State] NVARCHAR(50) NULL,
				[State2] NVARCHAR(50) NULL,
				[Zip] NVARCHAR(50) NULL,
				[Country] NVARCHAR(50) NULL,
				[Phone] NVARCHAR(50) NULL,
				[Email] NVARCHAR(150) NULL,
				[ShipToYes] BIT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				[Phone2] NVARCHAR(50) NULL,
				[Fax] NVARCHAR(50) NULL,
				[Residence] BIT NULL  DEFAULT 0,
				CONSTRAINT [TempCustomer_PK]  PRIMARY KEY  CLUSTERED  ([TempCust_ID])
				); 

---- Table structure for table `TempOrder` 
----

CREATE TABLE 	[TempOrder] (
				[BasketNum] NVARCHAR(30) NOT NULL,
				[OrderTotal] FLOAT NULL  DEFAULT 0,
				[Tax] FLOAT NULL  DEFAULT 0,
				[ShipType] NVARCHAR(75) NULL,
				[Shipping] FLOAT NULL  DEFAULT 0,
				[Freight] INT NULL  DEFAULT 0,
				[OrderDisc] FLOAT NULL  DEFAULT 0,
				[Credits] FLOAT NULL  DEFAULT 0,
				[AddonTotal] FLOAT NULL  DEFAULT 0,
				[DateAdded] DATETIME NULL,
				[Affiliate] INT NULL  DEFAULT 0,
				[Referrer] NVARCHAR(255) NULL,
				[GiftCard] NVARCHAR(255) NULL,
				[Delivery] NVARCHAR(50) NULL,
				[Comments] NVARCHAR(255) NULL,
				[CustomText1] NVARCHAR(255) NULL,
				[CustomText2] NVARCHAR(255) NULL,
				[CustomText3] NVARCHAR(255) NULL,
				[CustomSelect1] NVARCHAR(100) NULL,
				[CustomSelect2] NVARCHAR(100) NULL,
				CONSTRAINT [TempOrder_PK]  PRIMARY KEY  CLUSTERED  ([BasketNum])
				); 

---- Table structure for table `TempShipTo` 
----

CREATE TABLE 	[TempShipTo] (
				[TempShip_ID] NVARCHAR(30) NOT NULL,
				[FirstName] NVARCHAR(50) NULL,
				[LastName] NVARCHAR(150) NULL,
				[Company] NVARCHAR(150) NULL,
				[Address1] NVARCHAR(150) NULL,
				[Address2] NVARCHAR(150) NULL,
				[City] NVARCHAR(150) NULL,
				[County] NVARCHAR(50) NULL,
				[State] NVARCHAR(50) NULL,
				[State2] NVARCHAR(50) NULL,
				[Zip] NVARCHAR(50) NULL,
				[Country] NVARCHAR(50) NULL,
				[DateAdded] DATETIME NULL,
				[Phone] NVARCHAR(50) NULL,
				[Email] NVARCHAR(150) NULL,
				[Residence] BIT NULL  DEFAULT 0,
				CONSTRAINT [TempShipTo_PK]  PRIMARY KEY  CLUSTERED  ([TempShip_ID])
				); 

---- Table structure for table `UPSMethods` 
----

CREATE TABLE 	[UPSMethods] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(75) NULL,
				[USCode] NVARCHAR(5) NULL,
				[EUCode] NVARCHAR(5) NULL,
				[CACode] NVARCHAR(5) NULL,
				[PRCode] NVARCHAR(5) NULL,
				[MXCode] NVARCHAR(5) NULL,
				[OOCode] NVARCHAR(5) NULL,
				[Used] BIT NOT NULL  DEFAULT 0,
				[Priority] INT NULL  DEFAULT 0,
				CONSTRAINT [UPSMethods_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 
 CREATE  INDEX [UPSMethods_UPSMethods_Used_Idx] ON [UPSMethods] ([Used]);

---- Table structure for table `UPS_Origins` 
----

CREATE TABLE 	[UPS_Origins] (
				[UPS_Code] NVARCHAR(10) NOT NULL,
				[Description] NVARCHAR(20) NULL,
				[OrderBy] INT NULL  DEFAULT 0,
				CONSTRAINT [UPS_Origins_PK]  PRIMARY KEY  CLUSTERED  ([UPS_Code])
				); 

---- Table structure for table `UPS_Packaging` 
----

CREATE TABLE 	[UPS_Packaging] (
				[UPS_Code] NVARCHAR(10) NOT NULL,
				[Description] NVARCHAR(50) NULL,
				CONSTRAINT [UPS_Packaging_PK]  PRIMARY KEY  CLUSTERED  ([UPS_Code])
				); 

---- Table structure for table `UPS_Pickup` 
----

CREATE TABLE 	[UPS_Pickup] (
				[UPS_Code] NVARCHAR(10) NOT NULL,
				[Description] NVARCHAR(50) NULL,
				CONSTRAINT [UPS_Pickup_PK]  PRIMARY KEY  CLUSTERED  ([UPS_Code])
				); 

---- Table structure for table `UPS_Settings` 
----

CREATE TABLE 	[UPS_Settings] (
				[UPS_ID] INT IDENTITY(1,1) ,
				[ResRates] BIT NOT NULL  DEFAULT 0,
				[Username] NVARCHAR(150) NULL,
				[Password] NVARCHAR(100) NULL,
				[Accesskey] NVARCHAR(100) NULL,
				[AccountNo] NVARCHAR(20) NULL,
				[Origin] NVARCHAR(10) NULL,
				[MaxWeight] INT NOT NULL  DEFAULT 0,
				[UnitsofMeasure] NVARCHAR(20) NULL,
				[CustomerClass] NVARCHAR(20) NULL,
				[Pickup] NVARCHAR(20) NULL,
				[Packaging] NVARCHAR(20) NULL,
				[OrigZip] NVARCHAR(20) NULL,
				[OrigCity] NVARCHAR(75) NULL,
				[OrigCountry] NVARCHAR(10) NULL,
				[Debug] BIT NOT NULL  DEFAULT 0,
				[UseAV] BIT NOT NULL  DEFAULT 0,
				[Logging] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [UPS_Settings_PK]  PRIMARY KEY CLUSTERED  ([UPS_ID])
				); 

---- Table structure for table `USPSCountries` 
----

CREATE TABLE 	[USPSCountries] (
				[ID] INT NOT NULL,
				[Abbrev] NVARCHAR(2) NOT NULL,
				[Name] NVARCHAR(255) NOT NULL,
				CONSTRAINT [USPSCountries_PK]  PRIMARY KEY  NONCLUSTERED  ([ID])
				); 
 CREATE CLUSTERED INDEX [USPSCountries_USPSCountries_Abbrev_Idx] ON [USPSCountries] ([Abbrev]);

---- Table structure for table `USPSMethods` 
----

CREATE TABLE 	[USPSMethods] (
				[ID] INT IDENTITY(1,1) ,
				[Name] NVARCHAR(75) NULL,
				[Used] BIT NOT NULL  DEFAULT 0,
				[Code] NVARCHAR(225) NULL,
				[Type] NVARCHAR(20) NULL,
				[Priority] INT NULL  DEFAULT 0,
				CONSTRAINT [USPSMethods_PK]  PRIMARY KEY  CLUSTERED  ([ID])
				); 
 CREATE  INDEX [USPSMethods_USPSMethods_Used_Idx] ON [USPSMethods] ([Used]);

---- Table structure for table `USPS_Settings` 
----

CREATE TABLE 	[USPS_Settings] (
				[USPS_ID] INT IDENTITY(1,1) ,
				[UserID] NVARCHAR(30) NOT NULL,
				[Server] NVARCHAR(75) NOT NULL,
				[MerchantZip] NVARCHAR(20) NULL,
				[MaxWeight] INT NOT NULL  DEFAULT 50,
				[Logging] BIT NOT NULL  DEFAULT 0,
				[Debug] BIT NOT NULL  DEFAULT 0,
				[UseAV] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [USPS_Settings_PK]  PRIMARY KEY  CLUSTERED  ([USPS_ID])
				); 

---- Table structure for table `UserSettings` 
----

CREATE TABLE 	[UserSettings] (
				[ID] INT IDENTITY(1,1) ,
				[UseRememberMe] BIT NOT NULL  DEFAULT 0,
				[EmailAsName] BIT NOT NULL  DEFAULT 0,
				[UseStateList] BIT NOT NULL  DEFAULT 1,
				[UseStateBox] BIT NOT NULL  DEFAULT 1,
				[RequireCounty] BIT NOT NULL  DEFAULT 0,
				[UseCountryList] BIT NOT NULL  DEFAULT 1,
				[UseResidential] BIT NOT NULL  DEFAULT 0,
				[UseGroupCode] BIT NOT NULL  DEFAULT 0,
				[UseBirthdate] BIT NOT NULL  DEFAULT 0,
				[UseTerms] BIT NOT NULL  DEFAULT 0,
				[TermsText] NTEXT NULL,
				[UseCCard] BIT NOT NULL  DEFAULT 0,
				[UseEmailConf] BIT NOT NULL  DEFAULT 0,
				[UseEmailNotif] BIT NOT NULL  DEFAULT 0,
				[MemberNotify] BIT NOT NULL  DEFAULT 0,
				[UseShipTo] BIT NOT NULL  DEFAULT 1,
				[UseAccounts] BIT NOT NULL  DEFAULT 0,
				[ShowAccount] BIT NOT NULL  DEFAULT 1,
				[ShowDirectory] BIT NOT NULL  DEFAULT 1,
				[ShowSubscribe] BIT NOT NULL  DEFAULT 1,
				[StrictLogins] BIT NOT NULL  DEFAULT 0,
				[MaxDailyLogins] INT NOT NULL  DEFAULT 0,
				[MaxFailures] INT NOT NULL  DEFAULT 5,
				[AllowAffs] BIT NOT NULL  DEFAULT 0,
				[AffPercent] FLOAT NULL  DEFAULT 0,
				[AllowWholesale] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [UserSettings_PK]  PRIMARY KEY  NONCLUSTERED  ([ID])
				); 

---- Table structure for table `FeatureReviews` 
----

CREATE TABLE 	[FeatureReviews] (
				[Review_ID] INT IDENTITY(1,1) ,
				[Feature_ID] INT NOT NULL,
				[Parent_ID] INT NULL  DEFAULT 0,
				[User_ID] INT NULL  DEFAULT 0,
				[Anonymous] BIT NOT NULL  DEFAULT 0,
				[Anon_Name] NVARCHAR(100) NULL,
				[Anon_Loc] NVARCHAR(100) NULL,
				[Anon_Email] NVARCHAR(100) NULL,
				[Editorial] NVARCHAR(50) NULL,
				[Title] NVARCHAR(75) NULL,
				[Comment] NTEXT NULL,
				[Rating] INT NULL  DEFAULT 0,
				[Recommend] BIT NOT NULL  DEFAULT 0,
				[Posted] DATETIME NOT NULL,
				[Updated] DATETIME NULL,
				[Approved] BIT NOT NULL  DEFAULT 0,
				[NeedsCheck] BIT NOT NULL  DEFAULT 0,
				CONSTRAINT [FeatureReviews_PK]  PRIMARY KEY  CLUSTERED  ([Review_ID]), 
				CONSTRAINT [FeatureReviews_Features_FeatureReviews_FK] FOREIGN KEY ("Feature_ID") REFERENCES "Features" ( "Feature_ID" )
				); 
 CREATE  INDEX [FeatureReviews_FeatureReviews_Feature_ID_Idx] ON [FeatureReviews] ([Feature_ID]);
 CREATE  INDEX [FeatureReviews_FeatureReviews_Parent_ID_Idx] ON [FeatureReviews] ([Parent_ID]);
 CREATE  INDEX [FeatureReviews_FeatureReviews_Posted_Idx] ON [FeatureReviews] ([Posted]);
 CREATE  INDEX [FeatureReviews_FeatureReviews_Rating_Idx] ON [FeatureReviews] ([Rating]);
 CREATE  INDEX [FeatureReviews_FeatureReviews_User_ID_Idx] ON [FeatureReviews] ([User_ID]);

---- Table structure for table `Pages` 
----

CREATE TABLE 	[Pages] (
				[Page_ID] INT NOT NULL,
				[Page_URL] NVARCHAR(75) NULL,
				[CatCore_ID] INT NULL  DEFAULT 0,
				[PassParam] NVARCHAR(100) NULL,
				[Display] BIT NOT NULL  DEFAULT 0,
				[PageAction] NVARCHAR(30) NULL,
				[Page_Name] NVARCHAR(100) NOT NULL,
				[Page_Title] NVARCHAR(75) NULL,
				[Sm_Image] NVARCHAR(100) NULL,
				[Lg_Image] NVARCHAR(100) NULL,
				[Sm_Title] NVARCHAR(100) NULL,
				[Lg_Title] NVARCHAR(100) NULL,
				[Color_ID] INT NULL,
				[PageText] NTEXT NULL,
				[System] BIT NOT NULL  DEFAULT 0,
				[Href_Attributes] NVARCHAR(50) NULL,
				[AccessKey] INT NULL  DEFAULT 0,
				[Priority] INT NULL  DEFAULT 9999,
				[Parent_ID] INT NULL  DEFAULT 0,
				[Title_Priority] INT NULL  DEFAULT 0,
				[Metadescription] NVARCHAR(255) NULL,
				[Keywords] NVARCHAR(255) NULL,
				[TitleTag] NVARCHAR(255) NULL,
				CONSTRAINT [Pages_PK]  PRIMARY KEY  CLUSTERED  ([Page_ID]), 
				CONSTRAINT [Pages_CatCore_Pages_FK] FOREIGN KEY ("CatCore_ID") REFERENCES "CatCore" ( "CatCore_ID" ), 
				CONSTRAINT [Pages_Colors_Pages_FK] FOREIGN KEY ("Color_ID") REFERENCES "Colors" ( "Color_ID" )
				); 
 CREATE  INDEX [Pages_Pages_AccessKey_Idx] ON [Pages] ([AccessKey]);
 CREATE  INDEX [Pages_Pages_CatCore_ID_Idx] ON [Pages] ([CatCore_ID]);
 CREATE  INDEX [Pages_Pages_Color_ID_Idx] ON [Pages] ([Color_ID]);

---- Inserting data for table `AccessKeys`
---- 


 SET IDENTITY_INSERT [AccessKeys] ON 
 GO

INSERT INTO [AccessKeys] ([AccessKey_ID],[Name],[Keyring],[System]) VALUES (1,N'Log In Required',N'System',1)
INSERT INTO [AccessKeys] ([AccessKey_ID],[Name],[Keyring],[System]) VALUES (2,N'Members Only',NULL,0)

 SET IDENTITY_INSERT [AccessKeys] OFF 
 GO


---- Inserting data for table `CCProcess`
---- 


 SET IDENTITY_INSERT [CCProcess] ON 
 GO

INSERT INTO [CCProcess] ([ID],[CCServer],[Transtype],[Username],[Password],[Setting1],[Setting2],[Setting3]) VALUES (1,NULL,N'Sale',NULL,NULL,NULL,NULL,NULL)
INSERT INTO [CCProcess] ([ID],[CCServer],[Transtype],[Username],[Password],[Setting1],[Setting2],[Setting3]) VALUES (2,N'https://api.sandbox.paypal.com/2.0/',N'Sale',NULL,NULL,NULL,NULL,N'PayPalExpress')
INSERT INTO [CCProcess] ([ID],[CCServer],[Transtype],[Username],[Password],[Setting1],[Setting2],[Setting3]) VALUES (3,N'TEST',N'',NULL,NULL,NULL,NULL,N'CRESecure')

 SET IDENTITY_INSERT [CCProcess] OFF 
 GO


---- Inserting data for table `Users`
---- 


 SET IDENTITY_INSERT [Users] ON 
 GO

INSERT INTO [Users] ([User_ID],[Username],[Password],[Email],[EmailIsBad],[EmailLock],[Subscribe],[Customer_ID],[ShipTo],[Group_ID],[Account_ID],[Affiliate_ID],[Basket],[Birthdate],[CardisValid],[CardType],[NameonCard],[CardNumber],[CardExpire],[CardZip],[EncryptedCard],[CurrentBalance],[LastLogin],[Permissions],[AdminNotes],[Disable],[LoginsTotal],[LoginsDay],[FailedLogins],[LastAttempt],[Created],[LastUpdate],[ID_Tag]) VALUES (1,N'admin',N'21232F297A57A5A743894A0E4A801FC3',N'info@yoursite.com',0,N'verified',1,0,0,1,0,0,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,N'2007-03-18 19:00:24',N'contentkey_list^2;Users^2;registration^63',NULL,0,1,1,0,N'2007-03-18 19:00:24',NULL,N'2007-02-02 13:33:31',NULL)

 SET IDENTITY_INSERT [Users] OFF 
 GO


---- Inserting data for table `CatCore`
---- 

INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (0,N'category header only',N'noline=1,notitle=1',N'category/catcore_catheader_only.cfm',1,0,0,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (1,N'sub-categories only',N'noline=1,notitle=1',N'category/dsp_subcats.cfm',1,0,0,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (2,N'home page',N'topcats, searchform,new,onsale,hot,notsold,ProdofDay,listing,notitle,columns=x',N'catcores/catcore_home.cfm',0,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (3,N'highlights (new & on sale)',N'new=1,onsale=1,notsold=1,notitle=1,columns=x',N'catcores/catcore_highlight.cfm',1,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (4,N'contact us email form',N'noline=1,EmailTo=email@address.com, BoxTitle=Title,Subject=Email Subject Line',N'email/catcore_contactus.cfm',1,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (5,N'search form',N'noline=1,notitle=1',N'search/dsp_search_form.cfm',1,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (6,N'search results page',N'noline=1,notitle=1',N'search/act_search.cfm',0,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (7,N'products department home',N'noline=1,notitle=1',N'catcores/catcore_products_home.cfm',1,1,0,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (8,N'products',N'listing=vertical|short, displaycount=x, productcols=x,searchheader=1,searchheader=form,alpha=1,notitle=1',N'product/catcore_products.cfm',1,1,0,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (9,N'features',N'noline=1,notitle=1,searchform=1, displaycount=x',N'feature/catcore_features.cfm',1,1,1,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (11,N'items on sale',N'noline=1,notitle=1',N'catcores/dsp_sale.cfm',1,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (12,N'features + products',N'noline=1,notitle=1,listing=short|vertical',N'catcores/catcore_features_products.cfm',1,1,1,0)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (13,N'account directory',N'noline=1,notitle=1,displaycount,accountcols,sort,order,type1',N'users/account/catcore_accounts.cfm',1,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (14,N'Site Map',N'noline=1,alpha=1,notitle=1',N'catcores/dsp_sitemap.cfm',0,0,0,1)
INSERT INTO [CatCore] ([CatCore_ID],[Catcore_Name],[PassParams],[Template],[Category],[Products],[Features],[Page]) VALUES (15,N'Contact Us with file attachment',N'noline=1,EmailTo=email@address.com, BoxTitle=Title,Subject=Email Subject Line',N'email/catcore_contactus_attachment.cfm',1,0,0,1)

---- Inserting data for table `States`
---- 

INSERT INTO [States] ([Abb],[Name]) VALUES (N'AA',N'Armed Forces Americas')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AB',N'Alberta')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AE',N'Armed Forces Canada/Europe')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AK',N'Alaska')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AL',N'Alabama')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AP',N'Armed Forces Pacific')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AR',N'Arkansas')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AS',N'American Samoa')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'AZ',N'Arizona')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'BC',N'British Columbia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'CA',N'California')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'CO',N'Colorado')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'CT',N'Connecticut')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'DC',N'District of Columbia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'DE',N'Delaware')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'FL',N'Florida')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'GA',N'Georgia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'GU',N'Guam')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'HI',N'Hawaii')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'IA',N'Iowa')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'ID',N'Idaho')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'IL',N'Illinois')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'IN',N'Indiana')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'KS',N'Kansas')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'KY',N'Kentucky')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'LA',N'Louisiana')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MA',N'Massachusetts')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MB',N'Manitoba')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MD',N'Maryland')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'ME',N'Maine')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MI',N'Michigan')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MN',N'Minnesota')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MO',N'Missouri')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MS',N'Mississippi')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'MT',N'Montana')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NB',N'New Brunswick')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NC',N'North Carolina')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'ND',N'North Dakota')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NE',N'Nebraska')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NF',N'Newfoundland and Labrador')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NH',N'New Hampshire')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NJ',N'New Jersey')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NM',N'New Mexico')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NS',N'Nova Scotia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NT',N'Northwest Territories')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NV',N'Nevada')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'NY',N'New York')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'OH',N'Ohio')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'OK',N'Oklahoma')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'ON',N'Ontario')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'OR',N'Oregon')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'PA',N'Pennsylvania')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'PE',N'Prince Edward Island')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'PR',N'Puerto Rico')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'PW',N'Palau')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'QC',N'Quebec')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'RI',N'Rhode Island')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'SC',N'South Carolina')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'SD',N'South Dakota')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'SK',N'Saskatchewan')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'TN',N'Tennessee')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'TX',N'Texas')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'UT',N'Utah')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'VA',N'Virginia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'VI',N'U.S. Virgin Islands')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'VT',N'Vermont')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'WA',N'Washington')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'WI',N'Wisconsin')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'WV',N'West Virginia')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'WY',N'Wyoming')
INSERT INTO [States] ([Abb],[Name]) VALUES (N'YT',N'Yukon Territory')

---- Inserting data for table `Countries`
---- 


 SET IDENTITY_INSERT [Countries] ON 
 GO

INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (2,N'AL',N'Albania',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (3,N'DZ',N'Algeria',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (4,N'AD',N'Andorra',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (6,N'AI',N'Anguilla',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (7,N'AG',N'Antigua and Barbuda',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (8,N'AR',N'Argentina',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (10,N'AW',N'Aruba',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (11,N'AU',N'Australia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (12,N'AT',N'Austria',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (15,N'BS',N'Bahamas',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (16,N'BH',N'Bahrain',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (17,N'BD',N'Bangladesh',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (18,N'BB',N'Barbados',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (19,N'BY',N'Belarus',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (20,N'BE',N'Belgium',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (21,N'BZ',N'Belize',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (22,N'BJ',N'Benin',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (23,N'BM',N'Bermuda',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (25,N'BO',N'Bolivia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (27,N'BW',N'Botswana',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (28,N'BR',N'Brazil',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (29,N'VG',N'Virgin Islands (British)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (30,N'BN',N'Brunei',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (31,N'BG',N'Bulgaria',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (32,N'BF',N'Burkina Faso',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (34,N'BI',N'Burundi',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (35,N'CM',N'Cameroon',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (36,N'CA',N'Canada',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (37,N'CV',N'Cape Verde',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (38,N'KY',N'Cayman Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (39,N'CF',N'Central African Republic',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (40,N'TD',N'Chad',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (41,N'CL',N'Chile',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (42,N'CN',N'China - People''s Republic of',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (43,N'CO',N'Colombia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (45,N'CG',N'Congo',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (47,N'CR',N'Costa Rica',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (48,N'CI',N'Cote D''Ivoire (Ivory Coast)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (49,N'HR',N'Croatia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (50,N'CY',N'Cyprus',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (51,N'CZ',N'Czech Republic',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (52,N'DK',N'Denmark',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (53,N'DJ',N'Djibouti',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (54,N'DM',N'Dominica',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (55,N'DO',N'Dominican Republic',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (56,N'EC',N'Ecuador',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (57,N'EG',N'Egypt',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (58,N'SV',N'El Salvador',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (59,N'GQ',N'Equatorial Guinea',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (60,N'ER',N'Eritrea',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (61,N'EE',N'Estonia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (62,N'ET',N'Ethiopia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (64,N'FO',N'Faroe Islands (Denmark)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (65,N'FJ',N'Fiji',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (66,N'FI',N'Finland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (67,N'FR',N'France',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (68,N'GF',N'French Guiana',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (69,N'PF',N'French Polynesia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (70,N'GA',N'Gabon',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (71,N'GM',N'Gambia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (72,N'GE',N'Georgia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (73,N'DE',N'Germany',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (74,N'GH',N'Ghana',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (75,N'GI',N'Gibraltar',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (77,N'GR',N'Greece',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (78,N'GL',N'Greenland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (79,N'GD',N'Grenada',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (80,N'GP',N'Guadeloupe',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (81,N'GT',N'Guatemala',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (82,N'GN',N'Guinea',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (83,N'GW',N'Guinea­Bissau',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (84,N'GY',N'Guyana',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (85,N'HT',N'Haiti',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (86,N'HN',N'Honduras',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (87,N'HK',N'Hong Kong',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (88,N'HU',N'Hungary',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (89,N'IS',N'Iceland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (90,N'IN',N'India',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (91,N'ID',N'Indonesia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (95,N'IL',N'Israel',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (96,N'IT',N'Italy',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (97,N'JM',N'Jamaica',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (98,N'JP',N'Japan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (99,N'JO',N'Jordan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (100,N'KZ',N'Kazakhstan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (101,N'KE',N'Kenya',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (102,N'KI',N'Kiribati',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (105,N'KW',N'Kuwait',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (106,N'KG',N'Kyrgyzstan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (107,N'LA',N'Laos',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (108,N'LV',N'Latvia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (109,N'LB',N'Lebanon',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (110,N'LS',N'Lesotho',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (111,N'LR',N'Liberia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (113,N'LI',N'Liechtenstein',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (114,N'LT',N'Lithuania',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (115,N'LU',N'Luxembourg',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (116,N'MO',N'Macao',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (117,N'MK',N'Macedonia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (118,N'MG',N'Madagascar',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (120,N'MW',N'Malawi',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (121,N'MY',N'Malaysia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (122,N'MV',N'Maldives',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (123,N'ML',N'Mali',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (124,N'MT',N'Malta',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (125,N'MQ',N'Martinique',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (126,N'MR',N'Mauritania',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (127,N'MU',N'Mauritius',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (128,N'MX',N'Mexico',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (129,N'MD',N'Moldova',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (131,N'MS',N'Montserrat',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (132,N'MA',N'Morocco',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (133,N'MZ',N'Mozambique',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (134,N'NA',N'Namibia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (136,N'NP',N'Nepal',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (137,N'NL',N'Netherlands (Holland)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (138,N'AN',N'Netherlands Antilles',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (139,N'NC',N'New Caledonia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (140,N'NZ',N'New Zealand',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (141,N'NI',N'Nicaragua',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (142,N'NE',N'Niger',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (143,N'NG',N'Nigeria',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (144,N'NO',N'Norway',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (145,N'OM',N'Oman',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (146,N'PK',N'Pakistan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (147,N'PA',N'Panama',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (148,N'PG',N'Papua New Guinea',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (149,N'PY',N'Paraguay',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (150,N'PE',N'Peru',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (151,N'PH',N'Philippines',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (153,N'PL',N'Poland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (154,N'PT',N'Portugal',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (155,N'QA',N'Qatar',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (156,N'RE',N'Reunion',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (157,N'RO',N'Romania',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (158,N'RU',N'Russian Federation',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (159,N'RW',N'Rwanda',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (163,N'VC',N'St. Vincent and the Grenadines',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (166,N'SA',N'Saudi Arabia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (167,N'SN',N'Senegal',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (169,N'SC',N'Seychelles',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (170,N'SL',N'Sierra Leone',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (171,N'SG',N'Singapore',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (172,N'SK',N'Slovakia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (173,N'SI',N'Slovenia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (174,N'SB',N'Solomon Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (176,N'ZA',N'South Africa',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (177,N'ES',N'Spain',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (178,N'LK',N'Sri Lanka',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (179,N'KN',N'St. Kitts and Nevis',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (181,N'SR',N'Suriname',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (182,N'SZ',N'Swaziland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (183,N'SE',N'Sweden',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (184,N'CH',N'Switzerland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (185,N'SY',N'Syria',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (186,N'TW',N'Taiwan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (187,N'TJ',N'Tajikistan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (188,N'TZ',N'Tanzania',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (189,N'TH',N'Thailand',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (190,N'TG',N'Togo',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (191,N'TO',N'Tonga',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (192,N'TT',N'Trinidad and Tobago',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (194,N'TN',N'Tunisia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (195,N'TR',N'Turkey',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (197,N'TC',N'Turks and Caicos Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (198,N'TV',N'Tuvalu',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (199,N'UG',N'Uganda',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (200,N'UA',N'Ukraine',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (201,N'AE',N'United Arab Emirates',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (202,N'US',N'United States',1,1,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (203,N'UY',N'Uruguay',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (204,N'UZ',N'Uzbekistan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (205,N'VU',N'Vanuatu',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (207,N'VE',N'Venezuela',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (208,N'VN',N'Vietnam',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (209,N'WF',N'Wallis and Futuna Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (210,N'WS',N'Western Samoa',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (213,N'ZM',N'Zambia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (214,N'ZW',N'Zimbabwe',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (215,N'AS',N'American Samoa',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (216,N'KH',N'Cambodia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (220,N'CK',N'Cook Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (223,N'GU',N'Guam',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (225,N'MH',N'Marshall Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (226,N'MC',N'Monaco',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (228,N'NF',N'Norfolk Island',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (230,N'MP',N'N. Mariana Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (231,N'PW',N'Palau',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (234,N'IE',N'Ireland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (244,N'LC',N'St. Lucia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (248,N'KR',N'Korea (South)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (252,N'VI',N'Virgin Islands (U.S.)',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (256,N'BA',N'Bosnia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (257,N'GB',N'United Kingdom',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (258,N'AF',N'Afghanistan',0,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (259,N'AO',N'Angola',0,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (260,N'AZ',N'Azerbaijan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (261,N'BT',N'Bhutan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (263,N'FM',N'Micronesia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (264,N'MN',N'Mongolia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (266,N'SM',N'San Marino',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (268,N'TM',N'Turkmenistan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (269,N'YE',N'Yemen',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (270,N'YU',N'Yugoslavia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (271,N'AM',N'Armenia',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (273,N'BV',N'Bouvet Island',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (274,N'IO',N'British Indian Ocean Terr.',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (275,N'CD',N'Democratic Rep. of Congo',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (276,N'CX',N'Christmas Island',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (277,N'CC',N'Cocos (Keeling) Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (281,N'FK',N'Falkland Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (282,N'TF',N'French Southern Territories',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (283,N'HM',N'Heard Island',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (284,N'KO',N'Kosrae',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (286,N'MM',N'Myanmar',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (290,N'NB',N'Northern Ireland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (292,N'PO',N'Ponape',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (293,N'PR',N'Puerto Rico',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (294,N'RT',N'Rota',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (295,N'SS',N'Saba',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (296,N'SP',N'Saipan',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (298,N'SF',N'Scotland',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (300,N'SW',N'St. Christopher',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (301,N'EU',N'St. Eustatius',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (302,N'SH',N'St. Helena',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (303,N'MB',N'St. Maarten',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (304,N'TB',N'St. Martin',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (308,N'TI',N'Tinian',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (310,N'TU',N'Truk',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (313,N'VA',N'Vatican City State',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (315,N'YA',N'Yap',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (316,N'AX',N'Aland Islands',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (317,N'AQ',N'Antarctica',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (318,N'KM',N'Comoros',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (319,N'CU',N'Cuba',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (320,N'GG',N'Guernsey',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (321,N'IQ',N'Iraq',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (322,N'JE',N'Jersey',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (323,N'ME',N'Madeira',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (324,N'TA',N'Tahiti',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (325,N'TL',N'Timor Leste',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (326,N'UI',N'Union Island',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (327,N'CS',N'Serbia and Montenegro',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (328,N'VR',N'Virgin Gorda',1,0,0)
INSERT INTO [Countries] ([ID],[Abbrev],[Name],[AllowUPS],[Shipping],[AddShipAmount]) VALUES (329,N'WL',N'Wales',1,0,0)

 SET IDENTITY_INSERT [Countries] OFF 
 GO


---- Inserting data for table `TaxCodes`
---- 


 SET IDENTITY_INSERT [TaxCodes] ON 
 GO

INSERT INTO [TaxCodes] ([Code_ID],[CodeName],[DisplayName],[CalcOrder],[Cumulative],[TaxAddress],[TaxAll],[TaxRate],[TaxShipping],[ShowonProds]) VALUES (1,N'Taxes',N'Taxes',0,0,N'Shipping',0,0,0,0)

 SET IDENTITY_INSERT [TaxCodes] OFF 
 GO


---- Inserting data for table `CreditCards`
---- 


 SET IDENTITY_INSERT [CreditCards] ON 
 GO

INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (2,N'Visa',1)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (3,N'MasterCard',1)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (4,N'Amex',1)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (5,N'Discover',1)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (6,N'Diner''s Club',0)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (7,N'Carte Blanche',0)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (8,N'JCB',0)
INSERT INTO [CreditCards] ([ID],[CardName],[Used]) VALUES (9,N'enRoute',0)

 SET IDENTITY_INSERT [CreditCards] OFF 
 GO


---- Inserting data for table `CustomMethods`
---- 


 SET IDENTITY_INSERT [CustomMethods] ON 
 GO

INSERT INTO [CustomMethods] ([ID],[Name],[Amount],[Used],[Priority],[Domestic],[International]) VALUES (1,N'Next Day Air',10,1,3,1,0)
INSERT INTO [CustomMethods] ([ID],[Name],[Amount],[Used],[Priority],[Domestic],[International]) VALUES (2,N'2nd Day Air',5.5,1,2,1,0)
INSERT INTO [CustomMethods] ([ID],[Name],[Amount],[Used],[Priority],[Domestic],[International]) VALUES (35,N'Ground Shipping',0,1,1,1,0)
INSERT INTO [CustomMethods] ([ID],[Name],[Amount],[Used],[Priority],[Domestic],[International]) VALUES (36,N'Airmail',20,1,4,0,1)

 SET IDENTITY_INSERT [CustomMethods] OFF 
 GO


---- Inserting data for table `CustomShipSettings`
---- 


 SET IDENTITY_INSERT [CustomShipSettings] ON 
 GO

INSERT INTO [CustomShipSettings] ([Setting_ID],[ShowShipTable],[MultPerItem],[CumulativeAmounts],[MultMethods],[Debug]) VALUES (1,1,1,1,0,0)

 SET IDENTITY_INSERT [CustomShipSettings] OFF 
 GO


---- Inserting data for table `Colors`
---- 


 SET IDENTITY_INSERT [Colors] ON 
 GO

INSERT INTO [Colors] ([Color_ID],[Bgcolor],[Bgimage],[MainTitle],[MainText],[MainLink],[MainVLink],[BoxHBgcolor],[BoxHText],[BoxTBgcolor],[BoxTText],[InputHBgcolor],[InputHText],[InputTBgcolor],[InputTText],[OutputHBgcolor],[OutputHText],[OutputTBgcolor],[OutputTText],[OutputTAltcolor],[OutputTHighlight],[LineColor],[HotImage],[SaleImage],[NewImage],[MainLineImage],[MinorLineImage],[Palette_Name],[FormReq],[LayoutFile],[FormReqOB],[PassParam]) VALUES (1,N'',N'',N'666699',N'333333',N'666699',N'666699',N'999999',N'ffffff',N'DBDBDB',N'000000',N'8696b6',N'ffffff',N'ffffff',N'000000',N'acaba9',N'ffffff',N'ffffcc',N'242215',N'FAF287',N'C2C8CE',N'dddddd',N'hot.jpg',N'sale.gif',N'new.gif',N'HR',N'HR',N'CFWebstore Basic',N'ff3300',NULL,N'ff3300',N'')

 SET IDENTITY_INSERT [Colors] OFF 
 GO


---- Inserting data for table `Groups`
---- 

INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (1,N'Administrator',N'User Permissions',N'contentkey_list^1,2;Access^7;Category^1;Feature^11;Page^1;Product^253;Shopping^1023;Users^15',1,N'',0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (2,N'Webmaster',N'Menus, categories, pages, site settings',N'contentkey_list^2,1;FEATURE^3;CATEGORY^1;SHOPPING^3;USERS^7;PAGE^1;Access^0',0,NULL,0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (3,N'Editor',N'Manages site content',N'contentkey_list^4;FEATURE^3;CATEGORY^1;PAGE^3;USERS^2;PRODUCT^2',1,N'',0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (4,N'Order Manager',N'',N'contentkey_list^5,4;USERS^6;SHOPPING^508',1,N'',0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (5,N'Shipping Department',N'',N'contentkey_list^4;USERS^0;SHOPPING^272',1,N'',0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (6,N'Wholesale Startup',N'30% off given on order',N'contentkey_list^4',1,NULL,0,0)
INSERT INTO [Groups] ([Group_ID],[Name],[Description],[Permissions],[Wholesale],[Group_Code],[TaxExempt],[ShipExempt]) VALUES (7,N'Author',N'Add & edit own user''s own features',N'FEATURE^1;USERS^2',0,N'',0,0)

---- Inserting data for table `FedExMethods`
---- 


 SET IDENTITY_INSERT [FedExMethods] ON 
 GO

INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (1,N'FedEx<sup>&reg;</sup> Ground',1,N'FDXG',N'FEDEX_GROUND',1)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (2,N'FedEx<sup>&reg;</sup> Home Delivery',1,N'FDXG',N'GROUND_HOME_DELIVERY',2)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (3,N'FedEx Priority Overnight<sup>&reg;</sup>',1,N'FDXE',N'PRIORITY_OVERNIGHT',4)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (4,N'FedEx 2 Day<sup>&reg;</sup>',1,N'FDXE',N'FEDEX_2_DAY',3)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (5,N'FedEx First Overnight<sup>&reg;</sup>',1,N'FDXE',N'FIRST_OVERNIGHT',5)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (6,N'FedEx Express Saver<sup>&reg;</sup>',1,N'FDXE',N'FEDEX_EXPRESS_SAVER',6)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (7,N'FedEx Standard Overnight<sup>&reg;</sup>',1,N'FDXE',N'STANDARD_OVERNIGHT',7)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (8,N'FedEx International Priority<sup>&reg;</sup>',1,N'FDXE',N'INTERNATIONAL_PRIORITY',8)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (9,N'FedEx International Economy<sup>&reg;</sup>',1,N'FDXE',N'INTERNATIONAL_ECONOMY',9)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (10,N'FedEx International First<sup>&reg;</sup>',0,N'FDXE',N'INTERNATIONAL_FIRST',0)
INSERT INTO [FedExMethods] ([ID],[Name],[Used],[Shipper],[Code],[Priority]) VALUES (11,N'FedEx International Ground<sup>&reg;</sup>',0,N'FDXE',N'INTERNATIONAL_GROUND',0)

 SET IDENTITY_INSERT [FedExMethods] OFF 
 GO


---- Inserting data for table `FedEx_Dropoff`
---- 

INSERT INTO [FedEx_Dropoff] ([FedEx_Code],[Description]) VALUES (N'BUSINESS_SERVICE_CENTER',N'Business Service Center')
INSERT INTO [FedEx_Dropoff] ([FedEx_Code],[Description]) VALUES (N'DROP_BOX',N'Drop Box')
INSERT INTO [FedEx_Dropoff] ([FedEx_Code],[Description]) VALUES (N'REGULAR_PICKUP',N'Regular Pickup')
INSERT INTO [FedEx_Dropoff] ([FedEx_Code],[Description]) VALUES (N'REQUEST_COURIER',N'Request Courier')
INSERT INTO [FedEx_Dropoff] ([FedEx_Code],[Description]) VALUES (N'STATION',N'Station')

---- Inserting data for table `FedEx_Packaging`
---- 

INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_10KG_BOX',N'FedEx<sup>&reg;</sup> 10kb Box')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_25KG_BOX',N'FedEx<sup>&reg;</sup> 25kg Box')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_BOX',N'FedEx<sup>&reg;</sup> Box')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_ENVELOPE',N'FedEx<sup>&reg;</sup> Letter')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_PAK',N'FedEx<sup>&reg;</sup> Pak')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'FEDEX_TUBE',N'FedEx<sup>&reg;</sup> Tube')
INSERT INTO [FedEx_Packaging] ([FedEx_Code],[Description]) VALUES (N'YOUR_PACKAGING',N'Your Packaging')

---- Inserting data for table `FedEx_Settings`
---- 


 SET IDENTITY_INSERT [FedEx_Settings] ON 
 GO

INSERT INTO [FedEx_Settings] ([Fedex_ID],[AccountNo],[MeterNum],[MaxWeight],[UnitsofMeasure],[Dropoff],[Packaging],[OrigZip],[OrigState],[OrigCountry],[Debug],[UseGround],[UseExpress],[Logging],[UserKey],[Password],[UseSmartPost],[AddInsurance]) VALUES (1,NULL,NULL,150,N'KGS/CM',N'REGULAR_PICKUP',N'YOUR_PACKAGING',N'00000',N'NY',N'US',0,1,1,0,NULL,NULL,0,0)

 SET IDENTITY_INSERT [FedEx_Settings] OFF 
 GO


---- Inserting data for table `IntShipTypes`
---- 


 SET IDENTITY_INSERT [IntShipTypes] ON 
 GO

INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (1,N'UPS Next Day Air',1,N'UND',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (2,N'UPS 2nd Day Air',1,N'U2D',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (3,N'UPS Canadian Expedited Service',0,N'UCX',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (4,N'UPS Canadian Express Service',1,N'UCE',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (5,N'UPS 3-Day Select',1,N'U3S',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (6,N'UPS Next Day Air Saver',0,N'UNS',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (7,N'UPS Next Day Air Early AM',0,N'UNA',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (8,N'UPS Ground',1,N'UGN',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (9,N'U.S.P.S.Priority Mail',1,N'PPM',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (10,N'U.S.P.S. Parcel Post Machine',0,N'PGM',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (11,N'U.S.P.S.Express Mail',0,N'PEA',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (12,N'U.S.P.S. Parcel Post Non-Machine',0,N'PGN',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (13,N'FedEx Priority Overnight',0,N'FPN',5)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (14,N'FedEx 2nd Day',1,N'F2D',2)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (15,N'FedEx Express Saver',1,N'FES',3)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (16,N'FedEx Ground',1,N'FGN',1)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (17,N'FedEx Standard Overnight',1,N'FSO',6)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (18,N'DHL Overnight',1,N'DON',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (20,N'UPS Canadian Express Plus Service',0,N'UCP',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (21,N'UPS Standard Canadian Service',0,N'UCS',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (22,N'FedEx First Overnight',1,N'FON',4)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (23,N'FedEx Canadian Ground',0,N'FCG',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (24,N'FedEx Canadian International Economy',0,N'FCE',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (25,N'FedEx Canadian International Priority',0,N'FCP',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (27,N'FedEx Canadian International First',0,N'FCF',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (28,N'UPS 2nd Day Air AM',0,N'U2A',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (29,N'FedEx International Economy',0,N'FIE',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (30,N'FedEx International First',0,N'FIF',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (31,N'FedEx International Priority',0,N'FIP',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (32,N'U.S.P.S.Express Mail PO',0,N'PEO',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (33,N'U.S.P.S. Global Express Guaranteed',1,N'PEG',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (34,N'U.S.P.S. Priority Mail Intl.',1,N'PMI',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (35,N'U.S.P.S. First Class Mail Intl.',1,N'PFI',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (36,N'U.S.P.S. Express Mail Intl.',0,N'PEM',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (37,N'UPS WorldWide Expedited',1,N'UWX',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (38,N'UPS WorldWide Express',1,N'UWE',99)
INSERT INTO [IntShipTypes] ([ID],[Name],[Used],[Code],[Priority]) VALUES (39,N'UPS WorldWide Express Plus',0,N'UWP',99)

 SET IDENTITY_INSERT [IntShipTypes] OFF 
 GO


---- Inserting data for table `Intershipper`
---- 


 SET IDENTITY_INSERT [Intershipper] ON 
 GO

INSERT INTO [Intershipper] ([ID],[Password],[Residential],[Pickup],[UnitsofMeasure],[MaxWeight],[Carriers],[UserID],[Classes],[MerchantZip],[Logging],[Debug]) VALUES (1,NULL,1,N'SCD',N'LBS/IN',150,N'ALL',NULL,N'ALL',N'00000',0,0)

 SET IDENTITY_INSERT [Intershipper] OFF 
 GO


---- Inserting data for table `Locales`
---- 


 SET IDENTITY_INSERT [Locales] ON 
 GO

INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (1,N'Dutch (Belgian)',N'Netherlands')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (2,N'Dutch (Standard)',N'Euro')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (3,N'English (Australian)',N'Australia')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (4,N'English (Canadian)',N'Canada')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (5,N'English (New Zealand)',N'New Zealand')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (6,N'English (UK)',N'UK')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (7,N'English (US)',N'US')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (8,N'French (Belgian)',N'Belgium')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (9,N'French (Canadian)',N'Canada')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (10,N'French (Standard)',N'France')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (11,N'French (Swiss)',N'Switzerland')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (12,N'German (Austrian)',N'Austria')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (13,N'German (Standard)',N'Germany')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (14,N'German (Swiss)',N'Switzerland')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (15,N'Italian (Standard)',N'Italy')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (16,N'Italian (Swiss)',N'Switzerland')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (17,N'Norwegian (Bokmal)',N'Norway')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (18,N'Norwegian (Nynorsk)',N'Norway')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (19,N'Portuguese (Brazilian)',N'Portugal')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (20,N'Portuguese (Standard)',N'Portugal')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (21,N'Spanish (Mexican)',N'Mexico')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (22,N'Spanish (Standard)',N'Spain')
INSERT INTO [Locales] ([ID],[Name],[CurrExchange]) VALUES (23,N'Swedish',N'Sweden')

 SET IDENTITY_INSERT [Locales] OFF 
 GO


---- Inserting data for table `MailText`
---- 


 SET IDENTITY_INSERT [MailText] ON 
 GO

INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (2,N'Email Confirmation',N'Welcome to %SiteName%.\r\nTo complete the Email Confirmation process please click on the link below:\r\n%SiteURL%index.cfm?fuseaction=users.unlock&amp;email=%Email%&amp;emaillock=%EmailLock%\r\nIf the link does not appear in your email as a clickable link, just copy and paste the complete URL into your browser''s location bar and hit enter.\r\nYou can also complete the process by copying the following code into the Email Confirmation form.\r\nYour Code:\r\n%EmailLock%\r\nTo access the Email Confirmation form just sign in and click on ''My Account''.\r\nYou only need to confirm your email address once.\r\nSee you online!\r\n-- %SiteName%',N'%SiteName% Email Confirmation Code',NULL,1,N'EmailConfirmation')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (3,N'New Member Admin Notification',N'A new member has registered on %SiteName%:\r\n\r\n%MergeContent%',N'New Member Registration on  %SiteName%',NULL,1,N'NewMemberNotice')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (4,N'Forgot Password',N'Your password for %SiteName% has been reset to: %MergeContent%. Your username for this account is ''%Username%''.<br>\r\n<br>\r\nAfter logging in at %SiteURL% you can change this temporary password by clicking on ''My Account''.<br>\r\n<br>\r\nSee you online!',N'Login Information',NULL,1,N'ForgotPassword')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (5,N'Order Received Affiliate Notice',N'Here is a summary of an order received through your site! %Mergecontent%',N'Affiliate Order Received!',NULL,1,N'OrderRecvdAffiliate')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (6,N'Order Received Customer Notice',N'Here is a summary of your order, thanks for shopping with us! %mergecontent%',N'Order Received!',NULL,1,N'OrderRecvdCustomer')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (7,N'Gift Registry Purchase Notification',N'The following Gift Registry item was purchased: %Mergecontent%',N'%SiteName% Gift Registry Purchase',NULL,1,N'GiftRegistryPurchase')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (8,N'Membership Auto-Renewal Billed',NULL,NULL,NULL,1,N'MembershipAutoRenewBilled')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (9,N'Membership Auto-Renewal Cancel',N'<p>Your membership at %SiteName% has been cancelled as requested. Thanks for visiting!</p>',NULL,NULL,1,N'MembershipAutoRenewCancel')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (10,N'Membership Renewal Reminder',N'Just a quick reminder that it is time to renew your %sitename%\r\nmembership due to expire in just a few days. You can renew your\r\nmembership at %SiteURL%. <br>\r\n<br>\r\nSee you online!',NULL,NULL,1,N'MembershipRenewReminder')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (13,N'Order Shipping/Tracking Information',N'Shipping information for your order from %SiteName%<br />\r\n<br />\r\n%mergecontent%<br />\r\n<br />\r\n%Merchant%',N'%SiteName% Order Shipped!',NULL,1,N'OrderShipped')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (14,N'Custom Newsletter',N'Here''s an example of a custom newsletter. Inform your customers of what is going on at %SiteName%!<br />\r\n<br />\r\n%Merchant%',N'%SiteName% Newsletter',NULL,0,N'Newsletter')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (15,N'Gift Certificate Purchase',N'<p>Thanks for your purchase of a gift certificate from %SiteName%! Just enter the code when you are checking out to receive credits towards your purchase.</p>\r\n<p>%Mergecontent%</p>',N'%SiteName% Gift Certificate Purchase',NULL,1,N'GiftCertPurchase')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (16,N'New Affiliate Admin Notification',N'A new affiliate has registered on %SiteName%:\r\n<br><br>%MergeContent%',N'New Affiliate Registration on',NULL,1,N'NewAffiliateNotice')
INSERT INTO [MailText] ([MailText_ID],[MailText_Name],[MailText_Message],[MailText_Subject],[MailText_Attachment],[System],[MailAction]) VALUES (17,N'Order Refund',N'<p>%MergeContent%</p><p>Please shop with us again!</p><p>%Merchant%</p>',N'%SiteName% Order Refund',NULL,1,N'OrderRefund')

 SET IDENTITY_INSERT [MailText] OFF 
 GO


---- Inserting data for table `OrderSettings`
---- 


 SET IDENTITY_INSERT [OrderSettings] ON 
 GO

INSERT INTO [OrderSettings] ([ID],[AllowInt],[AllowOffline],[OnlyOffline],[OfflineMessage],[CCProcess],[AllowPO],[EmailAdmin],[EmailUser],[EmailAffs],[EmailDrop],[OrderEmail],[DropEmail],[EmailDropWhen],[Giftcard],[Delivery],[Coupons],[Backorders],[BaseOrderNum],[StoreCardInfo],[UseCVV2],[MinTotal],[NoGuests],[UseBilling],[UsePayPal],[PayPalEmail],[PayPalLog],[CustomText1],[CustomText2],[CustomText3],[CustomSelect1],[CustomSelect2],[CustomChoices1],[CustomChoices2],[CustomText_Req],[CustomSelect_Req],[AgreeTerms],[Giftwrap],[ShowBasket],[SkipAddressForm],[PayPalMethod],[UseCRESecure],[PDT_Token],[PayPalServer]) VALUES (1,1,1,0,N'Please call us at 1-xxx-xxx-xxxx to complete your order.',N'None',0,1,1,1,0,N'info@yoursite.com',NULL,N'Processed',1,1,1,1,1000,0,0,0,0,1,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,N'Standard',0,NULL,N'live')

 SET IDENTITY_INSERT [OrderSettings] OFF 
 GO


---- Inserting data for table `Permission_Groups`
---- 


 SET IDENTITY_INSERT [Permission_Groups] ON 
 GO

INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (1,N'Access')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (2,N'Category')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (3,N'Feature')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (4,N'Product')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (5,N'Shopping')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (6,N'Users')
INSERT INTO [Permission_Groups] ([Group_ID],[Name]) VALUES (7,N'Page')

 SET IDENTITY_INSERT [Permission_Groups] OFF 
 GO


---- Inserting data for table `Permissions`
---- 


 SET IDENTITY_INSERT [Permissions] ON 
 GO

INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (1,1,N'Assign Permissions',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (2,1,N'Manage Access Keys',2)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (3,1,N'Manage Memberships',4)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (4,2,N'Category Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (5,3,N'Feature Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (6,3,N'Feature Editor',2)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (7,3,N'Feature Author',4)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (8,4,N'Full Product Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (9,4,N'User Products Admin',2)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (10,4,N'Discount Admin',4)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (11,4,N'Promotion Admin',8)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (12,5,N'Cart Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (13,5,N'Order Access',2)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (14,5,N'Gift Certs Admin',4)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (15,5,N'Order Approve',8)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (16,5,N'Order Process',16)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (17,5,N'Order Dropship',32)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (18,5,N'Order Edit',64)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (19,5,N'Order Reports',128)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (20,6,N'Site Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (21,6,N'Admin Menu',2)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (22,6,N'Group & User Admin',4)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (23,6,N'User Export',8)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (24,7,N'Page Admin',1)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (25,4,N'Product Import',16)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (26,4,N'Product Export',32)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (27,4,N'Site Feeds',128)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (28,5,N'Order Search',256)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (29,4,N'Product Reviews',64)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (30,3,N'Feature Reviews',8)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (31,5,N'Gift Registry Admin',512)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (32,5,N'Abandoned Basket Admin',1024)
INSERT INTO [Permissions] ([ID],[Group_ID],[Name],[BitValue]) VALUES (33,5,N'Place Orders as Customer',1024)

 SET IDENTITY_INSERT [Permissions] OFF 
 GO


---- Inserting data for table `PickLists`
---- 


 SET IDENTITY_INSERT [PickLists] ON 
 GO

INSERT INTO [PickLists] ([Picklist_ID],[Feature_Type],[Acc_Rep],[Acc_Type1],[Acc_Descr1],[Product_Availability],[Shipping_Status],[PO_Status],[GiftRegistry_Type],[Review_Editorial]) VALUES (1,N'press release,article,training',N'mike,mary jo',N'distributor',NULL,N'ships immediately,on backorder',N'incomplete,backordered',N'emailed,faxed',N'wedding,christmas,birthday,baby',N'Editor,Spotlight')

 SET IDENTITY_INSERT [PickLists] OFF 
 GO


---- Inserting data for table `Settings`
---- 


 SET IDENTITY_INSERT [Settings] ON 
 GO

INSERT INTO [Settings] ([SettingID],[SiteName],[SiteLogo],[Merchant],[HomeCountry],[MerchantEmail],[Webmaster],[DefaultImages],[FilePath],[MimeTypes],[MoneyUnit],[WeightUnit],[SizeUnit],[InvLevel],[ShowInStock],[OutofStock],[ShowRetail],[ItemSort],[Wishlists],[OrderButtonText],[OrderButtonImage],[AllowWholesale],[UseVerity],[CollectionName],[CColumns],[PColumns],[MaxProds],[ProdRoot],[CachedProds],[FeatureRoot],[MaxFeatures],[Locale],[CurrExchange],[CurrExLabel],[Color_ID],[Metadescription],[Keywords],[Email_Server],[Email_Port],[Admin_New_Window],[UseSES],[Default_Fuseaction],[Editor],[ProductReviews],[ProductReview_Approve],[ProductReview_Flag],[ProductReview_Add],[ProductReview_Rate],[ProductReviews_Page],[FeatureReviews],[FeatureReview_Add],[FeatureReview_Flag],[FeatureReview_Approve],[GiftRegistry]) VALUES (1,N'CFWebstore',NULL,NULL,N'US^United States',N'info@yoursite.com',N'orders@yoursite.com',N'images',NULL,N'application/x-zip-compressed,application/zip, application/msword, application/x-excel, text/plain, application/pdf, image/gif, image/jpeg, image/pjpeg, image/png, audio/mpeg',N'Dollars',N'Pounds',N'Inches',N'Mixed',0,1,1,N'Name',1,N'Add to Cart',N'addtocart.gif',0,0,NULL,2,1,10,0,0,0,6,N'English (US)',N'None',NULL,1,N'default site description goes here',N'default,site,description',N'mail.yoursite.net',25,1,0,N'page.home',N'Default',1,0,1,2,0,2,1,2,0,1,0)

 SET IDENTITY_INSERT [Settings] OFF 
 GO


---- Inserting data for table `ShipSettings`
---- 


 SET IDENTITY_INSERT [ShipSettings] ON 
 GO

INSERT INTO [ShipSettings] ([ID],[ShipType],[ShipBase],[MerchantZip],[InStorePickup],[AllowNoShip],[NoShipMess],[NoShipType],[ShipHand],[Freeship_Min],[Freeship_ShipIDs],[ShowEstimator],[ShowFreight],[UseDropShippers],[ID_Tag]) VALUES (1,N'Price',0,N'00000',0,1,N'We were unable to calculate shipping for your order.<BR>\r\nPlease complete your order and we will email you the exact shipping cost before final processing of your order.',N'Not Calculated',0,0,NULL,0,0,0,NULL)

 SET IDENTITY_INSERT [ShipSettings] OFF 
 GO


---- Inserting data for table `UPSMethods`
---- 


 SET IDENTITY_INSERT [UPSMethods] ON 
 GO

INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (1,N'Next Day Air<sup>&reg;</sup>',N'01',N'00',N'00',N'01',N'00',N'00',1,4)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (2,N'2nd Day Air<sup>&reg;</sup>',N'02',N'00',N'00',N'02',N'00',N'00',1,3)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (3,N'Ground',N'03',N'00',N'00',N'03',N'00',N'00',1,1)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (4,N'Worldwide Express<sup><small>SM</small></sup>',N'07',N'00',N'07',N'07',N'00',N'07',1,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (5,N'Worldwide Expedited<sup><small>SM</small></sup>',N'08',N'00',N'08',N'08',N'00',N'08',1,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (6,N'Express',N'00',N'07',N'00',N'00',N'07',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (7,N'Expedited',N'00',N'08',N'00',N'00',N'08',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (8,N'Standard',N'11',N'11',N'11',N'00',N'00',N'00',1,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (9,N'3 Day Select<sup><small>SM</small></sup>',N'12',N'00',N'12',N'00',N'00',N'00',1,2)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (10,N'Next Day Air Saver<sup>&reg;</sup>',N'13',N'00',N'00',N'00',N'00',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (11,N'Express Saver',N'00',N'65',N'13',N'00',N'00',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (12,N'Next Day Air<sup>&reg;</sup> Early A.M.<sup>&reg;</sup>',N'14',N'00',N'00',N'14',N'00',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (13,N'Express Early A.M.',N'00',N'00',N'14',N'00',N'00',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (14,N'Worldwide Express Plus<sup><small>SM</small></sup>',N'54',N'54',N'54',N'54',N'00',N'54',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (15,N'Express Plus',N'00',N'00',N'00',N'00',N'54',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (16,N'2nd Day Air A.M.<sup>&reg;</sup>',N'59',N'00',N'00',N'00',N'00',N'00',0,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (17,N'Worldwide Saver<sup><small>SM</small></sup>',N'65',N'00',N'65',N'65',N'65',N'65',1,99)
INSERT INTO [UPSMethods] ([ID],[Name],[USCode],[EUCode],[CACode],[PRCode],[MXCode],[OOCode],[Used],[Priority]) VALUES (18,N'Express Saver<sup><small>SM</small></sup>',N'00',N'65',N'13',N'00',N'00',N'00',0,99)

 SET IDENTITY_INSERT [UPSMethods] OFF 
 GO


---- Inserting data for table `UPS_Origins`
---- 

INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'CA',N'Canada',2)
INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'EU',N'European Union',5)
INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'MX',N'Mexico',4)
INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'OO',N'All Other Origins',6)
INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'PR',N'Puerto Rico',3)
INSERT INTO [UPS_Origins] ([UPS_Code],[Description],[OrderBy]) VALUES (N'US',N'United States',1)

---- Inserting data for table `UPS_Packaging`
---- 

INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'01',N'UPS Letter')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'02',N'Your Package')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'03',N'UPS Tube')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'04',N'UPS Pak')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'21',N'UPS Express Box')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'24',N'UPS 25kg Box')
INSERT INTO [UPS_Packaging] ([UPS_Code],[Description]) VALUES (N'25',N'UPS 10Kg Box')

---- Inserting data for table `UPS_Pickup`
---- 

INSERT INTO [UPS_Pickup] ([UPS_Code],[Description]) VALUES (N'01',N'Daily Pickup')
INSERT INTO [UPS_Pickup] ([UPS_Code],[Description]) VALUES (N'03',N'Customer Counter')
INSERT INTO [UPS_Pickup] ([UPS_Code],[Description]) VALUES (N'11',N'Suggested Retail Rates (UPS Store)')

---- Inserting data for table `UPS_Settings`
---- 


 SET IDENTITY_INSERT [UPS_Settings] ON 
 GO

INSERT INTO [UPS_Settings] ([UPS_ID],[ResRates],[Username],[Password],[Accesskey],[AccountNo],[Origin],[MaxWeight],[UnitsofMeasure],[CustomerClass],[Pickup],[Packaging],[OrigZip],[OrigCity],[OrigCountry],[Debug],[UseAV],[Logging]) VALUES (1,1,NULL,NULL,NULL,NULL,N'US',150,N'LBS/IN',N'01',N'01',N'02',N'00000',N'',N'US',0,1,0)

 SET IDENTITY_INSERT [UPS_Settings] OFF 
 GO


---- Inserting data for table `USPSCountries`
---- 

INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (2,N'AL',N'Albania')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (3,N'DZ',N'Algeria')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (4,N'AD',N'Andorra')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (6,N'AI',N'Anguilla')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (7,N'AG',N'Antigua and Barbuda')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (8,N'AR',N'Argentina')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (10,N'AW',N'Aruba')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (11,N'AU',N'Australia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (12,N'AT',N'Austria')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (15,N'BS',N'Bahamas')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (16,N'BH',N'Bahrain')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (17,N'BD',N'Bangladesh')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (18,N'BB',N'Barbados')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (19,N'BY',N'Belarus')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (20,N'BE',N'Belgium')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (21,N'BZ',N'Belize')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (22,N'BJ',N'Benin')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (23,N'BM',N'Bermuda')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (25,N'BO',N'Bolivia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (27,N'BW',N'Botswana')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (28,N'BR',N'Brazil')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (29,N'VG',N'British Virgin Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (30,N'BN',N'Brunei Darussalam')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (31,N'BG',N'Bulgaria')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (32,N'BF',N'Burkina Faso')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (34,N'BI',N'Burundi')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (35,N'CM',N'Cameroon')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (36,N'CA',N'Canada')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (37,N'CV',N'Cape Verde')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (38,N'KY',N'Cayman Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (39,N'CF',N'Central African Republic')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (40,N'TD',N'Chad')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (41,N'CL',N'Chile')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (42,N'CN',N'China')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (43,N'CO',N'Colombia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (45,N'CG',N'Congo')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (47,N'CR',N'Costa Rica')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (48,N'CI',N'Cote d lvoire (Ivory Coast)')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (49,N'HR',N'Croatia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (50,N'CY',N'Cyprus')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (51,N'CZ',N'Czech Republic')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (52,N'DK',N'Denmark')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (53,N'DJ',N'Djibouti')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (54,N'DM',N'Dominica')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (55,N'DO',N'Dominican Republic')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (56,N'EC',N'Ecuador')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (57,N'EG',N'Egypt')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (58,N'SV',N'El Salvador')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (59,N'GQ',N'Equatorial Guinea')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (60,N'ER',N'Eritrea')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (61,N'EE',N'Estonia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (62,N'ET',N'Ethiopia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (64,N'FO',N'Faroe Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (65,N'FJ',N'Fiji')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (66,N'FI',N'Finland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (67,N'FR',N'France')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (68,N'GF',N'French Guiana')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (69,N'PF',N'French Polynesia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (70,N'GA',N'Gabon')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (71,N'GM',N'Gambia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (72,N'GE',N'Georgia, Republic of')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (73,N'DE',N'Germany')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (74,N'GH',N'Ghana')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (75,N'GI',N'Gibraltar')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (77,N'GR',N'Greece')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (78,N'GL',N'Greenland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (79,N'GD',N'Grenada')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (80,N'GP',N'Guadeloupe')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (81,N'GT',N'Guatemala')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (82,N'GN',N'Guinea')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (83,N'GW',N'Guinea-Bissau')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (84,N'GY',N'Guyana')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (85,N'HT',N'Haiti')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (86,N'HN',N'Honduras')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (87,N'HK',N'Hong Kong')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (88,N'HU',N'Hungary')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (89,N'IS',N'Iceland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (90,N'IN',N'India')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (91,N'ID',N'Indonesia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (95,N'IL',N'Israel')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (96,N'IT',N'Italy')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (97,N'JM',N'Jamaica')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (98,N'JP',N'Japan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (99,N'JO',N'Jordan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (100,N'KZ',N'Kazakhstan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (101,N'KE',N'Kenya')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (102,N'KI',N'Kiribati')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (105,N'KW',N'Kuwait')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (106,N'KG',N'Kyrgyzstan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (107,N'LA',N'Lao People''s Democratic Republic')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (108,N'LV',N'Latvia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (109,N'LB',N'Lebanon')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (110,N'LS',N'Lesotho')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (111,N'LR',N'Liberia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (113,N'LI',N'Liechtenstein')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (114,N'LT',N'Lithuania')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (115,N'LU',N'Luxembourg')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (116,N'MO',N'Macao')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (117,N'MK',N'Macedonia, Republic of')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (118,N'MG',N'Madagascar')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (119,N'ME',N'Madeira')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (120,N'MW',N'Malawi')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (121,N'MY',N'Malaysia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (122,N'MV',N'Maldives')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (123,N'ML',N'Mali')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (124,N'MT',N'Malta')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (125,N'MQ',N'Martinique')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (126,N'MR',N'Mauritania')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (127,N'MU',N'Mauritius')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (128,N'MX',N'Mexico')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (129,N'MD',N'Moldova')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (131,N'MS',N'Montserrat')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (132,N'MA',N'Morocco')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (133,N'MZ',N'Mozambique')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (134,N'NA',N'Namibia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (136,N'NP',N'Nepal')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (137,N'NL',N'Netherlands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (138,N'AN',N'Netherlands Antilles')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (139,N'NC',N'New Caledonia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (140,N'NZ',N'New Zealand')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (141,N'NI',N'Nicaragua')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (142,N'NE',N'Niger')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (143,N'NG',N'Nigeria')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (144,N'NO',N'Norway')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (145,N'OM',N'Oman')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (146,N'PK',N'Pakistan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (147,N'PA',N'Panama')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (148,N'PG',N'Papua New Guinea')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (149,N'PY',N'Paraguay')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (150,N'PE',N'Peru')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (151,N'PH',N'Philippines')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (153,N'PL',N'Poland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (154,N'PT',N'Portugal')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (155,N'QA',N'Qatar')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (156,N'RE',N'Reunion')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (157,N'RO',N'Romania')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (158,N'RU',N'Russian Federation')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (159,N'RW',N'Rwanda')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (163,N'VC',N'St. Vincent and the Grenadines')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (166,N'SA',N'Saudi Arabia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (167,N'SN',N'Senegal')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (169,N'SC',N'Seychelles')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (170,N'SL',N'Sierra Leone')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (171,N'SG',N'Singapore')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (172,N'SK',N'Slovakia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (173,N'SI',N'Slovenia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (174,N'SB',N'Solomon Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (176,N'ZA',N'South Africa')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (177,N'ES',N'Spain')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (178,N'LK',N'Sri Lanka')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (179,N'KN',N'St. Kitts and Nevis')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (181,N'SR',N'Suriname')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (182,N'SZ',N'Swaziland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (183,N'SE',N'Sweden')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (184,N'CH',N'Switzerland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (185,N'SY',N'Syrian Arab Republic')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (186,N'TW',N'Taiwan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (187,N'TJ',N'Tajikistan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (188,N'TZ',N'Tanzania')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (189,N'TH',N'Thailand')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (190,N'TG',N'Togo')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (191,N'TO',N'Tonga')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (192,N'TT',N'Trinidad and Tobago')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (194,N'TN',N'Tunisia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (195,N'TR',N'Turkey')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (197,N'TC',N'Turks and Caicos Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (198,N'TV',N'Tuvalu')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (199,N'UG',N'Uganda')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (200,N'UA',N'Ukraine')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (201,N'AE',N'United Arab Emirates')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (202,N'US',N'United States')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (203,N'UY',N'Uruguay')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (204,N'UZ',N'Uzbekistan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (205,N'VU',N'Vanuatu')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (207,N'VE',N'Venezuela')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (208,N'VN',N'Vietnam')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (209,N'WF',N'Wallis and Futuna Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (210,N'WS',N'Western Samoa')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (212,N'CD',N'Congo, Democratic Republic of the')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (213,N'ZM',N'Zambia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (214,N'ZW',N'Zimbabwe')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (215,N'AS',N'American Samoa')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (216,N'KH',N'Cambodia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (220,N'CK',N'United Kingdom (Great Britain)')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (221,N'CB',N'Netherlands Antilles')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (223,N'GU',N'Guam')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (224,N'KO',N'Kosrae')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (225,N'MH',N'Marshall Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (226,N'MC',N'Monaco')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (227,N'MM',N'Myanmar')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (228,N'NF',N'Norfolk Island')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (230,N'MP',N'Northern Mariana Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (231,N'PW',N'Palau')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (232,N'PO',N'Ponape')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (234,N'IE',N'Ireland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (235,N'RT',N'Rota')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (236,N'SS',N'Saba')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (237,N'SP',N'Saipan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (240,N'SW',N'St. Christopher and Nevis')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (241,N'SX',N'US Possession')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (243,N'UV',N'St. John')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (244,N'LC',N'St. Lucia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (246,N'TB',N'St. Martin')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (248,N'KR',N'Korea, Republic of (South Korea)')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (249,N'TA',N'Taiwan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (250,N'TU',N'Truk')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (252,N'VI',N'U.S. Virgin Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (254,N'WL',N'Wales')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (255,N'YA',N'Yap')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (256,N'BA',N'Bosnia-Herzegovina')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (257,N'GB',N'Great Britain and Northern Ireland')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (270,N'AF',N'Afghanistan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (271,N'FM',N'Micronesia, Federated States')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (272,N'PR',N'Puerto Rico')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (273,N'AM',N'Armenia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (274,N'AO',N'Angola')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (275,N'AQ',N'Antarctica')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (276,N'AZ',N'Azerbaijan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (277,N'AO',N'Angola')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (278,N'BT',N'Bhutan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (279,N'BV',N'Bouvet Island')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (280,N'CC',N'Cocos (Keeling) Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (281,N'CU',N'Cuba')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (282,N'CX',N'Christmas Island')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (283,N'EH',N'Western Sahara')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (284,N'FK',N'Falkland Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (285,N'FM',N'Micronesia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (286,N'FX',N'France, Metropolitan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (287,N'GS',N'South Georgia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (288,N'HM',N'Heard & McDonald Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (289,N'IO',N'British Indian Ocean Territory')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (290,N'IQ',N'Iraq')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (291,N'KM',N'Comoros')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (292,N'MN',N'Mongolia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (293,N'NR',N'Nauru')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (294,N'NU',N'Niue')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (295,N'SD',N'Sudan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (296,N'SH',N'St. Helena')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (297,N'SJ',N'Svalbard & Jan Mayen Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (298,N'SM',N'San Marino')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (299,N'SO',N'Somalia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (300,N'ST',N'Sao Tome & Principe')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (301,N'TF',N'French Southern Territories')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (302,N'TK',N'Tokelau')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (303,N'TM',N'Turkmenistan')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (304,N'TP',N'East Timor')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (305,N'UM',N'United States Minor Outlying Islands')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (306,N'VA',N'Vatican City State')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (307,N'YE',N'Yemen')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (308,N'YT',N'Mayotte')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (309,N'YU',N'Yugoslavia')
INSERT INTO [USPSCountries] ([ID],[Abbrev],[Name]) VALUES (310,N'ZR',N'Zaire')

---- Inserting data for table `USPSMethods`
---- 


 SET IDENTITY_INSERT [USPSMethods] ON 
 GO

INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (1,N'Priority Mail',1,N'Priority Mail 2-Day',N'Domestic',1)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (2,N'Parcel Post',1,N'Standard Post',N'Domestic',2)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (3,N'Priority Mail Express 1-Day',1,N'Express Mail',N'Domestic',3)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (6,N'First Class',1,N'First-Class Mail Parcel',N'Domestic',6)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (11,N'Media Mail',0,N'Media Mail',N'Domestic',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (12,N'Library Mail',0,N'Library Mail',N'Domestic',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (13,N'Global Express Guaranteed',1,N'Global Express Guaranteed (GXG)**',N'International',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (14,N'Express Mail Intl.',1,N'Priority Mail Express International',N'International',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (16,N'Priority Mail Intl.',1,N'Priority Mail International',N'International',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (19,N'First-Class Mail Intl',1,N'First-Class Package International Service**',N'International',99)
INSERT INTO [USPSMethods] ([ID],[Name],[Used],[Code],[Type],[Priority]) VALUES (20,N'Express Mail Sunday/Holiday Delivery',0,N'Priority Mail Express 1-Day Sunday/Holiday Delivery',N'Domestic',2)

 SET IDENTITY_INSERT [USPSMethods] OFF 
 GO


---- Inserting data for table `USPS_Settings`
---- 


 SET IDENTITY_INSERT [USPS_Settings] ON 
 GO

INSERT INTO [USPS_Settings] ([USPS_ID],[UserID],[Server],[MerchantZip],[MaxWeight],[Logging],[Debug],[UseAV]) VALUES (1,N'userid',N'http://production.shippingapis.com/ShippingAPI.dll',N'00000',50,0,0,0)

 SET IDENTITY_INSERT [USPS_Settings] OFF 
 GO


---- Inserting data for table `UserSettings`
---- 


 SET IDENTITY_INSERT [UserSettings] ON 
 GO

INSERT INTO [UserSettings] ([ID],[UseRememberMe],[EmailAsName],[UseStateList],[UseStateBox],[RequireCounty],[UseCountryList],[UseResidential],[UseGroupCode],[UseBirthdate],[UseTerms],[TermsText],[UseCCard],[UseEmailConf],[UseEmailNotif],[MemberNotify],[UseShipTo],[UseAccounts],[ShowAccount],[ShowDirectory],[ShowSubscribe],[StrictLogins],[MaxDailyLogins],[MaxFailures],[AllowAffs],[AffPercent],[AllowWholesale]) VALUES (1,1,0,1,1,0,1,0,0,0,0,N'',0,0,0,0,1,0,1,1,1,0,10,3,1,0.04,0)

 SET IDENTITY_INSERT [UserSettings] OFF 
 GO


---- Inserting data for table `Pages`
---- 

INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (0,N'none',0,NULL,1,NULL,N'(Default Page Menu)',N'',NULL,NULL,NULL,NULL,NULL,N'',0,NULL,0,0,0,3,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (1,N'index.cfm',2,N'topcats=1,onsale=1,new=1,hot=1,prodofday=1,notsold=1,listing=vertical',1,N'home',N'home',N'Better than ever!',NULL,NULL,NULL,NULL,NULL,N'<br />We&nbsp;have created this demo site to show off some of the&nbsp;incredible features of CFWebstore''s new Fusebox Edition.&nbsp;This product is so flexible that it''s impossible to&nbsp;demonstrate all the things it can do but&nbsp;look around&nbsp;and we''re&nbsp;sure you''ll agree that it is packed with incredible features! <br /><br />This page, like all the other pages in this site, is completely editable&nbsp;using&nbsp;any web browser. You have full control over the layout and content.',1,NULL,0,7,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (2,N'index.cfm?fuseaction=users.manager',0,N'noline=1',1,N'manager',N'user account',N'My Account',NULL,NULL,NULL,NULL,NULL,N'',1,NULL,0,3,0,0,N'',N'',N'')
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (3,N'index.cfm?fuseaction=shopping.basket',0,N'noline=1',1,N'basket',N'view cart',N'',NULL,NULL,NULL,NULL,NULL,N'<blockquote style="margin-right: 0px;" dir="ltr" class="carttext">\r\n<p><strong>Return Policy</strong>: All Sales Final. Return of damaged goods&nbsp;will be accepted at time of<br />\r\ndelivery with 15% restocking fee.</p>\r\n<p>This bottom text area is defined in the Page Manager for the shopping cart.</p>\r\n</blockquote>\r\n<p align="center"><img width="39" height="24" border="0" src="images/icons/cc_mastercard.gif" alt="" />&nbsp; <img width="36" height="24" border="0" src="images/icons/cc_visa.gif" alt="" />&nbsp; <img width="29" height="24" border="0" src="images/icons/cc_amex.gif" alt="" />&nbsp; <img width="60" height="24" border="0" src="images/icons/cc_discover.gif" alt="" /></p>',1,NULL,0,1,0,0,N'',N'',N'Shopping Cart')
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (4,N'index.cfm?fuseaction=page.search',5,NULL,1,N'search',N'search',N'Site Search',NULL,NULL,NULL,NULL,NULL,N'Please enter keywords to search for:',1,NULL,0,6,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (5,N'index.cfm?fuseaction=page.searchresults',6,NULL,0,N'searchResults',N'Search Results',N'Search Results',NULL,NULL,NULL,NULL,NULL,N'',1,NULL,0,9999,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (6,N'index.cfm?fuseaction=page.new',3,N'new=1,onsale=1',0,N'new',N'what''s new',N'What''s New',NULL,NULL,NULL,NULL,NULL,N'<P>This&nbsp;page displays all the new and&nbsp;sale&nbsp;categories, products and feature articles.&nbsp;Items are automatically placed on this page when you&nbsp;turn on&nbsp;the "new" or "highlight" option&nbsp;on the item''s admin page.&nbsp; </P>\r\n<P>This What''s New page is included as a standard Page in the Page Manager. You can also call it as a Category template to include it as a Category&nbsp;OR it can be included as part of&nbsp; the Home page. </P>\r\n<P>You have the choice of selecting only New, only Sale, or Both.</P>',1,NULL,0,9999,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (7,N'index.cfm?fuseaction=page.membersOnly',0,NULL,0,N'membersOnly',N'Members Only',N'Members Only',NULL,NULL,NULL,NULL,NULL,N'<p><strong><font color="#ff3300">Sorry!&nbsp; A membership is required.</font></strong></p>\r\n<p>This text displays when content is locked with an access key and the user IS logged in and does not have the key. If the user was not logged in, the user would get a PLEASE LOG IN page instead.</p>\r\n<p>You can check your membership information by clicking on the Current Memberships link on the My Accounts page or clicking <a href="index.cfm?fuseaction=access.memberships">HERE</a>.</p>\r\n<p>You can edit the text of this page in the Page Manager.</p>\r\n<p>This page automatically&nbsp;lists all&nbsp;Membership Products below.</p>',1,NULL,0,9999,0,0,N'',N'members, login',N'CFWebstore Members Only Page')
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (8,N'index.cfm?fuseaction=page.contactUs',15,N'noline=1,BoxTitle=Email Us',1,N'contactUs',N'contact us',N'Contact Us',NULL,NULL,NULL,NULL,NULL,N'<p>Have a question? Have a comment? Please contact us!</p>\r\n&nbsp;\r\n<table width="75%" cellspacing="0" cellpadding="3" border="0">\r\n    <tbody>\r\n        <tr>\r\n            <td>Phone:</td>\r\n            <td><strong>222-555-6442</strong></td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top">Mail:</td>\r\n            <td>\r\n            <p>CFWebstore<br />\r\n            Dogpatch Software<br />\r\n            222 Main Street<br />\r\n            Jonesville, MD</p>\r\n            </td>\r\n        </tr>\r\n        <tr>\r\n            <td>E-mail:</td>\r\n            <td><a href="mailto:info&#064;YourSite.com">info-at-YourSite.com</a></td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n<br />\r\nYou can also use the form below:\r\n<p>&nbsp;</p>',1,NULL,0,4,0,0,N'',N'',N'')
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (9,N'index.cfm?fuseaction=page.sitemap',14,N'noline=1,alpha=1',0,N'sitemap',N'site map',N'Site Map',NULL,NULL,NULL,NULL,NULL,N'<P>The following is a list of all the Categories, Products and Feature Articles on our site. We hope it will assist you in finding what you''re looking for.</P>',1,NULL,0,5,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (10,N'index.cfm?fuseaction=shopping.wishlist',0,NULL,1,N'wishlist',N'wishlist',N'Wishlist',NULL,NULL,NULL,NULL,NULL,N'',1,NULL,0,2,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (16,N'index.cfm?fuseaction=page.cvv2help',0,N'noline=1',0,N'cvv2help',N'cvv2help',N'Your Credit Card Verification Value',NULL,N'',N'',N'',NULL,N'<P>Entering the Card Verification Value 2 (CVV2) number helps us to prevent credit card fraud and keep costs down for everyone. Since a CVV2 number is listed on your credit card but is not stored anywhere, the only way to know the correct CVV2 number for your credit card is to physically have possession of the card itself. All VISA, MasterCard and American Express cards made in America&nbsp;have a CVV2 number. </P>\r\n<P><STRONG>How to find your CVV2 Number:</STRONG></P>\r\n<P><IMG height=115 alt="Amex Card" src="images/icons/amex_cvv2.gif" width=157 align=left border=0><STRONG>American Express</STRONG><BR><BR>Enter the 4 digit, non-embossed number printed above your account number on the <B>face</B> of your card.</P>\r\n<P>&nbsp;</P>\r\n<P><img height="115" src="images/icons/visa_cvv2.gif" width=157 align=left border=0><STRONG>Visa</STRONG><BR><BR>Enter the 3-digit, non-embossed number printed on the signature panel on the <B>back</B> of the card immediately following the Visa card account number.</P>\r\n<P>&nbsp;</P>\r\n<P><IMG height=115 src="images/icons/mastercard_cvv2.gif" width=157 align=left border=0><STRONG>MasterCard</STRONG><BR><BR>Enter the 3-digit, non-embossed number printed on the signature panel on the <B>back</B> of the card.</P>\r\n<P>&nbsp;</P>\r\n<P><IMG height=115 src="images/icons/discover_cvv2.gif" width=157 align=left border=0><STRONG>Discover</STRONG><BR><BR>Enter the 3-digit, non-embossed number printed on the signature panel on the <B>back</B> of the card.</P>',1,N'',0,9999,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (17,N'index.cfm?fuseaction=page.receipt',0,N'noline=1',0,N'receipt',N'receipt',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,0,9999,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (18,N'index.cfm?fuseaction=shopping.tracking',0,NULL,0,N'tracking',N'track order',N'',NULL,NULL,NULL,NULL,NULL,N'',0,NULL,0,4,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (19,N'index.cfm?fuseaction=shopping.giftregistry',0,NULL,0,N'giftregistry',N'gift registry',N'',NULL,NULL,NULL,NULL,NULL,N'',0,NULL,0,4,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (20,N'index.cfm?fuseaction=page.pagenotfound',0,NULL,0,N'PageNotFound',N'Page Error',N'Page Not Found',NULL,NULL,NULL,NULL,NULL,N'<sup>Sorry, an error was encountered in retrieving the information, or the item is no longer available.<br/><br/>Please try Searching or The Site Map for assistance.<br/><br type="_moz"/></sup>',1,NULL,0,9999,0,0,NULL,NULL,NULL)
INSERT INTO [Pages] ([Page_ID],[Page_URL],[CatCore_ID],[PassParam],[Display],[PageAction],[Page_Name],[Page_Title],[Sm_Image],[Lg_Image],[Sm_Title],[Lg_Title],[Color_ID],[PageText],[System],[Href_Attributes],[AccessKey],[Priority],[Parent_ID],[Title_Priority],[Metadescription],[Keywords],[TitleTag]) VALUES (21,N'index.cfm?fuseaction=page.nocookies',0,NULL,0,N'nocookies',N'No Cookies',N'Cookies Required',NULL,NULL,NULL,NULL,NULL,N'This site requires cookies in order to shop and to checkout. This is the safest and most secure way to conduct online business so is done for your safety and convenience. Please check your browser settings and ensure that you have set it to allow cookies.',1,NULL,0,9999,0,0,NULL,NULL,NULL)
