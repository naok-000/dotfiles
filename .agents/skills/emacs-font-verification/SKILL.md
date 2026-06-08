---
name: emacs-font-verification
description: Verify actual GUI Emacs font rendering with emacsclient. Use when changing or debugging Emacs font configuration, especially macOS/CoreText, fontaine, mixed-pitch, Org mode, CJK/Japanese fallback fonts, face attributes, or fontset behavior.
---

# Emacs Font Verification

## Purpose

Use a running GUI Emacs daemon to verify the font that Emacs actually renders for a character, face, or mode-specific buffer. Prefer this over batch Emacs for final font checks, because batch/terminal Emacs does not exercise the same GUI font backend.

## Workflow

1. Confirm that a GUI Emacs daemon is running:

```sh
ps -ef
```

Look for `Emacs.app` with `--daemon` or `--bg-daemon`.

2. Check whether Emacs sees the expected font family:

```sh
emacsclient --eval '(member "IBM Plex Sans JP" (font-family-list))'
emacsclient --eval '(font-info "IBM Plex Sans JP")'
```

3. Reload changed config into the daemon before measuring:

```sh
emacsclient --eval '(load-file "/absolute/path/to/emacs/lisp/my-font.el")'
emacsclient --eval '(load-file "/absolute/path/to/emacs/lisp/my-org.el")'
```

4. Measure resolved fonts with `font-at` and `font-xlfd-name`:

```sh
emacsclient --eval '(font-xlfd-name (font-at 0 nil "日") t)'
emacsclient --eval '(font-xlfd-name (font-at 0 nil (propertize "日" '\''face '\''fixed-pitch)) t)'
emacsclient --eval '(font-xlfd-name (font-at 0 nil (propertize "日" '\''face '\''variable-pitch)) t)'
emacsclient --eval '(font-xlfd-name (font-at 0 nil (propertize "A" '\''face '\''variable-pitch)) t)'
```

Use `face-attribute` only as supporting context. It reports configured attributes, not the final font selected for a specific glyph.

5. For mode-specific checks, display a temporary buffer before calling `font-at`:

```sh
emacsclient --eval '
(save-window-excursion
  (let ((buf (get-buffer-create " *font-test*")))
    (switch-to-buffer buf)
    (erase-buffer)
    (org-mode)
    (mixed-pitch-mode 1)
    (insert "日本語 /日本語/ A /A/ ~code日本語~")
    (font-lock-ensure)
    (list :org-ja (font-xlfd-name (font-at 1) t)
          :org-ja-emph (font-xlfd-name (font-at 6) t)
          :org-a (font-xlfd-name (font-at 10) t)
          :org-a-emph (font-xlfd-name (font-at 13) t)
          :org-code-ja (font-xlfd-name (font-at 22) t))))'
```

`font-at` needs the target buffer to be displayed in a window when inspecting buffer positions. Use `switch-to-buffer` inside `save-window-excursion` for temporary checks.

## Notes

- `mixed-pitch-mode` remaps `default` to the `:family` of `variable-pitch`; it does not preserve a custom fontset attached to `variable-pitch`.
- `set-fontset-font` with `FONTSET` set to `nil` changes the selected frame's fontset. With `t`, it changes the default fontset.
- For changes that create temporary frames, wrap frame creation in `unwind-protect` and delete the frame before returning.
- Report the exact XLFD strings returned by `font-xlfd-name` in final summaries.
