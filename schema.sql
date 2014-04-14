-- contacts.sqlite3
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
-- apparently ON DELETE CASCADE doesn't actually deliver...
CREATE TRIGGER IF NOT EXISTS purge_metadata BEFORE DELETE ON names
    FOR EACH ROW BEGIN
        DELETE FROM metadata WHERE metadata.id = old.id;
    END;
