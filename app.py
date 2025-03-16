from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import os
import mysql.connector

app = Flask(__name__)
CORS(app)

MESSAGE_FILE = "messages.json"


if not os.path.exists(MESSAGE_FILE):
    with open(MESSAGE_FILE, "w") as f:
        json.dump([], f)


def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root", 
        password="FIT5120TP14",  
        database="SunscreenTracker"
    )


@app.route('/api/uv', methods=['GET'])
def get_uv_index():
    location = request.args.get('location', '').title()
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT l.Suburb, u.UVIndex, u.Date, u.Time 
            FROM UVIndex u
            JOIN Location l ON u.LocationID = l.LocationID
            WHERE l.Suburb = %s
            ORDER BY u.Date DESC, u.Time DESC
            LIMIT 1
        """, (location,))
        data = cursor.fetchone()

       
        uv_level = "Unknown"
        if data and data["UVIndex"] is not None:
            if data["UVIndex"] > 7:
                uv_level = "High"
            elif data["UVIndex"] > 3:
                uv_level = "Moderate"
            else:
                uv_level = "Low"

        result = {
            "location": data["Suburb"] if data else location,
            "uv_index": data["UVIndex"] if data else "N/A",
            "level": uv_level, 
            "date": str(data["Date"]) if data else "N/A",
            "time": str(data["Time"]) if data else "N/A"
        }

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/messages', methods=['GET', 'POST'])
def messages():
    if request.method == 'GET':
        try:
          
            if os.path.exists("messages.json"):
                with open("messages.json", "r") as f:
                    messages = json.load(f)
            else:
                messages = []

            return jsonify({"messages": messages}), 200

        except Exception as e:
            return jsonify({"error": str(e)}), 500

    elif request.method == 'POST':
        try:
            data = request.json  
            name = data.get("name")
            email = data.get("email")
            message = data.get("message")

            if not name or not email or not message:
                return jsonify({"error": "Missing fields"}), 400

          
            if os.path.exists("messages.json"):
                with open("messages.json", "r") as f:
                    messages = json.load(f)
            else:
                messages = []

            new_message = {"name": name, "email": email, "message": message}
            messages.append(new_message)

            
            with open("messages.json", "w") as f:
                json.dump(messages, f, indent=4)

            return jsonify({"message": "Message saved successfully!"}), 200

        except Exception as e:
            return jsonify({"error": str(e)}), 500



if __name__ == '__main__':
    app.run(debug=True, port=5000)

