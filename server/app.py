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
    # Create a cursor object using the connection
    cursor = conn.cursor()

    try:
        # Construct the SQL query to get all table names
        query = """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
        """

        # Execute the query to get all table names
        cursor.execute(query)

        # Fetch all table names from the result set
        table_names = cursor.fetchall()

        # Return the list of table names
        return [table_name[0] for table_name in table_names]

    finally:
        # Close the cursor
        cursor.close()


@app.route("/")
def health_check():
    return "OK"


@app.route("/tournament", methods=["GET"])
def tournament():
    return "OK"


@app.route("/db", methods=["GET"])
def db():
    conn = psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host="postgres",  # Use service name as hostname
        port=5432,
    )

    results = select_all_from_table(conn, "users")
    # results = list_all_tables(conn)
    return jsonify(results)
