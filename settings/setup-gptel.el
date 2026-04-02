;;; package --- setup-gptel
;;; Commentary:
;;;   Henning Jansen 2025.
;;; Code:

;; --- Authinfo secret management
(require 'auth-source)
(require 'epa-file)

(epa-file-enable)
(setq auth-sources '("~/.authinfo.gpg"))

(defun my/get-secret (host login)
  "Return the secret (password) for HOST and LOGIN via auth-source."
  (let ((match (car (auth-source-search :host host :user login :max 1))))
    (when match
      (let ((secret (plist-get match :secret)))
        (if (functionp secret) (funcall secret) secret)))))

;; --- Directives ---------------------------------------------------------

(setq gptel-directive-clojure
      '((default . "You are Codestral in Emacs, specializing in Clojure development. Follow these principles:
- Write idiomatic Clojure with emphasis on functional programming
- Debugging and optimizing existing code
- Explaining complex concepts step-by-step
- Prefer immutability, pure functions, and data-oriented design
- Use threading macros (-> ->>) for clarity
- Include REPL-friendly examples

When explaining code:
1. Start with the high-level concept
2. Show a minimal working example
3. Build complexity incrementally
4. Highlight key insights with =inline code= or *emphasis*
5. Explain 'why' before 'how'")))

(setq gptel-directive-architect
      '((default . "You are a large language model living in Emacs and a helpful assistant Software Engineer and Systems Architect.
- Favouring clean, idiomatic system architecture based on a Principle First way of reasoning.
- Explaining complex concepts step-by-step
- Writing clean, idiomatic code with clear explanations
- Suggesting Clojure or Bash specific workflows, Linux first principles.

When explaining code:
1. Start with the high-level concept
2. Show a minimal working example
3. Build complexity incrementally
4. Highlight key insights with =inline code= or *emphasis*
5. Explain 'why' before 'how'")))

(setq gptel-directive-sweng
      '((default . "You are a large language model living in Emacs and a helpful assistant Software Engineer and Systems Architect.
- Favouring clean, idiomatic system architecture based on a Principle First way of reasoning.
- Explaining complex concepts step-by-step
- Providing clean, idiomatic guidance with clear explanations
- Excel in topics related to on premises Linux administration, networking, Docker, Bash and Clojure

When explaining concepts:
1. Start with the high-level concept
2. Ask questions instead of guessing, or give a clear indication if unsure.
2. Show a minimal working example
3. Build complexity incrementally
4. Highlight key insights with =inline code= or *emphasis*
5. Explain 'why' before 'how'")))

(setq gptel-directive-writing-buddy
      '((default . "You are a large language model living in Emacs and my
Writing, Thinking, and Reasoning Buddy. You partner with me (an Engineering
Manager) to plan, draft, review, and refine technical writing, design notes,
plans, code comments, and blog posts.

Use formal British English and a professional engineering register.
Prefer clarity, precision, and evidence over flourish; avoid hype.
Seasoned Linux engineer/developer; fluent in idiomatic, well-documented
Clojure, C# and Java..

Operating mode:
1. Default to thoughtful analysis; use reasoning capabilities internally.
2. Present concise reasoning summaries; do not expose internal scratch work.
3. Ask clarifying questions before proceeding when requirements are ambiguous.

Output format:
1. Use Emacs Org mode syntax for all responses.
2. Keep lines under 80 characters.
3. Use #+begin_src blocks with language tags (elisp, clojure, csharp, shell, yaml,
json).
4. Structure with headings (*, **, ***), lists, and named code blocks.
5. Be concise: favour clarity over verbosity.

When explaining or writing:
1. Start with purpose, audience, and success criteria.
2. Propose a brief outline first; await confirmation unless trivial.
3. Provide a minimal working example or template.
4. Build complexity incrementally; explain trade-offs briefly.
5. Highlight key insights with =inline code= or emphasis.
6. Offer an edit pass: style, structure, correctness, terminology.
7. Optionally provide Executive Summary and Action Items sections.

Org-first workflow:
1. Prefer Org tables, checklists, and property drawers for metadata.
2. Provide capture-friendly snippets and reusable templates.

Clojure guidance:
1. Provide idiomatic, documented code with docstrings and clojure.test tests.
2. Prefer pure functions, REPL-driven dev, small composable namespaces.
3. Include deps.edn snippets and run instructions when useful.

When asked to critique, return:
1. Strengths
2. Risks/Issues
3. Suggestions (with concrete rewrites)
4. Questions

Safety and sources:
1. Cite sources with links when claims benefit from references.
2. If unsure, state uncertainty and propose how to verify.")))

;; --- Directive alist (for interactive selection) -------------------------

(defvar gptel-directive-alist
  `(("architect"     . ,gptel-directive-architect)
    ("sweng"         . ,gptel-directive-sweng)
    ("clojure"       . ,gptel-directive-clojure)
    ("writing-buddy" . ,gptel-directive-writing-buddy))
  "Alist mapping directive names to directive values.")

(defun gptel-set-directives (directives)
  "Set gptel-directives and update the system message.
When called interactively, prompt with completing-read."
  (interactive
   (list (alist-get (completing-read "Directive: "
                                     gptel-directive-alist nil t)
                    gptel-directive-alist nil nil #'string=)))
  (setq gptel-directives directives)
  (setq gptel--system-message (alist-get 'default gptel-directives))
  (message "Switched to directive: %s"
           (truncate-string-to-width
            (alist-get 'default gptel-directives) 72)))

;; --- Initialize directives -----------------------------------------------

(defvar gptel-default-directive 'gptel-directive-writing-buddy
  "Default directive to use when initializing gptel.")

(defun gptel-initialize-directives ()
  "Initialize gptel directives using `gptel-default-directive'."
  (gptel-set-directives (symbol-value gptel-default-directive))
  (message "Initialized gptel with default directives"))

(gptel-initialize-directives)

;; --- Backends ------------------------------------------------------------

(setq gptel-mistral (gptel-make-openai "Mistral"
                      :host "api.mistral.ai"
                      :endpoint "/v1/chat/completions"
                      :stream t
                      :key (my/get-secret "api.mistral.ai" "apikey")
                      :models '(mistral-large-2512
                                codestral-2508
                                devstral-2512)))

(setq gptel-claude-opus (gptel-make-anthropic "Claude Opus"
                          :stream t
                          :key (my/get-secret "api.anthropic.ai" "apikey")
                          :models '(claude-opus-4-6)))

(setq gptel-backend gptel-mistral
      gptel-model 'mistral-large-2512)

;; --- Backend alist (for interactive selection) ---------------------------

(defvar gptel-backend-alist
  `(("mistral-large" . (,gptel-mistral     . mistral-large-2512))
    ("codestral"     . (,gptel-mistral     . codestral-2508))
    ("devstral"      . (,gptel-mistral     . devstral-2512))
    ("claude-opus"   . (,gptel-claude-opus . claude-opus-4-6)))
  "Alist mapping names to (backend . model) pairs.")

(defun gptel-switch-backend (backend model)
  "Switch to the specified BACKEND and MODEL.
When called interactively, prompt with completing-read."
  (interactive
   (let* ((choice (completing-read "Backend: "
                                   gptel-backend-alist nil t))
          (pair (alist-get choice gptel-backend-alist
                           nil nil #'string=)))
     (list (car pair) (cdr pair))))
  (setq gptel-backend backend
        gptel-model model)
  (message "Switched to %s / %s"
           (gptel-backend-name gptel-backend) gptel-model))

;; --- Profiles (directive + backend + model in one step) ------------------

(defvar gptel-profile-alist
  `(("architect"     . (:directives ,gptel-directive-architect
                         :backend    ,gptel-mistral
                         :model      mistral-large-2512))
    ("sweng"         . (:directives ,gptel-directive-sweng
                         :backend    ,gptel-mistral
                         :model      mistral-large-2512))
    ("clojure"       . (:directives ,gptel-directive-clojure
                         :backend    ,gptel-mistral
                         :model      codestral-2508))
    ("writing-buddy" . (:directives ,gptel-directive-writing-buddy
                         :backend    ,gptel-claude-opus
                         :model      claude-opus-4-6)))
  "Alist mapping profile names to (directives backend model).")

(defun gptel-switch-profile (profile-name)
  "Switch directive, backend, and model in one step.
When called interactively, prompt with completing-read."
  (interactive
   (list (completing-read "Profile: " gptel-profile-alist nil t)))
  (let* ((profile (alist-get profile-name gptel-profile-alist
                             nil nil #'string=))
         (directives (plist-get profile :directives))
         (backend    (plist-get profile :backend))
         (model      (plist-get profile :model)))
    (setq gptel-directives      directives
          gptel--system-message  (alist-get 'default directives)
          gptel-backend          backend
          gptel-model            model)
    (message "Profile: %s → %s / %s"
             profile-name
             (gptel-backend-name backend)
             model)))

(setq gptel-default-mode 'org-mode)

(provide 'setup-gptel)
;;; setup-gptel.el ends here
