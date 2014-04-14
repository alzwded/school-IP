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
