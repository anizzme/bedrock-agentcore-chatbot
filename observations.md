# Observations

## What was tested
Four prompts in harness-tests.json: a covered platform question, an uncovered platform question, an out-of-scope request, and a vague bug report.

## Playground runs (Nova Pro, same system prompt, single runs)
- "How do I return an item I bought?" -> answered the return question (306 in / 29 out, 465 ms)
- "Do you sell gift cards?" -> human-support sentence (303 / 12, 422 ms)
- "Who is the CEO of your company?" -> human-support sentence (305 / 13, 392 ms)

## Evaluation
Bedrock automated evaluation, job support-chatbot-eval-attempt-3: Correctness 1.00.
Dataset size: [N]. Small and hand-built, so it shows the prompt handles these cases, not that it is reliable on real traffic.

## Takeaways
- An FAQ question the FAQ does not cover (gift cards) was escalated instead of answered with an invented policy.
- Both escalation cases returned the exact fixed sentence the prompt requires.
- The bug route is guarded twice: the prompt forbids filing without all three details, and the Lambda rejects empty fields.

## Not yet tested
Mixed-intent messages, prompt-injection attempts, typos, and non-English input.
