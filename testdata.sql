DELETE FROM names ;
DELETE FROM metadata ;

INSERT INTO names
    ( id, first_name, last_name, date_of_birth )
    VALUES
    ( 1, 'ion' , 'popescu' , DATE('1990-01-13') ),
    ( 2, 'george' , 'ionescu' , DATE('1991-04-01') ),
    ( 3, 'ionut' , 'popescu' , DATE('1990-01-13') ),
    ( 4, 'alexandru' , 'ionescu' , DATE('1989-07-01') )
    ;

INSERT INTO metadata
    ( id, metadata_type, data )
    VALUES
    ( 1, 'mobil', '+40700123456' ),
    ( 1, 'email', 'ion.popescu@example.com' ),
    ( 2, 'mobil', '+40700234567' ),
    ( 3, 'mobil', '+40700123456' ),
    ( 3, 'fix', '+40700123456' ),
    ( 4, 'email', 'ion.popescu.2@example.com' ),
    ( 4, 'mobil', '+40700234567' )
    ;
