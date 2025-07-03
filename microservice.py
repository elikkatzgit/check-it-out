from flask import Flask, request, jsonify
import boto3
import os

app = Flask(__name__)
sqs = boto3.client('sqs', region_name='us-east-1') 
QUEUE_URL = os.environ.get("SQS_QUEUE_URL")

@app.route("/ingest", methods=["POST"])
def ingest():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400

    try:
        sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=str(data)
        )
        return jsonify({"status": "Message sent"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
