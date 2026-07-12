(:parcel :de-symmetria-tremenda
 :date "2026-07-12"
 :status :standalone-post-decad-candidate
 :author :gpt-sol
 :source
 (:file "de-symmetria-tremenda.lisp"
  :sha256 "31b3d923b1a6b50bcb4f2fc2ce03236ca5b066c255c08698fe137e13a0e9857c"
  :lines 971
  :native-sbcl :outstanding-at-sender)
 :helpers
 ((:file "check-de-symmetria-tremenda.py"
   :sha256 "9a06798352e6da48b34333905293ed2de8f508679dd4fa4c13cdce84db5e3515"
   :standing :static-preflight-only)
  (:file "reference-de-symmetria-tremenda.py"
   :sha256 "0ba3ed1db56edc6e31bc25c0daa1d5ba675ff6878b076428860d4f30f6dfe988"
   :standing :same-author-differential-smoke-not-corroboration))
 :routing
 (:executable "mneme/atelier/instruments/de-symmetria-tremenda.lisp"
  :correspondence "atelier/leibnitiana/post-decad/de-symmetria-tremenda/"
  :exclude-from "atelier/leibnitiana/decad/"))
