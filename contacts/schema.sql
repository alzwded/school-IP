-- contacts.sqlite3
PRAGMA foreign_keys = TRUE ;
CREATE TABLE IF NOT EXISTS names (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(40) NULL,
    last_name VARCHAR(40) NULL,
    date_of_birth DATE NULL
    );
CREATE TABLE IF NOT EXISTS metadata (
    id INTEGER,
    metadata_type VARCHAR(20) NOT NULL,
    data TEXT,
    FOREIGN KEY (id) REFERENCES names(id) ON DELETE CASCADE,
    PRIMARY KEY (id, metadata_type)
    );
-- NOTE: PRAGMA foreign_keys = TRUE ; solves this issue,
--       but it needs to be enabled per each connection.
--       Sadly, this is isn't possible on the fpc version I use to
--       compile this turkey because a transaction is always open
--       and that PRAGMA within a transactino is a no-op.
--       However, it became an option for the TSQLite3Connection
--       object in fpc 2.7.1. So, one day we will be able to
--       delete this turkey.
--       
-- apparently ON DELETE CASCADE doesn't actually deliver...
CREATE TRIGGER IF NOT EXISTS purge_metadata BEFORE DELETE ON names
    FOR EACH ROW BEGIN
        DELETE FROM metadata WHERE metadata.id = old.id;
    END;
