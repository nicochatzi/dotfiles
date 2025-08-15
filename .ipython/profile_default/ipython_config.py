c = get_config()
c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.display_completions = "readlinelike"
c.TerminalInteractiveShell.confirm_exit = True
c.TerminalInteractiveShell.shortcuts = [
    {
        "command": "IPython:auto_suggest.accept_or_jump_to_end",
        "new_keys": ["c-z"],
        "create": True,
    }
]
