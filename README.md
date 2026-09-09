# AWS Bedrock AgentCore: Multi-Agent Support Chatbot

A production-grade, multi-agent customer support system built using Amazon Bedrock and the AgentCore managed harness. This project demonstrates stateful conversational AI, strict prompt-based intent routing, and automated evaluation pipelines.

##  Architecture & Routing Logic

The core system bypasses legacy visual workflow builders in favor of deterministic prompt engineering. The system prompt acts as the central router, classifying user inputs into three strict categories:

1. **Bug Reports:** Routes to a mocked DynamoDB Lambda tool for ticket creation.
2. **Platform FAQs:** Handles embedded context directly without external tool invocation.
3. **Human Support:** Gracefully escalates unhandled or out-of-scope queries.

### Routing Execution
*(Visual proof of the routing logic properly handling in-scope and out-of-scope queries)*
- **FAQ Handled:**  
  ![FAQ Covered](./assets/test_faq_covered.png)
- **FAQ Uncovered (Escalation):**  
  ![FAQ Uncovered](./assets/test_faq_uncovered.png)
- **Out of Scope (Escalation):**  
  ![Other Request](./assets/test_other_request.png)

##  LLM-as-a-Judge Evaluation

To ensure production readiness and prevent hallucinated tool invocations, the prompt routing logic was evaluated using an automated Bedrock LLM-as-a-judge pipeline against a ground truth JSONL dataset.

* **Evaluation Metrics:** Task Completion, Groundedness, and Relevance.
* **Result:** The strict system prompt achieved a **1.0 Correctness score**.

![Evaluation Score](./assets/screenshot3.png)

##  Technology Stack
* **Cloud & Orchestration:** AWS Bedrock, AgentCore Managed Harness, Strands SDK
* **Models:** Amazon Nova Pro
* **Language:** Python 3.10+
* **Evaluation:** AWS Bedrock Automated Evaluation (JSONL)

##  Local Development
*(Note: AWS Cloud environment was ephemeral for security. To run the simulated routing logic locally:)*

1. Clone the repository.
2. Install dependencies (`pip install -r requirements.txt`).
3. Execute the mock chat terminal `python src/chat.py`.