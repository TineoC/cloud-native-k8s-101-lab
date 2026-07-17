"""Acme Shop microservice — minimal HTTP app for the K8s 101 lab.

Same pattern enterprises use on Kubernetes: small services, health probes,
config via env (ConfigMap/Secret), stable Service DNS between tiers.
"""
from __future__ import annotations

import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("PORT", "8080"))
SERVICE_NAME = os.environ.get("SERVICE_NAME", "checkout")
ENVIRONMENT = os.environ.get("ENVIRONMENT", "unknown")
WELCOME = os.environ.get("WELCOME_MESSAGE", "Acme Shop")
API_KEY = os.environ.get("API_KEY", "<not provided>")
PAYMENTS_URL = os.environ.get("PAYMENTS_URL", "")


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt: str, *args) -> None:
        print(f"{SERVICE_NAME}: {args[0]}")

    def _send(self, code: int, payload: dict) -> None:
        body = json.dumps(payload, indent=2).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:
        if self.path in ("/healthz", "/readyz"):
            self._send(200, {"status": "ok", "service": SERVICE_NAME})
            return

        if self.path in ("/", "/checkout") and SERVICE_NAME == "checkout":
            self._send(
                200,
                {
                    "service": SERVICE_NAME,
                    "message": WELCOME,
                    "environment": ENVIRONMENT,
                    "api_key_present": API_KEY not in ("", "<not provided>"),
                    "payments_url": PAYMENTS_URL or None,
                    "hint": "Enterprise pattern: checkout talks to payments via Service DNS",
                },
            )
            return

        if self.path in ("/", "/pay") and SERVICE_NAME == "payments":
            self._send(
                200,
                {
                    "service": SERVICE_NAME,
                    "message": "payments backend ready",
                    "environment": ENVIRONMENT,
                    "hint": "ClusterIP only — not exposed outside the cluster",
                },
            )
            return

        self._send(404, {"error": "not found", "service": SERVICE_NAME, "path": self.path})


if __name__ == "__main__":
    print(f"{SERVICE_NAME} listening on 0.0.0.0:{PORT} env={ENVIRONMENT}")
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
