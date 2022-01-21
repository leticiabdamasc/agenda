CREATE TABLE alarm(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    alarmDateTime TEXT NOT NULL,
    gradientColorIndex INTEGER
);

CREATE TABLE anotacao(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT,
    img TEXT,
    dataTime TEXT
);