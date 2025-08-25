CREATE TABLE IF NOT EXISTS doctors
(
    id          INT         NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(45) NOT NULL,
    second_name VARCHAR(45) NOT NULL,
    patronymic  VARCHAR(45) NULL,
    speciality  VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS rooms
(
    id   INT         NOT NULL AUTO_INCREMENT,
    num  INT         NOT NULL,
    type VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS patient
(
    id          INT         NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(45) NOT NULL,
    second_name VARCHAR(45) NOT NULL,
    patronymic  VARCHAR(45) NULL,
    birth_date  TIMESTAMP   NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS services
(
    id       INT         NOT NULL AUTO_INCREMENT,
    name     VARCHAR(90) NOT NULL,
    cost     FLOAT       NOT NULL DEFAULT 0,
    duration INT         NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS appointment
(
    id          INT          NOT NULL AUTO_INCREMENT,
    date        TIMESTAMP NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    doctors_id  INT          NOT NULL,
    rooms_id    INT          NOT NULL,
    patient_id  INT          NOT NULL,
    result      LONGTEXT     NULL,
    services_id INT          NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_apointment_doctors1
        FOREIGN KEY (doctors_id)
            REFERENCES clinic.doctors (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_apointment_rooms1
        FOREIGN KEY (rooms_id)
            REFERENCES clinic.rooms (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_apointment_patient1
        FOREIGN KEY (patient_id)
            REFERENCES clinic.patient (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_appointment_services1
        FOREIGN KEY (services_id)
            REFERENCES clinic.services (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE INDEX fk_apointment_doctors1_idx ON appointment (doctors_id ASC);

CREATE INDEX fk_apointment_rooms1_idx ON appointment (rooms_id ASC);

CREATE INDEX fk_apointment_patient1_idx ON appointment (patient_id ASC);

CREATE INDEX fk_appointment_services1_idx ON appointment (services_id ASC);


-- -----------------------------------------------------
-- Table clinic.equipment
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.equipment
(
    id           INT         NOT NULL AUTO_INCREMENT,
    name         VARCHAR(45) NOT NULL,
    state        TINYINT     NOT NULL,
    manufacturer VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table clinic.illnesses
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.illnesses
(
    id   INT         NOT NULL AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table clinic.medication
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.medication
(
    id           INT         NOT NULL AUTO_INCREMENT,
    name         VARCHAR(45) NOT NULL,
    manufacturer VARCHAR(45) NOT NULL,
    available    VARCHAR(45) NOT NULL,
    prescription VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table clinic.illnesses_has_medication
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.illnesses_has_medication
(
    illnesses_id  INT         NOT NULL,
    medication_id INT         NOT NULL,
    dosage        VARCHAR(45) NOT NULL,
    PRIMARY KEY (illnesses_id, medication_id),
    CONSTRAINT fk_illnesses_has_medication_illnesses1
        FOREIGN KEY (illnesses_id)
            REFERENCES clinic.illnesses (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_illnesses_has_medication_medication1
        FOREIGN KEY (medication_id)
            REFERENCES clinic.medication (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

CREATE INDEX fk_illnesses_has_medication_medication1_idx ON clinic.illnesses_has_medication (medication_id ASC);

CREATE INDEX fk_illnesses_has_medication_illnesses1_idx ON clinic.illnesses_has_medication (illnesses_id ASC);


-- -----------------------------------------------------
-- Table clinic.patient_has_illnesses
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.patient_has_illnesses
(
    patient_id   INT NOT NULL,
    illnesses_id INT NOT NULL,
    PRIMARY KEY (patient_id, illnesses_id),
    CONSTRAINT fk_patient_has_illnesses_patient1
        FOREIGN KEY (patient_id)
            REFERENCES clinic.patient (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_patient_has_illnesses_illnesses1
        FOREIGN KEY (illnesses_id)
            REFERENCES clinic.illnesses (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


CREATE INDEX fk_patient_has_illnesses_illnesses1_idx ON clinic.patient_has_illnesses (illnesses_id ASC);

CREATE INDEX fk_patient_has_illnesses_patient1_idx ON clinic.patient_has_illnesses (patient_id ASC);


-- -----------------------------------------------------
-- Table clinic.analyses
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.analyses
(
    id       INT         NOT NULL AUTO_INCREMENT,
    type     VARCHAR(45) NOT NULL,
    material VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
)
    ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table clinic.analyses_has_patient
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.analyses_has_patient
(
    analyses_id INT         NOT NULL,
    patient_id  INT         NOT NULL,
    result      VARCHAR(45) NOT NULL,
    PRIMARY KEY (analyses_id, patient_id),
    CONSTRAINT fk_analyses_has_patient_analyses1
        FOREIGN KEY (analyses_id)
            REFERENCES clinic.analyses (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_analyses_has_patient_patient1
        FOREIGN KEY (patient_id)
            REFERENCES clinic.patient (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

CREATE INDEX fk_analyses_has_patient_patient1_idx ON clinic.analyses_has_patient (patient_id ASC);

CREATE INDEX fk_analyses_has_patient_analyses1_idx ON clinic.analyses_has_patient (analyses_id ASC);


-- -----------------------------------------------------
-- Table clinic.rooms_has_equipment
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clinic.rooms_has_equipment
(
    rooms_id     INT NOT NULL,
    equipment_id INT NOT NULL,
    PRIMARY KEY (rooms_id, equipment_id),
    CONSTRAINT fk_rooms_has_equipment_rooms1
        FOREIGN KEY (rooms_id)
            REFERENCES clinic.rooms (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_rooms_has_equipment_equipment1
        FOREIGN KEY (equipment_id)
            REFERENCES clinic.equipment (id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

CREATE INDEX fk_rooms_has_equipment_equipment1_idx ON clinic.rooms_has_equipment (equipment_id ASC);

CREATE INDEX fk_rooms_has_equipment_rooms1_idx ON clinic.rooms_has_equipment (rooms_id ASC);

