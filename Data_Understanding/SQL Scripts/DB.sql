-- Database: football_db

-- DROP DATABASE IF EXISTS football_db;

CREATE DATABASE football_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE football_db
    IS 'Raw data for play by play';

GRANT TEMPORARY, CONNECT ON DATABASE football_db TO PUBLIC;

GRANT ALL ON DATABASE football_db TO javen_user;


GRANT ALL ON DATABASE football_db TO postgres;