import os, sys, logging
from app import create_app

config_name = os.environ.get("FLASK_ENV", "default")
app = create_app(config_name)

# Log errors to stderr (Render captures stderr in logs)
if not app.debug:
    handler = logging.StreamHandler(sys.stderr)
    handler.setLevel(logging.ERROR)
    app.logger.addHandler(handler)
