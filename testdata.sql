DELETE FROM names ;
DELETE FROM metadata ;

INSERT INTO names
    ( id, first_name, last_name, date_of_birth )
    VALUES
    ( 1, 'ion' , 'popescu' , DATE('1990-01-13') ),
    ( 2, 'george' , 'ionescu' , DATE('1991-04-01') )
    ;

INSERT INTO metadata
    ( id, metadata_type, data )
    VALUES
    ( 1, 'mobile1', '+40700123456' ),
    ( 1, 'email', 'ion.popescu@example.com' ),
    ( 2, 'mobile1', '+40700234567' )
    ;
