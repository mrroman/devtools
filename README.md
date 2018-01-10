# dev-tools

dev-tools is a small utility set for new Clojure CLI

## Set up

Add to your deps.edn file this repository as a depencency activated with alias, e.g.:

```edn
{:aliases
 {:dev {:extra-deps {dev-tools {:git/url "https://github.com/mrroman/devtools.git"
                                :sha "v1"}}}
  :cider {:extra-deps {cider/cider-nrepl {:mvn/version "0.16.0"}
                       refactor-nrepl {:mvn/version "2.3.1"}}}}}
```

## Command: nrepl

This utility starts a nrepl server. If it finds cider-nrepl or refactor-nrepl, it
automatically actives it. Run command with, e.g.:

```sh
clj -R:dev:cider -m devtools.nrepl
```

## Command: test

This utility runs tests with circleci.test runner. Command arguments are compatible
with circleci.test runner's. If you don't specify command, it will detect all
directories on your classpath and run all tests inside this directories. Run command with, e.g.:

```sh
clj -R:dev -m devtools.test
```

or specific namespace

```sh
clj -R:dev -m devtools.test myproject.core-test
```

## License

Distributed under the Eclipse Public License either version 1.0 or (at your option) any later version.