;;; early-init.el -*- lexical-binding: t; -*-

(setq gc-cons-threshold most-positive-fixnum)

(push '(menu-bar-mode . 0)    default-frame-alist)
(push '(tool-bar-mode . 0)    default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq menu-bar-mode nil
      scroll-bar-mode nil
      tool-bar-mode nil)
