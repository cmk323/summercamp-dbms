-- main function for Q2.sql
-- default: camper_id = 1, activity_id = 123

DECLARE
    camper_id Campers.cid%type;
BEGIN
    camper_id := register_camper(1, 123);
    dbms_output.put_line('Camper ID of registered camper:  ' || camper_id);
END;
/

