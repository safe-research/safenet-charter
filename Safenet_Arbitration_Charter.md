# Safenet Arbitration Charter

Authoritative rulebook for Safenet Security Council arbitration.
The canonical Charter is the IPFS document referenced by `safenet-charter.safe.eth`. Each transaction is governed by the Charter version effective when it was proposed.

---

## Article I — Purpose and Scope

This charter defines:

- what “secure” means under Safenet;
- which transaction-security rules the Security Council applies in disputed transactions;
- how Council rulings are made, recorded, and treated as precedent;
- how the Safenet Security Council is composed, authorised, and procedurally governed;
- how this charter relates to SafeDAO votes and Safenet protocol parameters;
- how Council rulings determine the applicable Sentinel slashing outcome;
- the Council's authority and explicit limits.

### Scope

- Safe settings-change blocking: block Safe settings changes submitted through Safenet, except where expressly allowed under the settings-change rules in Article IV.
- Delegatecall integrity: block delegatecalls that modify Safe storage, except where expressly allowed under the delegatecall integrity rules in Article IV.
- Target manipulation.
- Council composition, authority, procedure, precedent, and charter versioning.
- The scope may be expanded through the charter versioning process under § 5.4.

### Council and protocol boundaries

- The Council does not authorize transaction execution.
- A transaction that enters arbitration is not eligible for validator attestation, regardless of the ruling.
- A secure ruling resolves the arbitration and its protocol-defined Sentinel consequences only.
- Execution, fees, bonds, slashing, and timeout consequences remain governed by Safenet protocol rules.
- The Council cannot change protocol parameters, amend this Charter, or expand its own jurisdiction.

### Networks

- This charter’s transaction-security rules apply only to transactions submitted to Safenet on the following networks:
  - Ethereum
  - Arbitrum
  - Gnosis Chain
- Council composition, authority, procedure, precedent, and versioning provisions apply independently of network unless stated otherwise.
- Future networks may be added through the charter versioning process under § 5.4.

### Versioning

- Charter versions are governed by § 5.4.

### Common law model

- Initial rules are set at launch.
- Council rulings are rebuttable precedent as defined in § 5.1.
- Only SafeDAO may codify precedent through adoption of a later Charter version.
- Goal: reduce manual Council load and enable programmatic arbitration for clear cases.

---

## Article II — Definitions

### § 2.1 Safe

#### Definition

- A Safe is an Ethereum-compatible smart account that uses the official Safe smart account implementation developed by the Safe Ecosystem Foundation.

#### Council considers

- only Safe accounts using official Safe smart account versions developed by the Safe Ecosystem Foundation;
- only code tagged as an official version in the Safe Ecosystem Foundation GitHub repository.

#### Rules

- Valid Safe smart account versions are:
  - 1.3.0
  - 1.4.1
  - 1.5.0
- The official Safe Ecosystem Foundation GitHub repository for the Safe smart account is:
  - `https://github.com/safe-fndn/safe-smart-account`

#### Notes

- Documentation for the Safe smart account is available at:
  - `https://docs.safefoundation.org/smart-account/overview`

### § 2.2 Solidity

#### Definition

- Solidity is a programming language, compiler, optimizer, and related language specification used to develop Ethereum smart accounts.

#### Council considers

- only Solidity versions relevant to Safenet or the official Safe smart account versions listed in § 2.1;
- official Solidity versions, documentation, compiler behavior, and tagged source code maintained by the Ethereum Foundation or Argot.

#### Rules

- Solidity-specific terms used in this charter, including `mapping`, ABI encoding, and compiler-generated getter behavior, are interpreted according to the applicable Solidity language semantics.
- The charter does not independently restate or override Solidity language semantics.

#### References

- Official Solidity documentation:
  - `https://docs.soliditylang.org/`
- Official Solidity repository:
  - `https://github.com/argotorg/solidity`

### § 2.3 Transaction

#### Definition

- A transaction is any Safe transaction payload submitted to Safenet for a security determination.

#### Includes

- Safe address;
- chain ID;
- Safe transaction `to` address;
- value;
- calldata;
- operation;
- nonce;
- gas and refund parameters, if included in the Safe transaction payload;
- other transaction parameters defined by the relevant Safe smart contracts;
- contextual metadata included in the proposal.

### § 2.4 Expected target set

#### Definition

- The expected target set is the set of economically or permission-relevant target addresses consistent with the user’s established onchain pattern.

#### Target address means

- the address that receives value or tokens, is granted approvals or permissions, or otherwise receives economically relevant effects from the transaction;
- not merely an intermediate contract address called by the Safe transaction.

#### Council considers

- prior transaction history on the relevant network;
- protocol-recorded purpose, if any (§ 2.11);
- standard user behavior for comparable transactions (§ 2.9).

#### Notes

- A new target address is not automatically outside the expected target set.
- A contract may be a target address if it is the economically or permission-relevant counterparty of the interaction.
- If ambiguous, the Council applies the Article III ambiguity standard.

### § 2.5 Functionally unlimited token approval

#### Definition

- A token approval is functionally unlimited if its amount or permission scope materially exceeds what is plausibly needed for the stated interaction.

#### Applies only to

- ERC-20 approvals;
- ERC-721 operator approvals;
- ERC-1155 operator approvals.

#### Council considers

- token supply;
- token decimals, where applicable;
- token type;
- nature and scale of the interaction.

#### Rules

- Max `uint256` ERC-20 approval is always functionally unlimited.
- ERC-721 or ERC-1155 operator approval for all tokens is functionally unlimited unless plausibly required for the stated interaction.
- “Stated interaction” is determined from onchain data (§ 2.8) and protocol-recorded purpose (§ 2.11).
- Offchain context is admissible only if it qualifies as public offchain security evidence under Article III.
- Private or unverifiable user-intent statements carry no weight.

### § 2.6 Reputable threat intelligence source

#### Definition

- A reputable threat intelligence source is a public or professionally operated security source the Council reasonably treats as reliable for identifying malicious, compromised, or high-risk addresses or contracts.

#### Council considers

- independence;
- methodology;
- public accessibility;
- track record;
- attribution to an identifiable source.

#### Rules

- The Council does not maintain a recognised-source registry.
- Source reliability is assessed case-by-case.
- A source is not excluded merely because it is operated by, affiliated with, or surfaced through a Sentinel.
- Prior Council precedent may guide reliability findings.
- A source is not excluded merely because it lacks a complete timestamped archive, if the Council can identify:
  - when the evidence was observed;
  - why the source was treated as reliable.

### § 2.7 Public security flag

#### Definition

- A public security flag is admissible public offchain security evidence that an address, contract, application, or transaction pattern is malicious, compromised, exploited, or otherwise high-risk.

#### Examples

- reputable threat-intelligence label;
- block explorer warning;
- security-provider report;
- public incident disclosure;
- comparable public security source.

#### Rules

- The Council does not maintain a deny-list.
- The Council decides case-by-case whether public security evidence is reliable and relevant.
- For each public security flag relied on, the Council must identify:
  - source;
  - observation time;
  - reliability basis.

### § 2.8 Onchain data

#### Definition

- Onchain data means blockchain data publicly observable at the transaction proposal time.

#### Includes, but is not limited to

- transaction history;
- contract bytecode;
- event logs;
- token balances;
- ENS records;
- transaction payload contents;
- EVM execution traces.

### § 2.9 Standard user behavior

#### Definition

- Standard user behavior means what a reasonably informed, non-malicious user would do in a comparable transaction.

#### Rules

- Determined from admissible evidence under Article III.
- May include onchain data, protocol-recorded transaction context, and public offchain security context.
- Does not require inquiry into the specific user’s subjective intent.
- Private or unverifiable user-intent statements carry no weight.

### § 2.10 Settings

#### Definition

- Settings are Safe configuration parameters.

#### Includes

- singleton implementation address;
- enabled modules;
- fallback handler;
- guard;
- module guard;
- owner list;
- signing threshold.

### § 2.11 Protocol-recorded purpose

#### Definition

- Protocol-recorded purpose is a context field or label that is part of the transaction payload or protocol-defined proposal submitted to the Safenet oracle.

#### Must be one of

- cryptographically signed by the submitting account;
- recorded onchain at proposal time;
- otherwise recorded in a protocol-controlled or publicly verifiable proposal system.

#### Effect

- Protocol-recorded purpose has the highest weight for determining the stated interaction.

#### Potentially admissible under Article III, but not protocol-recorded purpose

- public app metadata;
- public dapp documentation;
- public transaction-flow context;
- public security warnings;
- other public, attributable, and reasonably verifiable offchain context.

#### Excluded

- private user statements;
- private messages;
- after-the-fact explanations;
- application-layer claims that are not public, attributable, or reasonably verifiable.

#### Effect of exclusion

- Excluded statements carry no evidentiary weight.

### § 2.12 Applicable Charter version

#### Definition

- The applicable Charter version is the IPFS document referenced by `safenet-charter.safe.eth` when the transaction was proposed.

### § 2.13 Council ruling

#### Definition

- A valid Council ruling on an in-scope arbitration request is `secure` or `insecure`. The Council cannot issue an `unknown` ruling.
- The Council may determine that a request is `out of scope` under § 3.9. This is not a security ruling.

### § 2.14 Sentinel vote reason

#### Definition

- Every revealed Sentinel vote carries a `reason` string. The exact string is cryptographically bound to the Sentinel's prior commitment and emitted onchain.
- The protocol accepts an empty or arbitrary string and does not validate whether the reason correctly applies this Charter. The reason does not affect vote counting or create another verdict.

#### Current standard Sentinel behavior

- A secure vote uses an empty reason.
- An insecure vote uses the applicable Charter rule identifier.

### § 2.15 Affected Sentinel

#### Definition

- An affected Sentinel is a Sentinel whose vote may result in Council-directed slashing in the arbitration.

### § 2.16 Conflict of interest and recusal

#### Definitions

- A conflict of interest is an interest or relationship reasonably capable of impairing a Council member's independent judgment.
- Recusal means that the conflicted member does not sign the ruling. Recusal does not change the Arbitrator Safe's configured threshold.

### § 2.17 Valid ruling

#### Definition

- A valid ruling satisfies this Charter's applicable requirements, is approved through the Council's Arbitrator Safe, and is submitted to the Safenet arbitration protocol within four weeks after arbitration begins. Reaching the Arbitrator Safe's threshold alone does not complete the ruling.

### § 2.18 Escape-hatch announcement transaction

#### Protocol boundary

- Calls to the Safenet Guard's `announceTransaction` and `cancelAnnouncement` functions are auto-allowed by the Guard without Sentinel review or Council arbitration.
- An announcement commits to every parameter of the future Safe `execTransaction` except the Safe nonce and signatures.
- The Guard does not constrain the outer announcement transaction's gas or refund parameters. Any requirement such as `gasPrice == 0` must be implemented or enforced at the contract, protocol, or transaction-construction layer and is outside this Charter.

---

## Article III — Ruling Standard

### § 3.1 Core question

> *"Given the admissible evidence available to Safenet, and applying this charter’s scope, rules, and standard user behavior, would the Safenet Security Council consider this transaction secure?"*

### § 3.2 Objective intent standard

#### Rules

- The Council considers objective transaction intent as evidenced by admissible evidence.
- Objective transaction intent may be inferred from calldata, decoded transaction effects, Safe transaction `to` addresses, target addresses under § 2.4, value transfers, prior onchain behavior, protocol-recorded purpose, and public, attributable transaction context.
- The Council does not rely on private, unverifiable, or after-the-fact user-intent claims.

### § 3.3 Admissible evidence

#### Admissible categories

- Onchain data (§ 2.8).
- Protocol-recorded purpose (§ 2.11).
- Public, attributable, and reasonably verifiable offchain context.
- Public offchain security evidence.

#### Public offchain context includes

- public app metadata;
- public dapp documentation;
- public transaction-flow context;
- public security warnings;
- public incident disclosures.

#### Public offchain security evidence includes

- threat-intelligence labels;
- block explorer warnings;
- security-provider reports;
- public evidence of compromise, phishing, malware, address poisoning, or ongoing attack activity.

### § 3.4 Offchain security evidence

#### Rule

- Offchain security evidence is admissible if it is public, attributable, and reasonably verifiable.

#### Council may consider it even if

- it was not recorded onchain at proposal time; and
- it is available before the Council ruling.

#### Council must identify

- source;
- observation time;
- reliability basis.

#### Protocol notice

- The onchain opening of an arbitration constitutes protocol notice. This Charter creates no additional communication, evidence-access, or response duty.

### § 3.5 Excluded evidence

#### Excluded

- private or unverifiable user-intent claims;
- after-the-fact user statements;
- private messages;
- application-layer claims that are not public, attributable, or reasonably verifiable.

### § 3.6 Non-retroactivity

#### Rules

- The applicable charter version is the version in effect at proposal time.
- Public offchain security evidence may be considered if available before the Council ruling.
- The Council must state when later evidence was observed.
- Later evidence may not be treated as if it had been available earlier.

### § 3.7 Rule failure

#### Rules

- A transaction is secure only if it satisfies all applicable Article IV rules.
- If it fails any Article IV rule, it is insecure.
- Deterministic rule failure is established by direct application of the rule.
- Principle-based rule failure requires a reasonable evidence-grounded Council finding.
- Where the protocol-supported ruling format permits, the Council should identify the applicable Charter rule and version in the ruling explanation or associated metadata.

### § 3.8 Ambiguity

#### Rule

- If admissible evidence is genuinely evenly balanced on a material security question, the Council rules the transaction insecure.
- Minor ambiguity that does not materially affect the security determination does not by itself make a transaction insecure.

#### A principle-based insecurity finding is reasonable if defensible by reference to

- admissible evidence;
- standard user behavior;
- this charter’s scope and rules.

#### Evidence weighting

- Direct evidence carries the most weight.
- Circumstantial evidence is weighed cumulatively.
- No single circumstantial factor is determinative.
- Absence of evidence may be circumstantial evidence, but is not determinative alone.

### § 3.9 Out-of-scope requests

#### Rule

- If an arbitration request is outside the transaction-security scope or networks defined in Article I, the Council determines it is out of scope and does not make a security determination under this Charter.

#### Effect

- An out-of-scope determination is neither a `secure` nor an `insecure` ruling.
- The Council does not submit a `resolveDispute` transaction for that request.
- The request remains unresolved until the protocol-defined arbitration timeout applies.
- An out-of-scope determination is not a finding that the transaction is malicious, compromised, or otherwise insecure.

#### Council outcomes

- A valid Council ruling on an in-scope request can only be `secure` or `insecure`.
- The Council cannot issue an `unknown` ruling.

---

## Article IV — Transaction Security Rules

### Part A — Deterministic rules

#### Nature of deterministic rules

- The Council does not exercise discretion.
- Failing any deterministic rule makes the transaction insecure.
- No further analysis is required for that deterministic failure.

---

### R-4.1 — Settings-change blocking

#### Rule

- A transaction is insecure if it modifies any Safe setting (§ 2.10), unless it falls within an allowed exception below.

#### Applies to

- singleton implementation address;
- enabled modules;
- fallback handler;
- guard;
- module guard;
- owner list;
- signing threshold.

#### Allowed exceptions

A settings change is not insecure under this rule only if all of the following apply:

- transaction is a non-batched multisignature Safe transaction;
- the transaction is triggered via `execTransaction`;
- `to` is the Safe itself;
- `operation` is `0` for CALL;
- `value` is `0`;
- `data` is a valid setting-change function following canonical Solidity ABI encoding, as interpreted under § 2.2 Solidity;
- the setting-change function is one of:
  - `disableModule` with any valid parameter;
  - `setFallbackHandler` with the zero address as the `handler` parameter.

#### Council applies by checking

- whether the transaction modifies a Safe setting;
- whether the transaction satisfies all requirements for an allowed exception.

#### Effect

- Any settings-change transaction that does not satisfy an allowed exception is insecure.
- No intent inquiry is required.

#### Note

- Other legitimate Safe settings changes must use the protocol-defined settings-change path outside Safenet’s standard transaction-security flow.

---

### R-4.2 — Delegatecall integrity

#### Rule

- A transaction is insecure if it performs a delegatecall that changes any storage slot of the Safe.

#### Exceptions

- Storage slots related to onchain message signing, meaning only data stored in the signedMessages mapping type and accessible via the Solidity-generated getter method, as interpreted under § 2.2 Solidity.

#### Council applies by checking

- whether the transaction performs a delegatecall;
- whether the transaction modifies any storage slots of the Safe that are not included in the exceptions.

#### Effect

- A transaction invoking a contract using delegatecall that modifies storage slots not included in the exceptions is insecure.
- A transaction invoking a contract using delegatecall that only modifies storage slots included in the exceptions passes this deterministic rule only.
- Passing this rule does not prevent an insecurity ruling under:
  - target-manipulation rules;
  - public-security-evidence rules;
  - any rule addressing compromised or high-risk contracts.

#### No warranty

- Inclusion does not mean the Council certifies the contract invoked with a delegatecall as bug-free, non-exploitable, or safe in all contexts.
- If admissible evidence indicates that the contract invoked with a delegatecall is compromised, exploited, affected by a serious bug, or otherwise high-risk, a transaction using it may still be insecure under R-4.6.

---

### Part B — Target manipulation

#### Nature of target-manipulation rules

- Principle-based.
- Apply Article II definitions.
- Apply the Article III ambiguity standard.
- Prior rulings are considered under § 5.1.

---

### R-4.3 — Value-target manipulation

#### Rule

- A transaction is insecure if it sends value to a recipient address outside the expected target set.

#### Council applies by checking

- the expected target set under § 2.4;
- whether the value recipient address is inside or outside that set.

#### For novel recipient addresses, Council weighs whether

- the recipient address has legitimate onchain history consistent with the protocol-recorded purpose (§ 2.11);
- the recipient address resembles a prior user address in a way consistent with address poisoning;
- standard users conducting comparable transactions would send value to this recipient address (§ 2.9).

#### Precedent

- Ambiguous-case rulings become rebuttable precedent under Article V.

---

### R-4.4 — Authorization-target manipulation: wrong target

#### Rule

- A transaction is insecure if it grants spend authority, operator rights, or equivalent permissions to an address outside the expected target set.

#### Applies to

- ERC-20 approvals;
- ERC-721 operators;
- ERC-1155 approval-for-all;
- functionally equivalent permission mechanisms.

#### Council applies by checking

- the expected target set under § 2.4;
- whether the authorization target is inside or outside that set.

#### Effect

- Authorization to an address outside the expected target set is insecure.

---

### R-4.5 — Authorization-target manipulation: excessive approval amount

#### Rule

- A transaction is insecure if it grants a functionally unlimited approval (§ 2.5).

#### Immediate failure

- Max `uint256` ERC- 20 approval is always functionally unlimited.
- The Council rules immediately without further analysis.

#### For other amounts, Council weighs

- token supply and decimals;
- nature and scale of the interaction, using onchain data (§ 2.8) and protocol-recorded purpose (§ 2.11);
- standard user behavior in comparable interactions (§ 2.9).

#### Notes

- An approval can be functionally unlimited even if not technically max `uint256`.
- Prior rulings on specific amounts or token types are rebuttable precedent under Article V.

---

### R-4.6 — Known malicious or compromised target

#### Rule

- A transaction is insecure if it interacts with an address or contract where admissible evidence supports a reasonable finding that the target is malicious, compromised, exploited, or otherwise high-risk before the Council ruling.

#### Council applies by checking

- onchain data (§ 2.8);
- public security flags (§ 2.7);
- source reliability, where applicable (§ 2.6);
- source, observation time, and reliability basis for any public security flag relied on;
- corroborating onchain evidence, where relevant.

#### Effect

- A reasonable evidence-grounded finding that the target is malicious, compromised, exploited, or otherwise high-risk makes the transaction insecure.

#### Precedent

- Rulings on application of security evidence may become rebuttable precedent under Article V, unless superseded by this Charter or protocol parameters.

---

## Article V — Precedent, Codification, and Charter Versions

### § 5.1 Common law principle

#### Rule

- A prior ruling is rebuttable precedent for a materially similar later case. The Council should follow it unless the later case is materially distinguishable or the Council identifies and explains a justified reason for departure under § 6.4. Precedent cannot amend or override this Charter.

#### Council must

- identify the most closely analogous prior ruling before exercising independent judgment on a fact pattern that has previously been decided;
- apply the most closely analogous prior ruling unless the later case is materially distinguishable or a ground under § 6.4 justifies departure.
- identify the prior ruling and explain any departure from it.

#### For novel fact patterns, Council must

- reason by analogy from the closest rule or precedent;
- state the analogy in the ruling;
- record the ruling as precedent;
- flag the issue for possible amendment by SafeDAO.

### § 5.2 Precedent record

#### Authoritative record

- The authoritative record of a ruling is the onchain arbitration transaction submitted through the Safenet arbitration protocol.
- The Arbitrator Safe submits `resolveDispute(requestId, approveWins, context)`. The resulting `DisputeResolved` event records the request, outcome, slashed amount, and `context`.
- The `context` must contain a concise ruling explanation or an IPFS CID referencing the ruling explanation.

#### Onchain-identifiable information

- request and disputed transaction;
- ruling outcome;
- ruling transaction and timestamp.

#### The ruling explanation must identify

- the Safe and network;
- the applicable Charter version;
- at least one applicable rule identifier and any precedent applied;
- any material evidence relied on;
- any recusals;
- the reason for the ruling.

#### A ruling establishes precedent when it

- resolves a disputed transaction; and
- states or applies a rule, analogy, source-reliability finding, or interpretation relevant to future cases.

#### Indexes and summaries

- Future Council rulings should identify and apply the most relevant prior arbitration transactions where available.
- Any offchain index, list, interface, or summary of prior rulings is informational only.
- If an offchain index conflicts with the protocol-recognised ruling record, the protocol-recognised ruling record controls.

### § 5.3 Codification

#### Rule

- Any person may propose a Charter amendment through the SafeDAO governance process. The Council may also recommend amendments. Only SafeDAO may adopt and activate a new Charter version.

#### Effect

- Codified rules are incorporated into Article IV.
- Codified rules are treated as deterministic rules from the effective date of the new version.
- The precedent from which a codified rule derives is noted in the charter for reference.

### § 5.4 Charter versions

#### Update authority

- Any person may propose an amendment through the SafeDAO governance process. The Council may recommend amendments but cannot adopt or activate them. Only SafeDAO may adopt and activate a new Charter version.

#### Each version must identify

- version number;
- the SafeDAO proposal approving the version;
- the IPFS hash referenced by `safenet-charter.safe.eth`;
- canonical publication location;
- material changes from the prior version.

#### Adoption and effectiveness

- A proposed version is published on IPFS.
- A successful SafeDAO proposal authorizes the update of the IPFS hash referenced by `safenet-charter.safe.eth`.
- The new version becomes effective when the approved ENS update executes.

#### Effect of new versions

- A new version applies only to transactions proposed after it becomes effective.
- Each transaction and resulting ruling remain governed by the Charter version effective when the transaction was proposed.

#### Publication

- Versions are published on IPFS; `safenet-charter.safe.eth` references the canonical effective version.
- Each Charter version must identify its IPFS CID and approving SafeDAO proposal.
- Historical versions are identified by the onchain history of updates to `safenet-charter.safe.eth`. SafeDAO governance history may provide a corresponding human-readable index.
- If publication metadata conflicts, the IPFS hash referenced by `safenet-charter.safe.eth` controls.

---

## Article VI — Council Composition, Authority, and Procedure

### § 6.1 Council composition

#### Rule

- The Safenet Security Council is the body responsible for applying this charter to transactions that enter arbitration under the applicable Safenet protocol rules.

#### Council composition

- The Council members and Arbitrator Safe threshold are defined through a SafeDAO proposal.
- Appointment and removal are controlled by SafeDAO. Membership creates no entitlement to continuation or reappointment.
- A SafeDAO vote may delegate operational details to a Council mandate, provided the delegation is public and specific.

#### Eligibility and independence

- Members must have relevant security-governance expertise.
- Council membership and the Council mandate create no contractual relationship with SEF.

#### Effect

- A Council ruling is valid only if issued by the Council appointed under the applicable SafeDAO vote.

### § 6.2 Council authority

#### Authority

- The Council may decide only transactions that enter arbitration under the applicable Safenet protocol rules.
- For an in-scope request, the Council may rule only `secure` or `insecure`. It may determine that a request is `out of scope` under § 3.9, which is not a security ruling.
- The Council may apply rebuttable precedent under Article V.
- The Council may identify issues and recommend future amendments to SafeDAO.

#### Limits

- The Council must not issue arbitrary, discriminatory, malicious, bad-faith, grossly negligent, self-interested, or revenue-motivated rulings.
- The Council cannot authorize transaction execution, change protocol parameters, direct funds outside the protocol-defined outcome, expand its jurisdiction, or amend this Charter.

#### No general certification

- A ruling that a transaction is secure means only that the transaction did not fail the applicable Safenet security rules under the admissible evidence standard.
- It is not a general certification that the transaction, contract, app, token, or protocol is safe in all respects.

### § 6.3 Council procedure

#### Procedure

1. A split Sentinel decision enters arbitration under the applicable Safenet protocol rules.
2. The disputed transaction, Sentinel votes, and affected Sentinels are identified.
3. Council members disclose conflicts of interest. A conflicted member recuses by not signing the ruling.
4. Recusal does not change the Arbitrator Safe's configured threshold.
5. The onchain opening of arbitration constitutes protocol notice; this Charter creates no additional communication or response duty.
6. Eligible Council members evaluate the transaction under the applicable Charter version and may consider only admissible evidence.
7. For an in-scope request, the Council approves a reasoned ruling satisfying § 5.2 through the Arbitrator Safe and submits it to the Safenet arbitration protocol.
8. For an out-of-scope request under § 3.9, the Council does not submit `resolveDispute`; the protocol-defined arbitration timeout applies.
9. An in-scope ruling is valid only if it is submitted to the Safenet arbitration protocol within four weeks after arbitration begins. Reaching the Arbitrator Safe's threshold alone does not complete the ruling.
10. If no valid ruling is submitted within four weeks, the protocol-defined fallback returns participating Sentinel bonds, refunds the Proposer fee, and applies no Council-directed slashing.
11. A transaction that entered arbitration remains ineligible for validator attestation regardless of the ruling or fallback.

#### Minimum ruling requirements

- Each in-scope ruling must satisfy the record requirements in § 5.2.

### § 6.4 Precedent review

#### Rule

- Final Council rulings are not reversed or retroactively changed under this charter.
- Prior rulings are rebuttable precedent for later cases under § 5.1.
- This does not create an appeal or reconsideration process for a specific ruling; a ruling's outcome and any resulting slashing are final for the transaction it decided.

#### Council may distinguish, narrow, or depart from a prior ruling if

- the prior ruling is inconsistent with this charter;
- material facts or protocol assumptions have changed;
- later Council experience shows the prior precedent is unsafe, overbroad, unclear, or impracticable;
- the later case is materially distinguishable from the earlier ruling.

#### Effect

- A ruling that distinguishes, narrows, or departs from a prior ruling must identify it and explain the reason.
- The prior ruling remains final for the transaction it decided.
- Any revised treatment of precedent applies only to later cases.

### § 6.5 SafeDAO and protocol primacy

#### Rule

- This charter defines the substantive transaction-security standard applied by the Council.
- SafeDAO votes define Council composition, appointment, removal, and mandate.
- Safenet protocol parameters define arbitration eligibility, procedural mechanics, economic mechanics, and execution mechanics.
- A Council ruling determines the applicable Sentinel slashing outcome but does not authorize the disputed transaction for validator attestation or execution.
- A transaction that enters arbitration remains ineligible for validator attestation regardless of the ruling.

#### Protocol economic mechanics include

- bonds;
- slashing;
- rewards;
- fee allocation;
- execution or non-execution consequences.

#### Slashing alignment

- Automatic non-reveal slashing occurs under the protocol rules without a Council decision.
- Council-directed slashing may occur only following a valid Council ruling.
- The applicable Sentinel Terms and protocol rules must authorize both mechanisms; this Charter does not create a contractual relationship with SEF.

#### Conflict hierarchy

- For Council composition, appointment, removal, mandate, or procedural authority, the applicable SafeDAO vote controls.
- For arbitration eligibility, procedural mechanics, economic mechanics, or execution mechanics, the applicable Safenet protocol parameters control.
- For the substantive transaction-security standard, this charter controls unless amended by SafeDAO vote or updated under § 5.4.

#### Conflict handling

- If a conflict affects the substantive transaction-security standard, the Council must flag the conflict for SafeDAO review or charter update.

### § 6.6 Severability

#### Rule

- If any provision of this charter is invalid, unenforceable, superseded by SafeDAO vote, or superseded by Safenet protocol parameters, the remaining provisions continue to apply.

---

— End of Safenet Arbitration Charter —
