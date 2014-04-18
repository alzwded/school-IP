-- renumber ID column to be sequential
BEGIN TRANSACTION ;
CREATE TEMPORARY TABLE tRENUMBER (
    newid INTEGER PRIMARY KEY AUTOINCREMENT,
    oldid INTEGER)
    ;
INSERT INTO tRENUMBER (oldid)
    SELECT (id) from refs
    ;
UPDATE refs SET id = ( SELECT newid FROM tRENUMBER WHERE oldid = refs.id );
DROP TABLE tRENUMBER ;
COMMIT TRANSACTION ;
