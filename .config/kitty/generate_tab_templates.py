#!/usr/bin/env python3

def generate_tab_title_template(fg_color, is_active=False):
    """Generate a tab title template with the given foreground color."""
    template_type = "active_tab_title_template" if is_active else "tab_title_template"
    
    template = (
        f'{{fmt.fg.{fg_color}}}{{index}} {{fmt.fg.tab}}{{fmt.bold}}'
        f'{{"  " if num_windows > 1 and layout_name == "stack" else ""}}'
        f'{{f"{{title[:30]}}…" if title.rindex(title[-1]) + 1 > 30 else '
        f'(title.center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else title.center(5))}}'
    )
    
    return f'{template_type} "{template}"'

def main():
    """Generate kitty tab title template configuration."""
    print("# Generated tab title templates")
    print(generate_tab_title_template("_40486A", is_active=False))
    print(generate_tab_title_template("_6E7698", is_active=True))

if __name__ == "__main__":
    main()