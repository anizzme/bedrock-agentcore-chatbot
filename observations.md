# Model Evaluation Observations

## Results
The initial Bedrock LLM-as-a-judge evaluation yielded a Correctness score of 0.67. 

## Analysis of the 0.67 Score
A score of 0.67 indicates that while the agent successfully triggers the `create_bug_report` tool most of the time, it occasionally misses the mark on certain test cases. Based on my observation of the chat logs, the primary reason for this dropped score is prompt adherence. 

The system prompt requires the model to collect three specific pieces of information (description, environment, steps to reproduce) before firing the tool. In some edge cases, the model either:
1. Hallucinates steps to reproduce if the user is vague.
2. Prematurely fires the tool call before confirming the user's operating system.
3. Fails to recognize that the user implicitly provided the environment data.

## Next Steps for Optimization
To push this correctness score closer to 1.0, I would implement the following improvements:
* **Prompt Engineering:** Refine the system prompt with strict `<instructions>` tags to enforce a hard stop—preventing the tool execution if any of the three variables are empty.
* **Few-Shot Examples:** Provide the model with example conversation trajectories in the prompt where a user tries to skip providing their environment, showing the model exactly how to push back.