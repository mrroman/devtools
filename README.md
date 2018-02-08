# dev-tools

dev-tools is a small utility set for new Clojure CLI

## Set up

Add to your `~/.clojure/deps.edn` file this repository as a depencency activated with alias, e.g.:

```edn
{:aliases
 {:devtools {:extra-deps {dev-tools {:git/url "https://github.com/mrroman/devtools.git"
                                     :sha "v1"}}}}}
```

## Usage

### Command: nrepl

This utility starts a nrepl server and creates `.nrepl-port` file in the current direcotory which contains. This file contains port where the server is available. Run command with, e.g.:

```sh
clojure -R:devtools -m devtools.nrepl
```

#### Cider support

**nrepl** command supports Cider. It looks for cider-nrepl or refactor-nrepl during startup and actives it automatically. Here is an example how to enable it:

1. Add additional alias to the `.clojure/deps.edn` file:

    ```edn
    {:aliases
     {:cider {:extra-deps {cider/cider-nrepl {:mvn/version "0.16.0"}
                           refactor-nrepl {:mvn/version "2.3.1"}}}}}
    ```
1. Start the server with this alias enabled.

    ```sh
    clojure -R:devtools:cider -m devtools.nrepl
    ```

I also added Emacs module that allows to automatically set up the server and start the Cider session. Projectile is required to work.

1. Download [cider-cli.el](https://raw.githubusercontent.com/mrroman/devtools/master/emacs/cider-cli.el) to `~/.emacs.d/lisp` directory.
1. Append this snippet to the `.emacs` or `.emacs.d/init.el` file (I'll deploy this package to MELPA repository soon).

    ```lisp
    (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
    (require 'cider-cli)
    ```

Now you can start the session with `cider-jack-in-cli` command.

#### Atom proto-repl support

You can use *nrepl* command with Atom and proto-repl plugin.

1. You have to add additional alias to the `.clojure/deps.edn` file.

    ```edn
    {:aliases
     {:proto-repl {:extra-deps {proto-repl {:mvn/version "0.3.1"}}}}}
    ```
1. You have to start the server in the main directory of your project.

    ```sh
    clojure -R:devtools:proto-repl -m devtools.nrepl
    ```
1. Go to Atom editor and execute "Proto Repl: Remote Nrepl Connection". It will automatically detect your the port and you can just hit Enter.

## Command: test

This utility is helpful to run your tests in a CI environment (Jenkins, CircleCI, TravisCI, Gitlab CI, etc.).
It runs tests with circleci.test runner. Command arguments are compatible with circleci.test runner's.
If you don't specify command, it will detect all directories on your classpath and run all tests inside these directories. Run command with, e.g.:

```sh
clojure -R:dev -m devtools.test
```

or specific namespace

```sh
clojure -R:dev -m devtools.test myproject.core-test
```

## License

Distributed under the Eclipse Public License either version 1.0 or (at your option) any later version.
