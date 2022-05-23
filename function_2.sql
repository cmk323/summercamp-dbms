Q2final.sql

-- function where given a camper id and activity id, will enroll
-- the camper in the specified activity
-- returns the resulting registration

SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION enroll_camper(camper_id IN NUMBER, activity_id IN NUMBER)
RETURN Registration%ROWTYPE IS

    this_camper Campers%ROWTYPE;        -- specified camper
    this_activity Activities%ROWTYPE;   -- specified activity
    campers_instance Campers%ROWTYPE;   -- variable for camper cursor data 
    result Registration%ROWTYPE;        -- result of registration
    condition BOOLEAN;                  -- zipcode condition (shares zipcode)
    mean_age Campers.age%type;          -- mean age of campers in this activity 

    CURSOR curs_campers IS
    SELECT * FROM Campers c WHERE c.cid IN (
            SELECT r.cid FROM Registration r WHERE r.aid = activity_id
    );

    CURSOR curs_registration IS
    SELECT * FROM Registration r WEHRE r.aid = activity_id AND r.cid = camper_id;

BEGIN
    condition := true;      -- default: shared zipcode

    -- get the mean age of campers in this activity
    SELECT AVG(age) INTO mean_age FROM Campers c, Registration r WHERE
        c.cid = r.cid AND r.aid = activity_id;
    -- store information of specified camper
    SELECT * INTO this_camper FROM Campers c WHERE c.cid = camper_id;
    -- store specified activity 
    SELECT * INTO this_activity FROM Activities a WHERE a.aid = activity_id;

    -- if camper's age is greater than or equal to 50% of mean age of other 
    -- campers registered for this activity, check zipcode
    IF (this_camper.age >= mean_age/2) THEN
        OPEN curs_campers;
        LOOP
            FETCH curs_campers INTO campers_instance;
            IF (this_camper.zipcode = campers_instance.zipcode) THEN
                condition := false;
            END IF;
            EXIT WHEN curs_campers%NOTFOUND;
        END LOOP;
        CLOSE curs_campers;
    -- if this camper shares a zipcode with another camper in the activity 
    -- and is less than 50% mean age of campers in this activity
    ELSIF (this_camper.age < mean_age/2) THEN
        OPEN curs_campers;
        LOOP
            FETCH curs_campers INTO campers_instance;
            -- create new activity with half price and double capacity 
            IF (this_camper.zipcode = campers_instance.zipcode) THEN
                INSERT INTO Activities VALUES(this_activity.aid + 1,
                    this_activity.aname, (this_activity.price)/2,
                    (this_activity.capacity)*2);
                -- add the registration to the result    
                OPEN curs_registration;
                FETCH curs_registration INTO result;
                CLOSE curs_registration;
            END IF;
            EXIT WHEN curs_campers%NOTFOUND;
            EXIT WHEN curs_registration%NOTFOUND;
        END LOOP;
    END IF;
    CLOSE curs_campers;
    -- if zipcode condition is met, register the camper in the original activity
    IF (condition = true) THEN
        INSERT INTO Registration VALUES(camper_id, activity_id);
        -- add the registration to the result    
        OPEN curs_registration;
        FETCH curs_registration INTO result;
        CLOSE curs_registration;
    END IF;
    RETURN result;
END;
/