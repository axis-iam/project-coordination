# Contract Sequencing

Use this reference when a change affects a public API, event, schema, browser client, SDK, or another consumer-facing boundary.

1. Locate the contract owner from local `AGENTS.md`, decision documents, and existing API sources. Do not infer ownership from directory names alone.
2. Record the desired request, response, error, nullable, enum, date, pagination, authorization, and compatibility behavior in the owning task or contract document.
3. Implement or verify the provider-side contract first when the contract is new or unresolved.
4. After the provider execution record exists, update consumers: frontend types and hooks, mocks, SDK types and methods, examples, and generated clients as applicable.
5. Validate the real provider path before treating mock, typecheck, or generated-code success as completion.
6. Record each consumer lane separately. A provider pass does not imply frontend, SDK, browser, or compatibility pass.

If the contract is already accepted and unchanged, consumers can proceed in parallel. State the accepted source and the compatibility assumption in each task record.
