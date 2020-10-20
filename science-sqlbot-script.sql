
----------------------------------------Створення таблиць--------------------------------------
-- Table: Category

CREATE TABLE Category
(
    ID VARCHAR(1) NOT NULL
    ,Title VARCHAR(50) NOT NULL
    ,PRIMARY KEY (ID)
);

-- Table: PlatformType

CREATE TABLE PlatformType
(
    ID INT GENERATED ALWAYS AS IDENTITY
    ,Title VARCHAR(50) NOT NULL
    ,IsActive boolean
    ,PRIMARY KEY (ID)
);

-- Table: Discipline

CREATE TABLE Discipline
(
    ID INT NOT NULL
    , Title VARCHAR(100) NOT NULL
    ,PRIMARY KEY (ID)
);

-- Table: Specialization

CREATE TABLE Specialization
(
    ID INT NOT NULL
    , DisciplineID INT NOT NULL
    , Title VARCHAR(100) NOT NULL
    , PRIMARY KEY (ID)
    , CONSTRAINT fk_Discipline
        FOREIGN KEY(DisciplineID)
	    REFERENCES Discipline(ID)
);

-- Table: ScienceEdition

CREATE TABLE ScienceEdition
(
    ID INT GENERATED ALWAYS AS IDENTITY
    , EditionTitle VARCHAR(500) NOT NULL
    , Owners VARCHAR(500)
    , SpecializationID INT NOT NULL
    , IntroDate date
    , CategoryID char NOT NULL
    , PRIMARY KEY (ID)
    , CONSTRAINT fk_Category
        FOREIGN KEY(CategoryID)
	    REFERENCES Category(ID)
    , CONSTRAINT fk_Specialization
        FOREIGN KEY(SpecializationID)
	    REFERENCES Specialization(ID)	
);


-- Table: SciencePlatform

CREATE TABLE SciencePlatform
(
    ID INT GENERATED ALWAYS AS IDENTITY
    , PlatformTitle VARCHAR(50) NOT NULL
    , DisciplineID INT NOT NULL
    , PlatformTypeID INT NOT NULL
    , PlatformURL VARCHAR(255) NOT NULL
    , PRIMARY KEY (ID)
    , CONSTRAINT fk_Discipline
        FOREIGN KEY(DisciplineID)
	    REFERENCES Discipline(ID)
    , CONSTRAINT fk_PlatformType
        FOREIGN KEY(PlatformTypeID)
	    REFERENCES PlatformType(ID )
);

-----------------------------------------Вставка данних -------------------------------
INSERT INTO public.category (id, title) VALUES
('A', 'Web of Science Core Collection/ Scopus')
, ('Б', 'Other');

INSERT INTO public.platformtype (title, isactive) VALUES
('website', true)
, ('facebook', true)
, ('telegram', true)
, ('twitter', true)
, ('youtube', true);

COPY discipline FROM 'D:/tables/discipline.csv' CSV HEADER DELIMITER ',';
COPY scienceplatform FROM 'D:/tables/scienceplatform.csv' CSV HEADER DELIMITER ',';
COPY specialization FROM 'D:/tables/specialization.csv' CSV HEADER DELIMITER ',';
COPY scienceedition FROM 'D:/tables/scienceedition.csv' CSV HEADER DELIMITER ',';
------------------------------Зовнішні запити для бота-------------------------------------
{
  "userName": "	{{dbUserName}}",
  "password": "{{dbPassword}}",
  "host": "{{dbHost}}",
  "port": {{dbPort}},
  "db": "{{dbDataBase}}",
  "query": "SELECT * FROM scienceedition WHERE specializationid = '{{input_specializationid}}' LIMIT 5"
}

{
  "userName": "	{{dbUserName}}",
  "password": "{{dbPassword}}",
  "host": "{{dbHost}}",
  "port": {{dbPort}},
  "db": "{{dbDataBase}}",
  "query": "SELECT  sp.platformtitle, sp.platformurl FROM scienceplatform as sp 
		JOIN discipline ON discipline.id = sp.disciplineid
	WHERE discipline.title = '{{input_discipline}}' LIMIT 5"
}