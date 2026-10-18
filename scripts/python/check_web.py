import datetime
import json
import subprocess
import urllib.error
import urllib.request

service = subprocess.run(
    ["systemctl", "is-active", "nginx"],
    capture_output=True,
    text=True,
    timeout=10,
)

result = {
    "checked_at": datetime.datetime.now(
        datetime.timezone.utc
    ).isoformat(),
    "service": service.stdout.strip(),
    "http_status": None,
    "error": None,
}

try:
    with urllib.request.urlopen(
        "http://127.0.0.1/", timeout=5
    ) as response:
        result["http_status"] = response.status
except urllib.error.HTTPError as exc:
    result["http_status"] = exc.code
    result["error"] = str(exc)
except (urllib.error.URLError, TimeoutError) as exc:
    result["error"] = str(exc)

result["healthy"] = (
    result["service"] == "active"
    and result["http_status"] == 200
)

print(json.dumps(result, indent=2))
raise SystemExit(0 if result["healthy"] else 1)
