import subprocess
import time
import urllib.request
import urllib.error
import json
import os
import signal
import sys

def make_request(url, method="GET", headers=None, data=None):
    if headers is None:
        headers = {}
    
    req_data = None
    if data is not None:
        if isinstance(data, dict):
            req_data = json.dumps(data).encode("utf-8")
            headers["Content-Type"] = "application/json"
        else:
            req_data = data  # raw bytes (e.g. multipart)
            
    req = urllib.request.Request(url, method=method, headers=headers, data=req_data)
    
    print(f"\n--- REQUEST: {method} {url} ---")
    if headers:
        print("Headers:")
        for k, v in headers.items():
            if k == "Authorization" and len(v) > 20:
                print(f"  {k}: Bearer [TRUNCATED_JWT]")
            else:
                print(f"  {k}: {v}")
    if data:
        if isinstance(data, dict):
            print(f"Body: {json.dumps(data)}")
        else:
            print(f"Body: [Raw/Binary Data - {len(data)} bytes]")
            
    try:
        with urllib.request.urlopen(req) as response:
            res_body = response.read().decode("utf-8")
            print(f"RESPONSE Status: {response.status}")
            try:
                parsed = json.loads(res_body)
                print(f"RESPONSE Body:\n{json.dumps(parsed, indent=2)}")
            except Exception:
                print(f"RESPONSE Body:\n{res_body}")
            return response.status, res_body
    except urllib.error.HTTPError as e:
        res_body = e.read().decode("utf-8")
        print(f"RESPONSE Status: {e.code}")
        try:
            parsed = json.loads(res_body)
            print(f"RESPONSE Body:\n{json.dumps(parsed, indent=2)}")
        except Exception:
            print(f"RESPONSE Body:\n{res_body}")
        return e.code, res_body
    except Exception as e:
        print(f"Network/Connection Error: {e}")
        return 0, str(e)

def wait_for_server():
    print("Waiting for server to start...")
    start_time = time.time()
    while time.time() - start_time < 12:
        try:
            req = urllib.request.Request("http://localhost:8000/api/v1/helplines/")
            with urllib.request.urlopen(req) as response:
                if response.status == 200:
                    print("Server started successfully!")
                    return True
        except Exception:
            pass
        time.sleep(0.5)
    print("Server failed to start in time.")
    return False

def run_tests():
    # Setup test env variables
    env = os.environ.copy()
    env["PYTHONPATH"] = "."
    env["DATABASE_URL"] = "sqlite:///./test.db"
    
    # Clean previous db if exists to start fresh
    if os.path.exists("test.db"):
        try:
            os.remove("test.db")
        except Exception:
            pass
            
    # Run migrations
    print("Running database migrations...")
    subprocess.run([r".\venv\Scripts\alembic", "upgrade", "head"], env=env, check=True)
    
    # Start server
    print("Starting Uvicorn server...")
    log_file = open("uvicorn.log", "w")
    proc = subprocess.Popen(
        [r".\venv\Scripts\python", "-m", "uvicorn", "app.main:app", "--port", "8000"],
        env=env,
        stdout=log_file,
        stderr=log_file,
        creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if sys.platform == 'win32' else 0
    )
    
    if not wait_for_server():
        print("Failed to start Uvicorn. Exiting.")
        return
        
    try:
        print("\n================== RUNNING ENDPOINT VERIFICATION TESTS ==================")
        
        # 1. Register - Valid
        register_payload = {
            "email": "test_user@example.com",
            "password": "strongpassword123",
            "full_name": "Test User",
            "phone": "+919876543210"
        }
        status, body = make_request("http://localhost:8000/api/v1/auth/register", "POST", data=register_payload)
        
        # 2. Register - Invalid (Short Password / Missing Field)
        invalid_register_payload = {
            "email": "invalid_user@example.com",
            "password": "123",  # Too short
            "full_name": "Invalid User"
            # Missing phone
        }
        make_request("http://localhost:8000/api/v1/auth/register", "POST", data=invalid_register_payload)
        
        # 3. Login - Valid
        login_payload = {
            "email": "test_user@example.com",
            "password": "strongpassword123"
        }
        status, body = make_request("http://localhost:8000/api/v1/auth/login", "POST", data=login_payload)
        token = json.loads(body)["access_token"]
        auth_header = {"Authorization": f"Bearer {token}"}
        
        # 4. Login - Invalid (Wrong Password)
        wrong_login_payload = {
            "email": "test_user@example.com",
            "password": "wrongpassword"
        }
        make_request("http://localhost:8000/api/v1/auth/login", "POST", data=wrong_login_payload)
        
        # 5. Me - Valid Token
        make_request("http://localhost:8000/api/v1/auth/me", "GET", headers=auth_header)
        
        # 6. Me - Invalid Token
        make_request("http://localhost:8000/api/v1/auth/me", "GET", headers={"Authorization": "Bearer badtoken123"})
        
        # 7. Me - Missing Token
        make_request("http://localhost:8000/api/v1/auth/me", "GET")
        
        # 8. Contacts - GET (Empty List)
        make_request("http://localhost:8000/api/v1/contacts/", "GET", headers=auth_header)
        
        # 9. Contacts - POST (Create)
        contact_payload = {
            "name": "Mom",
            "phone": "+919999999999",
            "relation": "Mother"
        }
        status, body = make_request("http://localhost:8000/api/v1/contacts/", "POST", headers=auth_header, data=contact_payload)
        contact_id = json.loads(body)["id"]
        
        # 10. Contacts - POST - Invalid (Missing required field)
        invalid_contact_payload = {
            "phone": "+919999999999" # Missing name
        }
        make_request("http://localhost:8000/api/v1/contacts/", "POST", headers=auth_header, data=invalid_contact_payload)
        
        # 11. Contacts - PUT (Update)
        update_contact_payload = {
            "name": "Mom (Primary)",
            "phone": "+919999999999",
            "relation": "Mother"
        }
        make_request(f"http://localhost:8000/api/v1/contacts/{contact_id}", "PUT", headers=auth_header, data=update_contact_payload)
        
        # 12. Contacts - DELETE
        make_request(f"http://localhost:8000/api/v1/contacts/{contact_id}", "DELETE", headers=auth_header)
        
        # 13. Contacts - DELETE - Invalid (Non-existent ID)
        make_request("http://localhost:8000/api/v1/contacts/00000000-0000-0000-0000-000000000000", "DELETE", headers=auth_header)
        
        # 14. SOS Trigger
        sos_payload = {
            "latitude": 28.7041,
            "longitude": 77.1025
        }
        make_request("http://localhost:8000/api/v1/sos/trigger", "POST", headers=auth_header, data=sos_payload)
        
        # 15. SOS Trigger - Invalid (Wrong type for latitude)
        invalid_sos_payload = {
            "latitude": "not-a-number",
            "longitude": 77.1025
        }
        make_request("http://localhost:8000/api/v1/sos/trigger", "POST", headers=auth_header, data=invalid_sos_payload)
        
        # 16. SOS Last
        make_request("http://localhost:8000/api/v1/sos/last", "GET", headers=auth_header)
        
        # 17. Journey Start
        journey_payload = {
            "start_latitude": 28.7041,
            "start_longitude": 77.1025,
            "dest_latitude": 28.7122,
            "dest_longitude": 77.1122
        }
        status, body = make_request("http://localhost:8000/api/v1/journey/start", "POST", headers=auth_header, data=journey_payload)
        journey_id = json.loads(body)["id"]
        
        # 18. Journey Update
        journey_update_payload = {
            "dest_latitude": 28.7150,
            "dest_longitude": 77.1150
        }
        make_request(f"http://localhost:8000/api/v1/journey/{journey_id}/update", "PUT", headers=auth_header, data=journey_update_payload)
        
        # 19. Journey Stop
        make_request(f"http://localhost:8000/api/v1/journey/{journey_id}/stop", "POST", headers=auth_header)
        
        # 20. Journey Stop - Invalid (Already stopped/Non-existent ID)
        make_request("http://localhost:8000/api/v1/journey/00000000-0000-0000-0000-000000000000/stop", "POST", headers=auth_header)
        
        # 21. Threat Analyze - High Risk
        threat_payload = {
            "text": "Please help, I am followed by someone!"
        }
        make_request("http://localhost:8000/api/v1/threat/analyze", "POST", data=threat_payload)
        
        # 22. Threat Analyze - Low Risk
        safe_threat_payload = {
            "text": ""
        }
        make_request("http://localhost:8000/api/v1/threat/analyze", "POST", data=safe_threat_payload)
        
        # 23. Threat Analyze - Invalid (Missing required text field)
        make_request("http://localhost:8000/api/v1/threat/analyze", "POST", data={})
        
        # 24. Evidence Upload - Valid
        boundary = "----WebKitFormBoundaryTestEvidence"
        multipart_data = (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="file"; filename="evidence.mp3"\r\n'
            f"Content-Type: audio/mpeg\r\n\r\n"
            f"MOCK AUDIO DATA CONTENT FOR TESTING\r\n"
            f"--{boundary}--\r\n"
        ).encode("utf-8")
        
        upload_headers = auth_header.copy()
        upload_headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
        
        make_request("http://localhost:8000/api/v1/evidence/upload", "POST", headers=upload_headers, data=multipart_data)
        
        # 25. Evidence Upload - Invalid (No file uploaded)
        make_request("http://localhost:8000/api/v1/evidence/upload", "POST", headers=auth_header, data={})
        
        # 26. Helplines GET
        make_request("http://localhost:8000/api/v1/helplines/", "GET")
        
    finally:
        print("\nShutting down Uvicorn server...")
        if sys.platform == 'win32':
            subprocess.run(["taskkill", "/F", "/T", "/PID", str(proc.pid)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        else:
            proc.terminate()
            proc.wait()
        print("Uvicorn server shut down.")

if __name__ == "__main__":
    run_tests()
