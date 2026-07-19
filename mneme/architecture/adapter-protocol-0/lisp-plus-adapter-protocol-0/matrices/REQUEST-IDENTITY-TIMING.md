# AP0 Request Identity Timing Matrix

| Class | Local ID | Idempotency ID | Provider ID | Reconciliation strength |
|---|---|---|---|---|
| pre-dispatch | required | optional | before send | strongest |
| acknowledgment | required | optional | in ack | strong |
| response-header | required | optional | header | strong |
| terminal-envelope | required | optional | terminal capture | moderate |
| reconciliation-only | required | optional | later query | delayed |
| unavailable | required | optional | absent | weak |
| conditional | required | optional | declared conditions | bounded |
