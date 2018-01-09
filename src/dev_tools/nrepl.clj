(ns dev-tools.nrepl
  (:require [clojure.tools.nrepl.server :as nrepl-server]))

; Supported middlewares

(def supported-middlewares
  ['refactor-nrepl.middleware/wrap-refactor])

; Supported handlers 

(def supported-handler
  ['cider.nrepl/cider-nrepl-handler])

;;;

(defn- namespace-avail? [ns]
  (try
    (require ns)
    true
    (catch Exception e
      false)))

(defn find-fns
  "Find functions that are available on classpath."
  [fns]
  (->> fns
       (filter (comp namespace-avail? symbol namespace))
       (map eval)))

(defn nrepl-middlewares
  "Find all active supported middlewares (that are on classpath). If not, return identity."
  []
  (let [middlewares (find-fns supported-middlewares)]
    (if (empty? middlewares)
      identity
      (reduce comp middlewares))))

(defn nrepl-handler
  "Find first active supported handler (that are on classpath). If not, return default one."
  []
  (let [handlers (find-fns supported-handler)]
    (if (empty? handlers)
      (clojure.tools.nrepl.server/default-handler)
      (first handlers))))

(defn -main []
  (let [server (nrepl-server/start-server :handler ((nrepl-middlewares) (nrepl-handler)))]
    (println "nrepl server started at port" (:port server))
    (spit ".nrepl-port" (str (:port server)))))
