# Testing Strategy for MobileShop

## Overview
This document outlines the testing approach for the MobileShop application. The goal is to ensure the reliability of key user flows including tracking repair status, updating repair details, and contacting support.

## Test Scope

### 1. End-to-End (E2E) Testing
**Tool:** Playwright (Python)
**Focus:** Critical user journeys through the web interface.
**Scenarios:**
- **Home/Landing Page:** Verifying the application loads and navigation elements are present.
- **Tracking Flow:** Simulating a user entering a tracking ID and verifying the redirection logic.
- **Contact Form:** Verifying form elements exist and can be interacted with.
- **Update Interface:** Verifying the admin/staff update forms (simulated).

### 2. Manual / Exploratory Testing
- **Visual Inspection:** Verifying layout responsiveness on mobile vs. desktop.
- **Database Integration:** Verifying that queries return expected data structures (requires DB setup).

## Test Environment Setup
1. Install dependencies: `pip install -r requirements.txt` and `pip install -r requirements-test.txt`.
2. Install Playwright browsers: `playwright install`.
3. Ensure MySQL database is running and configured as per `mobile-webapp.py`.
4. Run the Flask application: `python mobile-webapp.py`.

## Running Tests
Execute the test suite using Pytest:
```bash
pytest tests/
```

## CI/CD Integration
Future improvements will include a GitHub Actions workflow to lint the Python code and run these tests against a containerized database service.

