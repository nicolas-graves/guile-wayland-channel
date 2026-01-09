(define-module (guile-wayland packages guile-wayland)
  #:use-module (guile-wayland packages guile-xyz)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages xorg)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages gettext)
  #:use-module (guix gexp)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system guile)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages ibus)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages freedesktop))

(define-public guile-libinput
  (let ((commit "4ae1512a60e5575a2bbaf03a4854e8fba2fc0c5b")
        (revision "0"))
    (package
      (name "guile-libinput")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url
                "https://github.com/Z572/guile-libinput")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0xhh883libqsg22xw4g677j5p5g8gipbisaf2sxc73pyy6zh2bps"))))
      (build-system gnu-build-system)
      (arguments
       (list #:make-flags #~(list "GUILE_AUTO_COMPILE=0")
             #:phases
             #~(modify-phases %standard-phases
                 (add-after 'unpack 'patch-extension-path
                   (lambda* (#:key outputs #:allow-other-keys)
                     (substitute* (find-files "." "\\.scm")
                       (("\\(load-extension \"libguile_libinput\" *\"(.*)\"\\)" _ o)
                        (string-append
                         (object->string
                          `(or (false-if-exception
                                (load-extension "libguile_libinput" ,o))
                               (load-extension
                                ,(string-append
                                  #$output
                                  "/lib/libguile_libinput.so")
                                ,o)))))))))))
      (native-inputs
       (list autoconf automake
             pkg-config
             libtool
             guile-3.0-latest))
      (inputs (list guile-3.0-latest libinput))
      (propagated-inputs
       (list
        guile-bytestructure-class
        guile-bytestructures))
      (synopsis "")
      (description "")
      (home-page "")
      (license license:gpl3+))))

(define-public guile-xkbcommon
  (package
    (name "guile-xkbcommon")
    (version "0.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url
              "https://github.com/Z572/guile-xkbcommon")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1lfjnmwb1y1ji989xk6i2sdpqrm6lbgr06fnhy8kyaxa4anyvm4c"))))
    (build-system gnu-build-system)
    (arguments
     (list #:make-flags #~(list "GUILE_AUTO_COMPILE=0")))
    (native-inputs
     (list autoconf automake
           pkg-config
           guile-3.0-latest))
    (inputs (list guile-3.0-latest
                  libxkbcommon
                  ;;; xkbregistry pc file require
                  libxml2))
    (propagated-inputs
     (list
      guile-bytestructure-class
      guile-bytestructures))
    (synopsis "Guile bindings for libxkbcommon")
    (description "This package provides Guile FFI bindings for libxkbcommon.")
    (home-page "https://github.com/Z572/guile-xkbcommon")
    (license license:gpl3+)))

(define-public guile-xkbcommon-next
  (let ((commit "d2b502f0161f610acc8ea42b86a4ace147ee3acb")
        (revision "0"))
    (package
      (inherit guile-xkbcommon)
      (name "guile-xkbcommon-next")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url
                "https://github.com/Z572/guile-xkbcommon")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "08mj8pbvnnf070mdx5xgh0mqvd4k5d3s838wwkpqskjnmca94za5"))))
      (arguments
       (list #:make-flags #~(list "GUILE_AUTO_COMPILE=0")))
      (native-inputs
       (list autoconf automake
             pkg-config
             guile-3.0-latest))
      (inputs (list guile-3.0-latest
                    libxkbcommon
                  ;;; xkbregistry pc file require
                    libxml2))
      (propagated-inputs '()))))

(define-public guile-wayland
  (let ((commit "9c917b4d35debe33051fd11a6521f2d7672b4024")
        (revision "1"))
    (package
      (name "guile-wayland")
      (version (git-version "0.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url
                "https://github.com/guile-wayland/guile-wayland")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0bsxs9dy2x3kc43wxb917y6rvbdpcyf2lqrfgn1m3q2adz0k0bvi"))))
      (build-system gnu-build-system)
      (arguments
       (list
        ;; #:configure-flags '(list "--disable-static")
        #:make-flags '(list "GUILE_AUTO_COMPILE=0")
        #:phases
        #~(modify-phases
              %standard-phases
            (add-after 'build 'load-extension
              (lambda* (#:key outputs #:allow-other-keys)
                (substitute* (find-files "." "\\.scm")
                  (("\\(load-extension \"libguile-wayland\" *\"(.*)\"\\)" _ o)
                   (string-append
                    (object->string
                     `(or (false-if-exception
                           (load-extension "libguile-wayland" ,o))
                          (load-extension
                           ,(string-append
                             #$output
                             "/lib/libguile-wayland.so")
                           ,o)))))))))))
      (native-inputs
       (list autoconf
             automake
             libtool
             pkg-config
             texinfo
             guile-3.0-latest))
      (inputs (list guile-3.0-latest wayland wayland-protocols))
      (propagated-inputs
       (list
        guile-bytestructure-class
        guile-bytestructures))
      (synopsis "")
      (description "")
      (home-page "https://github.com/guile-wayland/guile-wayland")
      (license license:gpl3+))))


(define-public guile-wlroots
  (let ((commit "5134190355d26a4669eca7a76e09ce489cf4092d")
        (revision "3"))
    (package
      (name "guile-wlroots")
      (version (git-version "0.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url
                "https://github.com/Z572/guile-wlroots")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1b9hr1mk0k3fkm7vswmfck89gbddfd7369x1z3n6cs0vh9rdvzba"))))
      (build-system gnu-build-system)
      (arguments (list
                  #:make-flags '(list "GUILE_AUTO_COMPILE=0")
                  #:phases
                  #~(modify-phases %standard-phases
                      (add-after 'build 'load-extension
                        (lambda* (#:key outputs #:allow-other-keys)
                          (substitute*
                              (find-files "." ".*\\.scm")
                            (("\\(load-extension \"libguile-wlroots\" *\"(.*)\"\\)" _ o)
                             (string-append
                              (object->string
                               `(or (false-if-exception (load-extension "libguile-wlroots" ,o))
                                    (load-extension
                                     ,(string-append
                                       (assoc-ref outputs "out")
                                       "/lib/libguile-wlroots.so")
                                     ,o)))))))))))
      (native-inputs
       (list autoconf
             automake
             libtool
             pkg-config
             texinfo
             guile-3.0-latest))
      (inputs (list guile-3.0-latest wlroots-0.17))
      (propagated-inputs
       (list guile-bytestructures
             guile-wayland
             guile-bytestructure-class
             guile-util572
             guile-xkbcommon
             guile-libinput))
      (synopsis "")
      (description "")
      (home-page "")
      (license license:gpl3+))))

(define-public guile-dmenu
  (let* ((commit "4aeb688953d59971509b6fc1b0a9da81b5d08730")
         (revision "0"))
    (package
      (name "guile-dmenu")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://git.sr.ht/~ngraves/guile-dmenu")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "16ashksbssi0pvbzmjns5b5wr4y40i8kxd27b2zkl6ic7bpsmvk2"))))
      (build-system guile-build-system)
      (arguments
       (list
        #:source-directory "src"
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'build 'install-script
              (lambda* (#:key inputs #:allow-other-keys)
                (let* ((bin (string-append #$output "/bin/"))
                       (dmenu (string-append bin "dmenu")))
                  (install-file "scripts/dmenu" bin)
                  (wrap-program dmenu
                    #:sh (search-input-file inputs "bin/bash")
                    `("GUILE_AUTO_COMPILE" ":" = ("0"))
                    `("GUILE_LOAD_PATH" ":" prefix
                      ,(string-split (getenv "GUILE_LOAD_PATH") #\:))
                    `("GUILE_LOAD_COMPILED_PATH" ":" prefix
                      ,(string-split (getenv "GUILE_LOAD_COMPILED_PATH")
                                     #\:)))))))))
      (native-inputs (list guile-3.0))
      (inputs (list bash-minimal guile-3.0))
      (propagated-inputs (list guile-cairo
                               guile-fibers
                               guile-wayland
                               guile-xkbcommon))
      (home-page "https://git.sr.ht/~ngraves/guile-dmenu")
      (synopsis "Guile completing-read library and dynamic menu")
      (description "This package provides a guile wayland implementation
for dmenu.  On the guile-side, you can also find an Emacs-like
completing-read procedure.")
      (license license:gpl3+))))

(define-public gwwm
  (let ((revision "0")
        (commit "54f646731b508a0b44b247e41c34a7ad446f1160"))
    (package
      (name "gwwm")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url
                "https://github.com/Z572/gwwm")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0zs2a9dxxq18zk6bnmzj8qv4fh97awqj4mqmi8ys35k4yapcyrl5"))))
      (build-system gnu-build-system)
      (arguments
       (list #:make-flags
             #~(list "GUILE_AUTO_COMPILE=0")
                     ;;; XXX: is a bug? why can't use gexp for #:modules
             #:modules `(((guix build guile-build-system)
                          #:select (target-guile-effective-version))
                         ,@%gnu-build-system-modules)
             #:imported-modules `((guix build guile-build-system)
                                  ,@%gnu-build-system-modules)
             #:phases
             #~(modify-phases %standard-phases
                 (add-after 'build 'load-extension
                   (lambda* (#:key outputs #:allow-other-keys)
                     (substitute*
                         (find-files "." ".*\\.scm")
                       (("\\(load-extension \"libgwwm\" *\"(.*)\"\\)" _ o)
                        (string-append
                         (object->string
                          `(or (false-if-exception (load-extension "libgwwm" ,o))
                               (load-extension
                                ,(string-append
                                  (assoc-ref outputs "out")
                                  "/lib/libgwwm.so")
                                ,o))))))))
                 (add-after 'install 'wrap-executable
                   (lambda* (#:key inputs outputs #:allow-other-keys)
                     (let* ((out (assoc-ref outputs "out"))
                            (deps (map (lambda (a)
                                         (assoc-ref inputs a ))
                                       '("guile-wayland"
                                         "guile-wlroots"
                                         "guile-bytestructures"
                                         "guile-bytestructure-class"
                                         "guile-util572"
                                         "guile-srfi-189"
                                         "guile-srfi-145"
                                         "guile-xkbcommon"
                                         "guile-libinput")))
                            (effective (target-guile-effective-version))
                            (mods (map (lambda (o)
                                         (string-append
                                          o "/share/guile/site/" effective))
                                       (cons out deps)))
                            (gos
                             (map (lambda (o)
                                    (string-append
                                     o "/lib/guile/" effective "/site-ccache"))
                                  (cons out deps))))
                       (wrap-program (search-input-file outputs "bin/gwwm")
                         #:sh (search-input-file inputs "bin/bash")
                         `("GUILE_AUTO_COMPILE" ":" = ("0"))
                         `("GUILE_LOAD_PATH" ":" prefix ,mods)
                         `("GUILE_LOAD_COMPILED_PATH" ":" prefix ,gos))))))))
      (native-inputs
       (list autoconf automake
             pkg-config
             libtool
             gettext-minimal
             guile-3.0-latest
             bash-minimal
             texinfo))
      (inputs (list guile-3.0-latest
                    guile-cairo
                    guile-bytestructures
                    guile-bytestructure-class
                    guile-srfi-189
                    guile-wlroots
                    guile-util572
                    wlroots-0.17
                    guile-srfi-145
                    guile-xkbcommon
                    guile-libinput
                    guile-wayland))
      (synopsis "")
      (description "")
      (home-page "")
      (license license:gpl3+))))
