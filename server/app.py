from flask import Flask


app = Flask(__name__)


@app.route("/")
def health_check():
    return "OK"


@app.route("/tournament", methods=["GET"])
def tournament():
    return "OK"
