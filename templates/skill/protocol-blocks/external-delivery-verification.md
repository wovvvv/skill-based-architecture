# External Delivery Verification

Load this protocol only when the user requested commit, push, MR/PR, deploy, publish, database delivery, or another shared-system artifact. It verifies existing authority; it never grants it or declares task completion.

## Verify

1. Name the authorized action, expected artifact, target/source identity, and exact readback before delivery.
2. Verify the real artifact rather than a precursor: inspect commit/ref, remote branch, MR/PR URL and state, deployed runtime, published output, migration/version artifact, or authoritative schema/data readback as applicable.
3. For database delivery, never infer execution from a reviewed SQL sibling or application build. Require the project-owned migration/version artifact plus authoritative schema/data proof.
4. Return `stale` when source content, branch/config inputs, relevant verification, or delivery premise changed; Task Closure sends the task back to fitted verification or Task Execution.
5. Return `blocked` for authorization, credentials, conflict, policy, network, or target-state failure. Retry only the external boundary when verified local inputs remain unchanged.

## Result

Return exactly one typed result with evidence: `verified`, `blocked`, `stale`, or `premise-changed`. Only `verified` can be consumed toward `Closure Complete`.

Rationalizations to reject:

- “The branch was pushed, so the requested MR probably exists.” Verify the actual MR/PR.
- “A login/network retry means every local test must run again.” Re-run only the blocked boundary unless an input changed.
