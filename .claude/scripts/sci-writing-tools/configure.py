# /// script
# requires-python = ">=3.11"
# dependencies = ["tomlkit==0.13.3"]
# ///

import copy
import json
import os
import shutil
import stat
import tempfile
from collections.abc import MutableMapping
from pathlib import Path

import tomlkit


SERVERS = {
    "semantic-scholar": {
        "command": "uvx",
        "args": ["--with", "mcp<2", "semantic-scholar-mcp"],
    },
    "arxiv": {"command": "uvx", "args": ["arxiv-mcp-server"]},
    "zotero": {"command": "zotero-mcp", "args": ["serve"]},
    "pandoc": {"command": "uvx", "args": ["mcp-pandoc"]},
    "exa": {"url": "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa"},
    "docling": {
        "command": "docling-mcp-server",
        "args": ["--transport", "stdio", "conversion", "generation"],
        "env": {"DOCLING_MCP_CONVERSION_MODE": "local"},
    },
}


def write_config(path, content):
    path = path.expanduser().resolve()
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = stat.S_IMODE(path.stat().st_mode) if path.exists() else 0o600
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as handle:
            temporary = Path(handle.name)
            os.fchmod(handle.fileno(), mode)
            handle.write(content)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temporary, path)
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()
    print(f"Updated {path}")


def object_field(document, key):
    value = document.setdefault(key, {})
    if not isinstance(value, MutableMapping):
        raise ValueError(f"{key} must be an object")
    return value


def update_client(path, section, definitions, use_toml=False):
    original = path.read_text(encoding="utf-8") if path.exists() else ""
    document = tomlkit.parse(original) if use_toml else json.loads(original or "{}")
    if not isinstance(document, MutableMapping):
        raise ValueError(f"Expected an object in {path}")
    before = copy.deepcopy(document)
    servers = object_field(document, section)
    for name, definition in definitions.items():
        if name not in servers:
            servers[name] = definition
    existing = servers.get("semantic-scholar", {})
    if isinstance(existing, MutableMapping):
        if existing.get("command") == ["uvx", "semantic-scholar-mcp"]:
            existing["command"] = ["uvx", "--with", "mcp<2", "semantic-scholar-mcp"]
        elif existing.get("command") == "uvx" and existing.get("args") == ["semantic-scholar-mcp"]:
            existing["args"] = ["--with", "mcp<2", "semantic-scholar-mcp"]
    if section == "mcp":
        document.setdefault("$schema", "https://opencode.ai/config.json")
    if document != before:
        content = tomlkit.dumps(document) if use_toml else json.dumps(document, indent=2) + "\n"
        if content != original:
            write_config(path, content)


def configure_zotero(home):
    path = home / ".config/zotero-mcp/config.json"
    document = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
    if not isinstance(document, dict):
        raise ValueError(f"Expected an object in {path}")
    before = copy.deepcopy(document)
    semantic = object_field(document, "semantic_search")
    semantic.setdefault("embedding_model", "sentence-transformers/all-MiniLM-L6-v2")
    updates = object_field(semantic, "update_config")
    updates.setdefault("auto_update", False)
    updates.setdefault("update_frequency", "manual")
    if document != before:
        write_config(path, json.dumps(document, indent=2) + "\n")


def main():
    home = Path.home()
    configure_zotero(home)
    if os.environ.get("NO_MCP"):
        print("NO_MCP set; skipping harness MCP registration")
        return

    available = {
        name: copy.deepcopy(server)
        for name, server in SERVERS.items()
        if "url" in server or shutil.which(server["command"])
    }
    if shutil.which("claude"):
        definitions = {
            name: {"type": "http" if "url" in server else "stdio", **server}
            for name, server in available.items()
        }
        directory = os.environ.get("CLAUDE_CONFIG_DIR")
        path = Path(directory).expanduser() / ".claude.json" if directory else home / ".claude.json"
        update_client(path, "mcpServers", definitions)

    if shutil.which("codex"):
        definitions = copy.deepcopy(available)
        for name, startup, tool in (("zotero", 60, 120), ("exa", 30, 60), ("docling", 120, 300)):
            if name in definitions:
                definitions[name].update(startup_timeout_sec=startup, tool_timeout_sec=tool)
        path = Path(os.environ.get("CODEX_HOME", home / ".codex")).expanduser() / "config.toml"
        update_client(path, "mcp_servers", definitions, use_toml=True)

    if shutil.which("opencode"):
        definitions = {}
        for name, server in available.items():
            if "url" in server:
                definitions[name] = {"type": "remote", "url": server["url"], "timeout": 30000}
            else:
                definitions[name] = {"type": "local", "command": [server["command"], *server["args"]]}
                if "env" in server:
                    definitions[name]["environment"] = server["env"]
                if name == "docling":
                    definitions[name]["timeout"] = 120000
        path = Path(os.environ.get("XDG_CONFIG_HOME", home / ".config")).expanduser() / "opencode/opencode.json"
        update_client(path, "mcp", definitions)


if __name__ == "__main__":
    main()
