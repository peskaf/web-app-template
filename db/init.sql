-- Create database roles and grant permissions
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles 
        WHERE rolname = 'admin_private'
    ) THEN
        CREATE ROLE admin_private LOGIN PASSWORD 'password_admin_private';
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles 
        WHERE rolname = 'admin_public'
    ) THEN
        CREATE ROLE admin_public LOGIN PASSWORD 'password_admin_public';
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles 
        WHERE rolname = 'read_user'
    ) THEN
        CREATE ROLE read_user LOGIN PASSWORD 'password_read_user';
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles 
        WHERE rolname = 'write_user'
    ) THEN
        CREATE ROLE write_user LOGIN PASSWORD 'password_write_user';
    END IF;
END
$$;

-- Grant appropriate permissions to each role
-- Admin private role (for server management only)
GRANT ALL PRIVILEGES ON DATABASE dikyfotbalu TO admin_private;

-- Public admin role (for publicly working with the database)
GRANT CONNECT ON DATABASE dikyfotbalu TO admin_public;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_public;

-- Read user role (for read-only access)
GRANT CONNECT ON DATABASE dikyfotbalu TO read_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_user;

-- Write user role (for write access)
GRANT CONNECT ON DATABASE dikyfotbalu TO write_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO write_user;

-- Create a table for storing user information
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some dummy data into the users table
INSERT INTO users (username, email, password_hash) VALUES
    ('user1', 'user1@example.com', 'password_hash_1'),
    ('user2', 'user2@example.com', 'password_hash_2'),
    ('user3', 'user3@example.com', 'password_hash_3');
