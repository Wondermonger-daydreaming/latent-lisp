# AP0 reissue independence note

The reissued validator is maintained as a separate source file. It is not imported, embedded, copied, or emitted by `generate_ap0_vectors.py`; a byte-substring check is recorded in the transcript. The vector generator and validator were nevertheless authored in the same repair session, so their standing is **separate-file, non-importing, co-authored self-consistency certification only**. Independent Common Lisp conformance and the stranger audit remain outstanding.
