# LOCATED CLAIM IDENTITY /0 — ERRATA 0.1

**Document:** `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md`  
**Applies to:** `LOCATED-CLAIM-IDENTITY-SPEC.md` SHA-256 `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`  
**Date:** 2026-07-14  
**Status:** NORMATIVE NARROW ERRATA  
**LCI format:** `/0`  
**CD/0 dependency:** unchanged, frozen packet SHA-256 `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81`

## 0. Scope, force, and incorporation

This errata closes E1–E9 and incorporates the five I12 clarifications without changing the selected ClaimId or WarrantTarget model. “MUST”, “MUST NOT”, “SHALL”, and “SHALL NOT” are normative.

`LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md`, `LCI0-FIXTURE-REGISTRY.json`, and `LCI0-FIXTURE-VECTORS.jsonl` are normatively incorporated wherever this errata delegates a first-profile value, schema, algorithm, table, or vector. The JSON/JSONL artifacts carry the complete machine-readable abstract CD/0 values and canonical documents; prose aliases do not override them.

Nothing in this errata modifies frozen CD/0. No digest in this package is semantic identity.

## E1 — Pinned base references and neutral expressions

### E1.1 Normative rule

For Mneme ClaimProfile/0 under this first-implementation profile, the five base StableRefs and five neutral values below are the only accepted values for their named roles. They are complete CD/0 values; they are not host-language sentinels, omitted fields, aliases, or prose macros. A constructor MUST produce the exact abstract value and canonical octets stated here. A validator MUST reject a co-denoting but structurally different value unless an exact versioned pre-projection normalizer or approved bridge maps it to the pinned value before projection.

### Base reference 1 — Mneme scope-calculus reference

**Registry fixture:** `stable-ref.scope-calculus.primary`  
**Version:** `0`  
**Semantic role:** Pinned base Mneme fixture scope-calculus reference.  
**Validation rule:** Closed StableRef/0; exact domain and scheme; exact FixtureStableMaterial/0; object-id prefix is scope-calculus; mutable aliases are invalid.  
**Version/evolution rule:** Changing object identity or its immutable semantic version requires a different object-id/object-version and therefore different octets.  
**Equality expectation:** `exact-cd0:stable-ref.scope-calculus.primary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `563`  
**SHA-256 review checksum (not semantic identity):** `921327537a5f57fe9ec57e2c25b4ddef305785350f9c3aff549fea15b82fcd52`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "stable-reference"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "domain"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "domain",
          "scope-calculus"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "scheme"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "scheme",
          "scope-calculus",
          "structural",
          "0"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "material"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "fixture-stable-material"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-id"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "object",
                "scope-calculus",
                "mneme-primary"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "scope-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "scope-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "scope-calculus", "mneme-primary"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e0e73636f70652d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d650e73636f70652d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563740e73636f70652d63616c63756c75730d6d6e656d652d7072696d6172792205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Base reference 2 — Mneme temporal-model reference

**Registry fixture:** `stable-ref.temporal-model.primary`  
**Version:** `0`  
**Semantic role:** Pinned base Mneme fixture temporal-model reference.  
**Validation rule:** Closed StableRef/0; exact domain and scheme; exact FixtureStableMaterial/0; object-id prefix is temporal-model; mutable aliases are invalid.  
**Version/evolution rule:** Changing object identity or its immutable semantic version requires a different object-id/object-version and therefore different octets.  
**Equality expectation:** `exact-cd0:stable-ref.temporal-model.primary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `568`  
**SHA-256 review checksum (not semantic identity):** `17dff931bdd5206ab255522940ba4ed77fbe4764ae5ccf48fc973e7933814165`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "stable-reference"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "domain"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "domain",
          "temporal-model"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "scheme"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "scheme",
          "temporal-model",
          "structural",
          "0"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "material"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "fixture-stable-material"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-id"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "object",
                "temporal-model",
                "mneme-fixture-time"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "temporal-model"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "temporal-model", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "temporal-model", "mneme-fixture-time"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e0e74656d706f72616c2d6d6f64656c2203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d650e74656d706f72616c2d6d6f64656c0a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563740e74656d706f72616c2d6d6f64656c126d6e656d652d666978747572652d74696d652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Base reference 3 — Mneme dataset-slice-calculus reference

**Registry fixture:** `stable-ref.slice-calculus.primary`  
**Version:** `0`  
**Semantic role:** Pinned base Mneme fixture dataset-slice-calculus reference.  
**Validation rule:** Closed StableRef/0; exact domain and scheme; exact FixtureStableMaterial/0; object-id prefix is dataset-slice-calculus; mutable aliases are invalid.  
**Version/evolution rule:** Changing object identity or its immutable semantic version requires a different object-id/object-version and therefore different octets.  
**Equality expectation:** `exact-cd0:stable-ref.slice-calculus.primary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `593`  
**SHA-256 review checksum (not semantic identity):** `6f5d38ee64318d07583e454c06f6b37388afc0453931e2abc2bc26fa4c83b017`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "stable-reference"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "domain"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "domain",
          "dataset-slice-calculus"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "scheme"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "scheme",
          "dataset-slice-calculus",
          "structural",
          "0"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "material"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "fixture-stable-material"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-id"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "object",
                "dataset-slice-calculus",
                "mneme-fixture-slice"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "dataset-slice-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "dataset-slice-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "dataset-slice-calculus", "mneme-fixture-slice"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e16646174617365742d736c6963652d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d6516646174617365742d736c6963652d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a65637416646174617365742d736c6963652d63616c63756c7573136d6e656d652d666978747572652d736c6963652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Base reference 4 — Mneme semantic-boundary-calculus reference

**Registry fixture:** `stable-ref.boundary-calculus.primary`  
**Version:** `0`  
**Semantic role:** Pinned base Mneme fixture semantic-boundary-calculus reference.  
**Validation rule:** Closed StableRef/0; exact domain and scheme; exact FixtureStableMaterial/0; object-id prefix is semantic-boundary-calculus; mutable aliases are invalid.  
**Version/evolution rule:** Changing object identity or its immutable semantic version requires a different object-id/object-version and therefore different octets.  
**Equality expectation:** `exact-cd0:stable-ref.boundary-calculus.primary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `608`  
**SHA-256 review checksum (not semantic identity):** `990efe70bc2ad462f7f41c3c757517be16591641d255b8fb91086e90f8b66375`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "stable-reference"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "domain"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "domain",
          "semantic-boundary-calculus"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "scheme"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "scheme",
          "semantic-boundary-calculus",
          "structural",
          "0"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "material"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "fixture-stable-material"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-id"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "object",
                "semantic-boundary-calculus",
                "mneme-fixture-boundary"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "semantic-boundary-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "semantic-boundary-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "semantic-boundary-calculus", "mneme-fixture-boundary"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e1a73656d616e7469632d626f756e646172792d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d651a73656d616e7469632d626f756e646172792d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563741a73656d616e7469632d626f756e646172792d63616c63756c7573166d6e656d652d666978747572652d626f756e646172792205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Base reference 5 — Mneme interpretation-frame-schema reference

**Registry fixture:** `stable-ref.frame-schema.primary`  
**Version:** `0`  
**Semantic role:** Pinned base Mneme fixture interpretation-frame-schema reference.  
**Validation rule:** Closed StableRef/0; exact domain and scheme; exact FixtureStableMaterial/0; object-id prefix is interpretation-frame-schema; mutable aliases are invalid.  
**Version/evolution rule:** Changing object identity or its immutable semantic version requires a different object-id/object-version and therefore different octets.  
**Equality expectation:** `exact-cd0:stable-ref.frame-schema.primary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `608`  
**SHA-256 review checksum (not semantic identity):** `d9849523d9d3b541805b0b2140fd1d95c780313c3406c0989f2b19f6af05342a`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "stable-reference"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "domain"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "domain",
          "interpretation-frame-schema"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "scheme"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "fixture"
        ],
        "path": [
          "scheme",
          "interpretation-frame-schema",
          "structural",
          "0"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "material"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "fixture-stable-material"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-id"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "object",
                "interpretation-frame-schema",
                "mneme-fixture-frame"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "object-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "interpretation-frame-schema"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "interpretation-frame-schema", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "interpretation-frame-schema", "mneme-fixture-frame"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e1b696e746572707265746174696f6e2d6672616d652d736368656d612203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d651b696e746572707265746174696f6e2d6672616d652d736368656d610a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563741b696e746572707265746174696f6e2d6672616d652d736368656d61136d6e656d652d666978747572652d6672616d652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Neutral expression 1 — universal scope

**Registry fixture:** `neutral.universal-scope`  
**Version:** `0`  
**Semantic role:** Authoritative neutral universal scope for Mneme fixture ClaimIds.  
**Validation rule:** Must equal the registered Scope/0 document exactly; calculus and expression are both mandatory.  
**Version/evolution rule:** A replacement requires a new claim-profile/calculus version; these octets never change.  
**Equality expectation:** `exact-cd0:neutral-universal-scope`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `936`  
**SHA-256 review checksum (not semantic identity):** `d2b4a25a8001500574f676020517d165177e36e99d202bd6e7ea5570a35e07b0`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "scope"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "schema-version"
        ],
        "t": "id"
      },
      "value": {
        "t": "int",
        "v": "0"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "calculus"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "tag"
              ],
              "path": [
                "stable-reference"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "domain"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "domain",
                "scope-calculus"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "scheme"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scheme",
                "scope-calculus",
                "structural",
                "0"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "material"
              ],
              "t": "id"
            },
            "value": {
              "fields": [
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "kind"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "tag",
                      "fixture-stable-material"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "schema-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-id"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "object",
                      "scope-calculus",
                      "mneme-primary"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                }
              ],
              "t": "record"
            }
          }
        ],
        "t": "record"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "expression"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "scope-expression"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "form"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scope-form",
                "universal"
              ],
              "t": "id"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["scope"]), Id(["lisp-plus", "lci", "0"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0"], ["calculus"]) => Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "scope-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "scope-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "scope-calculus", "mneme-primary"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}, Id(["lisp-plus", "lci", "0"], ["expression"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "scope-expression"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["form"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scope-form", "universal"])}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c6369013003746167010573636f70652203096c6973702d706c7573036c63690130010863616c63756c757331042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e0e73636f70652d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d650e73636f70652d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563740e73636f70652d63616c63756c75730d6d6e656d652d7072696d6172792205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010a65787072657373696f6e31032205096c6973702d706c7573036c636901300766697874757265056669656c640104666f726d2204096c6973702d706c7573036c636901300766697874757265020a73636f70652d666f726d09756e6976657273616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c63690130076669787475726502037461671073636f70652d65787072657373696f6e2205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e736368656d612d76657273696f6e1000
```


### Neutral expression 2 — atemporal subject-time

**Registry fixture:** `neutral.atemporal-subject-time`  
**Version:** `0`  
**Semantic role:** Authoritative neutral atemporal SubjectTime/0 for Mneme fixture ClaimIds.  
**Validation rule:** Must equal the registered SubjectTime/0 exactly; temporal-model and atemporal expression are mandatory.  
**Version/evolution rule:** A replacement requires a new profile/model version; these octets never change.  
**Equality expectation:** `exact-cd0:neutral-atemporal-subject-time`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `960`  
**SHA-256 review checksum (not semantic identity):** `5bb34bdb9115789ff4a9f900ae011cac63c558c5641d7eae3a317883f152824e`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "subject-time"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "schema-version"
        ],
        "t": "id"
      },
      "value": {
        "t": "int",
        "v": "0"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "temporal-model"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "tag"
              ],
              "path": [
                "stable-reference"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "domain"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "domain",
                "temporal-model"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "scheme"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scheme",
                "temporal-model",
                "structural",
                "0"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "material"
              ],
              "t": "id"
            },
            "value": {
              "fields": [
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "kind"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "tag",
                      "fixture-stable-material"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "schema-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-id"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "object",
                      "temporal-model",
                      "mneme-fixture-time"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                }
              ],
              "t": "record"
            }
          }
        ],
        "t": "record"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "expression"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "temporal-expression"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "form"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "temporal-form",
                "atemporal"
              ],
              "t": "id"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["subject-time"]), Id(["lisp-plus", "lci", "0"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0"], ["temporal-model"]) => Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "temporal-model"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "temporal-model", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "temporal-model", "mneme-fixture-time"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}, Id(["lisp-plus", "lci", "0"], ["expression"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "temporal-expression"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["form"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["temporal-form", "atemporal"])}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c6369013003746167010c7375626a6563742d74696d652203096c6973702d706c7573036c63690130010a65787072657373696f6e31032205096c6973702d706c7573036c636901300766697874757265056669656c640104666f726d2204096c6973702d706c7573036c636901300766697874757265020d74656d706f72616c2d666f726d096174656d706f72616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c63690130076669787475726502037461671374656d706f72616c2d65787072657373696f6e2205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e74656d706f72616c2d6d6f64656c31042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e0e74656d706f72616c2d6d6f64656c2203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d650e74656d706f72616c2d6d6f64656c0a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563740e74656d706f72616c2d6d6f64656c126d6e656d652d666978747572652d74696d652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e1000
```


### Neutral expression 3 — all-members dataset slice

**Registry fixture:** `neutral.all-members-slice`  
**Version:** `0`  
**Semantic role:** Authoritative neutral all-members DatasetSlice/0.  
**Validation rule:** Must equal this complete DatasetSlice/0 exactly; omission, Unit, and empty host collections are invalid substitutes.  
**Version/evolution rule:** A replacement requires a new profile/calculus version; these octets never change.  
**Equality expectation:** `exact-cd0:neutral-all-members-slice`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `984`  
**SHA-256 review checksum (not semantic identity):** `a07f5910a8c8eaf11737a6f96bf8e3ee7474dac9b7adb51419b2191d1eb06baa`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "dataset-slice"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "schema-version"
        ],
        "t": "id"
      },
      "value": {
        "t": "int",
        "v": "0"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "calculus"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "tag"
              ],
              "path": [
                "stable-reference"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "domain"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "domain",
                "dataset-slice-calculus"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "scheme"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scheme",
                "dataset-slice-calculus",
                "structural",
                "0"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "material"
              ],
              "t": "id"
            },
            "value": {
              "fields": [
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "kind"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "tag",
                      "fixture-stable-material"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "schema-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-id"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "object",
                      "dataset-slice-calculus",
                      "mneme-fixture-slice"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                }
              ],
              "t": "record"
            }
          }
        ],
        "t": "record"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "expression"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "dataset-slice-expression"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "form"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "slice-form",
                "all-members"
              ],
              "t": "id"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["dataset-slice"]), Id(["lisp-plus", "lci", "0"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0"], ["calculus"]) => Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "dataset-slice-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "dataset-slice-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "dataset-slice-calculus", "mneme-fixture-slice"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}, Id(["lisp-plus", "lci", "0"], ["expression"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "dataset-slice-expression"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["form"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["slice-form", "all-members"])}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c6369013003746167010d646174617365742d736c6963652203096c6973702d706c7573036c63690130010863616c63756c757331042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e16646174617365742d736c6963652d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d6516646174617365742d736c6963652d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a65637416646174617365742d736c6963652d63616c63756c7573136d6e656d652d666978747572652d736c6963652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010a65787072657373696f6e31032205096c6973702d706c7573036c636901300766697874757265056669656c640104666f726d2204096c6973702d706c7573036c636901300766697874757265020a736c6963652d666f726d0b616c6c2d6d656d626572732205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616718646174617365742d736c6963652d65787072657373696f6e2205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e736368656d612d76657273696f6e1000
```


### Neutral expression 4 — not-applicable semantic boundary

**Registry fixture:** `neutral.not-applicable-boundary`  
**Version:** `0`  
**Semantic role:** Authoritative neutral not-applicable SemanticBoundary/0.  
**Validation rule:** Must equal this complete SemanticBoundary/0 exactly; omission, Unit, unknown, and unbounded are not aliases.  
**Version/evolution rule:** A replacement requires a new profile/calculus version; these octets never change.  
**Equality expectation:** `exact-cd0:neutral-not-applicable-boundary`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `1013`  
**SHA-256 review checksum (not semantic identity):** `0db0dedf17bab2acd9239fb63823d0cf303029898248a08b15a8030ac6e52ad6`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "semantic-boundary"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "schema-version"
        ],
        "t": "id"
      },
      "value": {
        "t": "int",
        "v": "0"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "calculus"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "tag"
              ],
              "path": [
                "stable-reference"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "domain"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "domain",
                "semantic-boundary-calculus"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "scheme"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scheme",
                "semantic-boundary-calculus",
                "structural",
                "0"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "material"
              ],
              "t": "id"
            },
            "value": {
              "fields": [
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "kind"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "tag",
                      "fixture-stable-material"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "schema-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-id"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "object",
                      "semantic-boundary-calculus",
                      "mneme-fixture-boundary"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                }
              ],
              "t": "record"
            }
          }
        ],
        "t": "record"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "expression"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "tag",
                "semantic-boundary-expression"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "schema-version"
              ],
              "t": "id"
            },
            "value": {
              "t": "int",
              "v": "0"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture",
                "field"
              ],
              "path": [
                "form"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "boundary-form",
                "not-applicable"
              ],
              "t": "id"
            }
          }
        ],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["semantic-boundary"]), Id(["lisp-plus", "lci", "0"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0"], ["calculus"]) => Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "semantic-boundary-calculus"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "semantic-boundary-calculus", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "semantic-boundary-calculus", "mneme-fixture-boundary"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}, Id(["lisp-plus", "lci", "0"], ["expression"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "semantic-boundary-expression"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["form"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["boundary-form", "not-applicable"])}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c6369013003746167011173656d616e7469632d626f756e646172792203096c6973702d706c7573036c63690130010863616c63756c757331042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e1a73656d616e7469632d626f756e646172792d63616c63756c75732203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d651a73656d616e7469632d626f756e646172792d63616c63756c75730a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563741a73656d616e7469632d626f756e646172792d63616c63756c7573166d6e656d652d666978747572652d626f756e646172792205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010a65787072657373696f6e31032205096c6973702d706c7573036c636901300766697874757265056669656c640104666f726d2204096c6973702d706c7573036c636901300766697874757265020d626f756e646172792d666f726d0e6e6f742d6170706c696361626c652205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c63690130076669787475726502037461671c73656d616e7469632d626f756e646172792d65787072657373696f6e2205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e736368656d612d76657273696f6e1000
```


### Neutral expression 5 — self-describing interpretation frame

**Registry fixture:** `neutral.self-describing-frame`  
**Version:** `0`  
**Semantic role:** Authoritative neutral self-describing InterpretationFrame/0.  
**Validation rule:** A proposition with no meaning-bearing interpretation context MUST use this exact full frame; omission and Unit are invalid.  
**Version/evolution rule:** A replacement requires a new profile/frame-schema version; these octets never change.  
**Equality expectation:** `exact-cd0:neutral-self-describing-frame`; equality is exact validated abstract-value equality witnessed by the complete canonical CD/0 document below.  
**Byte count:** `778`  
**SHA-256 review checksum (not semantic identity):** `60aef90afa2c0ea212f6d03811f9898fb2508f53d5ba52fce774946753cadae1`

**Exact abstract CD/0 value:**

```json
{
  "fields": [
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "kind"
        ],
        "t": "id"
      },
      "value": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0",
          "tag"
        ],
        "path": [
          "interpretation-frame"
        ],
        "t": "id"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "schema-version"
        ],
        "t": "id"
      },
      "value": {
        "t": "int",
        "v": "0"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "frame-schema"
        ],
        "t": "id"
      },
      "value": {
        "fields": [
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "kind"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "tag"
              ],
              "path": [
                "stable-reference"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "domain"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "domain",
                "interpretation-frame-schema"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "scheme"
              ],
              "t": "id"
            },
            "value": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0",
                "fixture"
              ],
              "path": [
                "scheme",
                "interpretation-frame-schema",
                "structural",
                "0"
              ],
              "t": "id"
            }
          },
          {
            "key": {
              "namespace": [
                "lisp-plus",
                "lci",
                "0"
              ],
              "path": [
                "material"
              ],
              "t": "id"
            },
            "value": {
              "fields": [
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "kind"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "tag",
                      "fixture-stable-material"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "schema-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-id"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture"
                    ],
                    "path": [
                      "object",
                      "interpretation-frame-schema",
                      "mneme-fixture-frame"
                    ],
                    "t": "id"
                  }
                },
                {
                  "key": {
                    "namespace": [
                      "lisp-plus",
                      "lci",
                      "0",
                      "fixture",
                      "field"
                    ],
                    "path": [
                      "object-version"
                    ],
                    "t": "id"
                  },
                  "value": {
                    "t": "int",
                    "v": "0"
                  }
                }
              ],
              "t": "record"
            }
          }
        ],
        "t": "record"
      }
    },
    {
      "key": {
        "namespace": [
          "lisp-plus",
          "lci",
          "0"
        ],
        "path": [
          "components"
        ],
        "t": "id"
      },
      "value": {
        "fields": [],
        "t": "record"
      }
    }
  ],
  "t": "record"
}
```

**Preferred diagnostic notation:**

```text
Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["interpretation-frame"]), Id(["lisp-plus", "lci", "0"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0"], ["frame-schema"]) => Record{Id(["lisp-plus", "lci", "0"], ["kind"]) => Id(["lisp-plus", "lci", "0", "tag"], ["stable-reference"]), Id(["lisp-plus", "lci", "0"], ["domain"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "interpretation-frame-schema"]), Id(["lisp-plus", "lci", "0"], ["scheme"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "interpretation-frame-schema", "structural", "0"]), Id(["lisp-plus", "lci", "0"], ["material"]) => Record{Id(["lisp-plus", "lci", "0", "fixture", "field"], ["kind"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["tag", "fixture-stable-material"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["schema-version"]) => 0, Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"]) => Id(["lisp-plus", "lci", "0", "fixture"], ["object", "interpretation-frame-schema", "mneme-fixture-frame"]), Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-version"]) => 0}}, Id(["lisp-plus", "lci", "0"], ["components"]) => Record{}}
```

**Complete canonical CD/0 document, lowercase hexadecimal:**

```text
4c5043440031042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670114696e746572707265746174696f6e2d6672616d652203096c6973702d706c7573036c63690130010a636f6d706f6e656e747331002203096c6973702d706c7573036c63690130010c6672616d652d736368656d6131042203096c6973702d706c7573036c6369013001046b696e642204096c6973702d706c7573036c63690130037461670110737461626c652d7265666572656e63652203096c6973702d706c7573036c636901300106646f6d61696e2204096c6973702d706c7573036c6369013007666978747572650206646f6d61696e1b696e746572707265746174696f6e2d6672616d652d736368656d612203096c6973702d706c7573036c636901300106736368656d652204096c6973702d706c7573036c6369013007666978747572650406736368656d651b696e746572707265746174696f6e2d6672616d652d736368656d610a7374727563747572616c01302203096c6973702d706c7573036c6369013001086d6174657269616c31042205096c6973702d706c7573036c636901300766697874757265056669656c6401046b696e642204096c6973702d706c7573036c636901300766697874757265020374616717666978747572652d737461626c652d6d6174657269616c2205096c6973702d706c7573036c636901300766697874757265056669656c6401096f626a6563742d69642204096c6973702d706c7573036c63690130076669787475726503066f626a6563741b696e746572707265746174696f6e2d6672616d652d736368656d61136d6e656d652d666978747572652d6672616d652205096c6973702d706c7573036c636901300766697874757265056669656c64010e6f626a6563742d76657273696f6e10002205096c6973702d706c7573036c636901300766697874757265056669656c64010e736368656d612d76657273696f6e10002203096c6973702d706c7573036c63690130010e736368656d612d76657273696f6e1000
```


### E1.2 Shared-octet obligation

The shared-octet obligation formerly stated for scope is extended to **all five base references and all five neutral expressions**. Independent Common Lisp and Python implementations MUST emit the exact complete lowercase hexadecimal CD/0 documents above. Equality expectations are exact validated abstract-value equality, witnessed by those octets. A diagnostic rendering, host printer, alias, digest, or display name is never an equality witness.

A change to any pinned value’s semantic meaning, nested reference, field set, normalization, or evolution ownership requires a new applicable claim-profile, frame-schema, calculus/model, or scheme version. The existing octets never change in place.

## E2 — Positive admissibility floor

Replace every ambiguous formulation equivalent to “target matching fails” with this exhaustive rule:

> A warrant MAY proceed to admissibility-policy evaluation only when `match-target` returns `R("exact-target")` or `R("supports-by-scope-narrowing")`.

Every F-valued target result is hard-inadmissible at this boundary. This includes `relation-undetermined`, `target-mismatch`, unsupported, incompatible, unknown, malformed, resource-refused, and every typed failure result regardless of its subcode.

An admissibility policy MAY reject either successful R-valued relation. It MUST NOT convert, wrap, reinterpret, downgrade, or otherwise promote an F-valued result into support. The policy is not consulted for the purpose of curing an F-valued relation. The exact result wrappers are `target-relation-result.exact` — 321 bytes; checksum `778c163d562f13e7cae83497f0e0d69a92fadfd5cb7eb91976a84d761ef3dffd` and `target-relation-result.scope-narrowing` — 336 bytes; checksum `d501881c7f4f08e077c4896c9a73edc4ebe1dbc3856fa1dc6027d012d18a84a5`.

The normative hard-inadmissibility witnesses are `LCI0-E2-COVERAGE`, `LCI0-E2-INCOMPATIBLE`, `LCI0-E2-NONMONOTONE`, and `LCI0-E2-UNKNOWN`; together they exercise target-mismatch, incompatible relation, undeclared narrowing, insufficient coverage, and relation-undetermined/unknown F-valued results. `LCI0-N012` remains the direct `match-target` unknown-relation witness.

## E3 — Version-bump governance

### E3.1 Tie-break

1. A change to the ClaimId field set, field ownership, projection role, or identity projection **changes the identity-policy version**.
2. A change to proposition grammar, normalization contract, semantic interpretation, interpretation-frame schema, or proposition/location consistency rules while the projection field set remains the same **changes the claim-profile version and/or frame-schema version** according to the changed owner.
3. A correction to an implementation that changes no accepted abstract input, normalized proposition, ClaimId, target relation, admissibility-floor result, or typed failure result need not change either version, but MUST carry conformance evidence proving preservation.
4. No meaning-changing normalizer revision may remain under the same declared claim-profile/frame-schema version. Finite vectors alone are insufficient authority for such a revision.
5. A change that crosses both ownership boundaries changes both applicable versions; authors MUST NOT use one version axis to conceal a change owned by the other.

### E3.2 Mandatory profile conformance evidence

Every normalizer revision MUST bind all three of the following exact records:

- `normalizer.conformance-binding.0` — 3200 bytes; checksum `c963d5080155130a1ac0716e9de9c99ed9923c114ad5f9589913cc4b309a971e`: immutable content identity or exact normative source artifact for the normalizer;
- `normalizer.mutation-vector.0` — 1665 bytes; checksum `06ee45abbeb3053c681464cf98e9a72901cabf61b95e5c25d7aa7b2f1bb33416`: at least one mutation witness per revision, including rejected and remapped surfaces where applicable;
- `normalizer.semantic-projection-ledger.0` — 13653 bytes; checksum `8947248fb4ec6f9fe13c23e7a1010b723c419866b53c680832e408d5c73bf185`: a before/after ledger over accepted-domain classes stating whether abstract input acceptance, normalized proposition, ClaimId, relation, or failure changed.

The ledger is an assurance artifact, not a field of ClaimId. The implementation binary, process image, compiler output, host path, deployment hash, or mutable package version MUST NOT be placed in ClaimId merely to establish conformance.

## E4 — Pre-projection normalization discipline

Every identity-bearing pre-projection normalizer for scope, subject-time, interpretation frame, dataset slice, and semantic boundary MUST be:

- total over its declared accepted source domain;
- deterministic;
- explicitly versioned and governed by E3;
- pure and independent of ambient state, locale, printer settings, registries, clocks, environment variables, network services, or mutable aliases;
- loss-reporting whenever source distinctions are discarded;
- applied before ClaimId projection.

The authoritative common contract is `algorithm.preprojection-normalization.0` — 1294 bytes; checksum `e38d6850c66d3842f23ea6d5134e6eeda2be3748778ed1b6e4e91d1b13c201fa`.

A proposition with no meaning-bearing interpretation context MUST use the exact pinned `neutral.self-describing-frame`. Co-denoting but structurally different time, frame, slice, or boundary expressions do not share ClaimId unless the exact versioned normalizer maps them to one canonical expression before projection. Implementations MUST NOT infer denotational equivalence after projection.

## E5 — Scope-narrowing failure vocabulary

The wider-target/narrower-candidate branch gains two distinct LCI failure codes:

- `ScopeNarrowingNotDeclared`: returned when the exact target-schema/proposition-form pair does not explicitly declare downward scope monotonicity.
- `ScopeNarrowingCoverageInsufficient`: returned when the target boundaries do not cover the candidate narrower scope, even though the form is declared monotone.

These paths MUST NOT return generic `ClaimTargetMismatch`, `ScopeWideningForbidden`, an implementation-local code, or a policy decision.

The mandatory witnesses are:

- `LCI0-E5-NONMONOTONE-NARROWING`: broad target, narrow candidate, all non-scope coordinates equal, nonmonotone proposition form, expected `ScopeNarrowingNotDeclared`;
- `LCI0-E5-COVERAGE-INSUFFICIENT`: monotone form with a target boundary that does not cover the candidate scope, expected `ScopeNarrowingCoverageInsufficient`.

A target schema’s monotonicity table is closed and form-specific. Implementations MUST NOT infer monotonicity from a form name, logical intuition, or another target kind.

## E6 — Deterministic intra-rank multi-fault precedence

LCI/0 selects deterministic schema-field order. For every closed record, failures are selected by this total procedure:

1. Frozen CD/0 parsing/decoding failures occur before any LCI-layer validation.
2. LCI validation ranks from the candidate specification are applied in their existing order.
3. Within one rank, missing required fields are tested in the schema’s declared field order.
4. Present declared fields are recursively validated depth-first in that same field order.
5. Sequence members are visited by increasing zero-based index.
6. After declared fields, unknown fields are visited in canonical CD/0 Identifier key order.
7. Named cross-field coherence checks run last in their declared order.
8. The first failure reached is returned with its exact category, code, stage, and structural path.

The authoritative algorithm record is `algorithm.validation-precedence.0` — 1477 bytes; checksum `8ebcb686b677e2c822bc71937325efeeea3ed1a66a8e158eefbfac2c631763ec`. Closed-schema declarations in the fixture registry own field and cross-check order. An implementation may internally discover faults in parallel, but its observable result MUST equal this walk.

## E7 — StableRef fixture-scheme closure

### E7.1 Exactly one fixture scheme per domain

For the first implementation profile, each domain below has exactly one canonical scheme. Domain and scheme Identifiers are themselves exact CD/0 values with complete octets in the registry. The material schema is uniformly the closed `FixtureStableMaterial/0` record with fields `kind`, `schema-version`, `object-id`, and `object-version`; domain-specific object-id prefixes are enforced.

| Domain | Domain registry item | Exact domain Identifier | Scheme registry item | Exact scheme Identifier | Scheme definition | Canonical example |
| --- | --- | --- | --- | --- | --- | --- |
| scope-calculus | `domain.scope-calculus` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "scope-calculus"]) | `scheme.scope-calculus.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "scope-calculus", "structural", "0"]) | `scheme-definition.scope-calculus.structural.0` | `stable-ref.scope-calculus.primary` |
| temporal-model | `domain.temporal-model` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "temporal-model"]) | `scheme.temporal-model.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "temporal-model", "structural", "0"]) | `scheme-definition.temporal-model.structural.0` | `stable-ref.temporal-model.primary` |
| dataset-slice-calculus | `domain.dataset-slice-calculus` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "dataset-slice-calculus"]) | `scheme.dataset-slice-calculus.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "dataset-slice-calculus", "structural", "0"]) | `scheme-definition.dataset-slice-calculus.structural.0` | `stable-ref.slice-calculus.primary` |
| semantic-boundary-calculus | `domain.semantic-boundary-calculus` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "semantic-boundary-calculus"]) | `scheme.semantic-boundary-calculus.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "semantic-boundary-calculus", "structural", "0"]) | `scheme-definition.semantic-boundary-calculus.structural.0` | `stable-ref.boundary-calculus.primary` |
| interpretation-frame-schema | `domain.interpretation-frame-schema` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "interpretation-frame-schema"]) | `scheme.interpretation-frame-schema.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "interpretation-frame-schema", "structural", "0"]) | `scheme-definition.interpretation-frame-schema.structural.0` | `stable-ref.frame-schema.primary` |
| logical-corpus | `domain.logical-corpus` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "logical-corpus"]) | `scheme.logical-corpus.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "logical-corpus", "structural", "0"]) | `scheme-definition.logical-corpus.structural.0` | `stable-ref.corpus.alpha` |
| immutable-corpus-revision | `domain.immutable-corpus-revision` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "immutable-corpus-revision"]) | `scheme.immutable-corpus-revision.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "immutable-corpus-revision", "structural", "0"]) | `scheme-definition.immutable-corpus-revision.structural.0` | `stable-ref.revision.alpha.3` |
| module | `domain.module` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "module"]) | `scheme.module.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "module", "structural", "0"]) | `scheme-definition.module.structural.0` | `stable-ref.module.mneme-fixture-profile` |
| procedure | `domain.procedure` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "procedure"]) | `scheme.procedure.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "procedure", "structural", "0"]) | `scheme-definition.procedure.structural.0` | `stable-ref.procedure.mneme-proposition-normalizer` |
| model | `domain.model` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "model"]) | `scheme.model.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "model", "structural", "0"]) | `scheme-definition.model.structural.0` | `stable-ref.model.alpha.1` |
| prompt-invocation | `domain.prompt-invocation` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "prompt-invocation"]) | `scheme.prompt-invocation.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "prompt-invocation", "structural", "0"]) | `scheme-definition.prompt-invocation.structural.0` | `stable-ref.invocation.call-17` |
| artifact | `domain.artifact` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "artifact"]) | `scheme.artifact.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "artifact", "structural", "0"]) | `scheme-definition.artifact.structural.0` | `stable-ref.artifact.file.alpha` |
| principal | `domain.principal` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "principal"]) | `scheme.principal.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "principal", "structural", "0"]) | `scheme-definition.principal.structural.0` | `stable-ref.principal.claimant-alpha` |
| policy | `domain.policy` | Id(["lisp-plus", "lci", "0", "fixture"], ["domain", "policy"]) | `scheme.policy.structural.0` | Id(["lisp-plus", "lci", "0", "fixture"], ["scheme", "policy", "structural", "0"]) | `scheme-definition.policy.structural.0` | `stable-ref.policy.a` |

Mutable aliases, display names, package names, file paths, registry lookup results, and unversioned external handles are refused as identity material. The first implementation MUST NOT choose among multiple schemes for the same fixture semantic object.

### E7.2 Future bridge rule

1. No declared bridge means different StableRef envelopes remain different ClaimIds/targets.
2. A bridge MUST be explicit, stable, versioned, total over its declared source domain, deterministic, and independently tested.
3. Canonicalization through a bridge occurs before projection; failure to bridge is typed and fail-closed.
4. A bridge does not retroactively make unequal CD/0 envelopes structurally equal and does not rewrite historical ClaimIds.
5. Migration, equivalence, and operational lookup remain explicit records. They do not collapse semantic equality.

The packet includes one explicit nonproduction bridge witness and one no-bridge witness; `LCI0-E7-BRIDGE-NONRETROACTIVE` proves that operational equivalence does not rewrite structural equality.

## E8 — Digest authority

Digest equality is never the definition of semantic ClaimId equality.

Semantic equality remains equality of validated ClaimId envelopes, witnessed by canonical CD/0 octets. A later digest MAY be an operational reference only under its own named cryptographic scheme. No collision rule, envelope-resolution rule, lookup convention, content-addressing convention, or successful digest verification may promote digest equality into semantic equality.

A digest-only purported ClaimId is refused. The fixture digest vectors deliberately use a nonproduction constant digest to prove that equal digests with unequal envelopes remain semantically unequal.

## E9 — Migration classifications and vectors

### E9.1 Vocabulary reconciliation

The seven LCI/0 classifications map to the prior ruling’s five terms as follows. Qualified many-to-one rows do not turn a gate, uncertainty, or privilege relation into a successful identity migration.

| LCI/0 classification | Prior-ruling term | Mapping qualification |
| --- | --- | --- |
| exact | exact | one-to-one |
| exact-after-explicit-tagging | explicitly-tagged | one-to-one |
| new-identity-required | profile-adapted | new LCI envelope projected; predecessor identity remains lineage only |
| lossy-with-represented-loss | lossy-with-represented-loss | one-to-one |
| rejected | rejected | one-to-one |
| deferred-to-named-calculus | profile-adapted | gate classification; must resolve through named calculus before final exact/tagged/lossy/rejected outcome |
| privileged-runtime-relation-outside-claim-id | profile-adapted | data may be projected as inert testimony; live authority is not migrated |

### E9.2 Required migration witnesses

The normative migration corpus MUST include exact vectors for:

- Unicode non-normalization, including NFC/NFD source distinctions;
- ambient-printer-setting and whitespace variation with no ambient printer dependence;
- hostile legacy payloads, including read-eval/reader-macro attempts;
- plausible-but-ambiguous `as-of` values;
- near-miss package/symbol mappings;
- syntactically valid but semantically wrong identifier mappings;
- legacy fingerprints colliding across scope;
- legacy fingerprints colliding across subject-time;
- legacy fingerprints colliding across immutable corpus revision;
- inert predecessor warrants;
- attempted live-warrant restoration.

The exact v1 grammar, source records, package/symbol table, source-site/role table, migration results, refusal tuples, and represented-loss accounts are defined in fixture §9 and the two machine artifacts. Migration MUST NOT invoke v1 code, host reader evaluation, current mutable registries, or live authority restoration. It creates zero live warrants.

## I12 — Incorporated clarifications

### I12(a) Reserved profile-location

Empty Mneme/0 `profile-location` is a reserved forward-compatibility slot and an explicit exception to the per-claim minimality test. It remains identity-bearing because its profile schema/version owns future profile coordinates. Its current empty value is exact and closed; implementations may not omit it.

### I12(b) Policy-evaluation target

A policy-evaluation WarrantTarget MUST record `inner-target-relation` and `testimony-mode`. The fixture mode is meta-testimony: it says that a named policy evaluated a named warrant under a named state snapshot and query time. It is not direct support for the embedded claim, and no consumer may erase that distinction.

### I12(c) Failure namespace

`PrivilegedRestorationAttempt` in this packet is an LCI failure code. It does not replace, alias, broaden, narrow, or reinterpret any frozen CD/0 category or code bearing similar words.

### I12(d) Recursive version closure

Unsupported nested calculus, temporal-model, slice-calculus, boundary-calculus, frame-schema, StableRef scheme/material, target schema, represented-loss account schema, and closed record versions fail closed recursively. No enclosing supported version may legalize an unsupported nested version.

### I12(e) Inert/live warrant debt

Inert/live warrant separation is a mandatory debt of the future warrant constitution. The present identity implementation may parse inert testimony and may refuse restoration. It MUST NOT invent issuance, standing, revocation, custody, revival, or live-authority transitions.

## Change boundary

| Surface | Effect of Errata 0.1 |
| --- | --- |
| ClaimId field set | No change |
| ClaimId field ownership/projection | No change |
| WarrantTarget field set | No change |
| Accepted previously determinate ClaimIds | No change |
| Already unambiguous canonical octets | No change |
| CD/0 | No change |
| LCI envelope version | Remains /0 |
| Identity-policy version | Remains 0 |
| Claim-profile version | Remains 0 |
| New base/neutral fixtures | First authoritative values and octets pinned here |
| Failure/wording seams | Closed |
| Selected constitutional model | Preserved; 0 BREAK |

Because this boundary holds, renewed constitutional review of the model is not required. Fable verification of this exact errata and fixture package remains required before implementation.
