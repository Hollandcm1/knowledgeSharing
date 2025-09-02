# knowledgeSharing

`knowledgeSharing` is an R package for analyzing knowledge sharing and convergence in conversations.  
It uses Latent Semantic Analysis (LSA) to build a shared semantic space, then applies a sliding-window approach to compute group-level centroids and measure how the conversation’s semantic content evolves over time.

---

## Features

- Build a **global LSA semantic space** across an entire conversation.
- Compute **sliding-window centroids** for groups or overall.
- Quantify **knowledge change dynamics** using:
  - Cosine similarity between windows
  - Euclidean distance between centroids
- Generate **visualizations** to explore how knowledge sharing and convergence unfold during interactions.
- Works with **grouped or ungrouped** data.

---

## Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools")
devtools::install_github("Hollandcm1/knowledgeSharing")
