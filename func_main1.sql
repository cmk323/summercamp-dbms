-- main function for Q1.sql
-- default: capacity_input = 70

DECLARE
    nearest_name Activities.aname%type;
BEGIN
    nearest_name := nearest_activity(70);
    dbms_output.put_line('Name of nearest activity: ' || nearest_name);
END;
/
	
