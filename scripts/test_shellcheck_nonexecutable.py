#!/usr/bin/env python3
"""Route shell-relevant files to ShellCheck. A pre-commit hook entrypoint.

For every file passed on argv, forward it to `shellcheck` when it is
shell-relevant:

- `file --mime-type -N` reports `text/x-shellscript`, or
- the file carries a file-wide `# shellcheck ... shell=...` directive in its
  leading header (the run of blank/`#` lines before the first command), the
  opt-in signal for files such as `.bashrc`.

Shell-extension files (`.sh`, `.bash`, `.bats`) are already covered by the
sibling `shellcheck` hook (`types: [shell]`), so no extension check is
needed here.

Forwarded files are passed to `shellcheck` as an argv list (never a shell
string). Exits non-zero when `shellcheck` reports findings or when the `file`
utility is missing or fails (a linter gate must not silently under-detect);
exits 0 when nothing is forwarded.
"""

import re
import subprocess
import sys

# A file-wide directive: a `# shellcheck` comment carrying the `shell=` option
# (only `shell=` resolves SC2148; `disable=`/`source=` do not count).
_DIRECTIVE = re.compile(r"#\s+shellcheck\b(.*)$")
_SHELL_OPTION = re.compile(r"(?:^|\s)shell=")


def has_shell_directive(path: str) -> bool:
    """Return `True` if the file has a `shell=` directive in its header.

    The directive must sit in the leading header: the run of blank and comment
    lines before the first code line. A file that is entirely comments counts as
    all-header.

    Args:
        path: Path of the file to inspect.

    Returns:
        `True` if a file-wide `# shellcheck ... shell=...` directive appears
        before the first command, `False` otherwise.
    """
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            stripped = line.strip()
            if not stripped:
                continue  # Blank line: still header.
            if not stripped.startswith("#"):
                break  # First command: header over.
            match = _DIRECTIVE.match(stripped)
            if match and _SHELL_OPTION.search(match.group(1)):
                return True
    return False


def mime_type(path: str) -> str:
    """Return the MIME type of a file as reported by `file`.

    Args:
        path: Path of the file to inspect.

    Returns:
        The MIME type string (e.g. `text/x-shellscript`).

    Raises:
        SystemExit: If the `file` utility is missing or fails.
    """
    try:
        proc = subprocess.run(
            ("file", "--mime-type", "-N", "--", path),
            capture_output=True,
            text=True,
            # returncode is handled below for a clear message.
            check=False,
        )
    except OSError as exc:
        sys.exit(
            f"test_shellcheck_nonexecutable: cannot run 'file' ({exc}); "
            "is it installed?"
        )
    if proc.returncode != 0:
        sys.exit(
            f"test_shellcheck_nonexecutable: 'file' failed on {path}: "
            f"{proc.stderr.strip()}"
        )
    out = proc.stdout.strip()
    return out.rsplit(":", 1)[1].strip() if ":" in out else out


def is_shell_relevant(path: str) -> bool:
    """Return `True` if the file should be forwarded to shellcheck.

    Args:
        path: Path of the file to classify.

    Returns:
        `True` if the file's MIME type is `text/x-shellscript` or it carries a
        file-wide `shell=` directive, `False` otherwise.
    """
    return mime_type(path) == "text/x-shellscript" or has_shell_directive(path)


def main(argv: list[str]) -> int:
    """Forward shell-relevant files to ShellCheck (`shellcheck`).

    Args:
        argv: File paths to consider.

    Returns:
        `shellcheck`'s exit code, or 0 if no file is forwarded.
    """
    forwarded = [path for path in argv if is_shell_relevant(path)]
    if not forwarded:
        return 0
    # check=False: `shellcheck`'s exit code (1 on findings) is propagated.
    return subprocess.run(("shellcheck", *forwarded), check=False).returncode


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
