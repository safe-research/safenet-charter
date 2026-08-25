# Safenet Arbitration Charter

> **Status:** Draft — format proposal. Not yet in force.
>
> **Version:** v1
>
> **Effective date:** TBD — pending Security Council formation
>
> **Issued by:** Safenet Security Council

Authoritative rulebook for Safenet Security Council arbitration.

---

## Article I — Purpose and Scope

This charter defines:

- what “secure” means under Safenet;
- which transaction-security rules the Security Council applies in disputed transactions;
- how Council rulings are made, recorded, and treated as precedent;
- how the Safenet Security Council is composed, authorised, and procedurally governed;
- how this charter relates to SafeDAO votes and Safenet protocol parameters.

### Scope

- Safe settings-change blocking: block Safe settings changes submitted through Safenet, except where expressly allowed under the settings-change rules in Article IV.
- Delegatecall integrity: block delegatecalls that modify Safe storage, except where expressly allowed under the delegatecall integrity rules in Article IV.
- Target manipulation.
- Council composition, authority, procedure, precedent, and charter versioning.
- The scope may be expanded through the charter versioning process under § 5.4.

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
- Council rulings become precedent.
- Settled precedent may be codified into later charter versions.
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

- If an arbitration request is outside the transaction-security scope or networks defined in Article I, the Council records it as out of scope and does not make a security determination under this charter.

#### Effect

- An out-of-scope request is not treated as secure.
- Unless another applicable Safenet process accepts the request, an out-of-scope request must not proceed through Safenet.
- An out-of-scope status is not a finding that the transaction is malicious, compromised, or otherwise insecure.

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
- Prior similar rulings are binding precedent under Article V.

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

- Ambiguous-case rulings become precedent under Article V.

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
- Prior rulings on specific amounts or token types are precedent.

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

- Rulings on application of security evidence may become precedent under Article V, unless superseded by protocol parameters.

---

## Article V — Precedent, Codification, and Charter Versions

### § 5.1 Common law principle

#### Rule

- Prior rulings of the Council on similar fact patterns are binding precedent in future cases, subject to precedent review under § 6.4.

#### Council must

- identify the most closely analogous prior ruling before exercising independent judgment on a fact pattern that has previously been decided;
- apply the most closely analogous prior ruling where applicable.

#### For novel fact patterns, Council must

- reason by analogy from the closest rule or precedent;
- state the analogy in the ruling;
- record the ruling as precedent;
- flag the issue for possible codification in a future charter version.

### § 5.2 Precedent record

#### Authoritative record

- The authoritative record of a ruling is the onchain arbitration transaction issued through the Safenet arbitration oracle or other protocol-recognised ruling mechanism in effect at the relevant time.
- The authoritative record includes any ruling metadata, explanation, or evidence reference included in or linked from that transaction.

#### The ruling record should identify, where available

- the disputed transaction;
- the ruling outcome;
- the ruling timestamp;
- the applicable charter version;
- the rule or precedent applied;
- any public evidence relied on;
- any content-addressed evidence or explanation reference.

#### A ruling establishes precedent when it

- resolves a disputed transaction; and
- states or applies a rule, analogy, source-reliability finding, or interpretation relevant to future cases.

#### Indexes and summaries

- Future Council rulings should identify and apply the most relevant prior arbitration transactions where available.
- Any offchain index, list, interface, or summary of prior rulings is informational only.
- If an offchain index conflicts with the protocol-recognised ruling record, the protocol-recognised ruling record controls.

### § 5.3 Codification

#### Rule

- Where a line of precedent has established a rule with sufficient clarity and consistency that it can be stated as a bright-line standard, the Council may codify that rule into a new version of this charter.

#### Effect

- Codified rules are incorporated into Article IV.
- Codified rules are treated as deterministic rules from the effective date of the new version.
- The precedent from which a codified rule derives is noted in the charter for reference.

### § 5.4 Charter versions

#### Update authority

- This charter may be updated by the Security Council only within the update authority delegated by SafeDAO vote.

#### Each version must identify

- version number;
- effective date;
- canonical publication location;
- material changes from the prior version.

#### Effect of new versions

- A new version applies only from its effective date.
- Prior rulings remain governed by the charter version in effect at the relevant time.

#### Publication

- Versions are published on IPFS and pinned at the canonical ENS location defined by Safenet protocol parameters.
- The latest version is referenced at the protocol-recognised latest-version location.
- If publication metadata conflicts, protocol-recognised publication metadata controls.

---

## Article VI — Council Composition, Authority, and Procedure

### § 6.1 Council composition

#### Rule

- The Safenet Security Council is the body responsible for applying this charter to transactions that enter arbitration under the applicable Safenet protocol rules.

#### Council composition

- The Council consists of members appointed by SafeDAO vote.
- The number of Council members, appointment process, replacement process, term length, and removal process must be defined by SafeDAO vote.
- A SafeDAO vote may delegate operational details to a Council mandate, provided the delegation is public and specific.

#### Effect

- A Council ruling is valid only if issued by the Council appointed under the applicable SafeDAO vote.

### § 6.2 Council authority

#### Authority

- The Council may decide only transactions that enter arbitration under the applicable Safenet protocol rules.
- The Council may classify an arbitration request as secure, insecure, or out of scope, as applicable under this charter.
- The Council may apply precedent under Article V.
- The Council may identify issues for future charter updates.

#### No general certification

- A ruling that a transaction is secure means only that the transaction did not fail the applicable Safenet security rules under the admissible evidence standard.
- It is not a general certification that the transaction, contract, app, token, or protocol is safe in all respects.

### § 6.3 Council procedure

#### Procedure

- Council voting procedure, quorum, voting period, submission format, evidence-submission process, ruling publication, economic mechanics, and execution mechanics are governed by this charter, the applicable SafeDAO vote, and Safenet protocol parameters.

#### Minimum ruling requirements

- Each ruling should identify, where applicable:
  - the disputed transaction;
  - the ruling outcome;
  - the applicable charter version;
  - the rule or precedent applied;
  - the evidence relied on;
  - the reason for the ruling.

### § 6.4 Precedent review

#### Rule

- Final Council rulings are not reversed or retroactively changed under this charter.
- The Council may review how prior rulings are taken into account as precedent in later cases.

#### Council may distinguish, narrow, or revise the precedential effect of a prior ruling if

- the prior ruling is inconsistent with this charter;
- material facts or protocol assumptions have changed;
- later Council experience shows the prior precedent is unsafe, overbroad, unclear, or impracticable;
- the later case is materially distinguishable from the earlier ruling.

#### Effect

- A ruling that distinguishes, narrows, or revises the precedential effect of a prior ruling must identify the prior ruling and explain the reason for the change.
- The prior ruling remains final for the transaction it decided.
- Any revised treatment of precedent applies only to later cases.
- The prior ruling remains final for the transaction it decided.

### § 6.5 SafeDAO and protocol primacy

#### Rule

- This charter defines the substantive transaction-security standard applied by the Council.
- SafeDAO votes define Council composition, appointment, removal, and mandate.
- Safenet protocol parameters define arbitration eligibility, procedural mechanics, economic mechanics, and execution mechanics.

#### Protocol economic mechanics include

- bonds;
- slashing;
- rewards;
- fee allocation;
- execution or non-execution consequences.

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
— End of Safenet Arbitration Charter, v1 —
