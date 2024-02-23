from flask import Flask, jsonify
import psycopg2
import os
import json
import datetime as dt

app = Flask(__name__)


def select_all_from_table(conn, table_name):
    # Create a cursor object using the connection
    cursor = conn.cursor()

    try:
        # Construct the SQL query
        query = f"SELECT * FROM {table_name};"
        cursor.execute(query)
        rows = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]

        results = []
        for row in rows:
            result = {}
            for i, value in enumerate(row):
                result[column_names[i]] = (
                    value
                    if type(value) != dt.datetime
                    else value.strftime("%d-%m-%Y %H:%M:%S")
                )
            results.append(result)

        return json.dumps(results)

    finally:
        cursor.close()


def list_all_tables(conn):
    cursor = conn.cursor()

    try:
        query = """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
        """

        cursor.execute(query)
        table_names = cursor.fetchall()

        return [table_name[0] for table_name in table_names]

    finally:
        cursor.close()


def list_all_roles(conn):
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT rolname FROM pg_catalog.pg_roles;")
        rows = cursor.fetchall()
        roles = [row[0] for row in rows]

        return roles

    except psycopg2.Error as e:
        print("Error fetching roles:", e)

    finally:
        cursor.close()
        conn.close()


@app.route("/")
def health_check():
    return "OK"


@app.route("/db-test", methods=["GET"])
def db():
    conn = psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host="postgres",  # Use service name as hostname
        port=5432,
    )

    test_table_users = select_all_from_table(conn, "test")
    tables = list_all_tables(conn)
    roles = list_all_roles(conn)
    return jsonify({"test_data": test_table_users, "tables": tables, "roles": roles})
