-- function that takes a capacity as an argument and returns 
-- the activity that is the nearest to 50% of the given capacity.
-- If there is a tie in activities, pick the activity with the lowest price.
-- If there is still a tie, pick the one with the highest activity id.
-- returns the name of the nearest activity
	
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION nearest_activity(capacity_input IN NUMBER)
RETURN Activities.aname%type IS

    instance Activities%ROWTYPE;            -- variable for cursor data
    nearest Activities%ROWTYPE;             -- track nearest activity
    half_cap NUMBER(2) := capacity_input/2; -- 50% input capacity
    diff NUMBER(3);                         -- difference in capcity
    nearest_name Activities.aname%type;     -- name of nearest activity

    CURSOR curs IS
    SELECT * FROM Activities;

BEGIN          
    diff := 100;    -- default difference

    OPEN curs;
    LOOP
        FETCH curs INTO instance;
        -- compare 50% of input capacity to current instance capacity 
        IF ABS(half_cap - instance.capacity) < diff THEN
            -- update difference in capacity and current nearest
            diff := ABS(half_cap - instance.capacity);  
            nearest := instance;
        -- tiebreakers
        ELSIF ABS(half_cap - instance.capacity) = diff THEN
            IF instance.price < nearest.price THEN
                nearest := instance;
            ELSIF instance.price = nearest.price THEN
                IF instance.aid > nearest.aid THEN
                    nearest := instance;
                END IF;
            END IF;
        END IF;
        nearest_name := nearest.aname;
        EXIT WHEN curs%NOTFOUND;
    END LOOP;      
    CLOSE curs;
    RETURN nearest_name;
END;   
/

