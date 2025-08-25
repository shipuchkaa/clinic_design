CREATE TRIGGER trig
AFTER INSERT ON Analyses_has_patient
FOR EACH ROW
BEGIN
    IF NEW.result LIKE '%_bad' 
       AND NEW.d  NOW() - INTERVAL 2 DAY THEN
        IF NOT apply_appointment(NEW.patient_id) THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Could not set appointment';
        END IF;
    END IF;
END;