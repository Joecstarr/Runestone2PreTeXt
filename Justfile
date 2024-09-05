
set export

PYTHONPATH := "."
python_dir := if os_family() == "windows" { "./.venv/Scripts" } else { "./.venv/bin" }
python_exe := python_dir + if os_family() == "windows" { "/python.exe" } else { "/python" }

# Set up development environment
bootstrap:
    if test ! -e build/flake; then mkdir -p build/flake; fi
    if test ! -e build/docs; then mkdir -p build/docs; fi
    if test ! -e .venv; then python -m venv .venv; fi
    {{ python_exe }} -m pip install --upgrade pip wheel pip-tools
    {{ python_exe }} -m pip install -r requirements.txt