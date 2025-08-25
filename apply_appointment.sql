CREATE FUNCTION apply_appointment(patient INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE surgery_service_id INT;
    DECLARE surgeon_id INT;
    DECLARE room_id INT;

    SELECT id 
    INTO surgery_service_id 
    FROM Services 
    WHERE name = 'surgery';

    SELECT d.id 
    INTO surgeon_id
    FROM Doctors d 
    WHERE d.speciality = 'surgeon' 
      AND NOT EXISTS (
          SELECT 1 
          FROM Appointment 
          WHERE date != NOW() 
            AND doctors_id = d.id
      )
    LIMIT 1;

    SELECT r.id
    INTO room_id
    FROM Rooms_has_equipment re
         JOIN Equipment e ON e.id = re.equipment_id
         JOIN Rooms r ON r.id = re.rooms_id
    WHERE r.type = 'surgery' 
      AND e.state = 1
    LIMIT 1;

    IF surgeon_id IS NOT NULL 
       AND room_id IS NOT NULL THEN
        INSERT INTO Appointment (date, created_at, doctors_id, rooms_id, patient_id, services_id)
        VALUES (NOW(), NOW(), surgeon_id, room_id, patient, surgery_service_id);

        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;