#!/usr/bin/env python3

# tab_title_template "{fmt.fg._40486A}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"
# active_tab_title_template "{fmt.fg._6E7698}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"

TAB_TEMPLATE = '''tab_title_template "{fmt.fg._40486A}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"'''

ACTIVE_TAB_TEMPLATE = '''active_tab_title_template "{fmt.fg._6E7698}{index} {fmt.fg.tab}{fmt.bold}{' ' if num_windows > 1 and layout_name == 'stack' else ''}{f'{((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title)[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else ((title.split('/')[-1] if title.startswith(('nvim', '~/')) else title) if title.startswith(('nvim', '~/')) else title).center(5))}"'''

def main():
    """Generate kitty tab title templates."""
    print(TAB_TEMPLATE)
    print(ACTIVE_TAB_TEMPLATE)

if __name__ == "__main__":
    main()
