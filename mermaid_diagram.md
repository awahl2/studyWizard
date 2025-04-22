```mermaid
graph TD
    A[main.dart] --> B[Controllers]
    A --> C[Views]
    B --> D[Services]
    D --> E[Models]
    C --> F[Models]
