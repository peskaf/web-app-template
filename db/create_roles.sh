#!/bin/bash
set -e

create_roles() {
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        DO \$\$
        BEGIN
            IF NOT EXISTS (
                SELECT FROM pg_catalog.pg_roles 
                WHERE rolname = 'admin_user'
            ) THEN
                CREATE ROLE admin_user LOGIN PASSWORD '$ADMIN_USER_PASSWORD';
				GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO admin_user;
				GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO admin_user;
            END IF;
        END
        \$\$;

        DO \$\$
        BEGIN
            IF NOT EXISTS (
                SELECT FROM pg_catalog.pg_roles 
                WHERE rolname = 'read_write_user'
            ) THEN
                CREATE ROLE read_write_user LOGIN PASSWORD '$READ_WRITE_USER_PASSWORD';
				GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO read_write_user;
				GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO read_write_user;
            END IF;
        END
        \$\$;

        DO \$\$
        BEGIN
            IF NOT EXISTS (
                SELECT FROM pg_catalog.pg_roles 
                WHERE rolname = 'read_user'
            ) THEN
                CREATE ROLE read_user LOGIN PASSWORD '$READ_USER_PASSWORD';
				GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO read_user;
				GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_user;
            END IF;
        END
        \$\$;

        DO \$\$
        BEGIN
            IF NOT EXISTS (
                SELECT FROM pg_catalog.pg_roles 
                WHERE rolname = 'write_user'
            ) THEN
                CREATE ROLE write_user LOGIN PASSWORD '$WRITE_USER_PASSWORD';
				GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO write_user;
				GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO write_user;
            END IF;
        END
        \$\$;
EOSQL
}

create_roles
