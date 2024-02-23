-- TODO: define your table schemas here --

-- Create test table
CREATE TABLE IF NOT EXISTS test (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert dummy data into test table
INSERT INTO test (username) VALUES
    ('user1'),
    ('user2'),
    ('user3');