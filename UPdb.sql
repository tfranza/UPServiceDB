-----------------------------------------------------------
----------------------
-- cleaning operation
DROP TRIGGER delEventStatTRIGGER;
DROP TRIGGER delItemRowTRIGGER;
DROP TRIGGER delVehicleRowTRIGGER;
DROP TRIGGER delCentreRowTRIGGER;
DROP TRIGGER delPastShipmentStatTRIGGER;
DROP TRIGGER delShipmentRowTRIGGER;
DROP TRIGGER delShipmentStatTRIGGER;
DROP TRIGGER verifyLatLongRouteTRIGGER;
DROP TRIGGER verifyPastShipmentDatesTRIGGER;
DROP TRIGGER verifyShipmentDatesTRIGGER;
DROP TRIGGER verifyDealerKindTRIGGER;

DROP INDEX trackItemRouteINDEX;

DROP PROCEDURE produceWeeklyReport;
DROP TABLE WeeklyReport;
DROP PROCEDURE addPosition;
DROP PROCEDURE addTransportationEvent;
DROP PROCEDURE trackAnItem;
DROP TABLE TrackItem;
DROP PROCEDURE collectItem;

DROP PROCEDURE deleteRoute;
DROP PROCEDURE deleteEvent;
DROP PROCEDURE deletePastItem;
DROP PROCEDURE deleteItem;
DROP PROCEDURE deleteVehicle;
DROP PROCEDURE deletePastShipment;
DROP PROCEDURE deleteShipment;
DROP PROCEDURE deleteDealer;

DROP PROCEDURE updateRoute;
DROP PROCEDURE updateEvent;
DROP PROCEDURE updateItem;
DROP PROCEDURE updateVehicle;
DROP PROCEDURE updateCentre;
DROP PROCEDURE updateShipment;
DROP PROCEDURE updateDealer;

DROP PROCEDURE readRoute;
DROP PROCEDURE readEvent;
DROP PROCEDURE readPastItem;
DROP PROCEDURE readItem;
DROP PROCEDURE readVehicle;
DROP PROCEDURE readCentre;
DROP PROCEDURE readPastShipment;
DROP PROCEDURE readShipment;
DROP PROCEDURE readDealer;
DROP TABLE tempRoute;
DROP TABLE tempEvent;
DROP TABLE tempPastItem;
DROP TABLE tempItem;
DROP TABLE tempVehicle;
DROP TABLE tempCentre;
DROP TABLE tempPastShipment;
DROP TABLE tempShipment;
DROP TABLE tempDealer;

DROP PROCEDURE createRoute;
DROP PROCEDURE createEvent;
DROP PROCEDURE createItem;
DROP PROCEDURE createVehicle;
DROP PROCEDURE createCentre;
DROP PROCEDURE createShipment;
DROP PROCEDURE createDealer;

DROP PROCEDURE populateRoute;
DROP PROCEDURE populateEvent;
DROP PROCEDURE populatePastItem;
DROP PROCEDURE populateItem;
DROP PROCEDURE populateVehicle;
DROP PROCEDURE populateCentre;
DROP PROCEDURE populatePastShipment;
DROP PROCEDURE populateShipment;
DROP PROCEDURE populateDealer;

DROP TABLE Vocabulary;
DROP TYPE VocabularyTY;
DROP TYPE VocabularyValuesTY;
DROP TYPE ValueTY;

DROP TABLE Route;
DROP TABLE Event;
DROP TABLE PastItem;
DROP TABLE Item;
DROP TABLE Vehicle;
DROP TABLE Centre;
DROP TABLE PastShipment;
DROP TABLE Shipment;
DROP TABLE Dealer;

DROP TYPE RouteTY;
DROP TYPE EventTY;
DROP TYPE PastItemTY;
DROP TYPE ItemTY;
DROP TYPE VehicleTY;
DROP TYPE CentreTY;
DROP TYPE PastShipmentTY;
DROP TYPE ShipmentTY;
DROP TYPE DealerTY;
DROP TYPE PositionTY;
DROP TYPE DimensionsTY;
DROP TYPE AddressTY;
-----------------------------------------------------------
----------------------
-- Type Generation
-- BASIC
CREATE OR REPLACE TYPE AddressTY AS OBJECT (
	zip			NUMBER,	
	country		VARCHAR2(40), 		
	city		VARCHAR2(40),
	street		VARCHAR2(40)
) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE DimensionsTY AS OBJECT  (
	width	NUMBER,
	length	NUMBER,
	height	NUMBER,
	weight	NUMBER
) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE PositionTY AS OBJECT  (
	latitude 	NUMBER(9,6),
	longitude 	NUMBER(9,6)
) INSTANTIABLE FINAL;
/
-- SIMPLE
CREATE OR REPLACE TYPE DealerTY AS OBJECT (
	id			VARCHAR2(40),		-- primary key
	kind		VARCHAR2(40), 	
	name		VARCHAR2(40),
	phone		VARCHAR2(40),
	mail		VARCHAR2(40),
	address 	AddressTY
) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE ShipmentTY AS OBJECT  (
	shipmentCode 	VARCHAR2(40),		-- primary key
	destination		VARCHAR2(40),	
	withdrawalDate	DATE,
	deliveryDate	DATE,
	earnings		NUMBER,
	MEMBER FUNCTION calculatePassedTime RETURN NUMBER
) INSTANTIABLE NOT FINAL;
/
CREATE OR REPLACE TYPE PastShipmentTY UNDER ShipmentTY () INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE CentreTY AS OBJECT  (
	id 			NUMBER,		-- primary key
	kind 		VARCHAR2(40),
	address 	VARCHAR2(40)
) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE VehicleTY AS OBJECT (
	driver 		VARCHAR2(40),
	plate		VARCHAR2(40),
	kind 		VARCHAR2(40),
	costs 		NUMBER
) INSTANTIABLE FINAL;
/
-- ADVANCED
CREATE OR REPLACE TYPE ItemTY AS OBJECT (
	shippingCode 	VARCHAR2(40),		-- primary key
	content			VARCHAR2(40),
	insurance		NUMBER,
	dimensions 		DimensionsTY,
	seller			REF DealerTY, 
	buyer			REF DealerTY,
	shipment 		REF ShipmentTY,
	MEMBER FUNCTION calculateCosts RETURN NUMBER
) INSTANTIABLE NOT FINAL;
/
CREATE OR REPLACE TYPE PastItemTY UNDER ItemTY (
	pastShipment 	REF PastShipmentTY
	) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE EventTY AS OBJECT  (
	id			NUMBER,		
	kind 		VARCHAR2(40),
	vehicle 	REF VehicleTY,
	shipment 	REF ShipmentTY,
	centre 		REF CentreTY
) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE RouteTY AS OBJECT (
	id			NUMBER,
	stamp	 	DATE,
	position	PositionTY,
	event 		REF EventTY
) INSTANTIABLE FINAL;
/
-----------------------------------------------------------
----------------------
-- Function Generation
CREATE TYPE BODY ShipmentTY AS
	MEMBER FUNCTION calculatePassedTime RETURN NUMBER IS
    	startDay    NUMBER;
    	startMonth  NUMBER;
    	startYear   NUMBER;
    	endDay      NUMBER;
    	endMonth    NUMBER;
    	endYear     NUMBER;
    	temp        NUMBER;
    BEGIN
    	SELECT EXTRACT (DAY FROM withdrawalDate) INTO startDay FROM DUAL;
    	SELECT EXTRACT (MONTH FROM withdrawalDate) INTO startMonth FROM DUAL;
    	SELECT EXTRACT (YEAR FROM withdrawalDate) INTO startYear FROM DUAL;
    	SELECT EXTRACT (DAY FROM deliveryDate) INTO endDay FROM DUAL;
    	SELECT EXTRACT (MONTH FROM deliveryDate) INTO endMonth FROM DUAL;
    	SELECT EXTRACT (YEAR FROM deliveryDate) INTO endYear FROM DUAL;
      
    	temp := 0;
      
    	IF startYear < endYear THEN
        	temp := temp + (endYear - startYear - 1)*365;
      	END IF;
      
      	IF startMonth < endMonth THEN
        	temp := temp + (endMonth - startMonth - 1)*30;
      	ELSIF startMonth > endMonth THEN
        	temp := temp + (12 - startMonth + endMonth - 1)*30;
      	END IF;

      	IF startDay < endDay THEN
        	temp := temp + endDay - startDay - 1;
      	ELSIF startDay > endDay THEN
        	temp := temp + 30 - startDay + endDay - 1;
      	END IF;
      
      	RETURN temp;
    END;
END;
/
CREATE OR REPLACE TYPE BODY ItemTY AS
	MEMBER FUNCTION calculateCosts RETURN NUMBER IS
	temp 	NUMBER;
	BEGIN
		temp := dimensions.weight + 6 + insurance;
		RETURN temp;
	END;
END;	
/
-----------------------------------------------------------
----------------------
-- Table Generation
CREATE TABLE Dealer         OF DealerTY;
CREATE TABLE Shipment		OF ShipmentTY;
CREATE TABLE PastShipment	OF PastShipmentTY;
CREATE TABLE Centre			OF CentreTY;
CREATE TABLE Vehicle		OF VehicleTY;
CREATE TABLE Item			OF ItemTY;
CREATE TABLE PastItem		OF PastItemTY;
CREATE TABLE Event			OF EventTY;
CREATE TABLE Route			OF RouteTY;

ALTER TABLE Dealer 			ADD CONSTRAINT uDealer UNIQUE (id);
ALTER TABLE Shipment		ADD CONSTRAINT uShipment UNIQUE (shipmentCode);
ALTER TABLE PastShipment	ADD CONSTRAINT uPastShipment UNIQUE (shipmentCode);
ALTER TABLE Centre 			ADD CONSTRAINT uCentre UNIQUE (id);
ALTER TABLE Vehicle			ADD CONSTRAINT uVehicle UNIQUE (plate);
ALTER TABLE Item			ADD CONSTRAINT uItem UNIQUE (shippingCode);
ALTER TABLE PastItem		ADD CONSTRAINT uPastItem UNIQUE (shippingCode);
ALTER TABLE Event			ADD CONSTRAINT uEvent UNIQUE (id);
ALTER TABLE Route			ADD CONSTRAINT uRoute UNIQUE (id);
-----------------------------------------------------------
----------------------
-- Vocabulary  Creation
CREATE OR REPLACE TYPE ValueTY AS OBJECT (
  key NUMBER, 
  voice VARCHAR2(40)
  ) INSTANTIABLE FINAL;
/
CREATE OR REPLACE TYPE VocabularyValuesTY AS VARRAY(1000) OF ValueTY;
/
CREATE OR REPLACE TYPE VocabularyTY AS OBJECT (
  semantic VARCHAR2(10), 
  vocabols VocabularyValuesTY
  ) INSTANTIABLE FINAL;
/
CREATE TABLE Vocabulary OF VocabularyTY;
ALTER TABLE Vocabulary ADD PRIMARY KEY (semantic);
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('names',     VocabularyValuesTY (ValueTY(1,'MARY'), ValueTY(2,'PATRICIA'), ValueTY(3,'LidxA'), ValueTY(4,'BARBARA'), ValueTY(5,'ELIZABETH'), ValueTY(6,'JENNIFER'), ValueTY(7,'MARIA'), ValueTY(8,'SUSAN'), ValueTY(9,'MARGARET'), ValueTY(10,'DOROTHY'), ValueTY(11,'LISA'), ValueTY(12,'NANCY'), ValueTY(13,'KAREN'), ValueTY(14,'BETTY'), ValueTY(15,'HELEN'), ValueTY(16,'SANDRA'), ValueTY(17,'DONNA'), ValueTY(18,'CAROL'), ValueTY(19,'RUTH'), ValueTY(20,'SHARON'), ValueTY(21,'MICHELLE'), ValueTY(22,'LAURA'), ValueTY(23,'SARAH'), ValueTY(24,'KIMBERLY'), ValueTY(25,'DEBORAH'), ValueTY(26,'JESSICA'), ValueTY(27,'SHIRLEY'), ValueTY(28,'CYNTHIA'), ValueTY(29,'ANGELA'), ValueTY(30,'MELISSA'), ValueTY(31,'BRENDA'), ValueTY(32,'AMY'), ValueTY(33,'ANNA'), ValueTY(34,'REBECCA'), ValueTY(35,'VIRGINIA'), ValueTY(36,'KATHLEEN'), ValueTY(37,'PAMELA'), ValueTY(38,'MARTHA'), ValueTY(39,'DEBRA'), ValueTY(40,'AMANDA'), ValueTY(41,'STEPHANIE'), ValueTY(42,'CAROLYN'), ValueTY(43,'CHRISTINE'), ValueTY(44,'MARIE'), ValueTY(45,'JANET'), ValueTY(46,'CATHERINE'), ValueTY(47,'FRANCES'), ValueTY(48,'ANN'), ValueTY(49,'JOYCE'), ValueTY(50,'DIANE'), ValueTY(51,'ALICE'), ValueTY(52,'JULIE'), ValueTY(53,'HEATHER'), ValueTY(54,'TERESA'), ValueTY(55,'DORIS'), ValueTY(56,'GLORIA'), ValueTY(57,'EVELYN'), ValueTY(58,'JEAN'), ValueTY(59,'CHERYL'), ValueTY(60,'MILDRED'), ValueTY(61,'KATHERINE'), ValueTY(62,'JOAN'), ValueTY(63,'ASHLEY'), ValueTY(64,'JUDITH'), ValueTY(65,'ROSE'), ValueTY(66,'JANICE'), ValueTY(67,'KELLY'), ValueTY(68,'NICOLE'), ValueTY(69,'JUDY'), ValueTY(70,'CHRISTINA'), ValueTY(71,'KATHY'), ValueTY(72,'THERESA'), ValueTY(73,'BEVERLY'), ValueTY(74,'DENISE'), ValueTY(75,'TAMMY'), ValueTY(76,'IRENE'), ValueTY(77,'JANE'), ValueTY(78,'LORI'), ValueTY(79,'RACHEL'), ValueTY(80,'MARILYN'), ValueTY(81,'ANDREA'), ValueTY(82,'KATHRYN'), ValueTY(83,'LOUISE'), ValueTY(84,'SARA'), ValueTY(85,'ANNE'), ValueTY(86,'JACQUELINE'), ValueTY(87,'WANDA'), ValueTY(88,'BONNIE'), ValueTY(89,'JULIA'), ValueTY(90,'RUBY'), ValueTY(91,'LOIS'), ValueTY(92,'TINA'), ValueTY(93,'PHYLLIS'), ValueTY(94,'NORMA'), ValueTY(95,'PAULA'), ValueTY(96,'DIANA'), ValueTY(97,'ANNIE'), ValueTY(98,'LILLIAN'), ValueTY(99,'EMILY'), ValueTY(100,'ROBIN'), ValueTY(101,'PEGGY'), ValueTY(102,'CRYSTAL'), ValueTY(103,'GLADYS'), ValueTY(104,'RITA'), ValueTY(105,'DAWN'), ValueTY(106,'CONNIE'), ValueTY(107,'FLORENCE'), ValueTY(108,'TRACY'), ValueTY(109,'EDNA'), ValueTY(110,'TIFFANY'), ValueTY(111,'CARMEN'), ValueTY(112,'ROSA'), ValueTY(113,'CidxY'), ValueTY(114,'GRACE'), ValueTY(115,'WENDY'), ValueTY(116,'VICTORIA'), ValueTY(117,'EDITH'), ValueTY(118,'KIM'), ValueTY(119,'SHERRY'), ValueTY(120,'SYLVIA'), ValueTY(121,'JOSEPHINE'), ValueTY(122,'THELMA'), ValueTY(123,'SHANNON'), ValueTY(124,'SHEILA'), ValueTY(125,'ETHEL'), ValueTY(126,'ELLEN'), ValueTY(127,'ELAINE'), ValueTY(128,'MARJORIE'), ValueTY(129,'CARRIE'), ValueTY(130,'CHARLOTTE'), ValueTY(131,'MONICA'), ValueTY(132,'ESTHER'), ValueTY(133,'PAULINE'), ValueTY(134,'EMMA'), ValueTY(135,'JUANITA'), ValueTY(136,'ANITA'), ValueTY(137,'RHONDA'), ValueTY(138,'HAZEL'), ValueTY(139,'AMBER'), ValueTY(140,'EVA'), ValueTY(141,'DEBBIE'), ValueTY(142,'APRIL'), ValueTY(143,'LESLIE'), ValueTY(144,'CLARA'), ValueTY(145,'LUCILLE'), ValueTY(146,'JAMIE'), ValueTY(147,'JOANNE'), ValueTY(148,'ELEANOR'), ValueTY(149,'VALERIE'), ValueTY(150,'DANIELLE'), ValueTY(151,'MEGAN'), ValueTY(152,'ALICIA'), ValueTY(153,'SUZANNE'), ValueTY(154,'MICHELE'), ValueTY(155,'GAIL'), ValueTY(156,'BERTHA'), ValueTY(157,'DARLENE'), ValueTY(158,'VERONICA'), ValueTY(159,'JILL'), ValueTY(160,'ERIN'), ValueTY(161,'GERALDINE'), ValueTY(162,'LAUREN'), ValueTY(163,'CATHY'), ValueTY(164,'JOANN'), ValueTY(165,'LORRAINE'), ValueTY(166,'LYNN'), ValueTY(167,'SALLY'), ValueTY(168,'REGINA'), ValueTY(169,'ERICA'), ValueTY(170,'BEATRICE'), ValueTY(171,'DOLORES'), ValueTY(172,'BERNICE'), ValueTY(173,'AUDREY'), ValueTY(174,'YVONNE'), ValueTY(175,'ANNETTE'), ValueTY(176,'JUNE'), ValueTY(177,'SAMANTHA'), ValueTY(178,'MARION'), ValueTY(179,'DANA'), ValueTY(180,'STACY'), ValueTY(181,'ANA'), ValueTY(182,'RENEE'), ValueTY(183,'IDA'), ValueTY(184,'VIVIAN'), ValueTY(185,'ROBERTA'), ValueTY(186,'HOLLY'), ValueTY(187,'BRITTANY'), ValueTY(188,'MELANIE'), ValueTY(189,'LORETTA'), ValueTY(190,'YOLANDA'), ValueTY(191,'JEANETTE'), ValueTY(192,'LAURIE'), ValueTY(193,'KATIE'), ValueTY(194,'KRISTEN'), ValueTY(195,'VANESSA'), ValueTY(196,'ALMA'), ValueTY(197,'SUE'), ValueTY(198,'ELSIE'), ValueTY(199,'BETH'), ValueTY(200,'JEANNE'), ValueTY(201,'VICKI'), ValueTY(202,'CARLA'), ValueTY(203,'TARA'), ValueTY(204,'ROSEMARY'), ValueTY(205,'EILEEN'), ValueTY(206,'TERRI'), ValueTY(207,'GERTRUDE'), ValueTY(208,'LUCY'), ValueTY(209,'TONYA'), ValueTY(210,'ELLA'), ValueTY(211,'STACEY'), ValueTY(212,'WILMA'), ValueTY(213,'GINA'), ValueTY(214,'KRISTIN'), ValueTY(215,'JESSIE'), ValueTY(216,'NATALIE'), ValueTY(217,'AGNES'), ValueTY(218,'VERA'), ValueTY(219,'WILLIE'), ValueTY(220,'CHARLENE'), ValueTY(221,'BESSIE'), ValueTY(222,'DELORES'), ValueTY(223,'MELidxA'), ValueTY(224,'PEARL'), ValueTY(225,'ARLENE'), ValueTY(226,'MAUREEN'), ValueTY(227,'COLLEEN'), ValueTY(228,'ALLISON'), ValueTY(229,'TAMARA'), ValueTY(230,'JOY'), ValueTY(231,'GEORGIA'), ValueTY(232,'CONSTANCE'), ValueTY(233,'LILLIE'), ValueTY(234,'CLAUDIA'), ValueTY(235,'JACKIE'), ValueTY(236,'MARCIA'), ValueTY(237,'TANYA'), ValueTY(238,'NELLIE'), ValueTY(239,'MINNIE'), ValueTY(240,'MARLENE'), ValueTY(241,'HEIDI'), ValueTY(242,'GLENDA'), ValueTY(243,'LYDIA'), ValueTY(244,'VIOLA'), ValueTY(245,'COURTNEY'), ValueTY(246,'MARIAN'), ValueTY(247,'STELLA'), ValueTY(248,'CAROLINE'), ValueTY(249,'DORA'), ValueTY(250,'JO'), ValueTY(251,'VICKIE'), ValueTY(252,'MATTIE'), ValueTY(253,'TERRY'), ValueTY(254,'MAXINE'), ValueTY(255,'IRMA'), ValueTY(256,'MABEL'), ValueTY(257,'MARSHA'), ValueTY(258,'MYRTLE'), ValueTY(259,'LENA'), ValueTY(260,'CHRISTY'), ValueTY(261,'DEANNA'), ValueTY(262,'PATSY'), ValueTY(263,'HILDA'), ValueTY(264,'GWENDOLYN'), ValueTY(265,'JENNIE'), ValueTY(266,'NORA'), ValueTY(267,'MARGIE'), ValueTY(268,'NINA'), ValueTY(269,'CASSANDRA'), ValueTY(270,'LEAH'), ValueTY(271,'PENNY'), ValueTY(272,'KAY'), ValueTY(273,'PRISCILLA'), ValueTY(274,'NAOMI'), ValueTY(275,'CAROLE'), ValueTY(276,'BRANDY'), ValueTY(277,'OLGA'), ValueTY(278,'BILLIE'), ValueTY(279,'DIANNE'), ValueTY(280,'TRACEY'), ValueTY(281,'LEONA'), ValueTY(282,'JENNY'), ValueTY(283,'FELICIA'), ValueTY(284,'SONIA'), ValueTY(285,'MIRIAM'), ValueTY(286,'VELMA'), ValueTY(287,'BECKY'), ValueTY(288,'BOBBIE'), ValueTY(289,'VIOLET'), ValueTY(290,'KRISTINA'), ValueTY(291,'TONI'), ValueTY(292,'MISTY'), ValueTY(293,'MAE'), ValueTY(294,'SHELLY'), ValueTY(295,'DAISY'), ValueTY(296,'RAMONA'), ValueTY(297,'SHERRI'), ValueTY(298,'ERIKA'), ValueTY(299,'KATRINA'), ValueTY(300,'CLAIRE'), ValueTY(301,'LidxSEY'), ValueTY(302,'LidxSAY'), ValueTY(303,'GENEVA'), ValueTY(304,'GUADALUPE'), ValueTY(305,'BELidxA'), ValueTY(306,'MARGARITA'), ValueTY(307,'SHERYL'), ValueTY(308,'CORA'), ValueTY(309,'FAYE'), ValueTY(310,'ADA'), ValueTY(311,'NATASHA'), ValueTY(312,'SABRINA'), ValueTY(313,'ISABEL'), ValueTY(314,'MARGUERITE'), ValueTY(315,'HATTIE'), ValueTY(316,'HARRIET'), ValueTY(317,'MOLLY'), ValueTY(318,'CECILIA'), ValueTY(319,'KRISTI'), ValueTY(320,'BRANDI'), ValueTY(321,'BLANCHE'), ValueTY(322,'SANDY'), ValueTY(323,'ROSIE'), ValueTY(324,'JOANNA'), ValueTY(325,'IRIS'), ValueTY(326,'EUNICE'), ValueTY(327,'ANGIE'), ValueTY(328,'INEZ'), ValueTY(329,'LYNDA'), ValueTY(330,'MADELINE'), ValueTY(331,'AMELIA'), ValueTY(332,'ALBERTA'), ValueTY(333,'GENEVIEVE'), ValueTY(334,'MONIQUE'), ValueTY(335,'JODI'), ValueTY(336,'JANIE'), ValueTY(337,'MAGGIE'), ValueTY(338,'KAYLA'), ValueTY(339,'SONYA'), ValueTY(340,'JAN'), ValueTY(341,'LEE'), ValueTY(342,'KRISTINE'), ValueTY(343,'CANDACE'), ValueTY(344,'FANNIE'), ValueTY(345,'MARYANN'), ValueTY(346,'OPAL'), ValueTY(347,'ALISON'), ValueTY(348,'YVETTE'), ValueTY(349,'MELODY'), ValueTY(350,'LUZ'), ValueTY(351,'SUSIE'), ValueTY(352,'OLIVIA'), ValueTY(353,'FLORA'), ValueTY(354,'SHELLEY'), ValueTY(355,'KRISTY'), ValueTY(356,'MAMIE'), ValueTY(357,'LULA'), ValueTY(358,'LOLA'), ValueTY(359,'VERNA'), ValueTY(360,'BEULAH'), ValueTY(361,'ANTOINETTE'), ValueTY(362,'CANDICE'), ValueTY(363,'JUANA'), ValueTY(364,'JEANNETTE'), ValueTY(365,'PAM'), ValueTY(366,'KELLI'), ValueTY(367,'HANNAH'), ValueTY(368,'WHITNEY'), ValueTY(369,'BRIDGET'), ValueTY(370,'KARLA'), ValueTY(371,'CELIA'), ValueTY(372,'LATOYA'), ValueTY(373,'PATTY'), ValueTY(374,'SHELIA'), ValueTY(375,'GAYLE'), ValueTY(376,'DELLA'), ValueTY(377,'VICKY'), ValueTY(378,'LYNNE'), ValueTY(379,'SHERI'), ValueTY(380,'MARIANNE'), ValueTY(381,'KARA'), ValueTY(382,'JACQUELYN'), ValueTY(383,'ERMA'), ValueTY(384,'BLANCA'), ValueTY(385,'MYRA'), ValueTY(386,'LETICIA'), ValueTY(387,'PAT'), ValueTY(388,'KRISTA'), ValueTY(389,'ROXANNE'), ValueTY(390,'ANGELICA'), ValueTY(391,'JOHNNIE'), ValueTY(392,'ROBYN'), ValueTY(393,'FRANCIS'), ValueTY(394,'ADRIENNE'), ValueTY(395,'ROSALIE'), ValueTY(396,'ALEXANDRA'), ValueTY(397,'BROOKE'), ValueTY(398,'BETHANY'), ValueTY(399,'SADIE'), ValueTY(400,'BERNADETTE'), ValueTY(401,'TRACI'), ValueTY(402,'JODY'), ValueTY(403,'KENDRA'), ValueTY(404,'JASMINE'), ValueTY(405,'NICHOLE'), ValueTY(406,'RACHAEL'), ValueTY(407,'CHELSEA'), ValueTY(408,'MABLE'), ValueTY(409,'ERNESTINE'), ValueTY(410,'MURIEL'), ValueTY(411,'MARCELLA'), ValueTY(412,'ELENA'), ValueTY(413,'KRYSTAL'), ValueTY(414,'ANGELINA'), ValueTY(415,'NADINE'), ValueTY(416,'KARI'), ValueTY(417,'ESTELLE'), ValueTY(418,'DIANNA'), ValueTY(419,'PAULETTE'), ValueTY(420,'LORA'), ValueTY(421,'MONA'), ValueTY(422,'DOREEN'), ValueTY(423,'ROSEMARIE'), ValueTY(424,'ANGEL'), ValueTY(425,'DESIREE'), ValueTY(426,'ANTONIA'), ValueTY(427,'HOPE'), ValueTY(428,'GINGER'), ValueTY(429,'JANIS'), ValueTY(430,'BETSY'), ValueTY(431,'CHRISTIE'), ValueTY(432,'FREDA'), ValueTY(433,'MERCEDES'), ValueTY(434,'MEREDITH'), ValueTY(435,'LYNETTE'), ValueTY(436,'TERI'), ValueTY(437,'CRISTINA'), ValueTY(438,'EULA'), ValueTY(439,'LEIGH'), ValueTY(440,'MEGHAN'), ValueTY(441,'SOPHIA'), ValueTY(442,'ELOISE'), ValueTY(443,'ROCHELLE'), ValueTY(444,'GRETCHEN'), ValueTY(445,'CECELIA'), ValueTY(446,'RAQUEL'), ValueTY(447,'HENRIETTA'), ValueTY(448,'ALYSSA'), ValueTY(449,'JANA'), ValueTY(450,'KELLEY'), ValueTY(451,'GWEN'), ValueTY(452,'KERRY'), ValueTY(453,'JENNA'), ValueTY(454,'TRICIA'), ValueTY(455,'LAVERNE'), ValueTY(456,'OLIVE'), ValueTY(457,'ALEXIS'), ValueTY(458,'TASHA'), ValueTY(459,'SILVIA'), ValueTY(460,'ELVIRA'), ValueTY(461,'CASEY'), ValueTY(462,'DELIA'), ValueTY(463,'SOPHIE'), ValueTY(464,'KATE'), ValueTY(465,'PATTI'), ValueTY(466,'LORENA'), ValueTY(467,'KELLIE'), ValueTY(468,'SONJA'), ValueTY(469,'LILA'), ValueTY(470,'LANA'), ValueTY(471,'DARLA'), ValueTY(472,'MAY'), ValueTY(473,'MidxY'), ValueTY(474,'ESSIE'), ValueTY(475,'MANDY'), ValueTY(476,'LORENE'), ValueTY(477,'ELSA'), ValueTY(478,'JOSEFINA'), ValueTY(479,'JEANNIE'), ValueTY(480,'MIRANDA'), ValueTY(481,'DIXIE'), ValueTY(482,'LUCIA'), ValueTY(483,'MARTA'), ValueTY(484,'FAITH'), ValueTY(485,'LELA'), ValueTY(486,'JOHANNA'), ValueTY(487,'SHARI'), ValueTY(488,'CAMILLE'), ValueTY(489,'TAMI'), ValueTY(490,'SHAWNA'), ValueTY(491,'ELISA'), ValueTY(492,'EBONY'), ValueTY(493,'MELBA'), ValueTY(494,'ORA'), ValueTY(495,'NETTIE'), ValueTY(496,'TABITHA'), ValueTY(497,'OLLIE'), ValueTY(498,'JAIME'), ValueTY(499,'WINIFRED'), ValueTY(500,'JAMES'), ValueTY(501,'JOHN'), ValueTY(502,'ROBERT'), ValueTY(503,'MICHAEL'), ValueTY(504,'WILLIAM'), ValueTY(505,'DAVID'), ValueTY(506,'RICHARD'), ValueTY(507,'CHARLES'), ValueTY(508,'JOSEPH'), ValueTY(509,'THOMAS'), ValueTY(510,'CHRISTOPHER'), ValueTY(511,'DANIEL'), ValueTY(512,'PAUL'), ValueTY(513,'MARK'), ValueTY(514,'DONALD'), ValueTY(515,'GEORGE'), ValueTY(516,'KENNETH'), ValueTY(517,'STEVEN'), ValueTY(518,'EDWARD'), ValueTY(519,'BRIAN'), ValueTY(520,'RONALD'), ValueTY(521,'ANTHONY'), ValueTY(522,'KEVIN'), ValueTY(523,'JASON'), ValueTY(524,'MATTHEW'), ValueTY(525,'GARY'), ValueTY(526,'TIMOTHY'), ValueTY(527,'JOSE'), ValueTY(528,'LARRY'), ValueTY(529,'JEFFREY'), ValueTY(530,'FRANK'), ValueTY(531,'SCOTT'), ValueTY(532,'ERIC'), ValueTY(533,'STEPHEN'), ValueTY(534,'ANDREW'), ValueTY(535,'RAYMOND'), ValueTY(536,'GREGORY'), ValueTY(537,'JOSHUA'), ValueTY(538,'JERRY'), ValueTY(539,'DENNIS'), ValueTY(540,'WALTER'), ValueTY(541,'PATRICK'), ValueTY(542,'PETER'), ValueTY(543,'HAROLD'), ValueTY(544,'DOUGLAS'), ValueTY(545,'HENRY'), ValueTY(546,'CARL'), ValueTY(547,'ARTHUR'), ValueTY(548,'RYAN'), ValueTY(549,'ROGER'), ValueTY(550,'JOE'), ValueTY(551,'JUAN'), ValueTY(552,'JACK'), ValueTY(553,'ALBERT'), ValueTY(554,'JONATHAN'), ValueTY(555,'JUSTIN'), ValueTY(556,'TERRY'), ValueTY(557,'GERALD'), ValueTY(558,'KEITH'), ValueTY(559,'SAMUEL'), ValueTY(560,'WILLIE'), ValueTY(561,'RALPH'), ValueTY(562,'LAWRENCE'), ValueTY(563,'NICHOLAS'), ValueTY(564,'ROY'), ValueTY(565,'BENJAMIN'), ValueTY(566,'BRUCE'), ValueTY(567,'BRANDON'), ValueTY(568,'ADAM'), ValueTY(569,'HARRY'), ValueTY(570,'FRED'), ValueTY(571,'WAYNE'), ValueTY(572,'BILLY'), ValueTY(573,'STEVE'), ValueTY(574,'LOUIS'), ValueTY(575,'JEREMY'), ValueTY(576,'AARON'), ValueTY(577,'RANDY'), ValueTY(578,'HOWARD'), ValueTY(579,'EUGENE'), ValueTY(580,'CARLOS'), ValueTY(581,'RUSSELL'), ValueTY(582,'BOBBY'), ValueTY(583,'VICTOR'), ValueTY(584,'MARTIN'), ValueTY(585,'ERNEST'), ValueTY(586,'PHILLIP'), ValueTY(587,'TODD'), ValueTY(588,'JESSE'), ValueTY(589,'CRAIG'), ValueTY(590,'ALAN'), ValueTY(591,'SHAWN'), ValueTY(592,'CLARENCE'), ValueTY(593,'SEAN'), ValueTY(594,'PHILIP'), ValueTY(595,'CHRIS'), ValueTY(596,'JOHNNY'), ValueTY(597,'EARL'), ValueTY(598,'JIMMY'), ValueTY(599,'ANTONIO'), ValueTY(600,'DANNY'), ValueTY(601,'BRYAN'), ValueTY(602,'TONY'), ValueTY(603,'LUIS'), ValueTY(604,'MIKE'), ValueTY(605,'STANLEY'), ValueTY(606,'LEONARD'), ValueTY(607,'NATHAN'), ValueTY(608,'DALE'), ValueTY(609,'MANUEL'), ValueTY(610,'RODNEY'), ValueTY(611,'CURTIS'), ValueTY(612,'NORMAN'), ValueTY(613,'ALLEN'), ValueTY(614,'MARVIN'), ValueTY(615,'VINCENT'), ValueTY(616,'GLENN'), ValueTY(617,'JEFFERY'), ValueTY(618,'TRAVIS'), ValueTY(619,'JEFF'), ValueTY(620,'CHAD'), ValueTY(621,'JACOB'), ValueTY(622,'LEE'), ValueTY(623,'MELVIN'), ValueTY(624,'ALFRED'), ValueTY(625,'KYLE'), ValueTY(626,'FRANCIS'), ValueTY(627,'BRADLEY'), ValueTY(628,'JESUS'), ValueTY(629,'HERBERT'), ValueTY(630,'FREDERICK'), ValueTY(631,'RAY'), ValueTY(632,'JOEL'), ValueTY(633,'EDWIN'), ValueTY(634,'DON'), ValueTY(635,'EDDIE'), ValueTY(636,'RICKY'), ValueTY(637,'TROY'), ValueTY(638,'RANDALL'), ValueTY(639,'BARRY'), ValueTY(640,'ALEXANDER'), ValueTY(641,'BERNARD'), ValueTY(642,'MARIO'), ValueTY(643,'LEROY'), ValueTY(644,'FRANCISCO'), ValueTY(645,'MARCUS'), ValueTY(646,'MICHEAL'), ValueTY(647,'THEODORE'), ValueTY(648,'CLIFFORD'), ValueTY(649,'MIGUEL'), ValueTY(650,'OSCAR'), ValueTY(651,'JAY'), ValueTY(652,'JIM'), ValueTY(653,'TOM'), ValueTY(654,'CALVIN'), ValueTY(655,'ALEX'), ValueTY(656,'JON'), ValueTY(657,'RONNIE'), ValueTY(658,'BILL'), ValueTY(659,'LLOYD'), ValueTY(660,'TOMMY'), ValueTY(661,'LEON'), ValueTY(662,'DEREK'), ValueTY(663,'WARREN'), ValueTY(664,'DARRELL'), ValueTY(665,'JEROME'), ValueTY(666,'FLOYD'), ValueTY(667,'LEO'), ValueTY(668,'ALVIN'), ValueTY(669,'TIM'), ValueTY(670,'WESLEY'), ValueTY(671,'GORDON'), ValueTY(672,'DEAN'), ValueTY(673,'GREG'), ValueTY(674,'JORGE'), ValueTY(675,'DUSTIN'), ValueTY(676,'PEDRO'), ValueTY(677,'DERRICK'), ValueTY(678,'DAN'), ValueTY(679,'LEWIS'), ValueTY(680,'ZACHARY'), ValueTY(681,'COREY'), ValueTY(682,'HERMAN'), ValueTY(683,'MAURICE'), ValueTY(684,'VERNON'), ValueTY(685,'ROBERTO'), ValueTY(686,'CLYDE'), ValueTY(687,'GLEN'), ValueTY(688,'HECTOR'), ValueTY(689,'SHANE'), ValueTY(690,'RICARDO'), ValueTY(691,'SAM'), ValueTY(692,'RICK'), ValueTY(693,'LESTER'), ValueTY(694,'BRENT'), ValueTY(695,'RAMON'), ValueTY(696,'CHARLIE'), ValueTY(697,'TYLER'), ValueTY(698,'GILBERT'), ValueTY(699,'GENE'), ValueTY(700,'MARC'), ValueTY(701,'REGINALD'), ValueTY(702,'RUBEN'), ValueTY(703,'BRETT'), ValueTY(704,'ANGEL'), ValueTY(705,'NATHANIEL'), ValueTY(706,'RAFAEL'), ValueTY(707,'LESLIE'), ValueTY(708,'EDGAR'), ValueTY(709,'MILTON'), ValueTY(710,'RAUL'), ValueTY(711,'BEN'), ValueTY(712,'CHESTER'), ValueTY(713,'CECIL'), ValueTY(714,'DUANE'), ValueTY(715,'FRANKLIN'), ValueTY(716,'ANDRE'), ValueTY(717,'ELMER'), ValueTY(718,'BRAD'), ValueTY(719,'GABRIEL'), ValueTY(720,'RON'), ValueTY(721,'MITCHELL'), ValueTY(722,'ROLAND'), ValueTY(723,'ARNOLD'), ValueTY(724,'HARVEY'), ValueTY(725,'JARED'), ValueTY(726,'ADRIAN'), ValueTY(727,'KARL'), ValueTY(728,'CORY'), ValueTY(729,'CLAUDE'), ValueTY(730,'ERIK'), ValueTY(731,'DARRYL'), ValueTY(732,'JAMIE'), ValueTY(733,'NEIL'), ValueTY(734,'JESSIE'), ValueTY(735,'CHRISTIAN'), ValueTY(736,'JAVIER'), ValueTY(737,'FERNANDO'), ValueTY(738,'CLINTON'), ValueTY(739,'TED'), ValueTY(740,'MATHEW'), ValueTY(741,'TYRONE'), ValueTY(742,'DARREN'), ValueTY(743,'LONNIE'), ValueTY(744,'LANCE'), ValueTY(745,'CODY'), ValueTY(746,'JULIO'), ValueTY(747,'KELLY'), ValueTY(748,'KURT'), ValueTY(749,'ALLAN'), ValueTY(750,'NELSON'), ValueTY(751,'GUY'), ValueTY(752,'CLAYTON'), ValueTY(753,'HUGH'), ValueTY(754,'MAX'), ValueTY(755,'DWAYNE'), ValueTY(756,'DWIGHT'), ValueTY(757,'ARMANDO'), ValueTY(758,'FELIX'), ValueTY(759,'JIMMIE'), ValueTY(760,'EVERETT'), ValueTY(761,'JORDAN'), ValueTY(762,'IAN'), ValueTY(763,'WALLACE'), ValueTY(764,'KEN'), ValueTY(765,'BOB'), ValueTY(766,'JAIME'), ValueTY(767,'CASEY'), ValueTY(768,'ALFREDO'), ValueTY(769,'ALBERTO'), ValueTY(770,'DAVE'), ValueTY(771,'IVAN'), ValueTY(772,'JOHNNIE'), ValueTY(773,'SIDNEY'), ValueTY(774,'BYRON'), ValueTY(775,'JULIAN'), ValueTY(776,'ISAAC'), ValueTY(777,'MORRIS'), ValueTY(778,'CLIFTON'), ValueTY(779,'WILLARD'), ValueTY(780,'DARYL'), ValueTY(781,'ROSS'), ValueTY(782,'VIRGIL'), ValueTY(783,'ANDY'), ValueTY(784,'MARSHALL'), ValueTY(785,'SALVADOR'), ValueTY(786,'PERRY'), ValueTY(787,'KIRK'), ValueTY(788,'SERGIO'), ValueTY(789,'MARION'), ValueTY(790,'TRACY'), ValueTY(791,'SETH'), ValueTY(792,'KENT'), ValueTY(793,'TERRANCE'), ValueTY(794,'RENE'), ValueTY(795,'EDUARDO'), ValueTY(796,'TERRENCE'), ValueTY(797,'ENRIQUE'), ValueTY(798,'FREDDIE'), ValueTY(799,'WADE'), ValueTY(800,'AUSTIN'), ValueTY(801,'STUART'), ValueTY(802,'FREDRICK'), ValueTY(803,'ARTURO'), ValueTY(804,'ALEJANDRO'), ValueTY(805,'JACKIE'), ValueTY(806,'JOEY'), ValueTY(807,'NICK'), ValueTY(808,'LUTHER'), ValueTY(809,'WENDELL'), ValueTY(810,'JEREMIAH'), ValueTY(811,'EVAN'), ValueTY(812,'JULIUS'), ValueTY(813,'DANA'), ValueTY(814,'DONNIE'), ValueTY(815,'OTIS'), ValueTY(816,'SHANNON'), ValueTY(817,'TREVOR'), ValueTY(818,'OLIVER'), ValueTY(819,'LUKE'), ValueTY(820,'HOMER'), ValueTY(821,'GERARD'), ValueTY(822,'DOUG'), ValueTY(823,'KENNY'), ValueTY(824,'HUBERT'), ValueTY(825,'ANGELO'), ValueTY(826,'SHAUN'), ValueTY(827,'LYLE'), ValueTY(828,'MATT'), ValueTY(829,'LYNN'), ValueTY(830,'ALFONSO'), ValueTY(831,'ORLANDO'), ValueTY(832,'REX'), ValueTY(833,'CARLTON'), ValueTY(834,'ERNESTO'), ValueTY(835,'CAMERON'), ValueTY(836,'NEAL'), ValueTY(837,'PABLO'), ValueTY(838,'LORENZO'), ValueTY(839,'OMAR'), ValueTY(840,'WILBUR'), ValueTY(841,'BLAKE'), ValueTY(842,'GRANT'), ValueTY(843,'HORACE'), ValueTY(844,'RODERICK'), ValueTY(845,'KERRY'), ValueTY(846,'ABRAHAM'), ValueTY(847,'WILLIS'), ValueTY(848,'RICKEY'), ValueTY(849,'JEAN'), ValueTY(850,'IRA'), ValueTY(851,'ANDRES'), ValueTY(852,'CESAR'), ValueTY(853,'JOHNATHAN'), ValueTY(854,'MALCOLM'), ValueTY(855,'RUDOLPH'), ValueTY(856,'DAMON'), ValueTY(857,'KELVIN'), ValueTY(858,'RUDY'), ValueTY(859,'PRESTON'), ValueTY(860,'ALTON'), ValueTY(861,'ARCHIE'), ValueTY(862,'MARCO'), ValueTY(863,'WM'), ValueTY(864,'PETE'), ValueTY(865,'RANDOLPH'), ValueTY(866,'GARRY'), ValueTY(867,'GEOFFREY'), ValueTY(868,'JONATHON'), ValueTY(869,'FELIPE'), ValueTY(870,'BENNIE'), ValueTY(871,'GERARDO'), ValueTY(872,'ED'), ValueTY(873,'DOMINIC'), ValueTY(874,'ROBIN'), ValueTY(875,'LOREN'), ValueTY(876,'DELBERT'), ValueTY(877,'COLIN'), ValueTY(878,'GUILLERMO'), ValueTY(879,'EARNEST'), ValueTY(880,'LUCAS'), ValueTY(881,'BENNY'), ValueTY(882,'NOEL'), ValueTY(883,'SPENCER'), ValueTY(884,'RODOLFO'), ValueTY(885,'MYRON'), ValueTY(886,'EDMUND'), ValueTY(887,'GARRETT'), ValueTY(888,'SALVATORE'), ValueTY(889,'CEDRIC'), ValueTY(890,'LOWELL'), ValueTY(891,'GREGG'), ValueTY(892,'SHERMAN'), ValueTY(893,'WILSON'), ValueTY(894,'DEVIN'), ValueTY(895,'SYLVESTER'), ValueTY(896,'KIM'), ValueTY(897,'ROOSEVELT'), ValueTY(898,'ISRAEL'), ValueTY(899,'JERMAINE'), ValueTY(900,'FORREST'), ValueTY(901,'WILBERT'), ValueTY(902,'LELAND'), ValueTY(903,'SIMON'), ValueTY(904,'GUADALUPE'), ValueTY(905,'CLARK'), ValueTY(906,'IRVING'), ValueTY(907,'CARROLL'), ValueTY(908,'BRYANT'), ValueTY(909,'OWEN'), ValueTY(910,'RUFUS'), ValueTY(911,'WOODROW'), ValueTY(912,'SAMMY'), ValueTY(913,'KRISTOPHER'), ValueTY(914,'MACK'), ValueTY(915,'LEVI'), ValueTY(916,'MARCOS'), ValueTY(917,'GUSTAVO'), ValueTY(918,'JAKE'), ValueTY(919,'LIONEL'), ValueTY(920,'MARTY'), ValueTY(921,'TAYLOR'), ValueTY(922,'ELLIS'), ValueTY(923,'DALLAS'), ValueTY(924,'GILBERTO'), ValueTY(925,'CLINT'), ValueTY(926,'NICOLAS'), ValueTY(927,'LAURENCE'), ValueTY(928,'ISMAEL'), ValueTY(929,'ORVILLE'), ValueTY(930,'DREW'), ValueTY(931,'JODY'), ValueTY(932,'ERVIN'), ValueTY(933,'DEWEY'), ValueTY(934,'AL'), ValueTY(935,'WILFRED'), ValueTY(936,'JOSH'), ValueTY(937,'HUGO'), ValueTY(938,'IGNACIO'), ValueTY(939,'CALEB'), ValueTY(940,'TOMAS'), ValueTY(941,'SHELDON'), ValueTY(942,'ERICK'), ValueTY(943,'FRANKIE'), ValueTY(944,'STEWART'), ValueTY(945,'DOYLE'), ValueTY(946,'DARREL'), ValueTY(947,'ROGELIO'), ValueTY(948,'TERENCE'), ValueTY(949,'SANTIAGO'), ValueTY(950,'ALONZO'), ValueTY(951,'ELIAS'), ValueTY(952,'BERT'), ValueTY(953,'ELBERT'), ValueTY(954,'RAMIRO'), ValueTY(955,'CONRAD'), ValueTY(956,'PAT'), ValueTY(957,'NOAH'), ValueTY(958,'GRADY'), ValueTY(959,'PHIL'), ValueTY(960,'CORNELIUS'), ValueTY(961,'LAMAR'), ValueTY(962,'ROLANDO'), ValueTY(963,'CLAY'), ValueTY(964,'PERCY'), ValueTY(965,'DEXTER'), ValueTY(966,'BRADFORD'), ValueTY(967,'MERLE'), ValueTY(968,'DARIN'), ValueTY(969,'AMOS'), ValueTY(970,'TERRELL'), ValueTY(971,'MOSES'), ValueTY(972,'IRVIN'), ValueTY(973,'SAUL'), ValueTY(974,'ROMAN'), ValueTY(975,'DARNELL'), ValueTY(976,'RANDAL'), ValueTY(977,'TOMMIE'), ValueTY(978,'TIMMY'), ValueTY(979,'DARRIN'), ValueTY(980,'WINSTON'), ValueTY(981,'BRENDAN'), ValueTY(982,'TOBY'), ValueTY(983,'VAN'), ValueTY(984,'ABEL'), ValueTY(985,'DOMINICK'), ValueTY(986,'BOYD'), ValueTY(987,'COURTNEY'), ValueTY(988,'JAN'), ValueTY(989,'EMILIO'), ValueTY(990,'ELIJAH'), ValueTY(991,'CARY'), ValueTY(992,'DOMINGO'), ValueTY(993,'SANTOS'), ValueTY(994,'AUBREY'), ValueTY(995,'EMMETT'), ValueTY(996,'MARLON'), ValueTY(997,'EMANUEL'), ValueTY(998,'JERALD'), ValueTY(999,'MARY')));
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('cities',    VocabularyValuesTY (ValueTY(1,'Aberaeron'), ValueTY(2,'Aberdare'), ValueTY(3,'Aberdeen'), ValueTY(4,'Aberfeldy'), ValueTY(5,'Abergavenny'), ValueTY(6,'Abergele'), ValueTY(7,'Abertillery'), ValueTY(8,'Aberystwyth'), ValueTY(9,'Abingdon'), ValueTY(10,'Accrington'), ValueTY(11,'Adlington'), ValueTY(12,'Airdrie'), ValueTY(13,'Alcester'), ValueTY(14,'Aldeburgh'), ValueTY(15,'Aldershot'), ValueTY(16,'Aldridge'), ValueTY(17,'Alford'), ValueTY(18,'Alfreton'), ValueTY(19,'Alloa'), ValueTY(20,'Alnwick'), ValueTY(21,'Alsager'), ValueTY(22,'Alston'), ValueTY(23,'Amesbury'), ValueTY(24,'Amlwch'), ValueTY(25,'Ammanford'), ValueTY(26,'Ampthill'), ValueTY(27,'Andover'), ValueTY(28,'Annan'), ValueTY(29,'Antrim'), ValueTY(30,'Appleby in'), ValueTY(31,'Westmorland'), ValueTY(32,'Arbroath'), ValueTY(33,'Armagh'), ValueTY(34,'Arundel'), ValueTY(35,'Ashbourne'), ValueTY(36,'Ashburton'), ValueTY(37,'Ashby de la Zouch'), ValueTY(38,'Ashford'), ValueTY(39,'Ashington'), ValueTY(40,'Ashton in Makerfield'), ValueTY(41,'Atherstone'), ValueTY(42,'Auchtermuchty'), ValueTY(43,'Axminster'), ValueTY(44,'Aylesbury'), ValueTY(45,'Aylsham'), ValueTY(46,'Ayr'), ValueTY(47,'Bacup'), ValueTY(48,'Bakewell'), ValueTY(49,'Bala'), ValueTY(50,'Ballater'), ValueTY(51,'Ballycastle'), ValueTY(52,'Ballyclare'), ValueTY(53,'Ballymena'), ValueTY(54,'Ballymoney'), ValueTY(55,'Ballynahinch'), ValueTY(56,'Banbridge'), ValueTY(57,'Banbury'), ValueTY(58,'Banchory'), ValueTY(59,'Banff'), ValueTY(60,'Bangor'), ValueTY(61,'Barmouth'), ValueTY(62,'Barnard Castle'), ValueTY(63,'Barnet'), ValueTY(64,'Barnoldswick'), ValueTY(65,'Barnsley'), ValueTY(66,'Barnstaple'), ValueTY(67,'Barrhead'), ValueTY(68,'Barrow in Furness'), ValueTY(69,'Barry'), ValueTY(70,'Barton upon'), ValueTY(71,'Humber'), ValueTY(72,'Basildon'), ValueTY(73,'Basingstoke'), ValueTY(74,'Bath'), ValueTY(75,'Bathgate'), ValueTY(76,'Batley'), ValueTY(77,'Battle'), ValueTY(78,'Bawtry'), ValueTY(79,'Beaconsfield'), ValueTY(80,'Bearsden'), ValueTY(81,'Beaumaris'), ValueTY(82,'Bebington'), ValueTY(83,'Beccles'), ValueTY(84,'Bedale'), ValueTY(85,'Bedford'), ValueTY(86,'Bedlington'), ValueTY(87,'Bedworth'), ValueTY(88,'Beeston'), ValueTY(89,'Bellshill'), ValueTY(90,'Belper'), ValueTY(91,'Berkhamsted'), ValueTY(92,'Berwick upon'), ValueTY(93,'Tweed'), ValueTY(94,'Betws y Coed'), ValueTY(95,'Beverley'), ValueTY(96,'Bewdley'), ValueTY(97,'Bexhill on Sea'), ValueTY(98,'Bicester'), ValueTY(99,'Biddulph'), ValueTY(100,'Bideford'), ValueTY(101,'Biggar'), ValueTY(102,'Biggleswade'), ValueTY(103,'Billericay'), ValueTY(104,'Bilston'), ValueTY(105,'Bingham'), ValueTY(106,'Birkenhead'), ValueTY(107,'Birmingham'), ValueTY(108,'Bishop Auckland'), ValueTY(109,'Blackburn'), ValueTY(110,'Blackheath'), ValueTY(111,'Blackpool'), ValueTY(112,'Blaenau Ffestiniog'), ValueTY(113,'Blandford Forum'), ValueTY(114,'Bletchley'), ValueTY(115,'Bloxwich'), ValueTY(116,'Blyth'), ValueTY(117,'Bodmin'), ValueTY(118,'Bognor Regis'), ValueTY(119,'Bollington'), ValueTY(120,'Bolsover'), ValueTY(121,'Bolton'), ValueTY(122,'Bootle'), ValueTY(123,'Borehamwood'), ValueTY(124,'Boston'), ValueTY(125,'Bourne'), ValueTY(126,'Bournemouth'), ValueTY(127,'Brackley'), ValueTY(128,'Bracknell'), ValueTY(129,'Bradford'), ValueTY(130,'Bradford on Avon'), ValueTY(131,'Brading'), ValueTY(132,'Bradley Stoke'), ValueTY(133,'Bradninch'), ValueTY(134,'Braintree'), ValueTY(135,'Brechin'), ValueTY(136,'Brecon'), ValueTY(137,'Brentwood'), ValueTY(138,'Bridge of Allan'), ValueTY(139,'Bridgend'), ValueTY(140,'Bridgnorth'), ValueTY(141,'Bridgwater'), ValueTY(142,'Bridlington'), ValueTY(143,'Bridport'), ValueTY(144,'Brigg'), ValueTY(145,'Brighouse'), ValueTY(146,'Brightlingsea'), ValueTY(147,'Brighton'), ValueTY(148,'Bristol'), ValueTY(149,'Brixham'), ValueTY(150,'Broadstairs'), ValueTY(151,'Bromsgrove'), ValueTY(152,'Bromyard'), ValueTY(153,'Brynmawr'), ValueTY(154,'Buckfastleigh'), ValueTY(155,'Buckie'), ValueTY(156,'Buckingham'), ValueTY(157,'Buckley'), ValueTY(158,'Bude'), ValueTY(159,'Budleigh Salterton'), ValueTY(160,'Builth Wells'), ValueTY(161,'Bungay'), ValueTY(162,'Buntingford'), ValueTY(163,'Burford'), ValueTY(164,'Burgess Hill'), ValueTY(165,'Burnham on'), ValueTY(166,'Crouch'), ValueTY(167,'Burnham on Sea'), ValueTY(168,'Burnley'), ValueTY(169,'Burntisland'), ValueTY(170,'Burntwood'), ValueTY(171,'Burry Port'), ValueTY(172,'Burton Latimer'), ValueTY(173,'Bury'), ValueTY(174,'Bushmills'), ValueTY(175,'Buxton'), ValueTY(176,'Caernarfon'), ValueTY(177,'Caerphilly'), ValueTY(178,'Caistor'), ValueTY(179,'Caldicot'), ValueTY(180,'Callander'), ValueTY(181,'Calne'), ValueTY(182,'Camberley'), ValueTY(183,'Camborne'), ValueTY(184,'Cambridge'), ValueTY(185,'Camelford'), ValueTY(186,'Campbeltown'), ValueTY(187,'Cannock'), ValueTY(188,'Canterbury'), ValueTY(189,'Cardiff'), ValueTY(190,'Cardigan'), ValueTY(191,'Carlisle'), ValueTY(192,'Carluke'), ValueTY(193,'Carmarthen'), ValueTY(194,'Carnforth'), ValueTY(195,'Carnoustie'), ValueTY(196,'Carrickfergus'), ValueTY(197,'Carterton'), ValueTY(198,'Castle Douglas'), ValueTY(199,'Castlederg'), ValueTY(200,'Castleford'), ValueTY(201,'Castlewellan'), ValueTY(202,'Chard'), ValueTY(203,'Charlbury'), ValueTY(204,'Chatham'), ValueTY(205,'Chatteris'), ValueTY(206,'Chelmsford'), ValueTY(207,'Cheltenham'), ValueTY(208,'Chepstow'), ValueTY(209,'Chesham'), ValueTY(210,'Cheshunt'), ValueTY(211,'Chester'), ValueTY(212,'Chester le Street'), ValueTY(213,'Chesterfield'), ValueTY(214,'Chichester'), ValueTY(215,'Chippenham'), ValueTY(216,'Chipping Campden'), ValueTY(217,'Chipping Norton'), ValueTY(218,'Chipping Sodbury'), ValueTY(219,'Chorley'), ValueTY(220,'Christchurch'), ValueTY(221,'Church Stretton'), ValueTY(222,'Cidxerford'), ValueTY(223,'Cirencester'), ValueTY(224,'Clacton on Sea'), ValueTY(225,'Cleckheaton'), ValueTY(226,'Cleethorpes'), ValueTY(227,'Clevedon'), ValueTY(228,'Clitheroe'), ValueTY(229,'Clogher'), ValueTY(230,'Clydebank'), ValueTY(231,'Coalisland'), ValueTY(232,'Coalville'), ValueTY(233,'Coatbridge'), ValueTY(234,'Cockermouth'), ValueTY(235,'Coggeshall'), ValueTY(236,'Colchester'), ValueTY(237,'Coldstream'), ValueTY(238,'Coleraine'), ValueTY(239,'Coleshill'), ValueTY(240,'Colne'), ValueTY(241,'Colwyn Bay'), ValueTY(242,'Comber'), ValueTY(243,'Congleton'), ValueTY(244,'Conwy'), ValueTY(245,'Cookstown'), ValueTY(246,'Corbridge'), ValueTY(247,'Corby'), ValueTY(248,'Coventry'), ValueTY(249,'Cowbridge'), ValueTY(250,'Cowdenbeath'), ValueTY(251,'Cowes'), ValueTY(252,'Craigavon'), ValueTY(253,'Cramlington'), ValueTY(254,'Crawley'), ValueTY(255,'Crayford'), ValueTY(256,'Crediton'), ValueTY(257,'Crewe'), ValueTY(258,'Crewkerne'), ValueTY(259,'Criccieth'), ValueTY(260,'Crickhowell'), ValueTY(261,'Crieff'), ValueTY(262,'Cromarty'), ValueTY(263,'Cromer'), ValueTY(264,'Crowborough'), ValueTY(265,'Crowthorne'), ValueTY(266,'Crumlin'), ValueTY(267,'Cuckfield'), ValueTY(268,'Cullen'), ValueTY(269,'Cullompton'), ValueTY(270,'Cumbernauld'), ValueTY(271,'Cupar'), ValueTY(272,'Cwmbran'), ValueTY(273,'Dalbeattie'), ValueTY(274,'Dalkeith'), ValueTY(275,'Darlington'), ValueTY(276,'Dartford'), ValueTY(277,'Dartmouth'), ValueTY(278,'Darwen'), ValueTY(279,'Daventry'), ValueTY(280,'Dawlish'), ValueTY(281,'Deal'), ValueTY(282,'Denbigh'), ValueTY(283,'Denton'), ValueTY(284,'Derby'), ValueTY(285,'Dereham'), ValueTY(286,'Devizes'), ValueTY(287,'Dewsbury'), ValueTY(288,'Didcot'), ValueTY(289,'Dingwall'), ValueTY(290,'Dinnington'), ValueTY(291,'Diss'), ValueTY(292,'Dolgellau'), ValueTY(293,'Donaghadee'), ValueTY(294,'Doncaster'), ValueTY(295,'Dorchester'), ValueTY(296,'Dorking'), ValueTY(297,'Dornoch'), ValueTY(298,'Dover'), ValueTY(299,'Downham Market'), ValueTY(300,'Downpatrick'), ValueTY(301,'Driffield'), ValueTY(302,'Dronfield'), ValueTY(303,'Droylsden'), ValueTY(304,'Dudley'), ValueTY(305,'Dufftown'), ValueTY(306,'Dukinfield'), ValueTY(307,'Dumbarton'), ValueTY(308,'Dumfries'), ValueTY(309,'Dunbar'), ValueTY(310,'Dunblane'), ValueTY(311,'Dundee'), ValueTY(312,'Dunfermline'), ValueTY(313,'Dungannon'), ValueTY(314,'Dunoon'), ValueTY(315,'Duns'), ValueTY(316,'Dunstable'), ValueTY(317,'Durham'), ValueTY(318,'Dursley'), ValueTY(319,'Easingwold'), ValueTY(320,'East Grinstead'), ValueTY(321,'East Kilbride'), ValueTY(322,'Eastbourne'), ValueTY(323,'Eastleigh'), ValueTY(324,'Eastwood'), ValueTY(325,'Ebbw Vale'), ValueTY(326,'Edenbridge'), ValueTY(327,'Edinburgh'), ValueTY(328,'Egham'), ValueTY(329,'Elgin'), ValueTY(330,'Ellesmere'), ValueTY(331,'Ellesmere Port'), ValueTY(332,'Ely'), ValueTY(333,'Enniskillen'), ValueTY(334,'Epping'), ValueTY(335,'Epsom'), ValueTY(336,'Erith'), ValueTY(337,'Esher'), ValueTY(338,'Evesham'), ValueTY(339,'Exeter'), ValueTY(340,'Exmouth'), ValueTY(341,'Eye'), ValueTY(342,'Eyemouth'), ValueTY(343,'Failsworth'), ValueTY(344,'Fairford'), ValueTY(345,'Fakenham'), ValueTY(346,'Falkirk'), ValueTY(347,'Falkland'), ValueTY(348,'Falmouth'), ValueTY(349,'Fareham'), ValueTY(350,'Faringdon'), ValueTY(351,'Farnborough'), ValueTY(352,'Farnham'), ValueTY(353,'Farnworth'), ValueTY(354,'Faversham'), ValueTY(355,'Felixstowe'), ValueTY(356,'Ferndown'), ValueTY(357,'Filey'), ValueTY(358,'Fintona'), ValueTY(359,'Fishguard'), ValueTY(360,'Fivemiletown'), ValueTY(361,'Fleet'), ValueTY(362,'Fleetwood'), ValueTY(363,'Flint'), ValueTY(364,'Flitwick'), ValueTY(365,'Folkestone'), ValueTY(366,'Fordingbridge'), ValueTY(367,'Forfar'), ValueTY(368,'Forres'), ValueTY(369,'Fort William'), ValueTY(370,'Fowey'), ValueTY(371,'Framlingham'), ValueTY(372,'Fraserburgh'), ValueTY(373,'Frodsham'), ValueTY(374,'Frome'), ValueTY(375,'Gainsborough'), ValueTY(376,'Galashiels'), ValueTY(377,'Gateshead'), ValueTY(378,'Gillingham'), ValueTY(379,'Glasgow'), ValueTY(380,'Glastonbury'), ValueTY(381,'Glossop'), ValueTY(382,'Gloucester'), ValueTY(383,'Godalming'), ValueTY(384,'Godmanchester'), ValueTY(385,'Goole'), ValueTY(386,'Gorseinon'), ValueTY(387,'Gosport'), ValueTY(388,'Gourock'), ValueTY(389,'Grange over'), ValueTY(390,'Sands'), ValueTY(391,'Grangemouth'), ValueTY(392,'Grantham'), ValueTY(393,'Grantown on Spey'), ValueTY(394,'Gravesend'), ValueTY(395,'Grays'), ValueTY(396,'Great Yarmouth'), ValueTY(397,'Greenock'), ValueTY(398,'Grimsby'), ValueTY(399,'Guildford'), ValueTY(400,'Haddington'), ValueTY(401,'Hadleigh'), ValueTY(402,'Hailsham'), ValueTY(403,'Halesowen'), ValueTY(404,'Halesworth'), ValueTY(405,'Halifax'), ValueTY(406,'Halstead'), ValueTY(407,'Haltwhistle'), ValueTY(408,'Hamilton'), ValueTY(409,'Harlow'), ValueTY(410,'Harpenden'), ValueTY(411,'Harrogate'), ValueTY(412,'Hartlepool'), ValueTY(413,'Harwich'), ValueTY(414,'Haslemere'), ValueTY(415,'Hastings'), ValueTY(416,'Hatfield'), ValueTY(417,'Havant'), ValueTY(418,'Haverfordwest'), ValueTY(419,'Haverhill'), ValueTY(420,'Hawarden'), ValueTY(421,'Hawick'), ValueTY(422,'Hay on Wye'), ValueTY(423,'Hayle'), ValueTY(424,'Haywards Heath'), ValueTY(425,'Heanor'), ValueTY(426,'Heathfield'), ValueTY(427,'Hebden Bridge'), ValueTY(428,'Helensburgh'), ValueTY(429,'Helston'), ValueTY(430,'Hemel Hempstead'), ValueTY(431,'Henley on Thames'), ValueTY(432,'Hereford'), ValueTY(433,'Herne Bay'), ValueTY(434,'Hertford'), ValueTY(435,'Hessle'), ValueTY(436,'Heswall'), ValueTY(437,'Hexham'), ValueTY(438,'High Wycombe'), ValueTY(439,'Higham Ferrers'), ValueTY(440,'Highworth'), ValueTY(441,'Hinckley'), ValueTY(442,'Hitchin'), ValueTY(443,'Hoddesdon'), ValueTY(444,'Holmfirth'), ValueTY(445,'Holsworthy'), ValueTY(446,'Holyhead'), ValueTY(447,'Holywell'), ValueTY(448,'Honiton'), ValueTY(449,'Horley'), ValueTY(450,'Horncastle'), ValueTY(451,'Hornsea'), ValueTY(452,'Horsham'), ValueTY(453,'Horwich'), ValueTY(454,'Houghton le Spring'), ValueTY(455,'Hove'), ValueTY(456,'Howden'), ValueTY(457,'Hoylake'), ValueTY(458,'Hucknall'), ValueTY(459,'Huddersfield'), ValueTY(460,'Hungerford'), ValueTY(461,'Hunstanton'), ValueTY(462,'Huntingdon'), ValueTY(463,'Huntly'), ValueTY(464,'Hyde'), ValueTY(465,'Hythe'), ValueTY(466,'Ilford'), ValueTY(467,'Ilfracombe'), ValueTY(468,'Ilkeston'), ValueTY(469,'Ilkley'), ValueTY(470,'Ilminster'), ValueTY(471,'Innerleithen'), ValueTY(472,'Inveraray'), ValueTY(473,'Inverkeithing'), ValueTY(474,'Inverness'), ValueTY(475,'Inverurie'), ValueTY(476,'Ipswich'), ValueTY(477,'Irthlingborough'), ValueTY(478,'Irvine'), ValueTY(479,'Ivybridge'), ValueTY(480,'Jarrow'), ValueTY(481,'Jedburgh'), ValueTY(482,'Johnstone'), ValueTY(483,'Keighley'), ValueTY(484,'Keith'), ValueTY(485,'Kelso'), ValueTY(486,'Kempston'), ValueTY(487,'Kendal'), ValueTY(488,'Kenilworth'), ValueTY(489,'Kesgrave'), ValueTY(490,'Keswick'), ValueTY(491,'Kettering'), ValueTY(492,'Keynsham'), ValueTY(493,'Kidderminster'), ValueTY(494,'Kilbarchan'), ValueTY(495,'Kilkeel'), ValueTY(496,'Killyleagh'), ValueTY(497,'Kilmarnock'), ValueTY(498,'Kilwinning'), ValueTY(499,'Kinghorn'), ValueTY(500,'Kingsbridge'), ValueTY(501,'Kington'), ValueTY(502,'Kingussie'), ValueTY(503,'Kinross'), ValueTY(504,'Kintore'), ValueTY(505,'Kirkby'), ValueTY(506,'Kirkby Lonsdale'), ValueTY(507,'Kirkcaldy'), ValueTY(508,'Kirkcudbright'), ValueTY(509,'Kirkham'), ValueTY(510,'Kirkwall'), ValueTY(511,'Kirriemuir'), ValueTY(512,'Knaresborough'), ValueTY(513,'Knighton'), ValueTY(514,'Knutsford'), ValueTY(515,'Ladybank'), ValueTY(516,'Lampeter'), ValueTY(517,'Lanark'), ValueTY(518,'Lancaster'), ValueTY(519,'Langholm'), ValueTY(520,'Largs'), ValueTY(521,'Larne'), ValueTY(522,'Laugharne'), ValueTY(523,'Launceston'), ValueTY(524,'Laurencekirk'), ValueTY(525,'Leamington Spa'), ValueTY(526,'Leatherhead'), ValueTY(527,'Ledbury'), ValueTY(528,'Leeds'), ValueTY(529,'Leek'), ValueTY(530,'Leicester'), ValueTY(531,'Leighton Buzzard'), ValueTY(532,'Leiston'), ValueTY(533,'Leominster'), ValueTY(534,'Lerwick'), ValueTY(535,'Letchworth'), ValueTY(536,'Leven'), ValueTY(537,'Lewes'), ValueTY(538,'Leyland'), ValueTY(539,'Lichfield'), ValueTY(540,'Limavady'), ValueTY(541,'Lincoln'), ValueTY(542,'Linlithgow'), ValueTY(543,'Lisburn'), ValueTY(544,'Liskeard'), ValueTY(545,'Lisnaskea'), ValueTY(546,'Littlehampton'), ValueTY(547,'Liverpool'), ValueTY(548,'Llandeilo'), ValueTY(549,'Llandovery'), ValueTY(550,'Llandridxod Wells'), ValueTY(551,'Llandudno'), ValueTY(552,'Llanelli'), ValueTY(553,'Llanfyllin'), ValueTY(554,'Llangollen'), ValueTY(555,'Llanidloes'), ValueTY(556,'Llanrwst'), ValueTY(557,'Llantrisant'), ValueTY(558,'Llantwit Major'), ValueTY(559,'Llanwrtyd Wells'), ValueTY(560,'Loanhead'), ValueTY(561,'Lochgilphead'), ValueTY(562,'Lockerbie'), ValueTY(563,'Londonderry'), ValueTY(564,'Long Eaton'), ValueTY(565,'Longridge'), ValueTY(566,'Looe'), ValueTY(567,'Lossiemouth'), ValueTY(568,'Lostwithiel'), ValueTY(569,'Loughborough'), ValueTY(570,'Loughton'), ValueTY(571,'Louth'), ValueTY(572,'Lowestoft'), ValueTY(573,'Ludlow'), ValueTY(574,'Lurgan'), ValueTY(575,'Luton'), ValueTY(576,'Lutterworth'), ValueTY(577,'Lydd'), ValueTY(578,'Lydney'), ValueTY(579,'Lyme Regis'), ValueTY(580,'Lymington'), ValueTY(581,'Lynton'), ValueTY(582,'Mablethorpe'), ValueTY(583,'Macclesfield'), ValueTY(584,'Machynlleth'), ValueTY(585,'Maesteg'), ValueTY(586,'Magherafelt'), ValueTY(587,'Maidenhead'), ValueTY(588,'Maidstone'), ValueTY(589,'Maldon'), ValueTY(590,'Malmesbury'), ValueTY(591,'Malton'), ValueTY(592,'Malvern'), ValueTY(593,'Manchester'), ValueTY(594,'Manningtree'), ValueTY(595,'Mansfield'), ValueTY(596,'March'), ValueTY(597,'Margate'), ValueTY(598,'Market Deeping'), ValueTY(599,'Market Drayton'), ValueTY(600,'Market Harborough'), ValueTY(601,'Market Rasen'), ValueTY(602,'Market Weighton'), ValueTY(603,'Markethill'), ValueTY(604,'Markinch'), ValueTY(605,'Marlborough'), ValueTY(606,'Marlow'), ValueTY(607,'Maryport'), ValueTY(608,'Matlock'), ValueTY(609,'Maybole'), ValueTY(610,'Melksham'), ValueTY(611,'Melrose'), ValueTY(612,'Melton Mowbray'), ValueTY(613,'Merthyr Tydfil'), ValueTY(614,'Mexborough'), ValueTY(615,'Middleham'), ValueTY(616,'Middlesbrough'), ValueTY(617,'Middlewich'), ValueTY(618,'Midhurst'), ValueTY(619,'Midsomer Norton'), ValueTY(620,'Milford Haven'), ValueTY(621,'Milngavie'), ValueTY(622,'Milton Keynes'), ValueTY(623,'Minehead'), ValueTY(624,'Moffat'), ValueTY(625,'Mold'), ValueTY(626,'Monifieth'), ValueTY(627,'Monmouth'), ValueTY(628,'Montgomery'), ValueTY(629,'Montrose'), ValueTY(630,'Morecambe'), ValueTY(631,'Moreton in Marsh'), ValueTY(632,'Moretonhampstead'), ValueTY(633,'Morley'), ValueTY(634,'Morpeth'), ValueTY(635,'Motherwell'), ValueTY(636,'Musselburgh'), ValueTY(637,'Nailsea'), ValueTY(638,'Nailsworth'), ValueTY(639,'Nairn'), ValueTY(640,'Nantwich'), ValueTY(641,'Narberth'), ValueTY(642,'Neath'), ValueTY(643,'Needham Market'), ValueTY(644,'Neston'), ValueTY(645,'New Mills'), ValueTY(646,'New Milton'), ValueTY(647,'Newbury'), ValueTY(648,'Newcastle'), ValueTY(649,'Newcastle Emlyn'), ValueTY(650,'Newcastle upon'), ValueTY(651,'Tyne'), ValueTY(652,'Newent'), ValueTY(653,'Newhaven'), ValueTY(654,'Newmarket'), ValueTY(655,'Newport'), ValueTY(656,'Newport Pagnell'), ValueTY(657,'Newport on Tay'), ValueTY(658,'Newquay'), ValueTY(659,'Newry'), ValueTY(660,'Newton Abbot'), ValueTY(661,'Newton Aycliffe'), ValueTY(662,'Newton Stewart'), ValueTY(663,'Newton le Willows'), ValueTY(664,'Newtown'), ValueTY(665,'Newtownabbey'), ValueTY(666,'Newtownards'), ValueTY(667,'Normanton'), ValueTY(668,'North Berwick'), ValueTY(669,'North Walsham'), ValueTY(670,'Northallerton'), ValueTY(671,'Northampton'), ValueTY(672,'Northwich'), ValueTY(673,'Norwich'), ValueTY(674,'Nottingham'), ValueTY(675,'Nuneaton'), ValueTY(676,'Oakham'), ValueTY(677,'Oban'), ValueTY(678,'Okehampton'), ValueTY(679,'Oldbury'), ValueTY(680,'Oldham'), ValueTY(681,'Oldmeldrum'), ValueTY(682,'Olney'), ValueTY(683,'Omagh'), ValueTY(684,'Ormskirk'), ValueTY(685,'Orpington'), ValueTY(686,'Ossett'), ValueTY(687,'Oswestry'), ValueTY(688,'Otley'), ValueTY(689,'Oundle'), ValueTY(690,'Oxford'), ValueTY(691,'Padstow'), ValueTY(692,'Paignton'), ValueTY(693,'Painswick'), ValueTY(694,'Paisley'), ValueTY(695,'Peebles'), ValueTY(696,'Pembroke'), ValueTY(697,'Penarth'), ValueTY(698,'Penicuik'), ValueTY(699,'Penistone'), ValueTY(700,'Penmaenmawr'), ValueTY(701,'Penrith'), ValueTY(702,'Penryn'), ValueTY(703,'Penzance'), ValueTY(704,'Pershore'), ValueTY(705,'Perth'), ValueTY(706,'Peterborough'), ValueTY(707,'Peterhead'), ValueTY(708,'Peterlee'), ValueTY(709,'Petersfield'), ValueTY(710,'Petworth'), ValueTY(711,'Pickering'), ValueTY(712,'Pitlochry'), ValueTY(713,'Pittenweem'), ValueTY(714,'Plymouth'), ValueTY(715,'Pocklington'), ValueTY(716,'Polegate'), ValueTY(717,'Pontefract'), ValueTY(718,'Pontypridd'), ValueTY(719,'Poole'), ValueTY(720,'Port Talbot'), ValueTY(721,'Portadown'), ValueTY(722,'Portaferry'), ValueTY(723,'Porth'), ValueTY(724,'Porthcawl'), ValueTY(725,'Porthmadog'), ValueTY(726,'Portishead'), ValueTY(727,'Portrush'), ValueTY(728,'Portsmouth'), ValueTY(729,'Portstewart'), ValueTY(730,'Potters Bar'), ValueTY(731,'Potton'), ValueTY(732,'Poulton le Fylde'), ValueTY(733,'Prescot'), ValueTY(734,'Prestatyn'), ValueTY(735,'Presteigne'), ValueTY(736,'Preston'), ValueTY(737,'Prestwick'), ValueTY(738,'Princes'), ValueTY(739,'Risborough'), ValueTY(740,'Prudhoe'), ValueTY(741,'Pudsey'), ValueTY(742,'Pwllheli'), ValueTY(743,'Ramsgate'), ValueTY(744,'Randalstown'), ValueTY(745,'Rayleigh'), ValueTY(746,'Reading'), ValueTY(747,'Redcar'), ValueTY(748,'Redditch'), ValueTY(749,'Redhill'), ValueTY(750,'Redruth'), ValueTY(751,'Reigate'), ValueTY(752,'Retford'), ValueTY(753,'Rhayader'), ValueTY(754,'Rhuddlan'), ValueTY(755,'Rhyl'), ValueTY(756,'Richmond'), ValueTY(757,'Rickmansworth'), ValueTY(758,'Ringwood'), ValueTY(759,'Ripley'), ValueTY(760,'Ripon'), ValueTY(761,'Rochdale'), ValueTY(762,'Rochester'), ValueTY(763,'Rochford'), ValueTY(764,'Romford'), ValueTY(765,'Romsey'), ValueTY(766,'Ross on Wye'), ValueTY(767,'Rostrevor'), ValueTY(768,'Rothbury'), ValueTY(769,'Rotherham'), ValueTY(770,'Rothesay'), ValueTY(771,'Rowley Regis'), ValueTY(772,'Royston'), ValueTY(773,'Rugby'), ValueTY(774,'Rugeley'), ValueTY(775,'Runcorn'), ValueTY(776,'Rushden'), ValueTY(777,'Rutherglen'), ValueTY(778,'Ruthin'), ValueTY(779,'Ryde'), ValueTY(780,'Rye'), ValueTY(781,'Saffron Walden'), ValueTY(782,'Saintfield'), ValueTY(783,'Salcombe'), ValueTY(784,'Sale'), ValueTY(785,'Salford'), ValueTY(786,'Salisbury'), ValueTY(787,'Saltash'), ValueTY(788,'Saltcoats'), ValueTY(789,'Sandbach'), ValueTY(790,'Sandhurst'), ValueTY(791,'Sandown'), ValueTY(792,'Sandwich'), ValueTY(793,'Sandy'), ValueTY(794,'Sawbridgeworth'), ValueTY(795,'Saxmundham'), ValueTY(796,'Scarborough'), ValueTY(797,'Scunthorpe'), ValueTY(798,'Seaford'), ValueTY(799,'Seaton'), ValueTY(800,'Sedgefield'), ValueTY(801,'Selby'), ValueTY(802,'Selkirk'), ValueTY(803,'Selsey'), ValueTY(804,'Settle'), ValueTY(805,'Sevenoaks'), ValueTY(806,'Shaftesbury'), ValueTY(807,'Shanklin'), ValueTY(808,'Sheerness'), ValueTY(809,'Sheffield'), ValueTY(810,'Shepshed'), ValueTY(811,'Shepton Mallet'), ValueTY(812,'Sherborne'), ValueTY(813,'Sheringham'), ValueTY(814,'Shildon'), ValueTY(815,'Shipston on Stour'), ValueTY(816,'Shoreham by Sea'), ValueTY(817,'Shrewsbury'), ValueTY(818,'Sidmouth'), ValueTY(819,'Sittingbourne'), ValueTY(820,'Skegness'), ValueTY(821,'Skelmersdale'), ValueTY(822,'Skipton'), ValueTY(823,'Sleaford'), ValueTY(824,'Slough'), ValueTY(825,'Smethwick'), ValueTY(826,'Soham'), ValueTY(827,'Solihull'), ValueTY(828,'Somerton'), ValueTY(829,'South Molton'), ValueTY(830,'South Shields'), ValueTY(831,'South Woodham'), ValueTY(832,'Ferrers'), ValueTY(833,'Southam'), ValueTY(834,'Southampton'), ValueTY(835,'Southborough'), ValueTY(836,'Southend on Sea'), ValueTY(837,'Southport'), ValueTY(838,'Southsea'), ValueTY(839,'Southwell'), ValueTY(840,'Southwold'), ValueTY(841,'Spalding'), ValueTY(842,'Spennymoor'), ValueTY(843,'Spilsby'), ValueTY(844,'Stafford'), ValueTY(845,'Staines'), ValueTY(846,'Stamford'), ValueTY(847,'Stanley'), ValueTY(848,'Staveley'), ValueTY(849,'Stevenage'), ValueTY(850,'Stirling'), ValueTY(851,'Stockport'), ValueTY(852,'Stockton on Tees'), ValueTY(853,'Stoke on Trent'), ValueTY(854,'Stone'), ValueTY(855,'Stowmarket'), ValueTY(856,'Strabane'), ValueTY(857,'Stranraer'), ValueTY(858,'Stratford upon'), ValueTY(859,'Avon'), ValueTY(860,'Strood'), ValueTY(861,'Stroud'), ValueTY(862,'Sudbury'), ValueTY(863,'Sunderland'), ValueTY(864,'Sutton Coldfield'), ValueTY(865,'Sutton in Ashfield'), ValueTY(866,'Swadlincote'), ValueTY(867,'Swanage'), ValueTY(868,'Swanley'), ValueTY(869,'Swansea'), ValueTY(870,'Swidxon'), ValueTY(871,'Tadcaster'), ValueTY(872,'Tadley'), ValueTY(873,'Tain'), ValueTY(874,'Talgarth'), ValueTY(875,'Tamworth'), ValueTY(876,'Taunton'), ValueTY(877,'Tavistock'), ValueTY(878,'Teignmouth'), ValueTY(879,'Telford'), ValueTY(880,'Tenby'), ValueTY(881,'Tenterden'), ValueTY(882,'Tetbury'), ValueTY(883,'Tewkesbury'), ValueTY(884,'Thame'), ValueTY(885,'Thatcham'), ValueTY(886,'Thaxted'), ValueTY(887,'Thetford'), ValueTY(888,'Thirsk'), ValueTY(889,'Thornbury'), ValueTY(890,'Thrapston'), ValueTY(891,'Thurso'), ValueTY(892,'Tilbury'), ValueTY(893,'Tillicoultry'), ValueTY(894,'Tipton'), ValueTY(895,'Tiverton'), ValueTY(896,'Tobermory'), ValueTY(897,'Todmorden'), ValueTY(898,'Tonbridge'), ValueTY(899,'Torpoint'), ValueTY(900,'Torquay'), ValueTY(901,'Totnes'), ValueTY(902,'Totton'), ValueTY(903,'Towcester'), ValueTY(904,'Tredegar'), ValueTY(905,'Tregaron'), ValueTY(906,'Tring'), ValueTY(907,'Troon'), ValueTY(908,'Trowbridge'), ValueTY(909,'Truro'), ValueTY(910,'Tunbridge Wells'), ValueTY(911,'Tywyn'), ValueTY(912,'Uckfield'), ValueTY(913,'Ulverston'), ValueTY(914,'Uppingham'), ValueTY(915,'Usk'), ValueTY(916,'Uttoxeter'), ValueTY(917,'Ventnor'), ValueTY(918,'Verwood'), ValueTY(919,'Wadebridge'), ValueTY(920,'Wadhurst'), ValueTY(921,'Wakefield'), ValueTY(922,'Wallasey'), ValueTY(923,'Wallingford'), ValueTY(924,'Walsall'), ValueTY(925,'Waltham Abbey'), ValueTY(926,'Waltham Cross'), ValueTY(927,'Walton on Thames'), ValueTY(928,'Walton on the'), ValueTY(929,'Naze'), ValueTY(930,'Wantage'), ValueTY(931,'Ware'), ValueTY(932,'Wareham'), ValueTY(933,'Warminster'), ValueTY(934,'Warrenpoint'), ValueTY(935,'Warrington'), ValueTY(936,'Warwick'), ValueTY(937,'Washington'), ValueTY(938,'Watford'), ValueTY(939,'Wednesbury'), ValueTY(940,'Wednesfield'), ValueTY(941,'Wellingborough'), ValueTY(942,'Wellington'), ValueTY(943,'Wells'), ValueTY(944,'Wells next the Sea'), ValueTY(945,'Welshpool'), ValueTY(946,'Welwyn Garden'), ValueTY(947,'Wem'), ValueTY(948,'Wendover'), ValueTY(949,'West Bromwich'), ValueTY(950,'Westbury'), ValueTY(951,'Westerham'), ValueTY(952,'Westhoughton'), ValueTY(953,'Weston super'), ValueTY(954,'Mare'), ValueTY(955,'Wetherby'), ValueTY(956,'Weybridge'), ValueTY(957,'Weymouth'), ValueTY(958,'Whaley Bridge'), ValueTY(959,'Whitby'), ValueTY(960,'Whitchurch'), ValueTY(961,'Whitehaven'), ValueTY(962,'Whitley Bay'), ValueTY(963,'Whitnash'), ValueTY(964,'Whitstable'), ValueTY(965,'Whitworth'), ValueTY(966,'Wick'), ValueTY(967,'Wickford'), ValueTY(968,'Widnes'), ValueTY(969,'Wigan'), ValueTY(970,'Wigston'), ValueTY(971,'Wigtown'), ValueTY(972,'Willenhall'), ValueTY(973,'Wincanton'), ValueTY(974,'Winchester'), ValueTY(975,'Widxermere'), ValueTY(976,'Winsford'), ValueTY(977,'Winslow'), ValueTY(978,'Wisbech'), ValueTY(979,'Witham'), ValueTY(980,'Withernsea'), ValueTY(981,'Witney'), ValueTY(982,'Woburn'), ValueTY(983,'Woking'), ValueTY(984,'Wokingham'), ValueTY(985,'Wolverhampton'), ValueTY(986,'Wombwell'), ValueTY(987,'Woodbridge'), ValueTY(988,'Woodstock'), ValueTY(989,'Wootton Bassett'), ValueTY(990,'Worcester'), ValueTY(991,'Workington'), ValueTY(992,'Worksop'), ValueTY(993,'Worthing'), ValueTY(994,'Wotton under Edge'), ValueTY(995,'Wrexham'), ValueTY(996,'Wymondham'), ValueTY(997,'Yarm'), ValueTY(998,'Yarmouth'), ValueTY(999,'Yate')));
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('surnames',  VocabularyValuesTY (ValueTY(1,'SMITH'), ValueTY(2,'JOHNSON'), ValueTY(3,'WILLIAMS'), ValueTY(4,'JONES'), ValueTY(5,'BROWN'), ValueTY(6,'DAVIS'), ValueTY(7,'MILLER'), ValueTY(8,'WILSON'), ValueTY(9,'MOORE'), ValueTY(10,'TAYLOR'), ValueTY(11,'ANDERSON'), ValueTY(12,'THOMAS'), ValueTY(13,'JACKSON'), ValueTY(14,'WHITE'), ValueTY(15,'HARRIS'), ValueTY(16,'MARTIN'), ValueTY(17,'THOMPSON'), ValueTY(18,'GARCIA'), ValueTY(19,'MARTINEZ'), ValueTY(20,'ROBINSON'), ValueTY(21,'CLARK'), ValueTY(22,'RODRIGUEZ'), ValueTY(23,'LEWIS'), ValueTY(24,'LEE'), ValueTY(25,'WALKER'), ValueTY(26,'HALL'), ValueTY(27,'ALLEN'), ValueTY(28,'YOUNG'), ValueTY(29,'HERNANDEZ'), ValueTY(30,'KING'), ValueTY(31,'WRIGHT'), ValueTY(32,'LOPEZ'), ValueTY(33,'HILL'), ValueTY(34,'SCOTT'), ValueTY(35,'GREEN'), ValueTY(36,'ADAMS'), ValueTY(37,'BAKER'), ValueTY(38,'GONZALEZ'), ValueTY(39,'NELSON'), ValueTY(40,'CARTER'), ValueTY(41,'MITCHELL'), ValueTY(42,'PEREZ'), ValueTY(43,'ROBERTS'), ValueTY(44,'TURNER'), ValueTY(45,'PHILLIPS'), ValueTY(46,'CAMPBELL'), ValueTY(47,'PARKER'), ValueTY(48,'EVANS'), ValueTY(49,'EDWARDS'), ValueTY(50,'COLLINS'), ValueTY(51,'STEWART'), ValueTY(52,'SANCHEZ'), ValueTY(53,'MORRIS'), ValueTY(54,'ROGERS'), ValueTY(55,'REED'), ValueTY(56,'COOK'), ValueTY(57,'MORGAN'), ValueTY(58,'BELL'), ValueTY(59,'MURPHY'), ValueTY(60,'BAILEY'), ValueTY(61,'RIVERA'), ValueTY(62,'COOPER'), ValueTY(63,'RICHARDSON'), ValueTY(64,'COX'), ValueTY(65,'HOWARD'), ValueTY(66,'WARD'), ValueTY(67,'TORRES'), ValueTY(68,'PETERSON'), ValueTY(69,'GRAY'), ValueTY(70,'RAMIREZ'), ValueTY(71,'JAMES'), ValueTY(72,'WATSON'), ValueTY(73,'BROOKS'), ValueTY(74,'KELLY'), ValueTY(75,'SANDERS'), ValueTY(76,'PRICE'), ValueTY(77,'BENNETT'), ValueTY(78,'WOOD'), ValueTY(79,'BARNES'), ValueTY(80,'ROSS'), ValueTY(81,'HENDERSON'), ValueTY(82,'COLEMAN'), ValueTY(83,'JENKINS'), ValueTY(84,'PERRY'), ValueTY(85,'POWELL'), ValueTY(86,'LONG'), ValueTY(87,'PATTERSON'), ValueTY(88,'HUGHES'), ValueTY(89,'FLORES'), ValueTY(90,'WASHINGTON'), ValueTY(91,'BUTLER'), ValueTY(92,'SIMMONS'), ValueTY(93,'FOSTER'), ValueTY(94,'GONZALES'), ValueTY(95,'BRYANT'), ValueTY(96,'ALEXANDER'), ValueTY(97,'RUSSELL'), ValueTY(98,'GRIFFIN'), ValueTY(99,'DIAZ'), ValueTY(100,'HAYES'), ValueTY(101,'MYERS'), ValueTY(102,'FORD'), ValueTY(103,'HAMILTON'), ValueTY(104,'GRAHAM'), ValueTY(105,'SULLIVAN'), ValueTY(106,'WALLACE'), ValueTY(107,'WOODS'), ValueTY(108,'COLE'), ValueTY(109,'WEST'), ValueTY(110,'JORDAN'), ValueTY(111,'OWENS'), ValueTY(112,'REYNOLDS'), ValueTY(113,'FISHER'), ValueTY(114,'ELLIS'), ValueTY(115,'HARRISON'), ValueTY(116,'GIBSON'), ValueTY(117,'MCDONALD'), ValueTY(118,'CRUZ'), ValueTY(119,'MARSHALL'), ValueTY(120,'ORTIZ'), ValueTY(121,'GOMEZ'), ValueTY(122,'MURRAY'), ValueTY(123,'FREEMAN'), ValueTY(124,'WELLS'), ValueTY(125,'WEBB'), ValueTY(126,'SIMPSON'), ValueTY(127,'STEVENS'), ValueTY(128,'TUCKER'), ValueTY(129,'PORTER'), ValueTY(130,'HUNTER'), ValueTY(131,'HICKS'), ValueTY(132,'CRAWFORD'), ValueTY(133,'HENRY'), ValueTY(134,'BOYD'), ValueTY(135,'MASON'), ValueTY(136,'MORALES'), ValueTY(137,'KENNEDY'), ValueTY(138,'WARREN'), ValueTY(139,'DIXON'), ValueTY(140,'RAMOS'), ValueTY(141,'REYES'), ValueTY(142,'BURNS'), ValueTY(143,'GORDON'), ValueTY(144,'SHAW'), ValueTY(145,'HOLMES'), ValueTY(146,'RICE'), ValueTY(147,'ROBERTSON'), ValueTY(148,'HUNT'), ValueTY(149,'BLACK'), ValueTY(150,'DANIELS'), ValueTY(151,'PALMER'), ValueTY(152,'MILLS'), ValueTY(153,'NICHOLS'), ValueTY(154,'GRANT'), ValueTY(155,'KNIGHT'), ValueTY(156,'FERGUSON'), ValueTY(157,'ROSE'), ValueTY(158,'STONE'), ValueTY(159,'HAWKINS'), ValueTY(160,'DUNN'), ValueTY(161,'PERKINS'), ValueTY(162,'HUDSON'), ValueTY(163,'SPENCER'), ValueTY(164,'GARDNER'), ValueTY(165,'STEPHENS'), ValueTY(166,'PAYNE'), ValueTY(167,'PIERCE'), ValueTY(168,'BERRY'), ValueTY(169,'MATTHEWS'), ValueTY(170,'ARNOLD'), ValueTY(171,'WAGNER'), ValueTY(172,'WILLIS'), ValueTY(173,'RAY'), ValueTY(174,'WATKINS'), ValueTY(175,'OLSON'), ValueTY(176,'CARROLL'), ValueTY(177,'DUNCAN'), ValueTY(178,'SNYDER'), ValueTY(179,'HART'), ValueTY(180,'CUNNINGHAM'), ValueTY(181,'BRADLEY'), ValueTY(182,'LANE'), ValueTY(183,'ANDREWS'), ValueTY(184,'RUIZ'), ValueTY(185,'HARPER'), ValueTY(186,'FOX'), ValueTY(187,'RILEY'), ValueTY(188,'ARMSTRONG'), ValueTY(189,'CARPENTER'), ValueTY(190,'WEAVER'), ValueTY(191,'GREENE'), ValueTY(192,'LAWRENCE'), ValueTY(193,'ELLIOTT'), ValueTY(194,'CHAVEZ'), ValueTY(195,'SIMS'), ValueTY(196,'AUSTIN'), ValueTY(197,'PETERS'), ValueTY(198,'KELLEY'), ValueTY(199,'FRANKLIN'), ValueTY(200,'LAWSON'), ValueTY(201,'FIELDS'), ValueTY(202,'GUTIERREZ'), ValueTY(203,'RYAN'), ValueTY(204,'SCHMIDT'), ValueTY(205,'CARR'), ValueTY(206,'VASQUEZ'), ValueTY(207,'CASTILLO'), ValueTY(208,'WHEELER'), ValueTY(209,'CHAPMAN'), ValueTY(210,'OLIVER'), ValueTY(211,'MONTGOMERY'), ValueTY(212,'RICHARDS'), ValueTY(213,'WILLIAMSON'), ValueTY(214,'JOHNSTON'), ValueTY(215,'BANKS'), ValueTY(216,'MEYER'), ValueTY(217,'BISHOP'), ValueTY(218,'MCCOY'), ValueTY(219,'HOWELL'), ValueTY(220,'ALVAREZ'), ValueTY(221,'MORRISON'), ValueTY(222,'HANSEN'), ValueTY(223,'FERNANDEZ'), ValueTY(224,'GARZA'), ValueTY(225,'HARVEY'), ValueTY(226,'LITTLE'), ValueTY(227,'BURTON'), ValueTY(228,'STANLEY'), ValueTY(229,'NGUYEN'), ValueTY(230,'GEORGE'), ValueTY(231,'JACOBS'), ValueTY(232,'REID'), ValueTY(233,'KIM'), ValueTY(234,'FULLER'), ValueTY(235,'LYNCH'), ValueTY(236,'DEAN'), ValueTY(237,'GILBERT'), ValueTY(238,'GARRETT'), ValueTY(239,'ROMERO'), ValueTY(240,'WELCH'), ValueTY(241,'LARSON'), ValueTY(242,'FRAZIER'), ValueTY(243,'BURKE'), ValueTY(244,'HANSON'), ValueTY(245,'DAY'), ValueTY(246,'MENDOZA'), ValueTY(247,'MORENO'), ValueTY(248,'BOWMAN'), ValueTY(249,'MEDINA'), ValueTY(250,'FOWLER'), ValueTY(251,'BREWER'), ValueTY(252,'HOFFMAN'), ValueTY(253,'CARLSON'), ValueTY(254,'SILVA'), ValueTY(255,'PEARSON'), ValueTY(256,'HOLLAND'), ValueTY(257,'DOUGLAS'), ValueTY(258,'FLEMING'), ValueTY(259,'JENSEN'), ValueTY(260,'VARGAS'), ValueTY(261,'BYRD'), ValueTY(262,'DAVIDSON'), ValueTY(263,'HOPKINS'), ValueTY(264,'MAY'), ValueTY(265,'TERRY'), ValueTY(266,'HERRERA'), ValueTY(267,'WADE'), ValueTY(268,'SOTO'), ValueTY(269,'WALTERS'), ValueTY(270,'CURTIS'), ValueTY(271,'NEAL'), ValueTY(272,'CALDWELL'), ValueTY(273,'LOWE'), ValueTY(274,'JENNINGS'), ValueTY(275,'BARNETT'), ValueTY(276,'GRAVES'), ValueTY(277,'JIMENEZ'), ValueTY(278,'HORTON'), ValueTY(279,'SHELTON'), ValueTY(280,'BARRETT'), ValueTY(281,'OBRIEN'), ValueTY(282,'CASTRO'), ValueTY(283,'SUTTON'), ValueTY(284,'GREGORY'), ValueTY(285,'MCKINNEY'), ValueTY(286,'LUCAS'), ValueTY(287,'MILES'), ValueTY(288,'CRAIG'), ValueTY(289,'RODRIQUEZ'), ValueTY(290,'CHAMBERS'), ValueTY(291,'HOLT'), ValueTY(292,'LAMBERT'), ValueTY(293,'FLETCHER'), ValueTY(294,'WATTS'), ValueTY(295,'BATES'), ValueTY(296,'HALE'), ValueTY(297,'RHODES'), ValueTY(298,'PENA'), ValueTY(299,'BECK'), ValueTY(300,'NEWMAN'), ValueTY(301,'HAYNES'), ValueTY(302,'MCDANIEL'), ValueTY(303,'MENDEZ'), ValueTY(304,'BUSH'), ValueTY(305,'VAUGHN'), ValueTY(306,'PARKS'), ValueTY(307,'DAWSON'), ValueTY(308,'SANTIAGO'), ValueTY(309,'NORRIS'), ValueTY(310,'HARDY'), ValueTY(311,'LOVE'), ValueTY(312,'STEELE'), ValueTY(313,'CURRY'), ValueTY(314,'POWERS'), ValueTY(315,'SCHULTZ'), ValueTY(316,'BARKER'), ValueTY(317,'GUZMAN'), ValueTY(318,'PAGE'), ValueTY(319,'MUNOZ'), ValueTY(320,'BALL'), ValueTY(321,'KELLER'), ValueTY(322,'CHANDLER'), ValueTY(323,'WEBER'), ValueTY(324,'LEONARD'), ValueTY(325,'WALSH'), ValueTY(326,'LYONS'), ValueTY(327,'RAMSEY'), ValueTY(328,'WOLFE'), ValueTY(329,'SCHNEIDER'), ValueTY(330,'MULLINS'), ValueTY(331,'BENSON'), ValueTY(332,'SHARP'), ValueTY(333,'BOWEN'), ValueTY(334,'DANIEL'), ValueTY(335,'BARBER'), ValueTY(336,'CUMMINGS'), ValueTY(337,'HINES'), ValueTY(338,'BALDWIN'), ValueTY(339,'GRIFFITH'), ValueTY(340,'VALDEZ'), ValueTY(341,'HUBBARD'), ValueTY(342,'SALAZAR'), ValueTY(343,'REEVES'), ValueTY(344,'WARNER'), ValueTY(345,'STEVENSON'), ValueTY(346,'BURGESS'), ValueTY(347,'SANTOS'), ValueTY(348,'TATE'), ValueTY(349,'CROSS'), ValueTY(350,'GARNER'), ValueTY(351,'MANN'), ValueTY(352,'MACK'), ValueTY(353,'MOSS'), ValueTY(354,'THORNTON'), ValueTY(355,'DENNIS'), ValueTY(356,'MCGEE'), ValueTY(357,'FARMER'), ValueTY(358,'DELGADO'), ValueTY(359,'AGUILAR'), ValueTY(360,'VEGA'), ValueTY(361,'GLOVER'), ValueTY(362,'MANNING'), ValueTY(363,'COHEN'), ValueTY(364,'HARMON'), ValueTY(365,'RODGERS'), ValueTY(366,'ROBBINS'), ValueTY(367,'NEWTON'), ValueTY(368,'TODD'), ValueTY(369,'BLAIR'), ValueTY(370,'HIGGINS'), ValueTY(371,'INGRAM'), ValueTY(372,'REESE'), ValueTY(373,'CANNON'), ValueTY(374,'STRICKLAND'), ValueTY(375,'TOWNSEND'), ValueTY(376,'POTTER'), ValueTY(377,'GOODWIN'), ValueTY(378,'WALTON'), ValueTY(379,'ROWE'), ValueTY(380,'HAMPTON'), ValueTY(381,'ORTEGA'), ValueTY(382,'PATTON'), ValueTY(383,'SWANSON'), ValueTY(384,'JOSEPH'), ValueTY(385,'FRANCIS'), ValueTY(386,'GOODMAN'), ValueTY(387,'MALDONADO'), ValueTY(388,'YATES'), ValueTY(389,'BECKER'), ValueTY(390,'ERICKSON'), ValueTY(391,'HODGES'), ValueTY(392,'RIOS'), ValueTY(393,'CONNER'), ValueTY(394,'ADKINS'), ValueTY(395,'WEBSTER'), ValueTY(396,'NORMAN'), ValueTY(397,'MALONE'), ValueTY(398,'HAMMOND'), ValueTY(399,'FLOWERS'), ValueTY(400,'COBB'), ValueTY(401,'MOODY'), ValueTY(402,'QUINN'), ValueTY(403,'BLAKE'), ValueTY(404,'MAXWELL'), ValueTY(405,'POPE'), ValueTY(406,'FLOYD'), ValueTY(407,'OSBORNE'), ValueTY(408,'PAUL'), ValueTY(409,'MCCARTHY'), ValueTY(410,'GUERRERO'), ValueTY(411,'LidxSEY'), ValueTY(412,'ESTRADA'), ValueTY(413,'SANDOVAL'), ValueTY(414,'GIBBS'), ValueTY(415,'TYLER'), ValueTY(416,'GROSS'), ValueTY(417,'FITZGERALD'), ValueTY(418,'STOKES'), ValueTY(419,'DOYLE'), ValueTY(420,'SHERMAN'), ValueTY(421,'SAUNDERS'), ValueTY(422,'WISE'), ValueTY(423,'COLON'), ValueTY(424,'GILL'), ValueTY(425,'ALVARADO'), ValueTY(426,'GREER'), ValueTY(427,'PADILLA'), ValueTY(428,'SIMON'), ValueTY(429,'WATERS'), ValueTY(430,'NUNEZ'), ValueTY(431,'BALLARD'), ValueTY(432,'SCHWARTZ'), ValueTY(433,'MCBRIDE'), ValueTY(434,'HOUSTON'), ValueTY(435,'CHRISTENSEN'), ValueTY(436,'KLEIN'), ValueTY(437,'PRATT'), ValueTY(438,'BRIGGS'), ValueTY(439,'PARSONS'), ValueTY(440,'MCLAUGHLIN'), ValueTY(441,'ZIMMERMAN'), ValueTY(442,'FRENCH'), ValueTY(443,'BUCHANAN'), ValueTY(444,'MORAN'), ValueTY(445,'COPELAND'), ValueTY(446,'ROY'), ValueTY(447,'PITTMAN'), ValueTY(448,'BRADY'), ValueTY(449,'MCCORMICK'), ValueTY(450,'HOLLOWAY'), ValueTY(451,'BROCK'), ValueTY(452,'POOLE'), ValueTY(453,'FRANK'), ValueTY(454,'LOGAN'), ValueTY(455,'OWEN'), ValueTY(456,'BASS'), ValueTY(457,'MARSH'), ValueTY(458,'DRAKE'), ValueTY(459,'WONG'), ValueTY(460,'JEFFERSON'), ValueTY(461,'PARK'), ValueTY(462,'MORTON'), ValueTY(463,'ABBOTT'), ValueTY(464,'SPARKS'), ValueTY(465,'PATRICK'), ValueTY(466,'NORTON'), ValueTY(467,'HUFF'), ValueTY(468,'CLAYTON'), ValueTY(469,'MASSEY'), ValueTY(470,'LLOYD'), ValueTY(471,'FIGUEROA'), ValueTY(472,'CARSON'), ValueTY(473,'BOWERS'), ValueTY(474,'ROBERSON'), ValueTY(475,'BARTON'), ValueTY(476,'TRAN'), ValueTY(477,'LAMB'), ValueTY(478,'HARRINGTON'), ValueTY(479,'CASEY'), ValueTY(480,'BOONE'), ValueTY(481,'CORTEZ'), ValueTY(482,'CLARKE'), ValueTY(483,'MATHIS'), ValueTY(484,'SINGLETON'), ValueTY(485,'WILKINS'), ValueTY(486,'CAIN'), ValueTY(487,'BRYAN'), ValueTY(488,'UNDERWOOD'), ValueTY(489,'HOGAN'), ValueTY(490,'MCKENZIE'), ValueTY(491,'COLLIER'), ValueTY(492,'LUNA'), ValueTY(493,'PHELPS'), ValueTY(494,'MCGUIRE'), ValueTY(495,'ALLISON'), ValueTY(496,'BRIDGES'), ValueTY(497,'WILKERSON'), ValueTY(498,'NASH'), ValueTY(499,'SUMMERS'), ValueTY(500,'ATKINS'), ValueTY(501,'WILCOX'), ValueTY(502,'PITTS'), ValueTY(503,'CONLEY'), ValueTY(504,'MARQUEZ'), ValueTY(505,'BURNETT'), ValueTY(506,'RICHARD'), ValueTY(507,'COCHRAN'), ValueTY(508,'CHASE'), ValueTY(509,'DAVENPORT'), ValueTY(510,'HOOD'), ValueTY(511,'GATES'), ValueTY(512,'CLAY'), ValueTY(513,'AYALA'), ValueTY(514,'SAWYER'), ValueTY(515,'ROMAN'), ValueTY(516,'VAZQUEZ'), ValueTY(517,'DICKERSON'), ValueTY(518,'HODGE'), ValueTY(519,'ACOSTA'), ValueTY(520,'FLYNN'), ValueTY(521,'ESPINOZA'), ValueTY(522,'NICHOLSON'), ValueTY(523,'MONROE'), ValueTY(524,'WOLF'), ValueTY(525,'MORROW'), ValueTY(526,'KIRK'), ValueTY(527,'RANDALL'), ValueTY(528,'ANTHONY'), ValueTY(529,'WHITAKER'), ValueTY(530,'OCONNOR'), ValueTY(531,'SKINNER'), ValueTY(532,'WARE'), ValueTY(533,'MOLINA'), ValueTY(534,'KIRBY'), ValueTY(535,'HUFFMAN'), ValueTY(536,'BRADFORD'), ValueTY(537,'CHARLES'), ValueTY(538,'GILMORE'), ValueTY(539,'DOMINGUEZ'), ValueTY(540,'ONEAL'), ValueTY(541,'BRUCE'), ValueTY(542,'LANG'), ValueTY(543,'COMBS'), ValueTY(544,'KRAMER'), ValueTY(545,'HEATH'), ValueTY(546,'HANCOCK'), ValueTY(547,'GALLAGHER'), ValueTY(548,'GAINES'), ValueTY(549,'SHAFFER'), ValueTY(550,'SHORT'), ValueTY(551,'WIGGINS'), ValueTY(552,'MATHEWS'), ValueTY(553,'MCCLAIN'), ValueTY(554,'FISCHER'), ValueTY(555,'WALL'), ValueTY(556,'SMALL'), ValueTY(557,'MELTON'), ValueTY(558,'HENSLEY'), ValueTY(559,'BOND'), ValueTY(560,'DYER'), ValueTY(561,'CAMERON'), ValueTY(562,'GRIMES'), ValueTY(563,'CONTRERAS'), ValueTY(564,'CHRISTIAN'), ValueTY(565,'WYATT'), ValueTY(566,'BAXTER'), ValueTY(567,'SNOW'), ValueTY(568,'MOSLEY'), ValueTY(569,'SHEPHERD'), ValueTY(570,'LARSEN'), ValueTY(571,'HOOVER'), ValueTY(572,'BEASLEY'), ValueTY(573,'GLENN'), ValueTY(574,'PETERSEN'), ValueTY(575,'WHITEHEAD'), ValueTY(576,'MEYERS'), ValueTY(577,'KEITH'), ValueTY(578,'GARRISON'), ValueTY(579,'VINCENT'), ValueTY(580,'SHIELDS'), ValueTY(581,'HORN'), ValueTY(582,'SAVAGE'), ValueTY(583,'OLSEN'), ValueTY(584,'SCHROEDER'), ValueTY(585,'HARTMAN'), ValueTY(586,'WOODARD'), ValueTY(587,'MUELLER'), ValueTY(588,'KEMP'), ValueTY(589,'DELEON'), ValueTY(590,'BOOTH'), ValueTY(591,'PATEL'), ValueTY(592,'CALHOUN'), ValueTY(593,'WILEY'), ValueTY(594,'EATON'), ValueTY(595,'CLINE'), ValueTY(596,'NAVARRO'), ValueTY(597,'HARRELL'), ValueTY(598,'LESTER'), ValueTY(599,'HUMPHREY'), ValueTY(600,'PARRISH'), ValueTY(601,'DURAN'), ValueTY(602,'HUTCHINSON'), ValueTY(603,'HESS'), ValueTY(604,'DORSEY'), ValueTY(605,'BULLOCK'), ValueTY(606,'ROBLES'), ValueTY(607,'BEARD'), ValueTY(608,'DALTON'), ValueTY(609,'AVILA'), ValueTY(610,'VANCE'), ValueTY(611,'RICH'), ValueTY(612,'BLACKWELL'), ValueTY(613,'YORK'), ValueTY(614,'JOHNS'), ValueTY(615,'BLANKENSHIP'), ValueTY(616,'TREVINO'), ValueTY(617,'SALINAS'), ValueTY(618,'CAMPOS'), ValueTY(619,'PRUITT'), ValueTY(620,'MOSES'), ValueTY(621,'CALLAHAN'), ValueTY(622,'GOLDEN'), ValueTY(623,'MONTOYA'), ValueTY(624,'HARDIN'), ValueTY(625,'GUERRA'), ValueTY(626,'MCDOWELL'), ValueTY(627,'CAREY'), ValueTY(628,'STAFFORD'), ValueTY(629,'GALLEGOS'), ValueTY(630,'HENSON'), ValueTY(631,'WILKINSON'), ValueTY(632,'BOOKER'), ValueTY(633,'MERRITT'), ValueTY(634,'MIRANDA'), ValueTY(635,'ATKINSON'), ValueTY(636,'ORR'), ValueTY(637,'DECKER'), ValueTY(638,'HOBBS'), ValueTY(639,'PRESTON'), ValueTY(640,'TANNER'), ValueTY(641,'KNOX'), ValueTY(642,'PACHECO'), ValueTY(643,'STEPHENSON'), ValueTY(644,'GLASS'), ValueTY(645,'ROJAS'), ValueTY(646,'SERRANO'), ValueTY(647,'MARKS'), ValueTY(648,'HICKMAN'), ValueTY(649,'ENGLISH'), ValueTY(650,'SWEENEY'), ValueTY(651,'STRONG'), ValueTY(652,'PRINCE'), ValueTY(653,'MCCLURE'), ValueTY(654,'CONWAY'), ValueTY(655,'WALTER'), ValueTY(656,'ROTH'), ValueTY(657,'MAYNARD'), ValueTY(658,'FARRELL'), ValueTY(659,'LOWERY'), ValueTY(660,'HURST'), ValueTY(661,'NIXON'), ValueTY(662,'WEISS'), ValueTY(663,'TRUJILLO'), ValueTY(664,'ELLISON'), ValueTY(665,'SLOAN'), ValueTY(666,'JUAREZ'), ValueTY(667,'WINTERS'), ValueTY(668,'MCLEAN'), ValueTY(669,'RANDOLPH'), ValueTY(670,'LEON'), ValueTY(671,'BOYER'), ValueTY(672,'VILLARREAL'), ValueTY(673,'MCCALL'), ValueTY(674,'GENTRY'), ValueTY(675,'CARRILLO'), ValueTY(676,'KENT'), ValueTY(677,'AYERS'), ValueTY(678,'LARA'), ValueTY(679,'SHANNON'), ValueTY(680,'SEXTON'), ValueTY(681,'PACE'), ValueTY(682,'HULL'), ValueTY(683,'LEBLANC'), ValueTY(684,'BROWNING'), ValueTY(685,'VELASQUEZ'), ValueTY(686,'LEACH'), ValueTY(687,'CHANG'), ValueTY(688,'HOUSE'), ValueTY(689,'SELLERS'), ValueTY(690,'HERRING'), ValueTY(691,'NOBLE'), ValueTY(692,'FOLEY'), ValueTY(693,'BARTLETT'), ValueTY(694,'MERCADO'), ValueTY(695,'LANDRY'), ValueTY(696,'DURHAM'), ValueTY(697,'WALLS'), ValueTY(698,'BARR'), ValueTY(699,'MCKEE'), ValueTY(700,'BAUER'), ValueTY(701,'RIVERS'), ValueTY(702,'EVERETT'), ValueTY(703,'BRADSHAW'), ValueTY(704,'PUGH'), ValueTY(705,'VELEZ'), ValueTY(706,'RUSH'), ValueTY(707,'ESTES'), ValueTY(708,'DODSON'), ValueTY(709,'MORSE'), ValueTY(710,'SHEPPARD'), ValueTY(711,'WEEKS'), ValueTY(712,'CAMACHO'), ValueTY(713,'BEAN'), ValueTY(714,'BARRON'), ValueTY(715,'LIVINGSTON'), ValueTY(716,'MIDDLETON'), ValueTY(717,'SPEARS'), ValueTY(718,'BRANCH'), ValueTY(719,'BLEVINS'), ValueTY(720,'CHEN'), ValueTY(721,'KERR'), ValueTY(722,'MCCONNELL'), ValueTY(723,'HATFIELD'), ValueTY(724,'HARDING'), ValueTY(725,'ASHLEY'), ValueTY(726,'SOLIS'), ValueTY(727,'HERMAN'), ValueTY(728,'FROST'), ValueTY(729,'GILES'), ValueTY(730,'BLACKBURN'), ValueTY(731,'WILLIAM'), ValueTY(732,'PENNINGTON'), ValueTY(733,'WOODWARD'), ValueTY(734,'FINLEY'), ValueTY(735,'MCINTOSH'), ValueTY(736,'KOCH'), ValueTY(737,'BEST'), ValueTY(738,'SOLOMON'), ValueTY(739,'MCCULLOUGH'), ValueTY(740,'DUDLEY'), ValueTY(741,'NOLAN'), ValueTY(742,'BLANCHARD'), ValueTY(743,'RIVAS'), ValueTY(744,'BRENNAN'), ValueTY(745,'MEJIA'), ValueTY(746,'KANE'), ValueTY(747,'BENTON'), ValueTY(748,'JOYCE'), ValueTY(749,'BUCKLEY'), ValueTY(750,'HALEY'), ValueTY(751,'VALENTINE'), ValueTY(752,'MADDOX'), ValueTY(753,'RUSSO'), ValueTY(754,'MCKNIGHT'), ValueTY(755,'BUCK'), ValueTY(756,'MOON'), ValueTY(757,'MCMILLAN'), ValueTY(758,'CROSBY'), ValueTY(759,'BERG'), ValueTY(760,'DOTSON'), ValueTY(761,'MAYS'), ValueTY(762,'ROACH'), ValueTY(763,'CHURCH'), ValueTY(764,'CHAN'), ValueTY(765,'RICHMOND'), ValueTY(766,'MEADOWS'), ValueTY(767,'FAULKNER'), ValueTY(768,'ONEILL'), ValueTY(769,'KNAPP'), ValueTY(770,'KLINE'), ValueTY(771,'BARRY'), ValueTY(772,'OCHOA'), ValueTY(773,'JACOBSON'), ValueTY(774,'GAY'), ValueTY(775,'AVERY'), ValueTY(776,'HENDRICKS'), ValueTY(777,'HORNE'), ValueTY(778,'SHEPARD'), ValueTY(779,'HEBERT'), ValueTY(780,'CHERRY'), ValueTY(781,'CARDENAS'), ValueTY(782,'MCINTYRE'), ValueTY(783,'WHITNEY'), ValueTY(784,'WALLER'), ValueTY(785,'HOLMAN'), ValueTY(786,'DONALDSON'), ValueTY(787,'CANTU'), ValueTY(788,'TERRELL'), ValueTY(789,'MORIN'), ValueTY(790,'GILLESPIE'), ValueTY(791,'FUENTES'), ValueTY(792,'TILLMAN'), ValueTY(793,'SANFORD'), ValueTY(794,'BENTLEY'), ValueTY(795,'PECK'), ValueTY(796,'KEY'), ValueTY(797,'SALAS'), ValueTY(798,'ROLLINS'), ValueTY(799,'GAMBLE'), ValueTY(800,'DICKSON'), ValueTY(801,'BATTLE'), ValueTY(802,'SANTANA'), ValueTY(803,'CABRERA'), ValueTY(804,'CERVANTES'), ValueTY(805,'HOWE'), ValueTY(806,'HINTON'), ValueTY(807,'HURLEY'), ValueTY(808,'SPENCE'), ValueTY(809,'ZAMORA'), ValueTY(810,'YANG'), ValueTY(811,'MCNEIL'), ValueTY(812,'SUAREZ'), ValueTY(813,'CASE'), ValueTY(814,'PETTY'), ValueTY(815,'GOULD'), ValueTY(816,'MCFARLAND'), ValueTY(817,'SAMPSON'), ValueTY(818,'CARVER'), ValueTY(819,'BRAY'), ValueTY(820,'ROSARIO'), ValueTY(821,'MACDONALD'), ValueTY(822,'STOUT'), ValueTY(823,'HESTER'), ValueTY(824,'MELENDEZ'), ValueTY(825,'DILLON'), ValueTY(826,'FARLEY'), ValueTY(827,'HOPPER'), ValueTY(828,'GALLOWAY'), ValueTY(829,'POTTS'), ValueTY(830,'BERNARD'), ValueTY(831,'JOYNER'), ValueTY(832,'STEIN'), ValueTY(833,'AGUIRRE'), ValueTY(834,'OSBORN'), ValueTY(835,'MERCER'), ValueTY(836,'BENDER'), ValueTY(837,'FRANCO'), ValueTY(838,'ROWLAND'), ValueTY(839,'SYKES'), ValueTY(840,'BENJAMIN'), ValueTY(841,'TRAVIS'), ValueTY(842,'PICKETT'), ValueTY(843,'CRANE'), ValueTY(844,'SEARS'), ValueTY(845,'MAYO'), ValueTY(846,'DUNLAP'), ValueTY(847,'HAYDEN'), ValueTY(848,'WILDER'), ValueTY(849,'MCKAY'), ValueTY(850,'COFFEY'), ValueTY(851,'MCCARTY'), ValueTY(852,'EWING'), ValueTY(853,'COOLEY'), ValueTY(854,'VAUGHAN'), ValueTY(855,'BONNER'), ValueTY(856,'COTTON'), ValueTY(857,'HOLDER'), ValueTY(858,'STARK'), ValueTY(859,'FERRELL'), ValueTY(860,'CANTRELL'), ValueTY(861,'FULTON'), ValueTY(862,'LYNN'), ValueTY(863,'LOTT'), ValueTY(864,'CALDERON'), ValueTY(865,'ROSA'), ValueTY(866,'POLLARD'), ValueTY(867,'HOOPER'), ValueTY(868,'BURCH'), ValueTY(869,'MULLEN'), ValueTY(870,'FRY'), ValueTY(871,'RIDDLE'), ValueTY(872,'LEVY'), ValueTY(873,'DAVID'), ValueTY(874,'DUKE'), ValueTY(875,'ODONNELL'), ValueTY(876,'GUY'), ValueTY(877,'MICHAEL'), ValueTY(878,'BRITT'), ValueTY(879,'FREDERICK'), ValueTY(880,'DAUGHERTY'), ValueTY(881,'BERGER'), ValueTY(882,'DILLARD'), ValueTY(883,'ALSTON'), ValueTY(884,'JARVIS'), ValueTY(885,'FRYE'), ValueTY(886,'RIGGS'), ValueTY(887,'CHANEY'), ValueTY(888,'ODOM'), ValueTY(889,'DUFFY'), ValueTY(890,'FITZPATRICK'), ValueTY(891,'VALENZUELA'), ValueTY(892,'MERRILL'), ValueTY(893,'MAYER'), ValueTY(894,'ALFORD'), ValueTY(895,'MCPHERSON'), ValueTY(896,'ACEVEDO'), ValueTY(897,'DONOVAN'), ValueTY(898,'BARRERA'), ValueTY(899,'ALBERT'), ValueTY(900,'COTE'), ValueTY(901,'REILLY'), ValueTY(902,'COMPTON'), ValueTY(903,'RAYMOND'), ValueTY(904,'MOONEY'), ValueTY(905,'MCGOWAN'), ValueTY(906,'CRAFT'), ValueTY(907,'CLEVELAND'), ValueTY(908,'CLEMONS'), ValueTY(909,'WYNN'), ValueTY(910,'NIELSEN'), ValueTY(911,'BAIRD'), ValueTY(912,'STANTON'), ValueTY(913,'SNIDER'), ValueTY(914,'ROSALES'), ValueTY(915,'BRIGHT'), ValueTY(916,'WITT'), ValueTY(917,'STUART'), ValueTY(918,'HAYS'), ValueTY(919,'HOLDEN'), ValueTY(920,'RUTLEDGE'), ValueTY(921,'KINNEY'), ValueTY(922,'CLEMENTS'), ValueTY(923,'CASTANEDA'), ValueTY(924,'SLATER'), ValueTY(925,'HAHN'), ValueTY(926,'EMERSON'), ValueTY(927,'CONRAD'), ValueTY(928,'BURKS'), ValueTY(929,'DELANEY'), ValueTY(930,'PATE'), ValueTY(931,'LANCASTER'), ValueTY(932,'SWEET'), ValueTY(933,'JUSTICE'), ValueTY(934,'TYSON'), ValueTY(935,'SHARPE'), ValueTY(936,'WHITFIELD'), ValueTY(937,'TALLEY'), ValueTY(938,'MACIAS'), ValueTY(939,'IRWIN'), ValueTY(940,'BURRIS'), ValueTY(941,'RATLIFF'), ValueTY(942,'MCCRAY'), ValueTY(943,'MADDEN'), ValueTY(944,'KAUFMAN'), ValueTY(945,'BEACH'), ValueTY(946,'GOFF'), ValueTY(947,'CASH'), ValueTY(948,'BOLTON'), ValueTY(949,'MCFADDEN'), ValueTY(950,'LEVINE'), ValueTY(951,'GOOD'), ValueTY(952,'BYERS'), ValueTY(953,'KIRKLAND'), ValueTY(954,'KIDD'), ValueTY(955,'WORKMAN'), ValueTY(956,'CARNEY'), ValueTY(957,'DALE'), ValueTY(958,'MCLEOD'), ValueTY(959,'HOLCOMB'), ValueTY(960,'ENGLAND'), ValueTY(961,'FINCH'), ValueTY(962,'HEAD'), ValueTY(963,'BURT'), ValueTY(964,'HENDRIX'), ValueTY(965,'SOSA'), ValueTY(966,'HANEY'), ValueTY(967,'FRANKS'), ValueTY(968,'SARGENT'), ValueTY(969,'NIEVES'), ValueTY(970,'DOWNS'), ValueTY(971,'RASMUSSEN'), ValueTY(972,'BIRD'), ValueTY(973,'HEWITT'), ValueTY(974,'LidxSAY'), ValueTY(975,'LE'), ValueTY(976,'FOREMAN'), ValueTY(977,'VALENCIA'), ValueTY(978,'ONEIL'), ValueTY(979,'DELACRUZ'), ValueTY(980,'VINSON'), ValueTY(981,'DEJESUS'), ValueTY(982,'HYDE'), ValueTY(983,'FORBES'), ValueTY(984,'GILLIAM'), ValueTY(985,'GUTHRIE'), ValueTY(986,'WOOTEN'), ValueTY(987,'HUBER'), ValueTY(988,'BARLOW'), ValueTY(989,'BOYLE'), ValueTY(990,'MCMAHON'), ValueTY(991,'BUCKNER'), ValueTY(992,'ROCHA'), ValueTY(993,'PUCKETT'), ValueTY(994,'LANGLEY'), ValueTY(995,'KNOWLES'), ValueTY(996,'COOKE'), ValueTY(997,'VELAZQUEZ'), ValueTY(998,'WHITLEY'), ValueTY(999,'NOEL')));
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('countries', VocabularyValuesTY (ValueTY(1,'Afghanistan'), ValueTY(2, 'Albania'), ValueTY(3, 'Algeria'), ValueTY(4, 'America'), ValueTY(5, 'Andorra'), ValueTY(6, 'Angola'), ValueTY(7, 'Antigua'), ValueTY(8, 'Argentina'), ValueTY(9, 'Armenia'), ValueTY(10, 'Australia'), ValueTY(11, 'Austria'), ValueTY(12, 'Azerbaijan'), ValueTY(13, 'Bahamas'), ValueTY(14, 'Bahrain'), ValueTY(15, 'Bangladesh'), ValueTY(16, 'Barbados'), ValueTY(17, 'Belarus'), ValueTY(18, 'Belgium'), ValueTY(19, 'Belize'), ValueTY(20, 'Benin'), ValueTY(21, 'Bhutan'), ValueTY(22, 'Bissau'), ValueTY(23, 'Bolivia'), ValueTY(24, 'Bosnia'), ValueTY(25, 'Botswana'), ValueTY(26, 'Brazil'), ValueTY(27, 'British'), ValueTY(28, 'Brunei'), ValueTY(29, 'Bulgaria'), ValueTY(30, 'Burkina'), ValueTY(31, 'Burma'), ValueTY(32, 'Burundi'), ValueTY(33, 'Cambodia'), ValueTY(34, 'Cameroon'), ValueTY(35, 'Canada'), ValueTY(36, 'Cape Verde'), ValueTY(37, 'Central African Republic'), ValueTY(38, 'Chad'), ValueTY(39, 'Chile'), ValueTY(40, 'China'), ValueTY(41, 'Colombia'), ValueTY(42, 'Comoros'), ValueTY(43, 'Congo'), ValueTY(44, 'Costa Rica'), ValueTY(45, 'country debt'), ValueTY(46, 'Croatia'), ValueTY(47, 'Cuba'), ValueTY(48, 'Cyprus'), ValueTY(49, 'Czech'), ValueTY(50, 'Denmark'), ValueTY(51, 'Djibouti'), ValueTY(52, 'Dominica'), ValueTY(53, 'East Timor'), ValueTY(54, 'Ecuador'), ValueTY(55, 'Egypt'), ValueTY(56, 'El Salvador'), ValueTY(57, 'Emirate'), ValueTY(58, 'England'), ValueTY(59, 'Eritrea'), ValueTY(60, 'Estonia'), ValueTY(61, 'Ethiopia'), ValueTY(62, 'Fiji'), ValueTY(63, 'Finland'), ValueTY(64, 'France'), ValueTY(65, 'Gabon'), ValueTY(66, 'Gambia'), ValueTY(67, 'Georgia'), ValueTY(68, 'Germany'), ValueTY(69, 'Ghana'), ValueTY(70, 'Great Britain'), ValueTY(71, 'Greece'), ValueTY(72, 'Grenada'), ValueTY(73, 'Grenadines'), ValueTY(74, 'Guatemala'), ValueTY(75, 'Guinea'), ValueTY(76, 'Guyana'), ValueTY(77, 'Haiti'), ValueTY(78, 'Herzegovina'), ValueTY(79, 'Honduras'), ValueTY(80, 'Hungary'), ValueTY(81, 'Iceland'), ValueTY(82, 'in usa'), ValueTY(83, 'India'), ValueTY(84, 'Indonesia'), ValueTY(85, 'Iran'), ValueTY(86, 'Iraq'), ValueTY(87, 'Ireland'), ValueTY(88, 'Israel'), ValueTY(89, 'Italy'), ValueTY(90, 'Ivory Coast'), ValueTY(91, 'Jamaica'), ValueTY(92, 'Japan'), ValueTY(93, 'Jordan'), ValueTY(94, 'Kazakhstan'), ValueTY(95, 'Kenya'), ValueTY(96, 'Kiribati'), ValueTY(97, 'Korea'), ValueTY(98, 'Kosovo'), ValueTY(99, 'Kuwait'), ValueTY(100, 'Kyrgyzstan'), ValueTY(101, 'Laos'), ValueTY(102, 'Latvia'), ValueTY(103, 'Lebanon'), ValueTY(104, 'Lesotho'), ValueTY(105, 'Liberia'), ValueTY(106, 'Libya'), ValueTY(107, 'Liechtenstein'), ValueTY(108, 'Lithuania'), ValueTY(109, 'Luxembourg'), ValueTY(110, 'Macedonia'), ValueTY(111, 'Madagascar'), ValueTY(112, 'Malawi'), ValueTY(113, 'Malaysia'), ValueTY(114, 'Maldives'), ValueTY(115, 'Mali'), ValueTY(116, 'Malta'), ValueTY(117, 'Marshall'), ValueTY(118, 'Mauritania'), ValueTY(119, 'Mauritius'), ValueTY(120, 'Mexico'), ValueTY(121, 'Micronesia'), ValueTY(122, 'Moldova'), ValueTY(123, 'Monaco'), ValueTY(124, 'Mongolia'), ValueTY(125, 'Montenegro'), ValueTY(126, 'Morocco'), ValueTY(127, 'Mozambique'), ValueTY(128, 'Myanmar'), ValueTY(129, 'Namibia'), ValueTY(130, 'Nauru'), ValueTY(131, 'Nepal'), ValueTY(132, 'Netherlands'), ValueTY(133, 'New Zealand'), ValueTY(134, 'Nicaragua'), ValueTY(135, 'Niger'), ValueTY(136, 'Nigeria'), ValueTY(137, 'Norway'), ValueTY(138, 'Oman'), ValueTY(139, 'Pakistan'), ValueTY(140, 'Palau'), ValueTY(141, 'Panama'), ValueTY(142, 'Papua'), ValueTY(143, 'Paraguay'), ValueTY(144, 'Peru'), ValueTY(145, 'Philippines'), ValueTY(146, 'Poland'), ValueTY(147, 'Portugal'), ValueTY(148, 'Qatar'), ValueTY(149, 'Romania'), ValueTY(150, 'Russia'), ValueTY(151, 'Rwanda'), ValueTY(152, 'Samoa'), ValueTY(153, 'San Marino'), ValueTY(154, 'Sao Tome'), ValueTY(155, 'Saudi Arabia'), ValueTY(156, 'scotland'), ValueTY(157, 'scottish'), ValueTY(158, 'Senegal'), ValueTY(159, 'Serbia'), ValueTY(160, 'Seychelles'), ValueTY(161, 'Sierra Leone'), ValueTY(162, 'Singapore'), ValueTY(163, 'Slovakia'), ValueTY(164, 'Slovenia'), ValueTY(165, 'Solomon'), ValueTY(166, 'Somalia'), ValueTY(167, 'South Africa'), ValueTY(168, 'South Sudan'), ValueTY(169, 'Spain'), ValueTY(170, 'Sri Lanka'), ValueTY(171, 'St. Kitts'), ValueTY(172, 'St. Lucia'), ValueTY(173, 'St Kitts'), ValueTY(174, 'St Lucia'), ValueTY(175, 'Saint Kitts'), ValueTY(176, 'Santa Lucia'), ValueTY(177, 'Sudan'), ValueTY(178, 'Suriname'), ValueTY(179, 'Swaziland'), ValueTY(180, 'Sweden'), ValueTY(181, 'Switzerland'), ValueTY(182, 'Syria'), ValueTY(183, 'Taiwan'), ValueTY(184, 'Tajikistan'), ValueTY(185, 'Tanzania'), ValueTY(186, 'Thailand'), ValueTY(187, 'Tobago'), ValueTY(188, 'Togo'), ValueTY(189, 'Tonga'), ValueTY(190, 'Trinidad'), ValueTY(191, 'Tunisia'), ValueTY(192, 'Turkey'), ValueTY(193, 'Turkmenistan'), ValueTY(194, 'Tuvalu'), ValueTY(195, 'Uganda'), ValueTY(196, 'Ukraine'), ValueTY(197, 'United Kingdom'), ValueTY(198, 'United States'), ValueTY(199, 'Uruguay'), ValueTY(200, 'USA'), ValueTY(201, 'Uzbekistan'), ValueTY(202, 'Vanuatu'), ValueTY(203, 'Vatican'), ValueTY(204, 'Venezuela'), ValueTY(205, 'Vietnam'), ValueTY(206, 'wales'), ValueTY(207, 'welsh'), ValueTY(208, 'Yemen'), ValueTY(209, 'Zambia'), ValueTY(210, 'Zimbabwe'), ValueTY(211,'Afghanistan'), ValueTY(212, 'Albania'), ValueTY(213, 'Algeria'), ValueTY(214, 'America'), ValueTY(215, 'Andorra'), ValueTY(216, 'Angola'), ValueTY(217, 'Antigua'), ValueTY(218, 'Argentina'), ValueTY(219, 'Armenia'), ValueTY(220, 'Australia'), ValueTY(221, 'Austria'), ValueTY(222, 'Azerbaijan'), ValueTY(223, 'Bahamas'), ValueTY(224, 'Bahrain'), ValueTY(225, 'Bangladesh'), ValueTY(226, 'Barbados'), ValueTY(227, 'Belarus'), ValueTY(228, 'Belgium'), ValueTY(229, 'Belize'), ValueTY(230, 'Benin'), ValueTY(231, 'Bhutan'), ValueTY(232, 'Bissau'), ValueTY(233, 'Bolivia'), ValueTY(234, 'Bosnia'), ValueTY(235, 'Botswana'), ValueTY(236, 'Brazil'), ValueTY(237, 'British'), ValueTY(238, 'Brunei'), ValueTY(239, 'Bulgaria'), ValueTY(240, 'Burkina'), ValueTY(241, 'Burma'), ValueTY(242, 'Burundi'), ValueTY(243, 'Cambodia'), ValueTY(244, 'Cameroon'), ValueTY(245, 'Canada'), ValueTY(246, 'Cape Verde'), ValueTY(247, 'Central African Republic'), ValueTY(248, 'Chad'), ValueTY(249, 'Chile'), ValueTY(250, 'China'), ValueTY(251, 'Colombia'), ValueTY(252, 'Comoros'), ValueTY(253, 'Congo'), ValueTY(254, 'Costa Rica'), ValueTY(255, 'country debt'), ValueTY(256, 'Croatia'), ValueTY(257, 'Cuba'), ValueTY(258, 'Cyprus'), ValueTY(259, 'Czech'), ValueTY(260, 'Denmark'), ValueTY(261, 'Djibouti'), ValueTY(262, 'Dominica'), ValueTY(263, 'East Timor'), ValueTY(264, 'Ecuador'), ValueTY(265, 'Egypt'), ValueTY(266, 'El Salvador'), ValueTY(267, 'Emirate'), ValueTY(268, 'England'), ValueTY(269, 'Eritrea'), ValueTY(270, 'Estonia'), ValueTY(271, 'Ethiopia'), ValueTY(272, 'Fiji'), ValueTY(273, 'Finland'), ValueTY(274, 'France'), ValueTY(275, 'Gabon'), ValueTY(276, 'Gambia'), ValueTY(277, 'Georgia'), ValueTY(278, 'Germany'), ValueTY(279, 'Ghana'), ValueTY(280, 'Great Britain'), ValueTY(281, 'Greece'), ValueTY(282, 'Grenada'), ValueTY(283, 'Grenadines'), ValueTY(284, 'Guatemala'), ValueTY(285, 'Guinea'), ValueTY(286, 'Guyana'), ValueTY(287, 'Haiti'), ValueTY(288, 'Herzegovina'), ValueTY(289, 'Honduras'), ValueTY(290, 'Hungary'), ValueTY(291, 'Iceland'), ValueTY(292, 'in usa'), ValueTY(293, 'India'), ValueTY(294, 'Indonesia'), ValueTY(295, 'Iran'), ValueTY(296, 'Iraq'), ValueTY(297, 'Ireland'), ValueTY(298, 'Israel'), ValueTY(299, 'Italy'), ValueTY(300, 'Ivory Coast'), ValueTY(301, 'Jamaica'), ValueTY(302, 'Japan'), ValueTY(303, 'Jordan'), ValueTY(304, 'Kazakhstan'), ValueTY(305, 'Kenya'), ValueTY(306, 'Kiribati'), ValueTY(307, 'Korea'), ValueTY(308, 'Kosovo'), ValueTY(309, 'Kuwait'), ValueTY(310, 'Kyrgyzstan'), ValueTY(311, 'Laos'), ValueTY(312, 'Latvia'), ValueTY(313, 'Lebanon'), ValueTY(314, 'Lesotho'), ValueTY(315, 'Liberia'), ValueTY(316, 'Libya'), ValueTY(317, 'Liechtenstein'), ValueTY(318, 'Lithuania'), ValueTY(319, 'Luxembourg'), ValueTY(320, 'Macedonia'), ValueTY(321, 'Madagascar'), ValueTY(322, 'Malawi'), ValueTY(323, 'Malaysia'), ValueTY(324, 'Maldives'), ValueTY(325, 'Mali'), ValueTY(326, 'Malta'), ValueTY(327, 'Marshall'), ValueTY(328, 'Mauritania'), ValueTY(329, 'Mauritius'), ValueTY(330, 'Mexico'), ValueTY(331, 'Micronesia'), ValueTY(332, 'Moldova'), ValueTY(333, 'Monaco'), ValueTY(334, 'Mongolia'), ValueTY(335, 'Montenegro'), ValueTY(336, 'Morocco'), ValueTY(337, 'Mozambique'), ValueTY(338, 'Myanmar'), ValueTY(339, 'Namibia'), ValueTY(340, 'Nauru'), ValueTY(341, 'Nepal'), ValueTY(342, 'Netherlands'), ValueTY(343, 'New Zealand'), ValueTY(344, 'Nicaragua'), ValueTY(345, 'Niger'), ValueTY(346, 'Nigeria'), ValueTY(347, 'Norway'), ValueTY(348, 'Oman'), ValueTY(349, 'Pakistan'), ValueTY(350, 'Palau'), ValueTY(351, 'Panama'), ValueTY(352, 'Papua'), ValueTY(353, 'Paraguay'), ValueTY(354, 'Peru'), ValueTY(355, 'Philippines'), ValueTY(356, 'Poland'), ValueTY(357, 'Portugal'), ValueTY(358, 'Qatar'), ValueTY(359, 'Romania'), ValueTY(360, 'Russia'), ValueTY(361, 'Rwanda'), ValueTY(362, 'Samoa'), ValueTY(363, 'San Marino'), ValueTY(364, 'Sao Tome'), ValueTY(365, 'Saudi Arabia'), ValueTY(366, 'scotland'), ValueTY(367, 'scottish'), ValueTY(368, 'Senegal'), ValueTY(369, 'Serbia'), ValueTY(370, 'Seychelles'), ValueTY(371, 'Sierra Leone'), ValueTY(372, 'Singapore'), ValueTY(373, 'Slovakia'), ValueTY(374, 'Slovenia'), ValueTY(375, 'Solomon'), ValueTY(376, 'Somalia'), ValueTY(377, 'South Africa'), ValueTY(378, 'South Sudan'), ValueTY(379, 'Spain'), ValueTY(380, 'Sri Lanka'), ValueTY(381, 'St. Kitts'), ValueTY(382, 'St. Lucia'), ValueTY(383, 'St Kitts'), ValueTY(384, 'St Lucia'), ValueTY(385, 'Saint Kitts'), ValueTY(386, 'Santa Lucia'), ValueTY(387, 'Sudan'), ValueTY(388, 'Suriname'), ValueTY(389, 'Swaziland'), ValueTY(390, 'Sweden'), ValueTY(391, 'Switzerland'), ValueTY(392, 'Syria'), ValueTY(393, 'Taiwan'), ValueTY(394, 'Tajikistan'), ValueTY(395, 'Tanzania'), ValueTY(396, 'Thailand'), ValueTY(397, 'Tobago'), ValueTY(398, 'Togo'), ValueTY(399, 'Tonga'), ValueTY(400, 'Trinidad'), ValueTY(401, 'Tunisia'), ValueTY(402, 'Turkey'), ValueTY(403, 'Turkmenistan'), ValueTY(404, 'Tuvalu'), ValueTY(405, 'Uganda'), ValueTY(406, 'Ukraine'), ValueTY(407, 'United Kingdom'), ValueTY(408, 'United States'), ValueTY(409, 'Uruguay'), ValueTY(410, 'USA'), ValueTY(411, 'Uzbekistan'), ValueTY(412, 'Vanuatu'), ValueTY(413, 'Vatican'), ValueTY(414, 'Venezuela'), ValueTY(415, 'Vietnam'), ValueTY(416, 'wales'), ValueTY(417, 'welsh'), ValueTY(418, 'Yemen'), ValueTY(419, 'Zambia'), ValueTY(420, 'Zimbabwe'), ValueTY(421,'Afghanistan'), ValueTY(422, 'Albania'), ValueTY(423, 'Algeria'), ValueTY(424, 'America'), ValueTY(425, 'Andorra'), ValueTY(426, 'Angola'), ValueTY(427, 'Antigua'), ValueTY(428, 'Argentina'), ValueTY(429, 'Armenia'), ValueTY(430, 'Australia'), ValueTY(431, 'Austria'), ValueTY(432, 'Azerbaijan'), ValueTY(433, 'Bahamas'), ValueTY(434, 'Bahrain'), ValueTY(435, 'Bangladesh'), ValueTY(436, 'Barbados'), ValueTY(437, 'Belarus'), ValueTY(438, 'Belgium'), ValueTY(439, 'Belize'), ValueTY(440, 'Benin'), ValueTY(441, 'Bhutan'), ValueTY(442, 'Bissau'), ValueTY(443, 'Bolivia'), ValueTY(444, 'Bosnia'), ValueTY(445, 'Botswana'), ValueTY(446, 'Brazil'), ValueTY(447, 'British'), ValueTY(448, 'Brunei'), ValueTY(449, 'Bulgaria'), ValueTY(450, 'Burkina'), ValueTY(451, 'Burma'), ValueTY(452, 'Burundi'), ValueTY(453, 'Cambodia'), ValueTY(454, 'Cameroon'), ValueTY(455, 'Canada'), ValueTY(456, 'Cape Verde'), ValueTY(457, 'Central African Republic'), ValueTY(458, 'Chad'), ValueTY(459, 'Chile'), ValueTY(460, 'China'), ValueTY(461, 'Colombia'), ValueTY(462, 'Comoros'), ValueTY(463, 'Congo'), ValueTY(464, 'Costa Rica'), ValueTY(465, 'country debt'), ValueTY(466, 'Croatia'), ValueTY(467, 'Cuba'), ValueTY(468, 'Cyprus'), ValueTY(469, 'Czech'), ValueTY(470, 'Denmark'), ValueTY(471, 'Djibouti'), ValueTY(472, 'Dominica'), ValueTY(473, 'East Timor'), ValueTY(474, 'Ecuador'), ValueTY(475, 'Egypt'), ValueTY(476, 'El Salvador'), ValueTY(477, 'Emirate'), ValueTY(478, 'England'), ValueTY(479, 'Eritrea'), ValueTY(480, 'Estonia'), ValueTY(481, 'Ethiopia'), ValueTY(482, 'Fiji'), ValueTY(483, 'Finland'), ValueTY(484, 'France'), ValueTY(485, 'Gabon'), ValueTY(486, 'Gambia'), ValueTY(487, 'Georgia'), ValueTY(488, 'Germany'), ValueTY(489, 'Ghana'), ValueTY(490, 'Great Britain'), ValueTY(491, 'Greece'), ValueTY(492, 'Grenada'), ValueTY(493, 'Grenadines'), ValueTY(494, 'Guatemala'), ValueTY(495, 'Guinea'), ValueTY(496, 'Guyana'), ValueTY(497, 'Haiti'), ValueTY(498, 'Herzegovina'), ValueTY(499, 'Honduras'), ValueTY(500, 'Hungary'), ValueTY(501, 'Iceland'), ValueTY(502, 'in usa'), ValueTY(503, 'India'), ValueTY(504, 'Indonesia'), ValueTY(505, 'Iran'), ValueTY(506, 'Iraq'), ValueTY(507, 'Ireland'), ValueTY(508, 'Israel'), ValueTY(509, 'Italy'), ValueTY(510, 'Ivory Coast'), ValueTY(511, 'Jamaica'), ValueTY(512, 'Japan'), ValueTY(513, 'Jordan'), ValueTY(514, 'Kazakhstan'), ValueTY(515, 'Kenya'), ValueTY(516, 'Kiribati'), ValueTY(517, 'Korea'), ValueTY(518, 'Kosovo'), ValueTY(519, 'Kuwait'), ValueTY(520, 'Kyrgyzstan'), ValueTY(521, 'Laos'), ValueTY(522, 'Latvia'), ValueTY(523, 'Lebanon'), ValueTY(524, 'Lesotho'), ValueTY(525, 'Liberia'), ValueTY(526, 'Libya'), ValueTY(527, 'Liechtenstein'), ValueTY(528, 'Lithuania'), ValueTY(529, 'Luxembourg'), ValueTY(530, 'Macedonia'), ValueTY(531, 'Madagascar'), ValueTY(532, 'Malawi'), ValueTY(533, 'Malaysia'), ValueTY(534, 'Maldives'), ValueTY(535, 'Mali'), ValueTY(536, 'Malta'), ValueTY(537, 'Marshall'), ValueTY(538, 'Mauritania'), ValueTY(539, 'Mauritius'), ValueTY(540, 'Mexico'), ValueTY(541, 'Micronesia'), ValueTY(542, 'Moldova'), ValueTY(543, 'Monaco'), ValueTY(544, 'Mongolia'), ValueTY(545, 'Montenegro'), ValueTY(546, 'Morocco'), ValueTY(547, 'Mozambique'), ValueTY(548, 'Myanmar'), ValueTY(549, 'Namibia'), ValueTY(550, 'Nauru'), ValueTY(551, 'Nepal'), ValueTY(552, 'Netherlands'), ValueTY(553, 'New Zealand'), ValueTY(554, 'Nicaragua'), ValueTY(555, 'Niger'), ValueTY(556, 'Nigeria'), ValueTY(557, 'Norway'), ValueTY(558, 'Oman'), ValueTY(559, 'Pakistan'), ValueTY(560, 'Palau'), ValueTY(561, 'Panama'), ValueTY(562, 'Papua'), ValueTY(563, 'Paraguay'), ValueTY(564, 'Peru'), ValueTY(565, 'Philippines'), ValueTY(566, 'Poland'), ValueTY(567, 'Portugal'), ValueTY(568, 'Qatar'), ValueTY(569, 'Romania'), ValueTY(570, 'Russia'), ValueTY(571, 'Rwanda'), ValueTY(572, 'Samoa'), ValueTY(573, 'San Marino'), ValueTY(574, 'Sao Tome'), ValueTY(575, 'Saudi Arabia'), ValueTY(576, 'scotland'), ValueTY(577, 'scottish'), ValueTY(578, 'Senegal'), ValueTY(579, 'Serbia'), ValueTY(580, 'Seychelles'), ValueTY(581, 'Sierra Leone'), ValueTY(582, 'Singapore'), ValueTY(583, 'Slovakia'), ValueTY(584, 'Slovenia'), ValueTY(585, 'Solomon'), ValueTY(586, 'Somalia'), ValueTY(587, 'South Africa'), ValueTY(588, 'South Sudan'), ValueTY(589, 'Spain'), ValueTY(590, 'Sri Lanka'), ValueTY(591, 'St. Kitts'), ValueTY(592, 'St. Lucia'), ValueTY(593, 'St Kitts'), ValueTY(594, 'St Lucia'), ValueTY(595, 'Saint Kitts'), ValueTY(596, 'Santa Lucia'), ValueTY(597, 'Sudan'), ValueTY(598, 'Suriname'), ValueTY(599, 'Swaziland'), ValueTY(600, 'Sweden'), ValueTY(601, 'Switzerland'), ValueTY(602, 'Syria'), ValueTY(603, 'Taiwan'), ValueTY(604, 'Tajikistan'), ValueTY(605, 'Tanzania'), ValueTY(606, 'Thailand'), ValueTY(607, 'Tobago'), ValueTY(608, 'Togo'), ValueTY(609, 'Tonga'), ValueTY(610, 'Trinidad'), ValueTY(611, 'Tunisia'), ValueTY(612, 'Turkey'), ValueTY(613, 'Turkmenistan'), ValueTY(614, 'Tuvalu'), ValueTY(615, 'Uganda'), ValueTY(616, 'Ukraine'), ValueTY(617, 'United Kingdom'), ValueTY(618, 'United States'), ValueTY(619, 'Uruguay'), ValueTY(620, 'USA'), ValueTY(621, 'Uzbekistan'), ValueTY(622, 'Vanuatu'), ValueTY(623, 'Vatican'), ValueTY(624, 'Venezuela'), ValueTY(625, 'Vietnam'), ValueTY(626, 'wales'), ValueTY(627, 'welsh'), ValueTY(628, 'Yemen'), ValueTY(629, 'Zambia'), ValueTY(630, 'Zimbabwe'), ValueTY(631,'Afghanistan'), ValueTY(632, 'Albania'), ValueTY(633, 'Algeria'), ValueTY(634, 'America'), ValueTY(635, 'Andorra'), ValueTY(636, 'Angola'), ValueTY(637, 'Antigua'), ValueTY(638, 'Argentina'), ValueTY(639, 'Armenia'), ValueTY(640, 'Australia'), ValueTY(641, 'Austria'), ValueTY(642, 'Azerbaijan'), ValueTY(643, 'Bahamas'), ValueTY(644, 'Bahrain'), ValueTY(645, 'Bangladesh'), ValueTY(646, 'Barbados'), ValueTY(647, 'Belarus'), ValueTY(648, 'Belgium'), ValueTY(649, 'Belize'), ValueTY(650, 'Benin'), ValueTY(651, 'Bhutan'), ValueTY(652, 'Bissau'), ValueTY(653, 'Bolivia'), ValueTY(654, 'Bosnia'), ValueTY(655, 'Botswana'), ValueTY(656, 'Brazil'), ValueTY(657, 'British'), ValueTY(658, 'Brunei'), ValueTY(659, 'Bulgaria'), ValueTY(660, 'Burkina'), ValueTY(661, 'Burma'), ValueTY(662, 'Burundi'), ValueTY(663, 'Cambodia'), ValueTY(664, 'Cameroon'), ValueTY(665, 'Canada'), ValueTY(666, 'Cape Verde'), ValueTY(667, 'Central African Republic'), ValueTY(668, 'Chad'), ValueTY(669, 'Chile'), ValueTY(670, 'China'), ValueTY(671, 'Colombia'), ValueTY(672, 'Comoros'), ValueTY(673, 'Congo'), ValueTY(674, 'Costa Rica'), ValueTY(675, 'country debt'), ValueTY(676, 'Croatia'), ValueTY(677, 'Cuba'), ValueTY(678, 'Cyprus'), ValueTY(679, 'Czech'), ValueTY(680, 'Denmark'), ValueTY(681, 'Djibouti'), ValueTY(682, 'Dominica'), ValueTY(683, 'East Timor'), ValueTY(684, 'Ecuador'), ValueTY(685, 'Egypt'), ValueTY(686, 'El Salvador'), ValueTY(687, 'Emirate'), ValueTY(688, 'England'), ValueTY(689, 'Eritrea'), ValueTY(690, 'Estonia'), ValueTY(691, 'Ethiopia'), ValueTY(692, 'Fiji'), ValueTY(693, 'Finland'), ValueTY(694, 'France'), ValueTY(695, 'Gabon'), ValueTY(696, 'Gambia'), ValueTY(697, 'Georgia'), ValueTY(698, 'Germany'), ValueTY(699, 'Ghana'), ValueTY(700, 'Great Britain'), ValueTY(701, 'Greece'), ValueTY(702, 'Grenada'), ValueTY(703, 'Grenadines'), ValueTY(704, 'Guatemala'), ValueTY(705, 'Guinea'), ValueTY(706, 'Guyana'), ValueTY(707, 'Haiti'), ValueTY(708, 'Herzegovina'), ValueTY(709, 'Honduras'), ValueTY(710, 'Hungary'), ValueTY(711, 'Iceland'), ValueTY(712, 'in usa'), ValueTY(713, 'India'), ValueTY(714, 'Indonesia'), ValueTY(715, 'Iran'), ValueTY(716, 'Iraq'), ValueTY(717, 'Ireland'), ValueTY(718, 'Israel'), ValueTY(719, 'Italy'), ValueTY(720, 'Ivory Coast'), ValueTY(721, 'Jamaica'), ValueTY(722, 'Japan'), ValueTY(723, 'Jordan'), ValueTY(724, 'Kazakhstan'), ValueTY(725, 'Kenya'), ValueTY(726, 'Kiribati'), ValueTY(727, 'Korea'), ValueTY(728, 'Kosovo'), ValueTY(729, 'Kuwait'), ValueTY(730, 'Kyrgyzstan'), ValueTY(731, 'Laos'), ValueTY(732, 'Latvia'), ValueTY(733, 'Lebanon'), ValueTY(734, 'Lesotho'), ValueTY(735, 'Liberia'), ValueTY(736, 'Libya'), ValueTY(737, 'Liechtenstein'), ValueTY(738, 'Lithuania'), ValueTY(739, 'Luxembourg'), ValueTY(740, 'Macedonia'), ValueTY(741, 'Madagascar'), ValueTY(742, 'Malawi'), ValueTY(743, 'Malaysia'), ValueTY(744, 'Maldives'), ValueTY(745, 'Mali'), ValueTY(746, 'Malta'), ValueTY(747, 'Marshall'), ValueTY(748, 'Mauritania'), ValueTY(749, 'Mauritius'), ValueTY(750, 'Mexico'), ValueTY(751, 'Micronesia'), ValueTY(752, 'Moldova'), ValueTY(753, 'Monaco'), ValueTY(754, 'Mongolia'), ValueTY(755, 'Montenegro'), ValueTY(756, 'Morocco'), ValueTY(757, 'Mozambique'), ValueTY(758, 'Myanmar'), ValueTY(759, 'Namibia'), ValueTY(760, 'Nauru'), ValueTY(761, 'Nepal'), ValueTY(762, 'Netherlands'), ValueTY(763, 'New Zealand'), ValueTY(764, 'Nicaragua'), ValueTY(765, 'Niger'), ValueTY(766, 'Nigeria'), ValueTY(767, 'Norway'), ValueTY(768, 'Oman'), ValueTY(769, 'Pakistan'), ValueTY(770, 'Palau'), ValueTY(771, 'Panama'), ValueTY(772, 'Papua'), ValueTY(773, 'Paraguay'), ValueTY(774, 'Peru'), ValueTY(775, 'Philippines'), ValueTY(776, 'Poland'), ValueTY(777, 'Portugal'), ValueTY(778, 'Qatar'), ValueTY(779, 'Romania'), ValueTY(780, 'Russia'), ValueTY(781, 'Rwanda'), ValueTY(782, 'Samoa'), ValueTY(783, 'San Marino'), ValueTY(784, 'Sao Tome'), ValueTY(785, 'Saudi Arabia'), ValueTY(786, 'scotland'), ValueTY(787, 'scottish'), ValueTY(788, 'Senegal'), ValueTY(789, 'Serbia'), ValueTY(790, 'Seychelles'), ValueTY(791, 'Sierra Leone'), ValueTY(792, 'Singapore'), ValueTY(793, 'Slovakia'), ValueTY(794, 'Slovenia'), ValueTY(795, 'Solomon'), ValueTY(796, 'Somalia'), ValueTY(797, 'South Africa'), ValueTY(798, 'South Sudan'), ValueTY(799, 'Spain'), ValueTY(800, 'Sri Lanka'), ValueTY(801, 'St. Kitts'), ValueTY(802, 'St. Lucia'), ValueTY(803, 'St Kitts'), ValueTY(804, 'St Lucia'), ValueTY(805, 'Saint Kitts'), ValueTY(806, 'Santa Lucia'), ValueTY(807, 'Sudan'), ValueTY(808, 'Suriname'), ValueTY(809, 'Swaziland'), ValueTY(810, 'Sweden'), ValueTY(811, 'Switzerland'), ValueTY(812, 'Syria'), ValueTY(813, 'Taiwan'), ValueTY(814, 'Tajikistan'), ValueTY(815, 'Tanzania'), ValueTY(816, 'Thailand'), ValueTY(817, 'Tobago'), ValueTY(818, 'Togo'), ValueTY(819, 'Tonga'), ValueTY(820, 'Trinidad'), ValueTY(821, 'Tunisia'), ValueTY(822, 'Turkey'), ValueTY(823, 'Turkmenistan'), ValueTY(824, 'Tuvalu'), ValueTY(825, 'Uganda'), ValueTY(826, 'Ukraine'), ValueTY(827, 'United Kingdom'), ValueTY(828, 'United States'), ValueTY(829, 'Uruguay'), ValueTY(830, 'USA'), ValueTY(831, 'Uzbekistan'), ValueTY(832, 'Vanuatu'), ValueTY(833, 'Vatican'), ValueTY(834, 'Venezuela'), ValueTY(835, 'Vietnam'), ValueTY(836, 'wales'), ValueTY(837, 'welsh'), ValueTY(838, 'Yemen'), ValueTY(839, 'Zambia'), ValueTY(840, 'Zimbabwe'), ValueTY(841,'Afghanistan'), ValueTY(842, 'Albania'), ValueTY(843, 'Algeria'), ValueTY(844, 'America'), ValueTY(845, 'Andorra'), ValueTY(846, 'Angola'), ValueTY(847, 'Antigua'), ValueTY(848, 'Argentina'), ValueTY(849, 'Armenia'), ValueTY(850, 'Australia'), ValueTY(851, 'Austria'), ValueTY(852, 'Azerbaijan'), ValueTY(853, 'Bahamas'), ValueTY(854, 'Bahrain'), ValueTY(855, 'Bangladesh'), ValueTY(856, 'Barbados'), ValueTY(857, 'Belarus'), ValueTY(858, 'Belgium'), ValueTY(859, 'Belize'), ValueTY(860, 'Benin'), ValueTY(861, 'Bhutan'), ValueTY(862, 'Bissau'), ValueTY(863, 'Bolivia'), ValueTY(864, 'Bosnia'), ValueTY(865, 'Botswana'), ValueTY(866, 'Brazil'), ValueTY(867, 'British'), ValueTY(868, 'Brunei'), ValueTY(869, 'Bulgaria'), ValueTY(870, 'Burkina'), ValueTY(871, 'Burma'), ValueTY(872, 'Burundi'), ValueTY(873, 'Cambodia'), ValueTY(874, 'Cameroon'), ValueTY(875, 'Canada'), ValueTY(876, 'Cape Verde'), ValueTY(877, 'Central African Republic'), ValueTY(878, 'Chad'), ValueTY(879, 'Chile'), ValueTY(880, 'China'), ValueTY(881, 'Colombia'), ValueTY(882, 'Comoros'), ValueTY(883, 'Congo'), ValueTY(884, 'Costa Rica'), ValueTY(885, 'country debt'), ValueTY(886, 'Croatia'), ValueTY(887, 'Cuba'), ValueTY(888, 'Cyprus'), ValueTY(889, 'Czech'), ValueTY(890, 'Denmark'), ValueTY(891, 'Djibouti'), ValueTY(892, 'Dominica'), ValueTY(893, 'East Timor'), ValueTY(894, 'Ecuador'), ValueTY(895, 'Egypt'), ValueTY(896, 'El Salvador'), ValueTY(897, 'Emirate'), ValueTY(898, 'England'), ValueTY(899, 'Eritrea'), ValueTY(900, 'Estonia'), ValueTY(901, 'Ethiopia'), ValueTY(902, 'Fiji'), ValueTY(903, 'Finland'), ValueTY(904, 'France'), ValueTY(905, 'Gabon'), ValueTY(906, 'Gambia'), ValueTY(907, 'Georgia'), ValueTY(908, 'Germany'), ValueTY(909, 'Ghana'), ValueTY(910, 'Great Britain'), ValueTY(911, 'Greece'), ValueTY(912, 'Grenada'), ValueTY(913, 'Grenadines'), ValueTY(914, 'Guatemala'), ValueTY(915, 'Guinea'), ValueTY(916, 'Guyana'), ValueTY(917, 'Haiti'), ValueTY(918, 'Herzegovina'), ValueTY(919, 'Honduras'), ValueTY(920, 'Hungary'), ValueTY(921, 'Iceland'), ValueTY(922, 'in usa'), ValueTY(923, 'India'), ValueTY(924, 'Indonesia'), ValueTY(925, 'Iran'), ValueTY(926, 'Iraq'), ValueTY(927, 'Ireland'), ValueTY(928, 'Israel'), ValueTY(929, 'Italy'), ValueTY(930, 'Ivory Coast'), ValueTY(931, 'Jamaica'), ValueTY(932, 'Japan'), ValueTY(933, 'Jordan'), ValueTY(934, 'Kazakhstan'), ValueTY(935, 'Kenya'), ValueTY(936, 'Kiribati'), ValueTY(937, 'Korea'), ValueTY(938, 'Kosovo'), ValueTY(939, 'Kuwait'), ValueTY(940, 'Kyrgyzstan'), ValueTY(941, 'Laos'), ValueTY(942, 'Latvia'), ValueTY(943, 'Lebanon'), ValueTY(944, 'Lesotho'), ValueTY(945, 'Liberia'), ValueTY(946, 'Libya'), ValueTY(947, 'Liechtenstein'), ValueTY(948, 'Lithuania'), ValueTY(949, 'Luxembourg'), ValueTY(950, 'Macedonia'), ValueTY(951, 'Madagascar'), ValueTY(952, 'Malawi'), ValueTY(953, 'Malaysia'), ValueTY(954, 'Maldives'), ValueTY(955, 'Mali'), ValueTY(956, 'Malta'), ValueTY(957, 'Marshall'), ValueTY(958, 'Mauritania'), ValueTY(959, 'Mauritius'), ValueTY(960, 'Mexico'), ValueTY(961, 'Micronesia'), ValueTY(962, 'Moldova'), ValueTY(963, 'Monaco'), ValueTY(964, 'Mongolia'), ValueTY(965, 'Montenegro'), ValueTY(966, 'Morocco'), ValueTY(967, 'Mozambique'), ValueTY(968, 'Myanmar'), ValueTY(969, 'Namibia'), ValueTY(970, 'Nauru'), ValueTY(971, 'Nepal'), ValueTY(972, 'Netherlands'), ValueTY(973, 'New Zealand'), ValueTY(974, 'Nicaragua'), ValueTY(975, 'Niger'), ValueTY(976, 'Nigeria'), ValueTY(977, 'Norway'), ValueTY(978, 'Oman'), ValueTY(979, 'Pakistan'), ValueTY(980, 'Palau'), ValueTY(981, 'Panama'), ValueTY(982, 'Papua'), ValueTY(983, 'Paraguay'), ValueTY(984, 'Peru'), ValueTY(985, 'Philippines'), ValueTY(986, 'Poland'), ValueTY(987, 'Portugal'), ValueTY(988, 'Qatar'), ValueTY(989, 'Romania'), ValueTY(990, 'Russia'), ValueTY(991, 'Rwanda'), ValueTY(992, 'Samoa'), ValueTY(993, 'San Marino'), ValueTY(994, 'Sao Tome'), ValueTY(995, 'Saudi Arabia'), ValueTY(996, 'scotland'), ValueTY(997, 'scottish'), ValueTY(998, 'Senegal'), ValueTY(999, 'Serbia')));
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('streets',   VocabularyValuesTY (ValueTY(1,'Adams'), ValueTY(2, 'Air Cargo'), ValueTY(3, 'Alaska'), ValueTY(4, 'Alaska Service'), ValueTY(5, 'Alder'), ValueTY(6, 'Alderdale'), ValueTY(7, 'Alderwood Mall'), ValueTY(8, 'Alexander'), ValueTY(9, 'Algonquin'), ValueTY(10, 'Aloha'), ValueTY(11, 'Alvord'), ValueTY(12, 'Ames'), ValueTY(13, 'Andover'), ValueTY(14, 'Appleton'), ValueTY(15, 'Armour'), ValueTY(16, 'Armstrong'), ValueTY(17, 'Atlas'), ValueTY(18, 'Avalon'), ValueTY(19, 'Avondale'), ValueTY(20, 'Baker'), ValueTY(21, 'Balder'), ValueTY(22, 'Baldwin'), ValueTY(23, 'Barker'), ValueTY(24, 'Bartlett'), ValueTY(25, 'Battery'), ValueTY(26, 'Bay'), ValueTY(27, 'Bayview'), ValueTY(28, 'Beach'), ValueTY(29, 'Bear Creek'), ValueTY(30, 'Beardslee'), ValueTY(31, 'Beck'), ValueTY(32, 'Beech'), ValueTY(33, 'Bel Red'), ValueTY(34, 'Belfair'), ValueTY(35, 'Bell'), ValueTY(36, 'Bella Coola'), ValueTY(37, 'Bellefield Park'), ValueTY(38, 'Bellevue Redmond'), ValueTY(39, 'Bellflower'), ValueTY(40, 'Ben Howard'), ValueTY(41, 'Benson'), ValueTY(42, 'Benton'), ValueTY(43, 'Berry'), ValueTY(44, 'Bing'), ValueTY(45, 'Birch'), ValueTY(46, 'Bjune'), ValueTY(47, 'Blackford'), ValueTY(48, 'Blaine'), ValueTY(49, 'Blanchard'), ValueTY(50, 'Blanche'), ValueTY(51, 'Blomskog'), ValueTY(52, 'Blue Ridge'), ValueTY(53, 'Boeing Access'), ValueTY(54, 'Bogny'), ValueTY(55, 'Bonney'), ValueTY(56, 'Bonnie Brook'), ValueTY(57, 'Boren'), ValueTY(58, 'Bostian'), ValueTY(59, 'Boston'), ValueTY(60, 'Boundary'), ValueTY(61, 'Braemar'), ValueTY(62, 'Brew'), ValueTY(63, 'Brien'), ValueTY(64, 'Brier'), ValueTY(65, 'Broad'), ValueTY(66, 'Broadway'), ValueTY(67, 'Brook'), ValueTY(68, 'Brook Bay'), ValueTY(69, 'Brookmere'), ValueTY(70, 'Broomgerrie'), ValueTY(71, 'Brown'), ValueTY(72, 'Brygger'), ValueTY(73, 'Butterworth'), ValueTY(74, 'Cadman Quarry'), ValueTY(75, 'Cafe On The'), ValueTY(76, 'Cafe on the'), ValueTY(77, 'Canal'), ValueTY(78, 'Canyon'), ValueTY(79, 'Carmichael'), ValueTY(80, 'Carol'), ValueTY(81, 'Carter'), ValueTY(82, 'Cary'), ValueTY(83, 'Cascade'), ValueTY(84, 'Caspers'), ValueTY(85, 'Castle'), ValueTY(86, 'Cedar'), ValueTY(87, 'Cedar Crest'), ValueTY(88, 'Cedar Falls'), ValueTY(89, 'Cedar River Park'), ValueTY(90, 'Cedar River Pipeline'), ValueTY(91, 'Cedar Valley'), ValueTY(92, 'Cedars East'), ValueTY(93, 'Chelan'), ValueTY(94, 'Cherry'), ValueTY(95, 'Cherry Valley'), ValueTY(96, 'Chism Park'), ValueTY(97, 'Christensen'), ValueTY(98, 'Circle'), ValueTY(99, 'Clallam'), ValueTY(100, 'Clark'), ValueTY(101, 'Clay'), ValueTY(102, 'Clay Pit'), ValueTY(103, 'Cleveland'), ValueTY(104, 'Clover'), ValueTY(105, 'Club House'), ValueTY(106, 'Clyde'), ValueTY(107, 'Coal Creek'), ValueTY(108, 'Cocker Creek'), ValueTY(109, 'Coho'), ValueTY(110, 'Cole'), ValueTY(111, 'Colonial'), ValueTY(112, 'Colorado'), ValueTY(113, 'Columbia'), ValueTY(114, 'Comstock'), ValueTY(115, 'Cooper'), ValueTY(116, 'Cowlitz'), ValueTY(117, 'Crawford'), ValueTY(118, 'Cremona'), ValueTY(119, 'Crescent Lake'), ValueTY(120, 'Crockett'), ValueTY(121, 'Crystal Lake'), ValueTY(122, 'Daley'), ValueTY(123, 'Damson'), ValueTY(124, 'Dawn'), ValueTY(125, 'Dawson'), ValueTY(126, 'Deerford'), ValueTY(127, 'Dellwood'), ValueTY(128, 'Des Moines Memorial'), ValueTY(129, 'Detwiller'), ValueTY(130, 'Dexter'), ValueTY(131, 'Dike'), ValueTY(132, 'Ditch'), ValueTY(133, 'Dock'), ValueTY(134, 'Dogwood'), ValueTY(135, 'Donlan'), ValueTY(136, 'Douglas'), ValueTY(137, 'Downes'), ValueTY(138, 'Dravus'), ValueTY(139, 'Driftwood'), ValueTY(140, 'Duchess'), ValueTY(141, 'Dugway'), ValueTY(142, 'Durbin'), ValueTY(143, 'E Martin'), ValueTY(144, 'Eagle'), ValueTY(145, 'Eagle Harbor'), ValueTY(146, 'Eason'), ValueTY(147, 'East'), ValueTY(148, 'East Alder'), ValueTY(149, 'East Allison'), ValueTY(150, 'East Aloha'), ValueTY(151, 'East Bagwell'), ValueTY(152, 'East Bird'), ValueTY(153, 'East Blaine'), ValueTY(154, 'East Boston'), ValueTY(155, 'East Calhoun'), ValueTY(156, 'East Cherry'), ValueTY(157, 'East Columbia'), ValueTY(158, 'East Commercial'), ValueTY(159, 'East Crescent'), ValueTY(160, 'East Crockett'), ValueTY(161, 'East Echo Lake'), ValueTY(162, 'East Edgar'), ValueTY(163, 'East Eugene'), ValueTY(164, 'East Fir'), ValueTY(165, 'East Foster Island'), ValueTY(166, 'East Galer'), ValueTY(167, 'East Garfield'), ValueTY(168, 'East George'), ValueTY(169, 'East Glen'), ValueTY(170, 'East Gowe'), ValueTY(171, 'East Greystone'), ValueTY(172, 'East Hamlin'), ValueTY(173, 'East Harrison'), ValueTY(174, 'East Helen'), ValueTY(175, 'East High'), ValueTY(176, 'East Highland'), ValueTY(177, 'East Howe'), ValueTY(178, 'East Howell'), ValueTY(179, 'East Huron'), ValueTY(180, 'East Interlaken'), ValueTY(181, 'East Interurban'), ValueTY(182, 'East James'), ValueTY(183, 'East Jefferson'), ValueTY(184, 'East John'), ValueTY(185, 'East Jonathan'), ValueTY(186, 'East Lake Kayak'), ValueTY(187, 'East Lake Washington'), ValueTY(188, 'East Lee'), ValueTY(189, 'East Lost Lake'), ValueTY(190, 'East Louisa'), ValueTY(191, 'East Lousia'), ValueTY(192, 'East Lynn'), ValueTY(193, 'East Madison'), ValueTY(194, 'East Main'), ValueTY(195, 'East Marion'), ValueTY(196, 'East Mc Gilvra'), ValueTY(197, 'East Mc Graw'), ValueTY(198, 'East Meeker'), ValueTY(199, 'East Mercer'), ValueTY(200, 'East Mercer Highland'), ValueTY(201, 'East Miller'), ValueTY(202, 'East Morrison'), ValueTY(203, 'East Newton'), ValueTY(204, 'East North'), ValueTY(205, 'East Novak'), ValueTY(206, 'East Olive'), ValueTY(207, 'East Pike'), ValueTY(208, 'East Pine'), ValueTY(209, 'East Prospect'), ValueTY(210, 'East Reitze'), ValueTY(211, 'East Republican'), ValueTY(212, 'East Riverside'), ValueTY(213, 'East Roanoke'), ValueTY(214, 'East Roy'), ValueTY(215, 'East Rutherford'), ValueTY(216, 'East Seneca'), ValueTY(217, 'East Shore'), ValueTY(218, 'East Shorewood'), ValueTY(219, 'East Smith'), ValueTY(220, 'East Spring'), ValueTY(221, 'East Spruce'), ValueTY(222, 'East Superior'), ValueTY(223, 'East Tacoma'), ValueTY(224, 'East Temperance'), ValueTY(225, 'East Terrace'), ValueTY(226, 'East Thomas'), ValueTY(227, 'East Titus'), ValueTY(228, 'East Union'), ValueTY(229, 'East Valley'), ValueTY(230, 'East Ward'), ValueTY(231, 'Eastlake'), ValueTY(232, 'Eden'), ValueTY(233, 'Edmonds'), ValueTY(234, 'Edwards'), ValueTY(235, 'El Dorado Beach Club'), ValueTY(236, 'Elberta'), ValueTY(237, 'Eldorado'), ValueTY(238, 'Elephant'), ValueTY(239, 'Elliott'), ValueTY(240, 'Elm'), ValueTY(241, 'Emerald Hills'), ValueTY(242, 'Enatai'), ValueTY(243, 'Entwistle'), ValueTY(244, 'Erben'), ValueTY(245, 'Erie'), ValueTY(246, 'Etruria'), ValueTY(247, 'Euclid'), ValueTY(248, 'Evans Black'), ValueTY(249, 'Evergreen'), ValueTY(250, 'Evergreen Point'), ValueTY(251, 'Faben'), ValueTY(252, 'Fairview'), ValueTY(253, 'Fairweather'), ValueTY(254, 'Fales'), ValueTY(255, 'Fern Hollow'), ValueTY(256, 'Fernbrook'), ValueTY(257, 'Ferncroft'), ValueTY(258, 'Fernridge'), ValueTY(259, 'Filbert'), ValueTY(260, 'Fir'), ValueTY(261, 'Firdale'), ValueTY(262, 'Firwood'), ValueTY(263, 'Florentia'), ValueTY(264, 'Forbes Creek'), ValueTY(265, 'Forest Dell'), ValueTY(266, 'Forsyth'), ValueTY(267, 'Fort'), ValueTY(268, 'Fortuna'), ValueTY(269, 'Freeman'), ValueTY(270, 'Friar Tuck'), ValueTY(271, 'Frontage'), ValueTY(272, 'Fullerton'), ValueTY(273, 'Fulton'), ValueTY(274, 'Galer'), ValueTY(275, 'Garfield'), ValueTY(276, 'Gateway'), ValueTY(277, 'George Washington'), ValueTY(278, 'Gilman'), ValueTY(279, 'Giltner'), ValueTY(280, 'Glen'), ValueTY(281, 'Glenhome'), ValueTY(282, 'Glenridge'), ValueTY(283, 'Grand'), ValueTY(284, 'Grand Ridge'), ValueTY(285, 'Grandview'), ValueTY(286, 'Grannis'), ValueTY(287, 'Grant'), ValueTY(288, 'Gravel'), ValueTY(289, 'Gravenstein'), ValueTY(290, 'Green Valley'), ValueTY(291, 'Greenbrier'), ValueTY(292, 'Greening'), ValueTY(293, 'Grimes'), ValueTY(294, 'Groat Point'), ValueTY(295, 'Hall'), ValueTY(296, 'Halladay'), ValueTY(297, 'Halverson'), ValueTY(298, 'Hamilton'), ValueTY(299, 'Hamlin Park'), ValueTY(300, 'Hampton'), ValueTY(301, 'Hanna Park'), ValueTY(302, 'Harrington'), ValueTY(303, 'Harrison'), ValueTY(304, 'Harvard'), ValueTY(305, 'Harvest'), ValueTY(306, 'Hayes'), ValueTY(307, 'Hazel'), ValueTY(308, 'Hedlund'), ValueTY(309, 'Hellen'), ValueTY(310, 'Hemlock'), ValueTY(311, 'High'), ValueTY(312, 'Highland'), ValueTY(313, 'Highland Park'), ValueTY(314, 'Highlands'), ValueTY(315, 'Highmoor'), ValueTY(316, 'Hildebrand'), ValueTY(317, 'Hillcrest'), ValueTY(318, 'Hillside'), ValueTY(319, 'Hilltop'), ValueTY(320, 'Hindley'), ValueTY(321, 'Hoeder'), ValueTY(322, 'Holly'), ValueTY(323, 'Holly Hill'), ValueTY(324, 'Homeland'), ValueTY(325, 'Homeview'), ValueTY(326, 'Horton'), ValueTY(327, 'Howe'), ValueTY(328, 'Howell'), ValueTY(329, 'Hubbard'), ValueTY(330, 'Huckleberry'), ValueTY(331, 'Humber'), ValueTY(332, 'Hunts Point'), ValueTY(333, 'Hurst'), ValueTY(334, 'Illinios'), ValueTY(335, 'Industry'), ValueTY(336, 'International'), ValueTY(337, 'Interurban'), ValueTY(338, 'Island'), ValueTY(339, 'Island Heights'), ValueTY(340, 'Issaquah Hobart'), ValueTY(341, 'James'), ValueTY(342, 'Jason'), ValueTY(343, 'Jefferson'), ValueTY(344, 'Jewell'), ValueTY(345, 'John'), ValueTY(346, 'John Bailey'), ValueTY(347, 'Jonathan'), ValueTY(348, 'Kansas'), ValueTY(349, 'Kayak Lake'), ValueTY(350, 'Kelsy Creek'), ValueTY(351, 'Kenosia'), ValueTY(352, 'Kensington'), ValueTY(353, 'Kentish'), ValueTY(354, 'Kerriston'), ValueTY(355, 'Kerry'), ValueTY(356, 'King'), ValueTY(357, 'Kings Lake'), ValueTY(358, 'Kirkland'), ValueTY(359, 'Kitsap'), ValueTY(360, 'Klickitat'), ValueTY(361, 'Klockstad'), ValueTY(362, 'Kotschevar'), ValueTY(363, 'Kulshan'), ValueTY(364, 'Lac Lehman'), ValueTY(365, 'Lake'), ValueTY(366, 'Lake Bellevue'), ValueTY(367, 'Lake Dell'), ValueTY(368, 'Lake Fontal'), ValueTY(369, 'Lake Hills'), ValueTY(370, 'Lake Hills Connector'), ValueTY(371, 'Lake Shore'), ValueTY(372, 'Lake Washington'), ValueTY(373, 'Lakehurst'), ValueTY(374, 'Lakeshore Plaza'), ValueTY(375, 'Lakeside'), ValueTY(376, 'Lakeview'), ValueTY(377, 'Landing'), ValueTY(378, 'Lansdowne'), ValueTY(379, 'Laurel'), ValueTY(380, 'Lawton'), ValueTY(381, 'Lawtonwood'), ValueTY(382, 'Lee'), ValueTY(383, 'Lenora'), ValueTY(384, 'Lewis'), ValueTY(385, 'Lincoln'), ValueTY(386, 'Linda'), ValueTY(387, 'Lindley'), ValueTY(388, 'Little Bear Creek'), ValueTY(389, 'Lockwood'), ValueTY(390, 'Logan'), ValueTY(391, 'Logging'), ValueTY(392, 'Lost Lake'), ValueTY(393, 'Lotus'), ValueTY(394, 'Lucile'), ValueTY(395, 'Lynn'), ValueTY(396, 'Macarthur'), ValueTY(397, 'Madison'), ValueTY(398, 'Madonna'), ValueTY(399, 'Madrona'), ValueTY(400, 'Magnolia'), ValueTY(401, 'Main'), ValueTY(402, 'Main Tiger Mountain'), ValueTY(403, 'Makah'), ValueTY(404, 'Mallard'), ValueTY(405, 'Maple'), ValueTY(406, 'Maplewood'), ValueTY(407, 'Marine View'), ValueTY(408, 'Marion'), ValueTY(409, 'Market'), ValueTY(410, 'Marymoor Park'), ValueTY(411, 'Mason'), ValueTY(412, 'Mattson'), ValueTY(413, 'Maule'), ValueTY(414, 'Mc Graw'), ValueTY(415, 'Mc Millan'), ValueTY(416, 'McGraw'), ValueTY(417, 'McKinley'), ValueTY(418, 'Meadow'), ValueTY(419, 'Meadowdale'), ValueTY(420, 'Meadowdale Beach'), ValueTY(421, 'Melody'), ValueTY(422, 'Melrose'), ValueTY(423, 'Mercer'), ValueTY(424, 'Mercer Terrace'), ValueTY(425, 'Mercerwood'), ValueTY(426, 'Meridian'), ValueTY(427, 'Merrimount'), ValueTY(428, 'Midland'), ValueTY(429, 'Milwaukee'), ValueTY(430, 'Minkler'), ValueTY(431, 'Minor'), ValueTY(432, 'Monroe Duvall'), ValueTY(433, 'Monte Villa'), ValueTY(434, 'Moss'), ValueTY(435, 'Mount Baker'), ValueTY(436, 'Mount Forest'), ValueTY(437, 'Mountain'), ValueTY(438, 'Myrtle'), ValueTY(439, 'NE Allen'), ValueTY(440, 'NE Greens Crossing'), ValueTY(441, 'Nellis'), ValueTY(442, 'Nels Berglund'), ValueTY(443, 'Newcastle Coal Creek'), ValueTY(444, 'Newcastle Golf Club'), ValueTY(445, 'Newell'), ValueTY(446, 'News'), ValueTY(447, 'Newton'), ValueTY(448, 'Nickerson'), ValueTY(449, 'Nike Manor'), ValueTY(450, 'Nootka'), ValueTY(451, 'North'), ValueTY(452, 'North Brooks'), ValueTY(453, 'North Canal'), ValueTY(454, 'North Creek'), ValueTY(455, 'North Danvers'), ValueTY(456, 'North Deer'), ValueTY(457, 'North Dogwood'), ValueTY(458, 'North Echo Lake'), ValueTY(459, 'North Greenwood'), ValueTY(460, 'North High Rock'), ValueTY(461, 'North Kennebeck'), ValueTY(462, 'North Lenora'), ValueTY(463, 'North Marion'), ValueTY(464, 'North Market'), ValueTY(465, 'North Pacific'), ValueTY(466, 'North Richmond Beach'), ValueTY(467, 'North Riverside'), ValueTY(468, 'Northbrook'), ValueTY(469, 'Northeast Albertson'), ValueTY(470, 'Northeast Alder'), ValueTY(471, 'Northeast Alder Crest'), ValueTY(472, 'Northeast Alderwood'), ValueTY(473, 'Northeast Ambleside'), ValueTY(474, 'Northeast Ames Lake'), ValueTY(475, 'Northeast Anderson'), ValueTY(476, 'Northeast Apple Cove'), ValueTY(477, 'Northeast Arness'), ValueTY(478, 'Northeast Arrowhead'), ValueTY(479, 'Northeast Avalon'), ValueTY(480, 'Northeast Baker Hill'), ValueTY(481, 'Northeast Beach Crest'), ValueTY(482, 'Northeast Beachwood'), ValueTY(483, 'Northeast Beadonhall'), ValueTY(484, 'Northeast Beck'), ValueTY(485, 'Northeast Belle Hill'), ValueTY(486, 'Northeast Berry'), ValueTY(487, 'Northeast Big Rock'), ValueTY(488, 'Northeast Bill Point'), ValueTY(489, 'Northeast Birch'), ValueTY(490, 'Northeast Bird'), ValueTY(491, 'Northeast Blackster'), ValueTY(492, 'Northeast Blakeley'), ValueTY(493, 'Northeast Boat'), ValueTY(494, 'Northeast Brackenwood'), ValueTY(495, 'Northeast Brooklyn'), ValueTY(496, 'Northeast Brownell'), ValueTY(497, 'Northeast Burns'), ValueTY(498, 'Northeast Byron'), ValueTY(499, 'Northeast California'), ValueTY(500, 'Northeast Campus'), ValueTY(501, 'Northeast Carpenter'), ValueTY(502, 'Northeast Carriage'), ValueTY(503, 'Northeast Casey'), ValueTY(504, 'Northeast Cherry'), ValueTY(505, 'Northeast Clare'), ValueTY(506, 'Northeast Comegys'), ValueTY(507, 'Northeast Coral'), ValueTY(508, 'Northeast County Park'), ValueTY(509, 'Northeast Coyote'), ValueTY(510, 'Northeast Crescent'), ValueTY(511, 'Northeast D'), ValueTY(512, 'Northeast Daphne'), ValueTY(513, 'Northeast Darby'), ValueTY(514, 'Northeast Darden'), ValueTY(515, 'Northeast Day'), ValueTY(516, 'Northeast Delaney'), ValueTY(517, 'Northeast Dingley'), ValueTY(518, 'Northeast Discovery'), ValueTY(519, 'Northeast Dogwood'), ValueTY(520, 'Northeast Dorothy'), ValueTY(521, 'Northeast Douglas'), ValueTY(522, 'Northeast Eaton'), ValueTY(523, 'Northeast Endicott'), ValueTY(524, 'Northeast Erin'), ValueTY(525, 'Northeast Evergreen'), ValueTY(526, 'Northeast Ewing'), ValueTY(527, 'Northeast Federal'), ValueTY(528, 'Northeast Felicity'), ValueTY(529, 'Northeast Fenton'), ValueTY(530, 'Northeast Fir'), ValueTY(531, 'Northeast Georgia'), ValueTY(532, 'Northeast Gilman'), ValueTY(533, 'Northeast Gisle'), ValueTY(534, 'Northeast Glavin'), ValueTY(535, 'Northeast Goodfellow'), ValueTY(536, 'Northeast Gordon'), ValueTY(537, 'Northeast Grizdale'), ValueTY(538, 'Northeast Halls Hill'), ValueTY(539, 'Northeast Hansen'), ValueTY(540, 'Northeast Harris'), ValueTY(541, 'Northeast Harrison'), ValueTY(542, 'Northeast Hawthorne'), ValueTY(543, 'Northeast Hidden Cove'), ValueTY(544, 'Northeast High'), ValueTY(545, 'Northeast High School'), ValueTY(546, 'Northeast Hillside'), ValueTY(547, 'Northeast Hilltop'), ValueTY(548, 'Northeast Hollyhills'), ValueTY(549, 'Northeast Huckleberry'), ValueTY(550, 'Northeast Husky'), ValueTY(551, 'Northeast Iris'), ValueTY(552, 'Northeast Iverson'), ValueTY(553, 'Northeast Jade'), ValueTY(554, 'Northeast Jewell'), ValueTY(555, 'Northeast John'), ValueTY(556, 'Northeast Johnson'), ValueTY(557, 'Northeast Jonquil'), ValueTY(558, 'Northeast Joshua Tree'), ValueTY(559, 'Northeast Juanita'), ValueTY(560, 'Northeast Julep'), ValueTY(561, 'Northeast Juniper'), ValueTY(562, 'Northeast Karmenn'), ValueTY(563, 'Northeast Katsura'), ValueTY(564, 'Northeast Kelsey'), ValueTY(565, 'Northeast Kenilworth'), ValueTY(566, 'Northeast Kennedy'), ValueTY(567, 'Northeast Kenwood'), ValueTY(568, 'Northeast Keswick'), ValueTY(569, 'Northeast Killian'), ValueTY(570, 'Northeast Kitsap'), ValueTY(571, 'Northeast Kiwi'), ValueTY(572, 'Northeast Klabo'), ValueTY(573, 'Northeast Knight'), ValueTY(574, 'Northeast Koura'), ValueTY(575, 'Northeast Lacey'), ValueTY(576, 'Northeast Lafayette'), ValueTY(577, 'Northeast Lake Joy'), ValueTY(578, 'Northeast Larchmount'), ValueTY(579, 'Northeast Laurel Wood'), ValueTY(580, 'Northeast Laurelcrest'), ValueTY(581, 'Northeast Leprechaun'), ValueTY(582, 'Northeast Lofgren'), ValueTY(583, 'Northeast Logan'), ValueTY(584, 'Northeast Loughrey'), ValueTY(585, 'Northeast Lovgren'), ValueTY(586, 'Northeast Mabrey'), ValueTY(587, 'Northeast Magnolia'), ValueTY(588, 'Northeast Maine'), ValueTY(589, 'Northeast Manor'), ValueTY(590, 'Northeast Maple'), ValueTY(591, 'Northeast Marine View'), ValueTY(592, 'Northeast Marion'), ValueTY(593, 'Northeast Marketplace'), ValueTY(594, 'Northeast Mary Lou'), ValueTY(595, 'Northeast McRedmond'), ValueTY(596, 'Northeast Meadowmeer'), ValueTY(597, 'Northeast Meigs'), ValueTY(598, 'Northeast Meyers'), ValueTY(599, 'Northeast Michelle'), ValueTY(600, 'Northeast Midway'), ValueTY(601, 'Northeast Miller'), ValueTY(602, 'Northeast Monroe'), ValueTY(603, 'Northeast Monsaas'), ValueTY(604, 'Northeast Morgan'), ValueTY(605, 'Northeast Morning'), ValueTY(606, 'Northeast Moses'), ValueTY(607, 'Northeast Mulberry'), ValueTY(608, 'Northeast Munson'), ValueTY(609, 'Northeast Murden Cove'), ValueTY(610, 'Northeast NOAA'), ValueTY(611, 'Northeast Noble'), ValueTY(612, 'Northeast Northstar'), ValueTY(613, 'Northeast Norton'), ValueTY(614, 'Northeast Ocean'), ValueTY(615, 'Northeast Oddfellows'), ValueTY(616, 'Northeast Ohio'), ValueTY(617, 'Northeast Olive'), ValueTY(618, 'Northeast Oregon'), ValueTY(619, 'Northeast Pacific'), ValueTY(620, 'Northeast Park'), ValueTY(621, 'Northeast Paulanna'), ValueTY(622, 'Northeast Penrith'), ValueTY(623, 'Northeast Phillip'), ValueTY(624, 'Northeast Pine'), ValueTY(625, 'Northeast Point View'), ValueTY(626, 'Northeast Points'), ValueTY(627, 'Northeast Preston'), ValueTY(628, 'Northeast Puget'), ValueTY(629, 'Northeast Puget Bluff'), ValueTY(630, 'Northeast Quail Creek'), ValueTY(631, 'Northeast Raccoon'), ValueTY(632, 'Northeast Radford'), ValueTY(633, 'Northeast Rasperry'), ValueTY(634, 'Northeast Ravenna'), ValueTY(635, 'Northeast Redmond'), ValueTY(636, 'Northeast Reny'), ValueTY(637, 'Northeast Richardson'), ValueTY(638, 'Northeast Ring'), ValueTY(639, 'Northeast Roberts'), ValueTY(640, 'Northeast Roney'), ValueTY(641, 'Northeast Rotsten'), ValueTY(642, 'Northeast Rupard'), ValueTY(643, 'Northeast Sasquatch'), ValueTY(644, 'Northeast Seaborn'), ValueTY(645, 'Northeast Seaview'), ValueTY(646, 'Northeast Shore'), ValueTY(647, 'Northeast South Beach'), ValueTY(648, 'Northeast South Villa'), ValueTY(649, 'Northeast Sprayfalls'), ValueTY(650, 'Northeast Springwood'), ValueTY(651, 'Northeast Spruce'), ValueTY(652, 'Northeast Sunrose'), ValueTY(653, 'Northeast Sunset'), ValueTY(654, 'Northeast Tani Creek'), ValueTY(655, 'Northeast Theresa'), ValueTY(656, 'Northeast Tolt Hill'), ValueTY(657, 'Northeast Torvanger'), ValueTY(658, 'Northeast Tulin'), ValueTY(659, 'Northeast Union Hill'), ValueTY(660, 'Northeast Valley'), ValueTY(661, 'Northeast Victorian'), ValueTY(662, 'Northeast Viewcrest'), ValueTY(663, 'Northeast Virginia'), ValueTY(664, 'Northeast Warabi'), ValueTY(665, 'Northeast Wardwell'), ValueTY(666, 'Northeast Watch Hill'), ValueTY(667, 'Northeast White Horse'), ValueTY(668, 'Northeast Wiggins'), ValueTY(669, 'Northeast Windermere'), ValueTY(670, 'Northeast Wing Point'), ValueTY(671, 'Northeast Winthers'), ValueTY(672, 'Northeast Woldmere'), ValueTY(673, 'Northeast Wolmere'), ValueTY(674, 'Northeast Woodinville'), ValueTY(675, 'Northeast Wyant'), ValueTY(676, 'Northeast Yaquina'), ValueTY(677, 'Northside'), ValueTY(678, 'Northstream'), ValueTY(679, 'Northup'), ValueTY(680, 'Northwest Blue Ridge'), ValueTY(681, 'Northwest Boulder Way'), ValueTY(682, 'Northwest Bright'), ValueTY(683, 'Northwest Canal'), ValueTY(684, 'Northwest Culbertson'), ValueTY(685, 'Northwest Datewood'), ValueTY(686, 'Northwest Dogwood'), ValueTY(687, 'Northwest Elford'), ValueTY(688, 'Northwest Esplanade'), ValueTY(689, 'Northwest Everwood'), ValueTY(690, 'Northwest Far Country'), ValueTY(691, 'Northwest Firwood'), ValueTY(692, 'Northwest Gilman'), ValueTY(693, 'Northwest Golden'), ValueTY(694, 'Northwest Holly'), ValueTY(695, 'Northwest Inneswood'), ValueTY(696, 'Northwest James Bush'), ValueTY(697, 'Northwest Juniper'), ValueTY(698, 'Northwest Locust'), ValueTY(699, 'Northwest Mall'), ValueTY(700, 'Northwest Maple'), ValueTY(701, 'Northwest Market'), ValueTY(702, 'Northwest Montreux'), ValueTY(703, 'Northwest North Beach'), ValueTY(704, 'Northwest Northwood'), ValueTY(705, 'Northwest Pacific Elm'), ValueTY(706, 'Northwest Pebble'), ValueTY(707, 'Northwest Puget'), ValueTY(708, 'Northwest Richwood'), ValueTY(709, 'Northwest Ridgefield'), ValueTY(710, 'Northwest Sammamish'), ValueTY(711, 'Northwest Spring Fork'), ValueTY(712, 'Northwest Talus'), ValueTY(713, 'Nottingham'), ValueTY(714, 'Novak'), ValueTY(715, 'Oak'), ValueTY(716, 'Observation'), ValueTY(717, 'Ocean'), ValueTY(718, 'Ohde'), ValueTY(719, 'Okanogan'), ValueTY(720, 'Old Highbridge'), ValueTY(721, 'Old Leary'), ValueTY(722, 'Old Railroad Grade'), ValueTY(723, 'Old Redmond'), ValueTY(724, 'Old Siler Logging'), ValueTY(725, 'Old Tester'), ValueTY(726, 'Olympic'), ValueTY(727, 'Olympic View'), ValueTY(728, 'Orchard Point'), ValueTY(729, 'Oregon'), ValueTY(730, 'Ormbrek'), ValueTY(731, 'Palomino'), ValueTY(732, 'Paradise Lake'), ValueTY(733, 'Park'), ValueTY(734, 'Parkridge'), ValueTY(735, 'Parkside'), ValueTY(736, 'Parkwood'), ValueTY(737, 'Parkwood Ridge'), ValueTY(738, 'Pear Tree'), ValueTY(739, 'Pebble Beach'), ValueTY(740, 'Pend Oreille'), ValueTY(741, 'Penny'), ValueTY(742, 'Perimeter'), ValueTY(743, 'Peterson'), ValueTY(744, 'Phipps'), ValueTY(745, 'Pierce'), ValueTY(746, 'Pike'), ValueTY(747, 'Pilchuk'), ValueTY(748, 'Pine'), ValueTY(749, 'Pioneer'), ValueTY(750, 'Pleasure Point'), ValueTY(751, 'Pole Line'), ValueTY(752, 'Poppy'), ValueTY(753, 'Post'), ValueTY(754, 'Power'), ValueTY(755, 'Priest'), ValueTY(756, 'Private'), ValueTY(757, 'Proctor'), ValueTY(758, 'Prospect'), ValueTY(759, 'Puget'), ValueTY(760, 'Quail'), ValueTY(761, 'Queen Anne'), ValueTY(762, 'Railroad'), ValueTY(763, 'Rambling'), ValueTY(764, 'Rand'), ValueTY(765, 'Randolph'), ValueTY(766, 'Raye'), ValueTY(767, 'Red Oak'), ValueTY(768, 'Redwood'), ValueTY(769, 'Reiten'), ValueTY(770, 'Renton'), ValueTY(771, 'Renton Maple Valley'), ValueTY(772, 'Republican'), ValueTY(773, 'Rhody'), ValueTY(774, 'Ricci'), ValueTY(775, 'Richards'), ValueTY(776, 'Richmond'), ValueTY(777, 'Richmond Beach'), ValueTY(778, 'Ridge'), ValueTY(779, 'Ridgecrest'), ValueTY(780, 'Ridgeview'), ValueTY(781, 'Rimrock'), ValueTY(782, 'River Access'), ValueTY(783, 'River View Quarry'), ValueTY(784, 'Riverbend'), ValueTY(785, 'Riverside'), ValueTY(786, 'Riverview'), ValueTY(787, 'Robin Hood'), ValueTY(788, 'Rose Point'), ValueTY(789, 'Rosewood'), ValueTY(790, 'Ross'), ValueTY(791, 'Roy'), ValueTY(792, 'Royal Anne'), ValueTY(793, 'Russell'), ValueTY(794, 'Russet'), ValueTY(795, 'S Juneau'), ValueTY(796, 'S Raymond'), ValueTY(797, 'S Spencer'), ValueTY(798, 'Saint Andrew'), ValueTY(799, 'San Juan'), ValueTY(800, 'Sater'), ValueTY(801, 'Saxon'), ValueTY(802, 'Scenic'), ValueTY(803, 'School'), ValueTY(804, 'School District'), ValueTY(805, 'Scriber Lake'), ValueTY(806, 'Sea Shore'), ValueTY(807, 'Sealth'), ValueTY(808, 'Seamont'), ValueTY(809, 'Seashore'), ValueTY(810, 'Seneca'), ValueTY(811, 'Seward Park'), ValueTY(812, 'Shanti'), ValueTY(813, 'Sheila'), ValueTY(814, 'Shell Valley'), ValueTY(815, 'Shinkle'), ValueTY(816, 'Shore'), ValueTY(817, 'Shoreclift'), ValueTY(818, 'Shoreclub'), ValueTY(819, 'Shoreland'), ValueTY(820, 'Shorewood'), ValueTY(821, 'Sierra'), ValueTY(822, 'Six Penny'), ValueTY(823, 'Skagit'), ValueTY(824, 'Skamania'), ValueTY(825, 'Sky Meadows'), ValueTY(826, 'Skyline'), ValueTY(827, 'Slater'), ValueTY(828, 'Snohomish'), ValueTY(829, 'Snohomish Woodinville'), ValueTY(830, 'Snoqualmie'), ValueTY(831, 'Snoqualmie River'), ValueTY(832, 'Somerset'), ValueTY(833, 'Sound View'), ValueTY(834, 'Soundview'), ValueTY(835, 'South'), ValueTY(836, 'South Alaska'), ValueTY(837, 'South Americus'), ValueTY(838, 'South Andover'), ValueTY(839, 'South Angeline'), ValueTY(840, 'South Angelo'), ValueTY(841, 'South Apple'), ValueTY(842, 'South Atlantic'), ValueTY(843, 'South Augusta'), ValueTY(844, 'South Austin'), ValueTY(845, 'South Avon'), ValueTY(846, 'South Bailey'), ValueTY(847, 'South Bangor'), ValueTY(848, 'South Barton'), ValueTY(849, 'South Bateman'), ValueTY(850, 'South Bayview'), ValueTY(851, 'South Bellflower'), ValueTY(852, 'South Benefit'), ValueTY(853, 'South Bennett'), ValueTY(854, 'South Bond'), ValueTY(855, 'South Bow Lake'), ValueTY(856, 'South Bozeman'), ValueTY(857, 'South Bradford'), ValueTY(858, 'South Brandon'), ValueTY(859, 'South Burns'), ValueTY(860, 'South Byron'), ValueTY(861, 'South Cambridge'), ValueTY(862, 'South Carr'), ValueTY(863, 'South Carver'), ValueTY(864, 'South Charles'), ValueTY(865, 'South Charlestown'), ValueTY(866, 'South Chicago'), ValueTY(867, 'South Cloverdale'), ValueTY(868, 'South College'), ValueTY(869, 'South Concord'), ValueTY(870, 'South Cooper'), ValueTY(871, 'South Corgiat'), ValueTY(872, 'South Court'), ValueTY(873, 'South Creston'), ValueTY(874, 'South Dakota'), ValueTY(875, 'South Danvers'), ValueTY(876, 'South Dawson'), ValueTY(877, 'South Day'), ValueTY(878, 'South Dean'), ValueTY(879, 'South Dearborn'), ValueTY(880, 'South Dedham'), ValueTY(881, 'South Deer'), ValueTY(882, 'South Della'), ValueTY(883, 'South Director'), ValueTY(884, 'South Dogwood'), ValueTY(885, 'South Donovan'), ValueTY(886, 'South Doris'), ValueTY(887, 'South Eastwood'), ValueTY(888, 'South Eddy'), ValueTY(889, 'South Edmunds'), ValueTY(890, 'South Elizabeth'), ValueTY(891, 'South Elmgrove'), ValueTY(892, 'South Estelle'), ValueTY(893, 'South Fairbanks'), ValueTY(894, 'South Farrar'), ValueTY(895, 'South Ferdinand'), ValueTY(896, 'South Fidalgo'), ValueTY(897, 'South Findlay'), ValueTY(898, 'South Fletcher'), ValueTY(899, 'South Forest'), ValueTY(900, 'South Fountain'), ValueTY(901, 'South Front'), ValueTY(902, 'South Frontenac'), ValueTY(903, 'South Garden'), ValueTY(904, 'South Garden Loop'), ValueTY(905, 'South Gazelle'), ValueTY(906, 'South Genesee'), ValueTY(907, 'South Glacier'), ValueTY(908, 'South Graham'), ValueTY(909, 'South Grand'), ValueTY(910, 'South Hanford'), ValueTY(911, 'South Hardy'), ValueTY(912, 'South Harney'), ValueTY(913, 'South Hazel'), ValueTY(914, 'South Hill'), ValueTY(915, 'South Hinds'), ValueTY(916, 'South Holden'), ValueTY(917, 'South Holgate'), ValueTY(918, 'South Holly'), ValueTY(919, 'South Homer'), ValueTY(920, 'South Horton'), ValueTY(921, 'South Hudson'), ValueTY(922, 'South Hummingbird'), ValueTY(923, 'South Idaho'), ValueTY(924, 'South Irving'), ValueTY(925, 'South Jackson'), ValueTY(926, 'South Judkins'), ValueTY(927, 'South Juneau'), ValueTY(928, 'South Juniper'), ValueTY(929, 'South Kennbeck'), ValueTY(930, 'South Kennebeck'), ValueTY(931, 'South Kenny'), ValueTY(932, 'South Kent Des Moines'), ValueTY(933, 'South Kenyon'), ValueTY(934, 'South Keppler'), ValueTY(935, 'South King'), ValueTY(936, 'South Lake Dell'), ValueTY(937, 'South Lander'), ValueTY(938, 'South Langston'), ValueTY(939, 'South Laurel'), ValueTY(940, 'South Leo'), ValueTY(941, 'South Lilac'), ValueTY(942, 'South Main'), ValueTY(943, 'South Massachusetts'), ValueTY(944, 'South Mayflower'), ValueTY(945, 'South Mc Clellan'), ValueTY(946, 'South McClellan'), ValueTY(947, 'South Mead'), ValueTY(948, 'South Michigan'), ValueTY(949, 'South Monroe'), ValueTY(950, 'South Moore'), ValueTY(951, 'South Morgan'), ValueTY(952, 'South Mount Baker'), ValueTY(953, 'South Myrtle'), ValueTY(954, 'South Nebraska'), ValueTY(955, 'South Nevada'), ValueTY(956, 'South Norfolk'), ValueTY(957, 'South Norman'), ValueTY(958, 'South Normandy'), ValueTY(959, 'South Orcas'), ValueTY(960, 'South Orchard'), ValueTY(961, 'South Orr'), ValueTY(962, 'South Othello'), ValueTY(963, 'South Pamela'), ValueTY(964, 'South Pearl'), ValueTY(965, 'South Perimeter'), ValueTY(966, 'South Perry'), ValueTY(967, 'South Pilgrim'), ValueTY(968, 'South Pinebrook'), ValueTY(969, 'South Plum'), ValueTY(970, 'South Plummer'), ValueTY(971, 'South Portland'), ValueTY(972, 'South Prentice'), ValueTY(973, 'South Puget'), ValueTY(974, 'South Rainbow'), ValueTY(975, 'South Raymond'), ValueTY(976, 'South Redwing'), ValueTY(977, 'South River'), ValueTY(978, 'South Riverside'), ValueTY(979, 'South Rose'), ValueTY(980, 'South Roxbury'), ValueTY(981, 'South Ruggles'), ValueTY(982, 'South Rustic'), ValueTY(983, 'South Ryan'), ValueTY(984, 'South Seward Park'), ValueTY(985, 'South Shell'), ValueTY(986, 'South Shelton'), ValueTY(987, 'South Snoqualmie'), ValueTY(988, 'South Southern'), ValueTY(989, 'South Spencer'), ValueTY(990, 'South Spokane'), ValueTY(991, 'South Sullivan'), ValueTY(992, 'South Sunnycrest'), ValueTY(993, 'South Taft'), ValueTY(994, 'South Thayer'), ValueTY(995, 'South Thistle'), ValueTY(996, 'South Tillicum'), ValueTY(997, 'South Tobin'), ValueTY(998, 'South Todd'), ValueTY(999, 'South Trenton')));
INSERT INTO Vocabulary (semantic, vocabols) VALUES ('vehicles',	 VocabularyValuesTY (ValueTY(1,'Train'), ValueTY(2, 'Lorry'), ValueTY(3, 'Ship'), ValueTY(4, 'Plane'), ValueTY(5, 'Car'), ValueTY(6, 'Train'), ValueTY(7, 'Lorry'), ValueTY(8, 'Ship'), ValueTY(9, 'Plane'), ValueTY(10, 'Car'), ValueTY(11, 'Train'), ValueTY(12, 'Lorry'), ValueTY(13, 'Ship'), ValueTY(14, 'Plane'), ValueTY(15, 'Car'), ValueTY(16, 'Train'), ValueTY(17, 'Lorry'), ValueTY(18, 'Ship'), ValueTY(19, 'Plane'), ValueTY(20, 'Car'), ValueTY(21, 'Train'), ValueTY(22, 'Lorry'), ValueTY(23, 'Ship'), ValueTY(24, 'Plane'), ValueTY(25, 'Car'), ValueTY(26, 'Train'), ValueTY(27, 'Lorry'), ValueTY(28, 'Ship'), ValueTY(29, 'Plane'), ValueTY(30, 'Car'), ValueTY(31, 'Train'), ValueTY(32, 'Lorry'), ValueTY(33, 'Ship'), ValueTY(34, 'Plane'), ValueTY(35, 'Car'), ValueTY(36, 'Train'), ValueTY(37, 'Lorry'), ValueTY(38, 'Ship'), ValueTY(39, 'Plane'), ValueTY(40, 'Car'), ValueTY(41, 'Train'), ValueTY(42, 'Lorry'), ValueTY(43, 'Ship'), ValueTY(44, 'Plane'), ValueTY(45, 'Car'), ValueTY(46, 'Train'), ValueTY(47, 'Lorry'), ValueTY(48, 'Ship'), ValueTY(49, 'Plane'), ValueTY(50, 'Car'), ValueTY(51, 'Train'), ValueTY(52, 'Lorry'), ValueTY(53, 'Ship'), ValueTY(54, 'Plane'), ValueTY(55, 'Car'), ValueTY(56, 'Train'), ValueTY(57, 'Lorry'), ValueTY(58, 'Ship'), ValueTY(59, 'Plane'), ValueTY(60, 'Car'), ValueTY(61, 'Train'), ValueTY(62, 'Lorry'), ValueTY(63, 'Ship'), ValueTY(64, 'Plane'), ValueTY(65, 'Car'), ValueTY(66, 'Train'), ValueTY(67, 'Lorry'), ValueTY(68, 'Ship'), ValueTY(69, 'Plane'), ValueTY(70, 'Car'), ValueTY(71, 'Train'), ValueTY(72, 'Lorry'), ValueTY(73, 'Ship'), ValueTY(74, 'Plane'), ValueTY(75, 'Car'), ValueTY(76, 'Train'), ValueTY(77, 'Lorry'), ValueTY(78, 'Ship'), ValueTY(79, 'Plane'), ValueTY(80, 'Car'), ValueTY(81, 'Train'), ValueTY(82, 'Lorry'), ValueTY(83, 'Ship'), ValueTY(84, 'Plane'), ValueTY(85, 'Car'), ValueTY(86, 'Train'), ValueTY(87, 'Lorry'), ValueTY(88, 'Ship'), ValueTY(89, 'Plane'), ValueTY(90, 'Car'), ValueTY(91, 'Train'), ValueTY(92, 'Lorry'), ValueTY(93, 'Ship'), ValueTY(94, 'Plane'), ValueTY(95, 'Car'), ValueTY(96, 'Train'), ValueTY(97, 'Lorry'), ValueTY(98, 'Ship'), ValueTY(99, 'Plane'), ValueTY(100, 'Car'), ValueTY(101, 'Train'), ValueTY(102, 'Lorry'), ValueTY(103, 'Ship'), ValueTY(104, 'Plane'), ValueTY(105, 'Car'), ValueTY(106, 'Train'), ValueTY(107, 'Lorry'), ValueTY(108, 'Ship'), ValueTY(109, 'Plane'), ValueTY(110, 'Car'), ValueTY(111, 'Train'), ValueTY(112, 'Lorry'), ValueTY(113, 'Ship'), ValueTY(114, 'Plane'), ValueTY(115, 'Car'), ValueTY(116, 'Train'), ValueTY(117, 'Lorry'), ValueTY(118, 'Ship'), ValueTY(119, 'Plane'), ValueTY(120, 'Car'), ValueTY(121, 'Train'), ValueTY(122, 'Lorry'), ValueTY(123, 'Ship'), ValueTY(124, 'Plane'), ValueTY(125, 'Car'), ValueTY(126, 'Train'), ValueTY(127, 'Lorry'), ValueTY(128, 'Ship'), ValueTY(129, 'Plane'), ValueTY(130, 'Car'), ValueTY(131, 'Train'), ValueTY(132, 'Lorry'), ValueTY(133, 'Ship'), ValueTY(134, 'Plane'), ValueTY(135, 'Car'), ValueTY(136, 'Train'), ValueTY(137, 'Lorry'), ValueTY(138, 'Ship'), ValueTY(139, 'Plane'), ValueTY(140, 'Car'), ValueTY(141, 'Train'), ValueTY(142, 'Lorry'), ValueTY(143, 'Ship'), ValueTY(144, 'Plane'), ValueTY(145, 'Car'), ValueTY(146, 'Train'), ValueTY(147, 'Lorry'), ValueTY(148, 'Ship'), ValueTY(149, 'Plane'), ValueTY(150, 'Car'), ValueTY(151, 'Train'), ValueTY(152, 'Lorry'), ValueTY(153, 'Ship'), ValueTY(154, 'Plane'), ValueTY(155, 'Car'), ValueTY(156, 'Train'), ValueTY(157, 'Lorry'), ValueTY(158, 'Ship'), ValueTY(159, 'Plane'), ValueTY(160, 'Car'), ValueTY(161, 'Train'), ValueTY(162, 'Lorry'), ValueTY(163, 'Ship'), ValueTY(164, 'Plane'), ValueTY(165, 'Car'), ValueTY(166, 'Train'), ValueTY(167, 'Lorry'), ValueTY(168, 'Ship'), ValueTY(169, 'Plane'), ValueTY(170, 'Car'), ValueTY(171, 'Train'), ValueTY(172, 'Lorry'), ValueTY(173, 'Ship'), ValueTY(174, 'Plane'), ValueTY(175, 'Car'), ValueTY(176, 'Train'), ValueTY(177, 'Lorry'), ValueTY(178, 'Ship'), ValueTY(179, 'Plane'), ValueTY(180, 'Car'), ValueTY(181, 'Train'), ValueTY(182, 'Lorry'), ValueTY(183, 'Ship'), ValueTY(184, 'Plane'), ValueTY(185, 'Car'), ValueTY(186, 'Train'), ValueTY(187, 'Lorry'), ValueTY(188, 'Ship'), ValueTY(189, 'Plane'), ValueTY(190, 'Car'), ValueTY(191, 'Train'), ValueTY(192, 'Lorry'), ValueTY(193, 'Ship'), ValueTY(194, 'Plane'), ValueTY(195, 'Car'), ValueTY(196, 'Train'), ValueTY(197, 'Lorry'), ValueTY(198, 'Ship'), ValueTY(199, 'Plane'), ValueTY(200, 'Car'), ValueTY(201, 'Train'), ValueTY(202, 'Lorry'), ValueTY(203, 'Ship'), ValueTY(204, 'Plane'), ValueTY(205, 'Car'), ValueTY(206, 'Train'), ValueTY(207, 'Lorry'), ValueTY(208, 'Ship'), ValueTY(209, 'Plane'), ValueTY(210, 'Car'), ValueTY(211, 'Train'), ValueTY(212, 'Lorry'), ValueTY(213, 'Ship'), ValueTY(214, 'Plane'), ValueTY(215, 'Car'), ValueTY(216, 'Train'), ValueTY(217, 'Lorry'), ValueTY(218, 'Ship'), ValueTY(219, 'Plane'), ValueTY(220, 'Car'), ValueTY(221, 'Train'), ValueTY(222, 'Lorry'), ValueTY(223, 'Ship'), ValueTY(224, 'Plane'), ValueTY(225, 'Car'), ValueTY(226, 'Train'), ValueTY(227, 'Lorry'), ValueTY(228, 'Ship'), ValueTY(229, 'Plane'), ValueTY(230, 'Car'), ValueTY(231, 'Train'), ValueTY(232, 'Lorry'), ValueTY(233, 'Ship'), ValueTY(234, 'Plane'), ValueTY(235, 'Car'), ValueTY(236, 'Train'), ValueTY(237, 'Lorry'), ValueTY(238, 'Ship'), ValueTY(239, 'Plane'), ValueTY(240, 'Car'), ValueTY(241, 'Train'), ValueTY(242, 'Lorry'), ValueTY(243, 'Ship'), ValueTY(244, 'Plane'), ValueTY(245, 'Car'), ValueTY(246, 'Train'), ValueTY(247, 'Lorry'), ValueTY(248, 'Ship'), ValueTY(249, 'Plane'), ValueTY(250, 'Car'), ValueTY(251, 'Train'), ValueTY(252, 'Lorry'), ValueTY(253, 'Ship'), ValueTY(254, 'Plane'), ValueTY(255, 'Car'), ValueTY(256, 'Train'), ValueTY(257, 'Lorry'), ValueTY(258, 'Ship'), ValueTY(259, 'Plane'), ValueTY(260, 'Car'), ValueTY(261, 'Train'), ValueTY(262, 'Lorry'), ValueTY(263, 'Ship'), ValueTY(264, 'Plane'), ValueTY(265, 'Car'), ValueTY(266, 'Train'), ValueTY(267, 'Lorry'), ValueTY(268, 'Ship'), ValueTY(269, 'Plane'), ValueTY(270, 'Car'), ValueTY(271, 'Train'), ValueTY(272, 'Lorry'), ValueTY(273, 'Ship'), ValueTY(274, 'Plane'), ValueTY(275, 'Car'), ValueTY(276, 'Train'), ValueTY(277, 'Lorry'), ValueTY(278, 'Ship'), ValueTY(279, 'Plane'), ValueTY(280, 'Car'), ValueTY(281, 'Train'), ValueTY(282, 'Lorry'), ValueTY(283, 'Ship'), ValueTY(284, 'Plane'), ValueTY(285, 'Car'), ValueTY(286, 'Train'), ValueTY(287, 'Lorry'), ValueTY(288, 'Ship'), ValueTY(289, 'Plane'), ValueTY(290, 'Car'), ValueTY(291, 'Train'), ValueTY(292, 'Lorry'), ValueTY(293, 'Ship'), ValueTY(294, 'Plane'), ValueTY(295, 'Car'), ValueTY(296, 'Train'), ValueTY(297, 'Lorry'), ValueTY(298, 'Ship'), ValueTY(299, 'Plane'), ValueTY(300, 'Car'), ValueTY(301, 'Train'), ValueTY(302, 'Lorry'), ValueTY(303, 'Ship'), ValueTY(304, 'Plane'), ValueTY(305, 'Car'), ValueTY(306, 'Train'), ValueTY(307, 'Lorry'), ValueTY(308, 'Ship'), ValueTY(309, 'Plane'), ValueTY(310, 'Car'), ValueTY(311, 'Train'), ValueTY(312, 'Lorry'), ValueTY(313, 'Ship'), ValueTY(314, 'Plane'), ValueTY(315, 'Car'), ValueTY(316, 'Train'), ValueTY(317, 'Lorry'), ValueTY(318, 'Ship'), ValueTY(319, 'Plane'), ValueTY(320, 'Car'), ValueTY(321, 'Train'), ValueTY(322, 'Lorry'), ValueTY(323, 'Ship'), ValueTY(324, 'Plane'), ValueTY(325, 'Car'), ValueTY(326, 'Train'), ValueTY(327, 'Lorry'), ValueTY(328, 'Ship'), ValueTY(329, 'Plane'), ValueTY(330, 'Car'), ValueTY(331, 'Train'), ValueTY(332, 'Lorry'), ValueTY(333, 'Ship'), ValueTY(334, 'Plane'), ValueTY(335, 'Car'), ValueTY(336, 'Train'), ValueTY(337, 'Lorry'), ValueTY(338, 'Ship'), ValueTY(339, 'Plane'), ValueTY(340, 'Car'), ValueTY(341, 'Train'), ValueTY(342, 'Lorry'), ValueTY(343, 'Ship'), ValueTY(344, 'Plane'), ValueTY(345, 'Car'), ValueTY(346, 'Train'), ValueTY(347, 'Lorry'), ValueTY(348, 'Ship'), ValueTY(349, 'Plane'), ValueTY(350, 'Car'), ValueTY(351, 'Train'), ValueTY(352, 'Lorry'), ValueTY(353, 'Ship'), ValueTY(354, 'Plane'), ValueTY(355, 'Car'), ValueTY(356, 'Train'), ValueTY(357, 'Lorry'), ValueTY(358, 'Ship'), ValueTY(359, 'Plane'), ValueTY(360, 'Car'), ValueTY(361, 'Train'), ValueTY(362, 'Lorry'), ValueTY(363, 'Ship'), ValueTY(364, 'Plane'), ValueTY(365, 'Car'), ValueTY(366, 'Train'), ValueTY(367, 'Lorry'), ValueTY(368, 'Ship'), ValueTY(369, 'Plane'), ValueTY(370, 'Car'), ValueTY(371, 'Train'), ValueTY(372, 'Lorry'), ValueTY(373, 'Ship'), ValueTY(374, 'Plane'), ValueTY(375, 'Car'), ValueTY(376, 'Train'), ValueTY(377, 'Lorry'), ValueTY(378, 'Ship'), ValueTY(379, 'Plane'), ValueTY(380, 'Car'), ValueTY(381, 'Train'), ValueTY(382, 'Lorry'), ValueTY(383, 'Ship'), ValueTY(384, 'Plane'), ValueTY(385, 'Car'), ValueTY(386, 'Train'), ValueTY(387, 'Lorry'), ValueTY(388, 'Ship'), ValueTY(389, 'Plane'), ValueTY(390, 'Car'), ValueTY(391, 'Train'), ValueTY(392, 'Lorry'), ValueTY(393, 'Ship'), ValueTY(394, 'Plane'), ValueTY(395, 'Car'), ValueTY(396, 'Train'), ValueTY(397, 'Lorry'), ValueTY(398, 'Ship'), ValueTY(399, 'Plane'), ValueTY(400, 'Car'), ValueTY(401, 'Train'), ValueTY(402, 'Lorry'), ValueTY(403, 'Ship'), ValueTY(404, 'Plane'), ValueTY(405, 'Car'), ValueTY(406, 'Train'), ValueTY(407, 'Lorry'), ValueTY(408, 'Ship'), ValueTY(409, 'Plane'), ValueTY(410, 'Car'), ValueTY(411, 'Train'), ValueTY(412, 'Lorry'), ValueTY(413, 'Ship'), ValueTY(414, 'Plane'), ValueTY(415, 'Car'), ValueTY(416, 'Train'), ValueTY(417, 'Lorry'), ValueTY(418, 'Ship'), ValueTY(419, 'Plane'), ValueTY(420, 'Car'), ValueTY(421, 'Train'), ValueTY(422, 'Lorry'), ValueTY(423, 'Ship'), ValueTY(424, 'Plane'), ValueTY(425, 'Car'), ValueTY(426, 'Train'), ValueTY(427, 'Lorry'), ValueTY(428, 'Ship'), ValueTY(429, 'Plane'), ValueTY(430, 'Car'), ValueTY(431, 'Train'), ValueTY(432, 'Lorry'), ValueTY(433, 'Ship'), ValueTY(434, 'Plane'), ValueTY(435, 'Car'), ValueTY(436, 'Train'), ValueTY(437, 'Lorry'), ValueTY(438, 'Ship'), ValueTY(439, 'Plane'), ValueTY(440, 'Car'), ValueTY(441, 'Train'), ValueTY(442, 'Lorry'), ValueTY(443, 'Ship'), ValueTY(444, 'Plane'), ValueTY(445, 'Car'), ValueTY(446, 'Train'), ValueTY(447, 'Lorry'), ValueTY(448, 'Ship'), ValueTY(449, 'Plane'), ValueTY(450, 'Car'), ValueTY(451, 'Train'), ValueTY(452, 'Lorry'), ValueTY(453, 'Ship'), ValueTY(454, 'Plane'), ValueTY(455, 'Car'), ValueTY(456, 'Train'), ValueTY(457, 'Lorry'), ValueTY(458, 'Ship'), ValueTY(459, 'Plane'), ValueTY(460, 'Car'), ValueTY(461, 'Train'), ValueTY(462, 'Lorry'), ValueTY(463, 'Ship'), ValueTY(464, 'Plane'), ValueTY(465, 'Car'), ValueTY(466, 'Train'), ValueTY(467, 'Lorry'), ValueTY(468, 'Ship'), ValueTY(469, 'Plane'), ValueTY(470, 'Car'), ValueTY(471, 'Train'), ValueTY(472, 'Lorry'), ValueTY(473, 'Ship'), ValueTY(474, 'Plane'), ValueTY(475, 'Car'), ValueTY(476, 'Train'), ValueTY(477, 'Lorry'), ValueTY(478, 'Ship'), ValueTY(479, 'Plane'), ValueTY(480, 'Car'), ValueTY(481, 'Train'), ValueTY(482, 'Lorry'), ValueTY(483, 'Ship'), ValueTY(484, 'Plane'), ValueTY(485, 'Car'), ValueTY(486, 'Train'), ValueTY(487, 'Lorry'), ValueTY(488, 'Ship'), ValueTY(489, 'Plane'), ValueTY(490, 'Car'), ValueTY(491, 'Train'), ValueTY(492, 'Lorry'), ValueTY(493, 'Ship'), ValueTY(494, 'Plane'), ValueTY(495, 'Car'), ValueTY(496, 'Train'), ValueTY(497, 'Lorry'), ValueTY(498, 'Ship'), ValueTY(499, 'Plane'), ValueTY(500, 'Car'), ValueTY(501, 'Train'), ValueTY(502, 'Lorry'), ValueTY(503, 'Ship'), ValueTY(504, 'Plane'), ValueTY(505, 'Car'), ValueTY(506, 'Train'), ValueTY(507, 'Lorry'), ValueTY(508, 'Ship'), ValueTY(509, 'Plane'), ValueTY(510, 'Car'), ValueTY(511, 'Train'), ValueTY(512, 'Lorry'), ValueTY(513, 'Ship'), ValueTY(514, 'Plane'), ValueTY(515, 'Car'), ValueTY(516, 'Train'), ValueTY(517, 'Lorry'), ValueTY(518, 'Ship'), ValueTY(519, 'Plane'), ValueTY(520, 'Car'), ValueTY(521, 'Train'), ValueTY(522, 'Lorry'), ValueTY(523, 'Ship'), ValueTY(524, 'Plane'), ValueTY(525, 'Car'), ValueTY(526, 'Train'), ValueTY(527, 'Lorry'), ValueTY(528, 'Ship'), ValueTY(529, 'Plane'), ValueTY(530, 'Car'), ValueTY(531, 'Train'), ValueTY(532, 'Lorry'), ValueTY(533, 'Ship'), ValueTY(534, 'Plane'), ValueTY(535, 'Car'), ValueTY(536, 'Train'), ValueTY(537, 'Lorry'), ValueTY(538, 'Ship'), ValueTY(539, 'Plane'), ValueTY(540, 'Car'), ValueTY(541, 'Train'), ValueTY(542, 'Lorry'), ValueTY(543, 'Ship'), ValueTY(544, 'Plane'), ValueTY(545, 'Car'), ValueTY(546, 'Train'), ValueTY(547, 'Lorry'), ValueTY(548, 'Ship'), ValueTY(549, 'Plane'), ValueTY(550, 'Car'), ValueTY(551, 'Train'), ValueTY(552, 'Lorry'), ValueTY(553, 'Ship'), ValueTY(554, 'Plane'), ValueTY(555, 'Car'), ValueTY(556, 'Train'), ValueTY(557, 'Lorry'), ValueTY(558, 'Ship'), ValueTY(559, 'Plane'), ValueTY(560, 'Car'), ValueTY(561, 'Train'), ValueTY(562, 'Lorry'), ValueTY(563, 'Ship'), ValueTY(564, 'Plane'), ValueTY(565, 'Car'), ValueTY(566, 'Train'), ValueTY(567, 'Lorry'), ValueTY(568, 'Ship'), ValueTY(569, 'Plane'), ValueTY(570, 'Car'), ValueTY(571, 'Train'), ValueTY(572, 'Lorry'), ValueTY(573, 'Ship'), ValueTY(574, 'Plane'), ValueTY(575, 'Car'), ValueTY(576, 'Train'), ValueTY(577, 'Lorry'), ValueTY(578, 'Ship'), ValueTY(579, 'Plane'), ValueTY(580, 'Car'), ValueTY(581, 'Train'), ValueTY(582, 'Lorry'), ValueTY(583, 'Ship'), ValueTY(584, 'Plane'), ValueTY(585, 'Car'), ValueTY(586, 'Train'), ValueTY(587, 'Lorry'), ValueTY(588, 'Ship'), ValueTY(589, 'Plane'), ValueTY(590, 'Car'), ValueTY(591, 'Train'), ValueTY(592, 'Lorry'), ValueTY(593, 'Ship'), ValueTY(594, 'Plane'), ValueTY(595, 'Car'), ValueTY(596, 'Train'), ValueTY(597, 'Lorry'), ValueTY(598, 'Ship'), ValueTY(599, 'Plane'), ValueTY(600, 'Car'), ValueTY(601, 'Train'), ValueTY(602, 'Lorry'), ValueTY(603, 'Ship'), ValueTY(604, 'Plane'), ValueTY(605, 'Car'), ValueTY(606, 'Train'), ValueTY(607, 'Lorry'), ValueTY(608, 'Ship'), ValueTY(609, 'Plane'), ValueTY(610, 'Car'), ValueTY(611, 'Train'), ValueTY(612, 'Lorry'), ValueTY(613, 'Ship'), ValueTY(614, 'Plane'), ValueTY(615, 'Car'), ValueTY(616, 'Train'), ValueTY(617, 'Lorry'), ValueTY(618, 'Ship'), ValueTY(619, 'Plane'), ValueTY(620, 'Car'), ValueTY(621, 'Train'), ValueTY(622, 'Lorry'), ValueTY(623, 'Ship'), ValueTY(624, 'Plane'), ValueTY(625, 'Car'), ValueTY(626, 'Train'), ValueTY(627, 'Lorry'), ValueTY(628, 'Ship'), ValueTY(629, 'Plane'), ValueTY(630, 'Car'), ValueTY(631, 'Train'), ValueTY(632, 'Lorry'), ValueTY(633, 'Ship'), ValueTY(634, 'Plane'), ValueTY(635, 'Car'), ValueTY(636, 'Train'), ValueTY(637, 'Lorry'), ValueTY(638, 'Ship'), ValueTY(639, 'Plane'), ValueTY(640, 'Car'), ValueTY(641, 'Train'), ValueTY(642, 'Lorry'), ValueTY(643, 'Ship'), ValueTY(644, 'Plane'), ValueTY(645, 'Car'), ValueTY(646, 'Train'), ValueTY(647, 'Lorry'), ValueTY(648, 'Ship'), ValueTY(649, 'Plane'), ValueTY(650, 'Car'), ValueTY(651, 'Train'), ValueTY(652, 'Lorry'), ValueTY(653, 'Ship'), ValueTY(654, 'Plane'), ValueTY(655, 'Car'), ValueTY(656, 'Train'), ValueTY(657, 'Lorry'), ValueTY(658, 'Ship'), ValueTY(659, 'Plane'), ValueTY(660, 'Car'), ValueTY(661, 'Train'), ValueTY(662, 'Lorry'), ValueTY(663, 'Ship'), ValueTY(664, 'Plane'), ValueTY(665, 'Car'), ValueTY(666, 'Train'), ValueTY(667, 'Lorry'), ValueTY(668, 'Ship'), ValueTY(669, 'Plane'), ValueTY(670, 'Car'), ValueTY(671, 'Train'), ValueTY(672, 'Lorry'), ValueTY(673, 'Ship'), ValueTY(674, 'Plane'), ValueTY(675, 'Car'), ValueTY(676, 'Train'), ValueTY(677, 'Lorry'), ValueTY(678, 'Ship'), ValueTY(679, 'Plane'), ValueTY(680, 'Car'), ValueTY(681, 'Train'), ValueTY(682, 'Lorry'), ValueTY(683, 'Ship'), ValueTY(684, 'Plane'), ValueTY(685, 'Car'), ValueTY(686, 'Train'), ValueTY(687, 'Lorry'), ValueTY(688, 'Ship'), ValueTY(689, 'Plane'), ValueTY(690, 'Car'), ValueTY(691, 'Train'), ValueTY(692, 'Lorry'), ValueTY(693, 'Ship'), ValueTY(694, 'Plane'), ValueTY(695, 'Car'), ValueTY(696, 'Train'), ValueTY(697, 'Lorry'), ValueTY(698, 'Ship'), ValueTY(699, 'Plane'), ValueTY(700, 'Car'), ValueTY(701, 'Train'), ValueTY(702, 'Lorry'), ValueTY(703, 'Ship'), ValueTY(704, 'Plane'), ValueTY(705, 'Car'), ValueTY(706, 'Train'), ValueTY(707, 'Lorry'), ValueTY(708, 'Ship'), ValueTY(709, 'Plane'), ValueTY(710, 'Car'), ValueTY(711, 'Train'), ValueTY(712, 'Lorry'), ValueTY(713, 'Ship'), ValueTY(714, 'Plane'), ValueTY(715, 'Car'), ValueTY(716, 'Train'), ValueTY(717, 'Lorry'), ValueTY(718, 'Ship'), ValueTY(719, 'Plane'), ValueTY(720, 'Car'), ValueTY(721, 'Train'), ValueTY(722, 'Lorry'), ValueTY(723, 'Ship'), ValueTY(724, 'Plane'), ValueTY(725, 'Car'), ValueTY(726, 'Train'), ValueTY(727, 'Lorry'), ValueTY(728, 'Ship'), ValueTY(729, 'Plane'), ValueTY(730, 'Car'), ValueTY(731, 'Train'), ValueTY(732, 'Lorry'), ValueTY(733, 'Ship'), ValueTY(734, 'Plane'), ValueTY(735, 'Car'), ValueTY(736, 'Train'), ValueTY(737, 'Lorry'), ValueTY(738, 'Ship'), ValueTY(739, 'Plane'), ValueTY(740, 'Car'), ValueTY(741, 'Train'), ValueTY(742, 'Lorry'), ValueTY(743, 'Ship'), ValueTY(744, 'Plane'), ValueTY(745, 'Car'), ValueTY(746, 'Train'), ValueTY(747, 'Lorry'), ValueTY(748, 'Ship'), ValueTY(749, 'Plane'), ValueTY(750, 'Car'), ValueTY(751, 'Train'), ValueTY(752, 'Lorry'), ValueTY(753, 'Ship'), ValueTY(754, 'Plane'), ValueTY(755, 'Car'), ValueTY(756, 'Train'), ValueTY(757, 'Lorry'), ValueTY(758, 'Ship'), ValueTY(759, 'Plane'), ValueTY(760, 'Car'), ValueTY(761, 'Train'), ValueTY(762, 'Lorry'), ValueTY(763, 'Ship'), ValueTY(764, 'Plane'), ValueTY(765, 'Car'), ValueTY(766, 'Train'), ValueTY(767, 'Lorry'), ValueTY(768, 'Ship'), ValueTY(769, 'Plane'), ValueTY(770, 'Car'), ValueTY(771, 'Train'), ValueTY(772, 'Lorry'), ValueTY(773, 'Ship'), ValueTY(774, 'Plane'), ValueTY(775, 'Car'), ValueTY(776, 'Train'), ValueTY(777, 'Lorry'), ValueTY(778, 'Ship'), ValueTY(779, 'Plane'), ValueTY(780, 'Car'), ValueTY(781, 'Train'), ValueTY(782, 'Lorry'), ValueTY(783, 'Ship'), ValueTY(784, 'Plane'), ValueTY(785, 'Car'), ValueTY(786, 'Train'), ValueTY(787, 'Lorry'), ValueTY(788, 'Ship'), ValueTY(789, 'Plane'), ValueTY(790, 'Car'), ValueTY(791, 'Train'), ValueTY(792, 'Lorry'), ValueTY(793, 'Ship'), ValueTY(794, 'Plane'), ValueTY(795, 'Car'), ValueTY(796, 'Train'), ValueTY(797, 'Lorry'), ValueTY(798, 'Ship'), ValueTY(799, 'Plane'), ValueTY(800, 'Car'), ValueTY(801, 'Train'), ValueTY(802, 'Lorry'), ValueTY(803, 'Ship'), ValueTY(804, 'Plane'), ValueTY(805, 'Car'), ValueTY(806, 'Train'), ValueTY(807, 'Lorry'), ValueTY(808, 'Ship'), ValueTY(809, 'Plane'), ValueTY(810, 'Car'), ValueTY(811, 'Train'), ValueTY(812, 'Lorry'), ValueTY(813, 'Ship'), ValueTY(814, 'Plane'), ValueTY(815, 'Car'), ValueTY(816, 'Train'), ValueTY(817, 'Lorry'), ValueTY(818, 'Ship'), ValueTY(819, 'Plane'), ValueTY(820, 'Car'), ValueTY(821, 'Train'), ValueTY(822, 'Lorry'), ValueTY(823, 'Ship'), ValueTY(824, 'Plane'), ValueTY(825, 'Car'), ValueTY(826, 'Train'), ValueTY(827, 'Lorry'), ValueTY(828, 'Ship'), ValueTY(829, 'Plane'), ValueTY(830, 'Car'), ValueTY(831, 'Train'), ValueTY(832, 'Lorry'), ValueTY(833, 'Ship'), ValueTY(834, 'Plane'), ValueTY(835, 'Car'), ValueTY(836, 'Train'), ValueTY(837, 'Lorry'), ValueTY(838, 'Ship'), ValueTY(839, 'Plane'), ValueTY(840, 'Car'), ValueTY(841, 'Train'), ValueTY(842, 'Lorry'), ValueTY(843, 'Ship'), ValueTY(844, 'Plane'), ValueTY(845, 'Car'), ValueTY(846, 'Train'), ValueTY(847, 'Lorry'), ValueTY(848, 'Ship'), ValueTY(849, 'Plane'), ValueTY(850, 'Car'), ValueTY(851, 'Train'), ValueTY(852, 'Lorry'), ValueTY(853, 'Ship'), ValueTY(854, 'Plane'), ValueTY(855, 'Car'), ValueTY(856, 'Train'), ValueTY(857, 'Lorry'), ValueTY(858, 'Ship'), ValueTY(859, 'Plane'), ValueTY(860, 'Car'), ValueTY(861, 'Train'), ValueTY(862, 'Lorry'), ValueTY(863, 'Ship'), ValueTY(864, 'Plane'), ValueTY(865, 'Car'), ValueTY(866, 'Train'), ValueTY(867, 'Lorry'), ValueTY(868, 'Ship'), ValueTY(869, 'Plane'), ValueTY(870, 'Car'), ValueTY(871, 'Train'), ValueTY(872, 'Lorry'), ValueTY(873, 'Ship'), ValueTY(874, 'Plane'), ValueTY(875, 'Car'), ValueTY(876, 'Train'), ValueTY(877, 'Lorry'), ValueTY(878, 'Ship'), ValueTY(879, 'Plane'), ValueTY(880, 'Car'), ValueTY(881, 'Train'), ValueTY(882, 'Lorry'), ValueTY(883, 'Ship'), ValueTY(884, 'Plane'), ValueTY(885, 'Car'), ValueTY(886, 'Train'), ValueTY(887, 'Lorry'), ValueTY(888, 'Ship'), ValueTY(889, 'Plane'), ValueTY(890, 'Car'), ValueTY(891, 'Train'), ValueTY(892, 'Lorry'), ValueTY(893, 'Ship'), ValueTY(894, 'Plane'), ValueTY(895, 'Car'), ValueTY(896, 'Train'), ValueTY(897, 'Lorry'), ValueTY(898, 'Ship'), ValueTY(899, 'Plane'), ValueTY(900, 'Car'), ValueTY(901, 'Train'), ValueTY(902, 'Lorry'), ValueTY(903, 'Ship'), ValueTY(904, 'Plane'), ValueTY(905, 'Car'), ValueTY(906, 'Train'), ValueTY(907, 'Lorry'), ValueTY(908, 'Ship'), ValueTY(909, 'Plane'), ValueTY(910, 'Car'), ValueTY(911, 'Train'), ValueTY(912, 'Lorry'), ValueTY(913, 'Ship'), ValueTY(914, 'Plane'), ValueTY(915, 'Car'), ValueTY(916, 'Train'), ValueTY(917, 'Lorry'), ValueTY(918, 'Ship'), ValueTY(919, 'Plane'), ValueTY(920, 'Car'), ValueTY(921, 'Train'), ValueTY(922, 'Lorry'), ValueTY(923, 'Ship'), ValueTY(924, 'Plane'), ValueTY(925, 'Car'), ValueTY(926, 'Train'), ValueTY(927, 'Lorry'), ValueTY(928, 'Ship'), ValueTY(929, 'Plane'), ValueTY(930, 'Car'), ValueTY(931, 'Train'), ValueTY(932, 'Lorry'), ValueTY(933, 'Ship'), ValueTY(934, 'Plane'), ValueTY(935, 'Car'), ValueTY(936, 'Train'), ValueTY(937, 'Lorry'), ValueTY(938, 'Ship'), ValueTY(939, 'Plane'), ValueTY(940, 'Car'), ValueTY(941, 'Train'), ValueTY(942, 'Lorry'), ValueTY(943, 'Ship'), ValueTY(944, 'Plane'), ValueTY(945, 'Car'), ValueTY(946, 'Train'), ValueTY(947, 'Lorry'), ValueTY(948, 'Ship'), ValueTY(949, 'Plane'), ValueTY(950, 'Car'), ValueTY(951, 'Train'), ValueTY(952, 'Lorry'), ValueTY(953, 'Ship'), ValueTY(954, 'Plane'), ValueTY(955, 'Car'), ValueTY(956, 'Train'), ValueTY(957, 'Lorry'), ValueTY(958, 'Ship'), ValueTY(959, 'Plane'), ValueTY(960, 'Car'), ValueTY(961, 'Train'), ValueTY(962, 'Lorry'), ValueTY(963, 'Ship'), ValueTY(964, 'Plane'), ValueTY(965, 'Car'), ValueTY(966, 'Train'), ValueTY(967, 'Lorry'), ValueTY(968, 'Ship'), ValueTY(969, 'Plane'), ValueTY(970, 'Car'), ValueTY(971, 'Train'), ValueTY(972, 'Lorry'), ValueTY(973, 'Ship'), ValueTY(974, 'Plane'), ValueTY(975, 'Car'), ValueTY(976, 'Train'), ValueTY(977, 'Lorry'), ValueTY(978, 'Ship'), ValueTY(979, 'Plane'), ValueTY(980, 'Car'), ValueTY(981, 'Train'), ValueTY(982, 'Lorry'), ValueTY(983, 'Ship'), ValueTY(984, 'Plane'), ValueTY(985, 'Car'), ValueTY(986, 'Train'), ValueTY(987, 'Lorry'), ValueTY(988, 'Ship'), ValueTY(989, 'Plane'), ValueTY(990, 'Car'), ValueTY(991, 'Train'), ValueTY(992, 'Lorry'), ValueTY(993, 'Ship'), ValueTY(994, 'Plane'), ValueTY(995, 'Car'), ValueTY(996, 'Train'), ValueTY(997, 'Lorry'), ValueTY(998, 'Ship'), ValueTY(999, 'Plane')));
-----------------------------------------------------------
-----------------------------------------------------------
----------------------
-- Database Population
-- 1) Dealer Population
CREATE OR REPLACE PROCEDURE populateDealer AS
	id		VARCHAR2(40);		-- primary key
	kind	VARCHAR2(40); 	
	name	VARCHAR2(40);
	phone	VARCHAR2(40);
	mail	VARCHAR2(40);

	zip		NUMBER;
	country	VARCHAR2(40);
	city	VARCHAR2(40);
	street	VARCHAR2(40);

 	temp	VARCHAR2(40);
 	
 	nDealers	NUMBER;
 	batchSize   NUMBER;
  	nBatches    NUMBER;
	iterations	NUMBER;
  	jterations  NUMBER;
  
    CURSOR vNamesCURSOR IS  
      	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='names' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vSurnamesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='surnames' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vCitiesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='cities' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vCountriesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='countries' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vStreetsCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='streets' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;

	BEGIN
		iterations := 0;
		nDealers := 800000;
    	batchSize := 999;
    	nBatches := nDealers / batchSize;
		LOOP
      		jterations := 0;
      		OPEN vNamesCURSOR;
      		OPEN vSurnamesCURSOR;
   			OPEN vCitiesCURSOR;
   			OPEN vCountriesCURSOR;
      		OPEN vStreetsCURSOR;
    		LOOP
        		id := DBMS_RANDOM.STRING('x',10);
        		IF MOD(jterations, 2) = 0 THEN
          			kind := 'seller';
        		ELSE 
          			kind := 'buyer';
        		END IF;
        		FETCH vNamesCURSOR INTO name;
   				FETCH vSurnamesCURSOR INTO temp;
   				mail := CONCAT( CONCAT( CONCAT (name, temp), TRUNC(DBMS_RANDOM.VALUE(70,99),0)) , '@gmail.com');
   				name := CONCAT (CONCAT (name, ' '), temp);
   				phone := TO_CHAR( TRUNC(DBMS_RANDOM.VALUE(1, 10), 9) *1000000000);
    			zip := TRUNC (DBMS_RANDOM.VALUE(10000, 99999), 0);
    			FETCH vCountriesCURSOR INTO country;
    			FETCH vCitiesCURSOR INTO city;
    			FETCH vStreetsCURSOR INTO street;

		        INSERT INTO Dealer VALUES (id, kind, name, phone, mail, AddressTY(zip, country, city, street) );			
        
        		jterations := jterations +1;
      		EXIT WHEN (jterations >= batchSize) or (iterations*batchSize + jterations >= nDealers);
      		END LOOP;
      		CLOSE vNamesCURSOR;
      		CLOSE vSurnamesCURSOR;
   			CLOSE vCitiesCURSOR;
   			CLOSE vCountriesCURSOR;
    		CLOSE vStreetsCURSOR;
    		iterations := iterations +1;
		EXIT WHEN (iterations >= nBatches) or ((iterations-1)*batchSize + jterations >= nDealers);
		END LOOP;

	END populateDealer;
/
-- 2) Shipment Population 
CREATE OR REPLACE PROCEDURE populateShipment AS
	shipmentCode	VARCHAR2(40);		-- primary key
	destination		VARCHAR2(40); 	
	withdrawalDate	DATE;
	deliveryDate	DATE;
	earnings 		NUMBER;
	 	
 	nShipments		NUMBER;
 	batchSize   	NUMBER;
  	nBatches    	NUMBER;
	iterations		NUMBER;
  	jterations  	NUMBER;
    
    CURSOR vCountriesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='countries' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	
	BEGIN
		iterations := 0;
		nShipments := 20;
		batchSize := 999;
		nBatches := nShipments / batchSize;
    	LOOP
    		jterations := 0;
    		OPEN vCountriesCURSOR;
    		LOOP
	    		shipmentCode := DBMS_RANDOM.STRING ('x',10);
	    		FETCH vCountriesCURSOR INTO destination;
	    		withdrawalDate := TO_DATE ( TRUNC( DBMS_RANDOM.VALUE (TO_CHAR (DATE '2019-01-12','J'), TO_CHAR (DATE '2019-01-15','J'))),'J'); 
	    		deliveryDate := TO_DATE ( TRUNC( DBMS_RANDOM.VALUE (TO_CHAR (DATE '2019-01-19','J'), TO_CHAR (DATE '2019-01-25','J'))),'J'); 
       			earnings := TRUNC (DBMS_RANDOM.VALUE(7000,8000),0); 
       		
			    INSERT INTO Shipment VALUES (shipmentCode, destination, withdrawalDate, deliveryDate, earnings );			

			    jterations := jterations +1;
    		EXIT WHEN (jterations = batchSize) or (iterations*batchSize + jterations >= nShipments);
    		END LOOP;
    		CLOSE vCountriesCURSOR;
    		iterations := iterations +1;
		EXIT WHEN (iterations = nBatches) or ((iterations-1)*batchSize + jterations >= nShipments);
		END LOOP;
	END populateShipment;
/
-- 3) PastShipment Population 
CREATE OR REPLACE PROCEDURE populatePastShipment AS
	shipmentCode	VARCHAR2(40);		-- primary key
	destination		VARCHAR2(40); 	
	deliveryDate	DATE;
	withdrawalDate	DATE;
	earnings		NUMBER;
	 	
 	nShipments		NUMBER;
 	batchSize   	NUMBER;
  	nBatches    	NUMBER;
	iterations		NUMBER;
  	jterations  	NUMBER;
    
    CURSOR vCountriesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='countries' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	
	BEGIN
		iterations := 0;
		nShipments := 10000;
		batchSize := 999;
		nBatches := nShipments / batchSize;
    	LOOP
    		jterations := 0;
    		OPEN vCountriesCURSOR;
    		LOOP
	    		shipmentCode := DBMS_RANDOM.STRING ('x',10);
	    		FETCH vCountriesCURSOR INTO destination;
	    		withdrawalDate := TO_DATE ( TRUNC( DBMS_RANDOM.VALUE (TO_CHAR (DATE '2019-01-12','J'), TO_CHAR (DATE '2019-01-15','J'))),'J'); 
	    		deliveryDate := TO_DATE ( TRUNC( DBMS_RANDOM.VALUE (TO_CHAR (DATE '2019-01-19','J'), TO_CHAR (DATE '2019-01-25','J'))),'J'); 
	    		earnings := TRUNC (DBMS_RANDOM.VALUE(7000,8000),0); 
       		
			    INSERT INTO PastShipment VALUES (shipmentCode, destination, deliveryDate, withdrawalDate, earnings );			

			    jterations := jterations +1;
    		EXIT WHEN (jterations = batchSize) or (iterations*batchSize + jterations >= nShipments);
    		END LOOP;
    		CLOSE vCountriesCURSOR;
    		iterations := iterations +1;
		EXIT WHEN (iterations = nBatches) or ((iterations-1)*batchSize + jterations >= nShipments);
		END LOOP;
	END populatePastShipment;
/
-- 4) Centre Population
CREATE OR REPLACE PROCEDURE populateCentre AS 
	id 			NUMBER;
	kind		VARCHAR2(40);
	address		VARCHAR2(40);

    nCentres	NUMBER;
    iterations	NUMBER;

    BEGIN
    	iterations := 0;
    	nCentres := 200;
    	LOOP
    		id := iterations+1;
    		kind := DBMS_RANDOM.STRING('x',10);
    		address := DBMS_RANDOM.STRING('x',10);

    		INSERT INTO Centre VALUES (id, kind, address);

    		iterations := iterations+1;
    	EXIT WHEN iterations >= nCentres;
    	END LOOP;
	END populateCentre;
/
-- 5) Vehicle Population
CREATE OR REPLACE PROCEDURE populateVehicle AS 
	driver 		VARCHAR2(40);
	plate		VARCHAR2(40);
	kind 		VARCHAR2(40);
	costs 		NUMBER;

	temp 		VARCHAR2(40);

	nVehicles	NUMBER;
 	batchSize   NUMBER;
  	nBatches    NUMBER;
    iterations	NUMBER;
    jterations	NUMBER;

	CURSOR vVehiclesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='vehicles' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vNamesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='names' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;
  	CURSOR vSurnamesCURSOR IS  
    	SELECT * FROM (SELECT t.voice FROM Vocabulary v, TABLE(v.vocabols) t WHERE v.semantic='surnames' ORDER BY DBMS_RANDOM.VALUE(1,999)) WHERE ROWNUM<=999;

    BEGIN
     	iterations := 0;
    	nVehicles := 100;
    	batchSize := 999;
		nBatches := nVehicles / batchSize;
    
    	LOOP
    		jterations := 0;
    		OPEN vVehiclesCURSOR;
    		OPEN vNamesCURSOR;
    		OPEN vSurnamesCURSOR;
    		LOOP
    			FETCH vNamesCURSOR INTO driver;
    			FETCH vSurnamesCURSOR INTO temp;
    			driver := CONCAT( CONCAT(driver, ' '), temp);
    			plate := DBMS_RANDOM.STRING ('A',10);
    			FETCH vVehiclesCURSOR into kind;
    			costs := TRUNC( DBMS_RANDOM.VALUE (50, 300), 0);

    			INSERT INTO Vehicle VALUES (driver, plate, kind, costs);

    			jterations := jterations+1;
    		EXIT WHEN (jterations = batchSize) or (iterations*batchSize + jterations >= nVehicles);
    		END LOOP;
    		CLOSE vVehiclesCURSOR;
    		CLOSE vNamesCURSOR;
    		CLOSE vSurnamesCURSOR;
    		iterations := iterations+1;
    	EXIT WHEN iterations >= nBatches;
    	END LOOP;
	END populateVehicle;
/
-- 6) Item Population
CREATE OR REPLACE PROCEDURE populateItem AS
	shippingCode	VARCHAR2(40);		-- primary key
	content			VARCHAR2(40); 	
	insurance		NUMBER;
	
	width 		NUMBER;
	length 		NUMBER;
	height		NUMBER;
	weight		NUMBER;

	rSeller		REF DealerTY;
	rBuyer		REF DealerTY;
	rShipment 	REF ShipmentTY;

 	temp	VARCHAR2(40);
 	
 	nItems		NUMBER;
 	iterations	NUMBER;
  
    CURSOR sellerCURSOR IS  
      	SELECT REF(d) FROM Dealer d WHERE d.kind='seller';
  	CURSOR buyerCURSOR IS  
      	SELECT REF(d) FROM Dealer d WHERE d.kind='buyer';
  	CURSOR shipmentCURSOR IS  
      	SELECT REF(s) FROM Shipment s;
  	
	BEGIN
		iterations := 0;
		nItems := 3500;
    	OPEN sellerCURSOR;
    	OPEN buyerCURSOR;
    	OPEN shipmentCURSOR;
    	LOOP
     		shippingCode := DBMS_RANDOM.STRING('x',10);
       		content := DBMS_RANDOM.STRING ('x',20);
       		insurance := TRUNC (DBMS_RANDOM.VALUE (0,50),0);
       		width := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		length := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		height := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		weight := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		FETCH sellerCURSOR INTO rSeller;
       		FETCH buyerCURSOR INTO rBuyer;
       		IF MOD (iterations, 175) = 0 THEN
       			FETCH shipmentCURSOR INTO rShipment;
       		END IF;
		    
		    INSERT INTO Item VALUES (shippingCode, content, insurance, DimensionsTY (width, length, height, weight), rSeller, rBuyer, rShipment );			
        
    		iterations := iterations +1;
		EXIT WHEN iterations >= nItems;
		END LOOP;
		CLOSE sellerCURSOR;
		CLOSE buyerCURSOR;
		CLOSE shipmentCURSOR;
	END populateItem;
/
-- 7) PastItem Population 
CREATE OR REPLACE PROCEDURE populatePastItem AS
	shippingCode	VARCHAR2(40);		-- primary key
	content			VARCHAR2(40); 	
	insurance		NUMBER;

	width 		NUMBER;
	length 		NUMBER;
	height		NUMBER;
	weight		NUMBER;

	rSeller			REF DealerTY;
	rBuyer			REF DealerTY;
	rPastShipment	REF PastShipmentTY;
	
 	nPastItems	NUMBER;
 	iterations	NUMBER;
    
  	CURSOR sellerCURSOR IS  
      	SELECT REF(d) FROM Dealer d WHERE d.kind='seller';
  	CURSOR buyerCURSOR IS  
      	SELECT REF(d) FROM Dealer d WHERE d.kind='buyer';
    CURSOR pastShipmentCURSOR IS  
      	SELECT REF(ps) FROM PastShipment ps;
  	BEGIN
		iterations := 0;
		nPastItems := 1600000;
    	OPEN pastShipmentCURSOR;
    	OPEN sellerCURSOR;
    	OPEN buyerCURSOR;
    	LOOP
     		shippingCode := DBMS_RANDOM.STRING ('x',10);
       		content := DBMS_RANDOM.STRING ('x',20);
       		insurance := TRUNC (DBMS_RANDOM.VALUE (0,50),0);
       		width := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		length := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		height := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		weight := TRUNC (DBMS_RANDOM.VALUE(4,20),0);
       		IF MOD (iterations, 2)=0 THEN
       			FETCH sellerCURSOR INTO rSeller;
       			FETCH buyerCURSOR INTO rBuyer;
       		END IF; 
       		IF MOD (iterations, 160)=0 THEN
       			FETCH pastShipmentCURSOR INTO rPastShipment;
       		END IF; 

		    INSERT INTO PastItem VALUES (shippingCode, content, insurance, DimensionsTY(width, length, height, weight), rSeller, rBuyer, null, rPastShipment);			

    		iterations := iterations +1;
		EXIT WHEN iterations >= nPastItems;
		END LOOP;
    	CLOSE sellerCURSOR;
    	CLOSE buyerCURSOR;
		CLOSE pastShipmentCURSOR;
	END populatePastItem;
/
-- 8) Event Population
CREATE OR REPLACE PROCEDURE populateEvent AS 
	id 			NUMBER;
	kind		VARCHAR2(40);
	rVehicle	REF VehicleTY;
	rShipment 	REF ShipmentTY;
	rCentre 	REF CentreTY;

    nEvents		NUMBER;
 	batchSize   NUMBER;
  	nBatches    NUMBER;
    iterations	NUMBER;
    jterations	NUMBER;

	CURSOR vehicleCURSOR IS 
  		SELECT REF(v), v.kind FROM Vehicle v;
  	CURSOR shipmentCURSOR IS
  		SELECT REF(s) FROM Shipment s;
  	CURSOR centreCURSOR IS
  		SELECT REF(c) FROM Centre c;
    
    BEGIN
    	iterations := 0;
    	nEvents := 100;
    	batchSize := 1000;
		nBatches := nEvents / batchSize;
    
    	LOOP
    		jterations := 0;
    		OPEN vehicleCURSOR;
    		OPEN shipmentCURSOR;
    		OPEN centreCURSOR;
    		LOOP
    			id := (iterations*batchSize)+jterations+1;
    			FETCH vehicleCURSOR INTO rVehicle, kind; 
    			IF MOD(id, 5)=1 THEN
    				FETCH shipmentCURSOR INTO rShipment;
    				FETCH centreCURSOR INTO rCentre;
    			END IF;

    			INSERT INTO Event VALUES (id, kind, rVehicle, rShipment, rCentre);

    			jterations := jterations+1;
    		EXIT WHEN (jterations = batchSize) or (iterations*batchSize + jterations >= nEvents);
    		END LOOP;
    		CLOSE vehicleCURSOR;
    		CLOSE shipmentCURSOR;
    		CLOSE centreCURSOR;
    		iterations := iterations+1;
    	EXIT WHEN iterations >= nBatches;
    	END LOOP;
	END populateEvent;
/
-- 9) Route Population
CREATE OR REPLACE PROCEDURE populateRoute AS 
	id 			NUMBER;
	stamp		DATE;
	latitude	NUMBER(9,6);
	longitude	NUMBER(9,6);
	rEvent		REF EventTY;

	nRoutes		NUMBER;
	iterations 	NUMBER;

	CURSOR eventCURSOR IS
  		SELECT REF(e) FROM Event e;
    
    BEGIN
    	iterations := 0;
    	nRoutes := 14400;
    	OPEN eventCURSOR;
    	LOOP
    		id := iterations+1;
    		stamp := TO_DATE ( TRUNC ( DBMS_RANDOM.VALUE (TO_CHAR (DATE '2019-01-14','J'), TO_CHAR (DATE '2019-01-17','J'))),'J'); 
    		latitude := TRUNC(DBMS_RANDOM.VALUE(-180, 180),6); 
    		longitude := TRUNC(DBMS_RANDOM.VALUE(-180, 180),6); 
    		IF MOD(iterations, 144)=0 THEN
    			FETCH eventCURSOR INTO rEvent;
    		END IF;
   			
   			INSERT INTO Route VALUES (id, stamp, PositionTY(latitude, longitude), rEvent);

    		iterations := iterations+1;
    	EXIT WHEN iterations >= nRoutes;
    	END LOOP;
    	CLOSE eventCURSOR;
	END populateRoute;
/
-- Population execution
exec populateDealer;
exec populateShipment;
exec populatePastShipment;
exec populateCentre;
exec populateVehicle;
exec populateItem;
exec populatePastItem;
exec populateEvent;
exec populateRoute;
-----------------------------------------------------------
----------------------
-- Implementation of CRUD Operations
-- (create)
CREATE OR REPLACE PROCEDURE createDealer (kind IN VARCHAR2, name IN VARCHAR2, phone IN VARCHAR2, mail IN VARCHAR2, zip IN NUMBER, country IN VARCHAR2, city IN VARCHAR2, street IN VARCHAR2) AS
    id 	VARCHAR2(40);
    BEGIN
    	id := DBMS_RANDOM.STRING('x', 10);
    	INSERT INTO Dealer VALUES (id, kind, name, phone, mail, AddressTY (zip, country, city, street) );
	END createDealer;
/
CREATE OR REPLACE PROCEDURE createShipment (destination IN VARCHAR2, withdrawalDate IN VARCHAR2, deliveryDate IN VARCHAR2 ) AS
    shipmentCode 	VARCHAR2(40);
    BEGIN
    	shipmentCode := DBMS_RANDOM.STRING('x', 10);
    	INSERT INTO Shipment VALUES (shipmentCode, destination, TO_DATE(withdrawalDate), TO_DATE(deliveryDate), 0);
    END createShipment;
/
CREATE OR REPLACE PROCEDURE createCentre (kind IN VARCHAR2, address IN VARCHAR2) AS
	CURSOR centreCURSOR IS
		SELECT MAX(id) FROM Centre;
	id 		NUMBER;
    BEGIN
    	OPEN centreCURSOR;
    	FETCH centreCURSOR INTO id;
    	CLOSE centreCURSOR;
    	id := id+1;
    	INSERT INTO Centre VALUES (id, kind, address);
    END createCentre;
/
CREATE OR REPLACE PROCEDURE createVehicle (driver IN VARCHAR2, plate IN VARCHAR2, kind IN VARCHAR2, costs IN NUMBER) AS
    BEGIN
    	INSERT INTO Vehicle VALUES (driver, plate, kind, costs);
    END createVehicle;
/
CREATE OR REPLACE PROCEDURE createItem (content IN VARCHAR2, insurance IN VARCHAR2, width IN NUMBER, length IN NUMBER, height IN NUMBER, weight IN NUMBER, idSeller IN VARCHAR2, idBuyer IN VARCHAR2) AS
	CURSOR sellerCURSOR IS
		SELECT REF(d) FROM Dealer d WHERE d.id = idSeller;
	CURSOR buyerCURSOR IS
		SELECT REF(d) FROM Dealer d WHERE d.id = idBuyer;
	shippingCode 	VARCHAR2(40);
	rSeller			REF DealerTY;
	rBuyer			REF DealerTY;
	BEGIN
		shippingCode := DBMS_RANDOM.STRING('x', 10);
		OPEN sellerCURSOR;
		FETCH sellerCURSOR INTO rSeller;
		CLOSE sellerCURSOR;
		OPEN buyerCURSOR;
		FETCH buyerCURSOR INTO rBuyer;
		CLOSE buyerCURSOR;
    	INSERT INTO Item VALUES (shippingCode, content, insurance, DimensionsTY(width, length, height, weight), rSeller, rBuyer, null);
    END createItem;
/
CREATE OR REPLACE PROCEDURE createEvent (kind IN VARCHAR2, driver IN VARCHAR2, shipmentCode IN VARCHAR2, addressCentre IN NUMBER) AS
	id 			NUMBER;
	rVehicle	REF VehicleTY;
	rShipment	REF ShipmentTY;
	rCentre		REF CentreTY;
	CURSOR eventCURSOR IS 
		SELECT MAX(id) FROM Event;
	CURSOR vehicleCURSOR IS 
		SELECT REF(v) FROM Vehicle v WHERE v.driver = driver; 
	CURSOR shipmentCURSOR IS 
		SELECT REF(s) FROM Shipment s WHERE s.shipmentCode = shipmentCode; 
	CURSOR centreCURSOR IS 
		SELECT REF(c) FROM Centre c WHERE c.address = addressCentre; 

	BEGIN
		OPEN eventCURSOR;
		FETCH eventCURSOR INTO id;
		CLOSE eventCURSOR;
		OPEN vehicleCURSOR;
		FETCH vehicleCURSOR INTO rVehicle;
		CLOSE vehicleCURSOR;
		id := id+1;
		OPEN shipmentCURSOR;
		FETCH shipmentCURSOR INTO rShipment;
		CLOSE shipmentCURSOR;
		OPEN centreCURSOR;
		FETCH centreCURSOR INTO rCentre;
		CLOSE centreCURSOR;
    	INSERT INTO Event VALUES (id, kind, rVehicle, rShipment, rCentre);
    END createEvent;
/
CREATE OR REPLACE PROCEDURE createRoute (latitude IN NUMBER, longitude IN NUMBER, shipmentCode IN VARCHAR2) AS
	id 		NUMBER;
	rEvent 	REF EventTY;
	CURSOR routeCURSOR IS 
		SELECT MAX(id) FROM Route; 
	CURSOR eventCURSOR IS
		SELECT REF(e), MAX(e.id) FROM Event e WHERE e.shipment.shipmentCode = shipmentCode; 
	BEGIN
		OPEN eventCURSOR;
		FETCH eventCURSOR INTO rEvent, id;
		CLOSE eventCURSOR;    	
    	OPEN routeCURSOR;
		FETCH routeCURSOR INTO id;
		CLOSE routeCURSOR;
		INSERT INTO Route VALUES (id, CURRENT_DATE, PositionTY(latitude, longitude) , rEvent);
    END createRoute;
/
-- (read)
CREATE TABLE tempDealer (anything NUMBER);
CREATE TABLE tempShipment (anything NUMBER);
CREATE TABLE tempPastShipment (anything NUMBER);
CREATE TABLE tempCentre (anything NUMBER);
CREATE TABLE tempVehicle (anything NUMBER);
CREATE TABLE tempItem (anything NUMBER);
CREATE TABLE tempPastItem (anything NUMBER);
CREATE TABLE tempEvent (anything NUMBER);
CREATE TABLE tempRoute (anything NUMBER);

CREATE OR REPLACE PROCEDURE readDealer (id IN VARCHAR2, kind IN VARCHAR2, name IN VARCHAR2, phone IN VARCHAR2, mail IN VARCHAR2, zip IN NUMBER, country IN VARCHAR2, city IN VARCHAR2, street IN VARCHAR2) AS
  	command VARCHAR2(1000);
  	BEGIN
	    EXECUTE IMMEDIATE 'DROP TABLE tempDealer';
    	command := 'CREATE TABLE tempDealer AS SELECT * FROM Dealer d WHERE ';
	    IF NOT (id IS NULL) THEN
    	    command := CONCAT( CONCAT ( CONCAT (command, 'd.ID LIKE '''), id), ''' AND ');
	    END IF;
    	IF NOT (kind IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.KIND LIKE '''), kind), ''' AND ');
	    END IF;
    	IF NOT (name IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.NAME LIKE '''), name), ''' AND ');
	    END IF;
    	IF NOT (phone IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.PHONE LIKE '''), phone), ''' AND ');
	    END IF;
    	IF NOT (mail IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.MAIL LIKE '''), mail), ''' AND ');
	    END IF;
    	IF NOT (zip = -1) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.ADDRESS.ZIP LIKE '''), zip), ''' AND ');
	    END IF;
    	IF NOT (country IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.ADDRESS.COUNTRY LIKE '''), country), ''' AND ');
	    END IF;
    	IF NOT (city IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.ADDRESS.CITY LIKE '''), city), ''' AND ');
	    END IF;
    	IF NOT (street IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'd.ADDRESS.STREET LIKE '''), street), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
	    EXECUTE IMMEDIATE command;
	END readDealer;
/
CREATE OR REPLACE PROCEDURE readShipment (shipmentCode IN VARCHAR2, destination IN VARCHAR2, withdrawalDate IN VARCHAR2, deliveryDate IN VARCHAR2, earnings IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempShipment';
	    command := 'CREATE TABLE tempShipment AS SELECT * FROM Shipment s WHERE ';
    	IF NOT (shipmentCode IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 's.SHIPMENTCODE LIKE '''), shipmentCode), ''' AND ');
	    END IF;
    	IF NOT (destination IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 's.DESTINATION LIKE '''), destination), ''' AND ');
	    END IF;
    	IF NOT (withdrawalDate IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 's.WITHDRAWALDATE LIKE '''), TO_DATE(withdrawalDate)), ''' AND ');
	    END IF;
    	IF NOT (deliveryDate IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 's.DELIVERYDATE LIKE '''), TO_DATE(deliveryDate)), ''' AND ');
    	END IF;
    	IF NOT (earnings = -1) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 's.EARNINGS LIKE '''), earnings), ''' AND ');
    	END IF;
	    command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readShipment;
/
CREATE OR REPLACE PROCEDURE readPastShipment (shipmentCode IN VARCHAR2, destination IN VARCHAR2, withdrawalDate IN DATE, deliveryDate IN DATE, earnings IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempPastShipment';
	    command := 'CREATE TABLE tempPastShipment AS SELECT * FROM PastShipment ps WHERE ';
    	IF NOT (shipmentCode IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'ps.SHIPMENTCODE LIKE '''), shipmentCode), ''' AND ');
	    END IF;
    	IF NOT (destination IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'ps.DESTINATION LIKE '''), destination), ''' AND ');
	    END IF;
    	IF NOT (withdrawalDate IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'ps.WITHDRAWALDATE LIKE '''), withdrawalDate), ''' AND ');
	    END IF;
    	IF NOT (deliveryDate IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'ps.DELIVERYDATE LIKE '''), deliveryDate), ''' AND ');
	    END IF;
    	IF NOT (earnings = -1) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'ps.EARNINGS LIKE '''), earnings), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readPastShipment;
/
CREATE OR REPLACE PROCEDURE readCentre (id IN NUMBER, kind IN VARCHAR2, address IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempCentre';
    	command := 'CREATE TABLE tempCentre AS SELECT * FROM Centre c WHERE ';
    	IF NOT (id = -1) THEN
       		command := CONCAT( CONCAT ( CONCAT (command, 'c.ID LIKE '''), id), ''' AND ');
    	END IF;
    	IF NOT (kind IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'c.KIND LIKE '''), kind), ''' AND ');
    	END IF;
	    IF NOT (address IS NULL) THEN
    	    command := CONCAT( CONCAT ( CONCAT (command, 'c.ADDRESS LIKE '''), address), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readCentre;
/
CREATE OR REPLACE PROCEDURE readVehicle (driver IN VARCHAR2, plate IN VARCHAR2, kind IN VARCHAR2, costs IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempVehicle';
    	command := 'CREATE TABLE tempVehicle AS SELECT * FROM Vehicle v WHERE ';
    	IF NOT (driver IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'v.DRIVER LIKE '''), driver), ''' AND ');
	    END IF;
    	IF NOT (plate IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'v.PLATE LIKE '''), plate), ''' AND ');
	    END IF;
    	IF NOT (kind IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'v.KIND LIKE '''), kind), ''' AND ');
	    END IF;
    	IF NOT (costs= -1) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'v.COSTS LIKE '''), costs), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
	    EXECUTE IMMEDIATE command;
	END readVehicle;
/
CREATE OR REPLACE PROCEDURE readItem (shippingCode IN VARCHAR2, content IN VARCHAR2, sellerName IN VARCHAR2, buyerName IN VARCHAR2, shipmentCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempItem';
    	command := 'CREATE TABLE tempItem AS SELECT * FROM Item WHERE ';
	    IF NOT (shippingCode IS NULL) THEN
    	    command := CONCAT( CONCAT ( CONCAT (command, 'SHIPPINGCODE LIKE '''), shippingCode), ''' AND ');
	    END IF;
    	IF NOT (content IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'CONTENT LIKE '''), content), ''' AND ');
	    END IF;
    	IF NOT (sellerName IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'SELLER.NAME LIKE '''), sellerName), ''' AND ');
	    END IF;
    	IF NOT (buyerName IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'BUYER.NAME LIKE '''), buyerName), ''' AND ');
	    END IF;
    	IF NOT (shipmentCode IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'SHIPMENT.SHIPMENTCODE LIKE '''), shipmentCode), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readItem;
/
CREATE OR REPLACE PROCEDURE readPastItem (shippingCode IN VARCHAR2, content IN VARCHAR2, pastShipmentCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempPastItem';
    	command := 'CREATE TABLE tempPastItem AS SELECT * FROM PastItem pi WHERE ';
    	IF NOT (shippingCode IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'pi.SHIPPINGCODE LIKE '''), shippingCode), ''' AND ');
    	END IF;
    	IF NOT (content IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'pi.CONTENT LIKE '''), content), ''' AND ');
    	END IF;
    	IF NOT (pastShipmentCode IS NULL) THEN
	        command := CONCAT( CONCAT ( CONCAT (command, 'pi.PASTSHIPMENT.SHIPMENTCODE LIKE '''), pastShipmentCode), ''' AND ');
    	END IF;
	    command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readPastItem;
/
CREATE OR REPLACE PROCEDURE readEvent (kind IN VARCHAR2, driver IN VARCHAR2, shipmentCode IN VARCHAR2, idCentre IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempEvent';
	    command := 'CREATE TABLE tempEvent AS SELECT * FROM Event e WHERE ';
    	IF NOT (kind IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'e.KIND LIKE '''), kind), ''' AND ');
	    END IF;
    	IF NOT (driver IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'e.VEHICLE.DRIVER LIKE '''), driver), ''' AND ');
	    END IF;
    	IF NOT (shipmentCode IS NULL) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'e.SHIPMENT.SHIPMENTCODE LIKE '''), shipmentCode), ''' AND ');
	    END IF;
    	IF NOT (idCentre = -1) THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'e.CENTRE.ID LIKE '''), idCentre), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
    	EXECUTE IMMEDIATE command;
	END readEvent;
/
CREATE OR REPLACE PROCEDURE readRoute (shipmentCode IN VARCHAR2, kindEvent IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	EXECUTE IMMEDIATE 'DROP TABLE tempRoute';
	    command := 'CREATE TABLE tempRoute AS SELECT * FROM Route r WHERE ';
    	IF NOT ((shipmentCode IS NULL) OR (kindEvent IS NULL))  THEN
        	command := CONCAT( CONCAT ( CONCAT (command, 'r.EVENT.SHIPMENT.SHIPMENTCODE LIKE '''), shipmentCode), ''' AND ');
        	command := CONCAT( CONCAT ( CONCAT (command, 'r.EVENT.KIND LIKE '''), kindEvent), ''' AND ');
	    END IF;
    	command := CONCAT (command, '1=1');
	    EXECUTE IMMEDIATE command;
	END readRoute;
/
--(update)
CREATE OR REPLACE PROCEDURE updateDealer (id IN VARCHAR2, kind IN VARCHAR2, name IN VARCHAR2, phone IN VARCHAR2, mail IN VARCHAR2, zip IN NUMBER, country IN VARCHAR2, city IN VARCHAR2, street IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	command := 'UPDATE Dealer d SET ';
	    IF (kind IS NULL) THEN
    	    command := CONCAT (command, 'd.KIND=d.KIND, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.KIND='''), kind), ''', ');
	    END IF;
    	IF (name IS NULL) THEN
        	command := CONCAT (command, 'd.NAME=d.NAME, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.NAME='''), name), ''', ');
	    END IF;
    	IF (phone IS NULL) THEN
        	command := CONCAT (command, 'd.PHONE=d.PHONE, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.PHONE='''), phone), ''', ');
	    END IF;
    	IF (mail IS NULL) THEN
        	command := CONCAT (command, 'd.MAIL=d.MAIL, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.MAIL='''), mail), ''', ');
	    END IF;
    	IF (zip = -1) THEN
        	command := CONCAT (command, 'd.ADDRESS.ZIP=d.ADDRESS.ZIP, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.ADDRESS.ZIP='''), zip), ''', ');
	    END IF;
    	IF (country IS NULL) THEN
        	command := CONCAT (command, 'd.ADDRESS.COUNTRY=d.ADDRESS.COUNTRY, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.ADDRESS.COUNTRY='''), country), ''', ');
	    END IF;
    	IF (city IS NULL) THEN
        	command := CONCAT (command, 'd.ADDRESS.CITY=d.ADDRESS.CITY, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.ADDRESS.CITY='''), city), ''', ');
	    END IF;
    	IF (street IS NULL) THEN
        	command := CONCAT (command, 'd.ADDRESS.STREET=d.ADDRESS.STREET ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'd.ADDRESS.STREET='''), street), ''' ');
	    END IF;
    	command := CONCAT( CONCAT ( CONCAT (command, 'WHERE d.ID='''), id), '''');
	    EXECUTE IMMEDIATE command;
	END updateDealer;
/
CREATE OR REPLACE PROCEDURE updateShipment (shipmentCode IN VARCHAR2, destination IN VARCHAR2, withdrawalDate IN VARCHAR2, deliveryDate IN VARCHAR2, earnings IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	command := 'UPDATE Shipment s SET ';
	    IF (destination IS NULL) THEN
    	    command := CONCAT (command, 's.DESTINATION=s.DESTINATION, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 's.DESTINATION='''), destination), ''', ');
	    END IF;
    	IF (withdrawalDate IS NULL) THEN
        	command := CONCAT (command, 's.WITHDRAWALDATE=s.WITHDRAWALDATE, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 's.WITHDRAWALDATE='''), TO_DATE(withdrawalDate)), ''', ');
	    END IF;
    	IF (deliveryDate IS NULL) THEN
        	command := CONCAT (command, 's.DELIVERYDATE=s.DELIVERYDATE, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 's.DELIVERYDATE='''), TO_DATE(deliveryDate)), ''', ');
	    END IF;
    	IF (earnings = -1) THEN
        	command := CONCAT (command, 's.EARNINGS=s.EARNINGS ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 's.EARNINGS='''), earnings), ''' ');
	    END IF;
    	command := CONCAT( CONCAT ( CONCAT (command, 'WHERE s.SHIPMENTCODE='''), shipmentCode), '''');
    	EXECUTE IMMEDIATE command;
	END updateShipment;
/
CREATE OR REPLACE PROCEDURE updateCentre (id IN NUMBER, kind IN VARCHAR2, address IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
    	command := 'UPDATE Centre c SET ';
	    IF (kind IS NULL) THEN
    	    command := CONCAT (command, 'c.KIND=c.KIND, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'c.KIND='''), kind), ''', ');
	    END IF;
    	IF (address IS NULL) THEN
        	command := CONCAT (command, 'c.ADDRESS=c.ADDRESS ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'c.ADDRESS='''), address), ''' ');
	    END IF;
	    command := CONCAT( CONCAT ( CONCAT (command, 'WHERE c.ID='''), id), '''');
    	EXECUTE IMMEDIATE command;
	END updateCentre;
/
CREATE OR REPLACE PROCEDURE updateVehicle (driver IN VARCHAR2, plate IN VARCHAR2, kind IN VARCHAR2, costs IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
    	command := 'UPDATE Vehicle v SET ';
	    IF (driver IS NULL) THEN
    	    command := CONCAT (command, 'v.DRIVER=v.DRIVER, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'v.DRIVER='''), driver), ''', ');
	    END IF;
    	IF (kind IS NULL) THEN
        	command := CONCAT (command, 'v.KIND=v.KIND, ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'v.KIND='''), kind), ''', ');
	    END IF;
    	IF (costs = -1) THEN
        	command := CONCAT (command, 'v.COSTS=v.COSTS ');
	    ELSE
    	    command := CONCAT( CONCAT( CONCAT (command, 'v.COSTS='''), costs), ''' ');
	    END IF;
    	command := CONCAT( CONCAT ( CONCAT (command, 'WHERE v.PLATE='''), plate), '''');
    	EXECUTE IMMEDIATE command;
	END updateVehicle;
/
CREATE OR REPLACE PROCEDURE updateItem (shippingCode IN VARCHAR2, content IN VARCHAR2, insurance IN NUMBER, width IN NUMBER, length IN NUMBER, height IN NUMBER, weight IN NUMBER, idSeller IN VARCHAR2, idBuyer IN VARCHAR2, shipmentCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	CURSOR sellerCURSOR IS 
		SELECT REF(d) FROM Dealer d WHERE d.id = idSeller;
	CURSOR buyerCURSOR IS 
		SELECT REF(d) FROM Dealer d WHERE d.id = idBuyer;
	CURSOR shipmentCURSOR IS 
		SELECT REF(s) FROM Shipment s WHERE s.shipmentCode = shipmentCode;
    CURSOR itemCURSOR IS
		select SUM(i.calculateCosts()) from Item i where i.shipment.shipmentCode = shipmentCode;
	rSeller		REF DealerTY;
	rBuyer		REF DealerTY;
	rShipment	REF ShipmentTY;
	earnings 	NUMBER;
	BEGIN
    	command := 'UPDATE Item i SET ';
	    IF (content IS NULL) THEN
    	    command := CONCAT (command, 'i.CONTENT=i.CONTENT, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.CONTENT='''), content), ''', ');
    	END IF;
	    IF (insurance = -1) THEN
    	    command := CONCAT (command, 'i.INSURANCE=i.INSURANCE, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.INSURANCE='''), insurance), ''', ');
    	END IF;
	    IF (width = -1) THEN
    	    command := CONCAT (command, 'i.DIMENSIONS.WIDTH=i.DIMENSIONS.WIDTH, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.DIMENSIONS.WIDTH='''), width), ''', ');
    	END IF;
	    IF (length = -1) THEN
    	    command := CONCAT (command, 'i.DIMENSIONS.LENGTH=i.DIMENSIONS.LENGTH, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.DIMENSIONS.LENGTH='''), length), ''', ');
    	END IF;
	    IF (height = -1) THEN
    	    command := CONCAT (command, 'i.DIMENSIONS.HEIGHT=i.DIMENSIONS.HEIGHT, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.DIMENSIONS.HEIGHT='''), height), ''', ');
    	END IF;
	    IF (weight = -1) THEN
    	    command := CONCAT (command, 'i.DIMENSIONS.WEIGHT=i.DIMENSIONS.WEIGHT, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'i.DIMENSIONS.WEIGHT='''), weight), ''', ');
    	END IF;
		IF NOT (idSeller IS NULL) THEN
	    	OPEN sellerCURSOR;
	    	FETCH sellerCURSOR INTO rSeller;
	    	CLOSE sellerCURSOR;
        	UPDATE Item i SET i.seller = rSeller WHERE i.shippingCode = shippingCode;
    	END IF;
	    IF NOT (idBuyer IS NULL) THEN
	    	OPEN buyerCURSOR;
	    	FETCH buyerCURSOR INTO rBuyer;
	    	CLOSE buyerCURSOR;
        	UPDATE Item i SET i.buyer = rBuyer WHERE i.buyer = buyer;
    	END IF;
	    IF NOT(shipmentCode IS NULL) THEN
	    	OPEN shipmentCURSOR;
	    	FETCH shipmentCURSOR INTO rShipment;
	    	CLOSE shipmentCURSOR;
        	UPDATE Item i SET i.shipment = rShipment WHERE i.shippingCode = shippingCode;
	    	OPEN itemCURSOR;
	    	FETCH itemCURSOR INTO earnings;
	    	CLOSE itemCURSOR;
        	UPDATE Shipment s SET s.earnings = earnings WHERE s.shipmentCode = shipmentCode;
    	END IF;
	    command := CONCAT( CONCAT ( CONCAT (command, 'WHERE i.SHIPPINGCODE='''), shippingCode), '''');
    	EXECUTE IMMEDIATE command;
	END updateItem;
/
CREATE OR REPLACE PROCEDURE updateEvent (idEvent NUMBER, kind IN VARCHAR2, driver IN VARCHAR2, shipmentCode IN VARCHAR2, addressCentre IN VARCHAR2) AS
	command VARCHAR2(1000);
	CURSOR vehicleCURSOR IS 
		SELECT REF(v) FROM Vehicle v WHERE v.driver = driver;
	CURSOR shipmentCURSOR IS 
		SELECT REF(s) FROM Shipment s WHERE s.shipmentCode = shipmentCode;
	CURSOR centreCURSOR IS 
		SELECT REF(c) FROM Centre c WHERE c.address = addressCentre;
	rVehicle		REF VehicleTY;
	rShipment		REF ShipmentTY;
	rCentre			REF CentreTY;
	BEGIN
    	command := 'UPDATE Event e SET ';
	    IF (kind IS NULL) THEN
    	    command := CONCAT (command, 'e.KIND=e.KIND ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'e.KIND='''), kind), ''' ');
    	END IF;
	    IF NOT(driver IS NULL) THEN
	    	OPEN vehicleCURSOR;
	    	FETCH vehicleCURSOR INTO rVehicle;
	    	CLOSE vehicleCURSOR;
        	UPDATE Event e SET e.vehicle = rVehicle WHERE e.id = idEvent;
    	END IF;
	    IF NOT(shipmentCode IS NULL) THEN
	    	OPEN shipmentCURSOR;
	    	FETCH shipmentCURSOR INTO rShipment;
	    	CLOSE shipmentCURSOR;
        	UPDATE Event e SET e.shipment = rShipment WHERE e.id = idEvent;
    	END IF;
	    IF NOT(addressCentre IS NULL) THEN
	    	OPEN centreCURSOR;
	    	FETCH centreCURSOR INTO rCentre;
	    	CLOSE centreCURSOR;
        	UPDATE Event e SET e.centre = rCentre WHERE e.id = idEvent;
    	END IF;
	    command := CONCAT( CONCAT ( CONCAT (command, 'WHERE e.ID='''), idEvent), '''');
    	EXECUTE IMMEDIATE command;
	END updateEvent;
/
CREATE OR REPLACE PROCEDURE updateRoute (idRoute IN NUMBER, stamp IN DATE, latitude IN NUMBER, longitude IN NUMBER, idEvent IN NUMBER) AS
	command VARCHAR2(1000);
	CURSOR eventCURSOR IS 
		SELECT REF(e) FROM Event e WHERE e.id = idEvent;
	rEvent		REF EventTY;
	BEGIN
    	command := 'UPDATE Route r SET ';
	    IF (stamp IS NULL) THEN
    	    command := CONCAT (command, 'r.STAMP=r.STAMP, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'r.STAMP='''), stamp), ''', ');
    	END IF;
    	IF (latitude = -1) THEN
    	    command := CONCAT (command, 'r.POSITION.LATITUDE=r.POSITION.LATITUDE, ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'r.POSITION.LATITUDE='''), latitude), ''', ');
    	END IF;
    	IF (longitude = -1) THEN
    	    command := CONCAT (command, 'r.POSITION.LONGITUDE=r.POSITION.LONGITUDE ');
	    ELSE
        	command := CONCAT( CONCAT( CONCAT (command, 'r.POSITION.LONGITUDE='''), longitude), ''' ');
    	END IF;
    	IF NOT(idEvent = -1) THEN
	    	OPEN eventCURSOR;
	    	FETCH eventCURSOR INTO rEvent;
	    	CLOSE eventCURSOR;
        	UPDATE Route e SET e.event = rEvent WHERE e.id = idRoute;
    	END IF;
	    command := CONCAT( CONCAT ( CONCAT (command, 'WHERE ID='''), idRoute), '''');
    	EXECUTE IMMEDIATE command;
	END updateRoute;
/
--(delete)
CREATE OR REPLACE PROCEDURE deleteDealer (idDealer IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Dealer d WHERE d.id = idDealer;
	END deleteDealer;
/
CREATE OR REPLACE PROCEDURE deleteShipment (shipmentCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Shipment s WHERE s.shipmentCode = shipmentCode;
	END deleteShipment;
/
CREATE OR REPLACE PROCEDURE deletePastShipment (shipmentCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM PastShipment s WHERE s.shipmentCode = shipmentCode;
	END deletePastShipment;
/
CREATE OR REPLACE PROCEDURE deleteCentre (idCentre IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Centre c WHERE c.id = idCentre;
	END deleteCentre;
/
CREATE OR REPLACE PROCEDURE deleteVehicle (plate IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Vehicle v WHERE v.plate = plate;
	END deleteVehicle;
/
CREATE OR REPLACE PROCEDURE deleteItem (shippingCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Item i WHERE i.shippingCode = shippingCode;
	END deleteItem;
/
CREATE OR REPLACE PROCEDURE deletePastItem (shippingCode IN VARCHAR2) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM PastItem i WHERE i.shippingCode = shippingCode;
	END deletePastItem;
/
CREATE OR REPLACE PROCEDURE deleteEvent (idEvent IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Event e WHERE e.id = idEvent;
	END deleteEvent;
/
CREATE OR REPLACE PROCEDURE deleteRoute (idRoute IN NUMBER) AS
	command VARCHAR2(1000);
	BEGIN
		DELETE FROM Route r WHERE r.id = idRoute;
	END deleteRoute;
/
-- Implementation of Custom Operations 
-- Operation 1 Implementation 
CREATE OR REPLACE PROCEDURE collectItem (content IN VARCHAR2, insurance IN NUMBER, width IN NUMBER, length IN NUMBER, height IN NUMBER, weight IN NUMBER, idSeller IN VARCHAR2, idBuyer IN VARCHAR2) AS
	BEGIN
		createItem(content, insurance, width, length, height, weight, idSeller, idBuyer);
	END collectItem;
/
-- Operation 2 Implementation 
CREATE TABLE TrackItem (anything NUMBER);
CREATE OR REPLACE PROCEDURE trackAnItem (shippingCode IN VARCHAR2) AS
    command VARCHAR2(1000);
  BEGIN
		EXECUTE IMMEDIATE 'DROP TABLE TrackItem';
		command := 'CREATE TABLE TrackItem AS ';
    command := CONCAT (command, 'SELECT r.event.id AS idEvent, r.event.kind AS kindEvent, r.stamp AS stampRoute, r.position.latitude AS latitudeRoute, r.position.longitude AS longitudeRoute ');
    command := CONCAT (command, 'FROM Route r ');
    command := CONCAT (command, 'WHERE r.event.shipment=(SELECT i.shipment FROM Item i WHERE i.shippingCode =''');
    command := CONCAT ( CONCAT (command, shippingCode), ''')');
    command := CONCAT (command, 'ORDER BY idEvent, stampRoute');
    EXECUTE IMMEDIATE command;
	END trackAnItem;
/
-- Operation 3 Implementation
CREATE OR REPLACE PROCEDURE addTransportationEvent (kind IN VARCHAR2, driver IN VARCHAR2, shipmentCode IN VARCHAR2, addressCentre IN NUMBER) AS
	BEGIN
		createEvent(kind, driver, shipmentCode, addressCentre);
	END addTransportationEvent;
/
-- Operation 4 Implementation 
CREATE OR REPLACE PROCEDURE addPosition (latitude IN NUMBER, longitude IN NUMBER, shipmentCode IN VARCHAR2) AS
	BEGIN
		createRoute(latitude, longitude, shipmentCode);
	END addPosition;
/
-- Operation 5 Implementation 
CREATE TABLE WeeklyReport (id NUMBER, stamp DATE, averageDays NUMBER, nShipments NUMBER, earnings NUMBER, vehicleMaintenance NUMBER, total NUMBER);
ALTER TABLE WeeklyReport ADD CONSTRAINT uWeeklyReport UNIQUE (stamp);
CREATE OR REPLACE PROCEDURE produceWeeklyReport AS
	id 				NUMBER;
	averageDays 	NUMBER;
	nShipments 		NUMBER;
	earnings 		NUMBER;
	vehicleMaintenance 	NUMBER;
	total			NUMBER;
	CURSOR reportCURSOR IS
		SELECT COUNT(*) FROM WeeklyReport;
	CURSOR shipmentCURSOR IS
		SELECT AVG(s.calculatePassedTime()), COUNT(*), SUM(s.earnings) FROM Shipment s;
	CURSOR vehicleCURSOR IS
		SELECT SUM(v.costs) FROM Vehicle v;
	BEGIN
		OPEN reportCURSOR;
		FETCH reportCURSOR INTO id;
		CLOSE reportCURSOR;
		id := id+1;
		OPEN shipmentCURSOR;
		FETCH shipmentCURSOR INTO averageDays, nShipments, earnings;
		CLOSE shipmentCURSOR;
		OPEN vehicleCURSOR;
		FETCH vehicleCURSOR INTO vehicleMaintenance;
		CLOSE vehicleCURSOR;
		vehicleMaintenance := 0 - vehicleMaintenance;
		total := earnings + vehicleMaintenance;
		INSERT INTO WeeklyReport VALUES (id, TRUNC(CURRENT_DATE), averageDays, nShipments, earnings, vehicleMaintenance, total);
	END produceWeeklyReport;
/
-- Index Implementation
CREATE INDEX trackItemRouteINDEX         ON Route (id, stamp);

-- Triggers Implementation 
CREATE OR REPLACE TRIGGER verifyDealerKindTRIGGER       -- kind = {buyer, seller}
	BEFORE INSERT OR UPDATE ON Dealer
	FOR EACH ROW
	BEGIN
		IF NOT((:new.kind = 'seller') OR (:new.kind = 'buyer')) THEN
			RAISE_APPLICATION_ERROR(20501, 'Value for the attribute kind should be one of the set {seller, buyer}.');
		END IF;
	END verifyDealerKindTRIGGER;
/
CREATE OR REPLACE TRIGGER verifyShipmentDatesTRIGGER      -- deliveryDate > withdrawalDate
	BEFORE INSERT OR UPDATE ON Shipment
	FOR EACH ROW
	BEGIN
		IF (:new.withdrawalDate > :new.deliveryDate) THEN
			RAISE_APPLICATION_ERROR(20502, 'Value for the attribute withdrawalDate should be lower than that for the attribute deliveryDate.');
		END IF;
	END verifyShipmentDatesTRIGGER;
/
CREATE OR REPLACE TRIGGER verifyPastShipmentDatesTRIGGER      -- deliveryDate > withdrawalDate
	BEFORE INSERT OR UPDATE ON PastShipment
	FOR EACH ROW
	BEGIN
		IF (:new.withdrawalDate > :new.deliveryDate) THEN
			RAISE_APPLICATION_ERROR(20502, 'Value for the attribute withdrawalDate should be lower than that for the attribute deliveryDate.');
		END IF;
	END verifyPastShipmentDatesTRIGGER;
/
CREATE OR REPLACE TRIGGER verifyLatLongRouteTRIGGER       -- latitude and longitude in [-180, +180]
	BEFORE INSERT OR UPDATE ON Route
	FOR EACH ROW
	BEGIN
		IF ((:new.position.latitude > 180) OR (:new.position.latitude < 180)) OR ((:new.position.longitude > 180) OR (:new.position.longitude < 180)) THEN
			RAISE_APPLICATION_ERROR(20503, 'Latitude and longitude are values expressed in a range of [-180,+180].');
		END IF;
	END verifyLatLongRouteTRIGGER;
/
CREATE OR REPLACE TRIGGER delShipmentStatTRIGGER	   -- shipment is deleted => events, items are deleted, pastshipment is created, pastitem are updated
	AFTER DELETE ON Shipment 
	BEGIN
		DELETE FROM Event e WHERE e.shipment IS DANGLING;
		DELETE FROM Item i WHERE i.shipment IS DANGLING;
	END delShipmentStatTRIGGER;
/
CREATE OR REPLACE TRIGGER delShipmentRowTRIGGER	   -- shipment is deleted => events, items are deleted, pastshipment is created, pastitem are updated
	AFTER DELETE ON Shipment 
	FOR EACH ROW
	DECLARE
		rPastShipment 		REF PastShipmentTY;
	BEGIN
		INSERT INTO PastShipment VALUES (:old.shipmentCode, :old.destination, :old.withdrawalDate, :old.deliveryDate, :old.earnings);
		SELECT REF(ps) INTO rPastShipment FROM PastShipment ps WHERE ps.shipmentCode = :old.shipmentCode;
		UPDATE PastItem pi SET pi.pastShipment = rPastShipment WHERE pi.pastShipment IS DANGLING;
	END delShipmentRowTRIGGER;
/
CREATE OR REPLACE TRIGGER delPastShipmentStatTRIGGER	   -- pastshipment is deleted => pastitems are deleted
	AFTER DELETE ON PastShipment
	BEGIN
		DELETE PastItem pi WHERE pi.pastShipment IS DANGLING;
	END delPastShipmentStatTRIGGER;
/
CREATE OR REPLACE TRIGGER delCentreRowTRIGGER	       -- centre is deleted => event centres are nulled
	AFTER DELETE ON Centre
	FOR EACH ROW
	BEGIN
		UPDATE Event e SET e.centre = NULL WHERE e.centre.id = :old.id;
	END delCentreRowTRIGGER;
/
CREATE OR REPLACE TRIGGER delVehicleRowTRIGGER	   -- vehicle is deleted => event vehicles are nulled
	AFTER DELETE ON Vehicle
	FOR EACH ROW
	BEGIN
		UPDATE Event e SET e.vehicle = NULL WHERE e.vehicle.plate = :old.plate;
	END delVehicleRowTRIGGER;
/
CREATE OR REPLACE TRIGGER delItemRowTRIGGER	   -- item is deleted => pastitem is generated
	AFTER DELETE ON Item
	FOR EACH ROW
	BEGIN
		INSERT INTO PastItem VALUES(:new.shippingCode, :new.content, :new.insurance, :new.dimensions, :new.seller, :new.buyer, null, null);
	END delItemRowTRIGGER;
/
CREATE OR REPLACE TRIGGER delEventStatTRIGGER	   -- event is deleted => routes are deleted
	AFTER DELETE ON Event
	BEGIN
		DELETE FROM Route r WHERE r.event IS DANGLING;  
	END delEventStatTRIGGER;
/







