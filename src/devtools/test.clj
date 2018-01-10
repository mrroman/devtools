(ns devtools.test
  (:require [circleci.test :as test]
            [clojure.java.io :as io]
            [clojure.string :refer [split]])
  (:import (java.io File)
           (java.util.regex Pattern)))

(defn get-classpath []
  (split (System/getProperty "java.class.path")
         (Pattern/compile File/pathSeparator)))

(defn find-source-directories [classpath]
  (->> classpath
       (map io/file)
       (filter #(.isDirectory %))
       (map #(.getName %))
       (into [])))

(find-source-directories (get-classpath))

(defn -main [& args]
  (if (empty? args)
    (test/dir (str (find-source-directories (get-classpath))))
    (apply test/-main args)))
