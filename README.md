# knowledgeSharing

`knowledgeSharing` is an R package for analyzing knowledge sharing and convergence in conversations.  
It uses Latent Semantic Analysis (LSA) to build a shared semantic space, then applies a sliding-window approach to compute group-level centroids and measure how the conversation’s semantic content evolves over time.

--- 

## 📚 Background

The approach implemented in this package is inspired by the work of Andy Dong in the foundational paper:

Dong, A. (2005). The latent semantic approach to studying design team communication. Design Studies, 26(5), 445–461.
https://doi.org/10.1016/j.destud.2004.12.003

Dong introduced the concept of a semantic centroid for a team, and measured how individual contributions converge toward or diverge from this centroid over time. This method has since been adapted for broader use in communication analysis.

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
```
---

### Example Output Figures

#### 1. Cosine Similarity Plot (`cosine_plot.png`)  
This figure shows how similar each sliding-window centroid is to the one before it, using **cosine similarity**. Higher values (closer to 1) indicate that consecutive windows contain highly overlapping semantic content, while lower values reflect shifts in the conversation toward new ideas or topics.

<img width="2100" height="2100" alt="cosine_plot" src="https://github.com/user-attachments/assets/863551d4-1f5a-49ea-935e-7f9abb1798b7" />

#### 2. Euclidean Distance Plot (`euclid_plot.png`)  
This figure tracks the **magnitude of change** in the centroid between consecutive windows, measured as Euclidean distance in the semantic space. Larger distances mean that the group’s conversation vector has shifted substantially, while smaller distances suggest incremental change or stability.

<img width="2100" height="2100" alt="euclid_plot" src="https://github.com/user-attachments/assets/3b7d2d25-bea4-49a0-aa52-cbd3ea0400c1" />

#### 3. Combined Plot (`combined_plot.png`)  
This combines cosine similarity and Euclidean distance into one panel, allowing for a direct comparison of the two measures. Together, they show not only whether the conversation is moving in new directions, but also how big or small those changes are.

<img width="2100" height="2100" alt="combined_plot" src="https://github.com/user-attachments/assets/d4aadf99-d88d-4930-a70f-0ef0206f420e" />

#### 4. Cosine Colored by Euclidean Distance (`cosine_colored_by_euclid_plot.png`)  
This hybrid visualization overlays Euclidean distance as a **color gradient** on the cosine similarity plot. It highlights not only when the semantic similarity dips, but also how strongly the group is diverging in its shared knowledge space at that moment.

<img width="2100" height="2100" alt="cosine_colored_by_euclid_plot" src="https://github.com/user-attachments/assets/9fbce71b-d479-4a25-bd2d-e8bd0c001e3b" />
