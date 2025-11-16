# 🕹️ AWS CS2 Server – Cost Estimate

This document shows cost estimates for running a **Counter-Strike 2** server on AWS using this repository.  
The values consider the **sa-east-1 (São Paulo)** region, which is one of the more expensive AWS regions.

---

# Reference Configuration
All estimates use:

- **Region:** sa-east-1 (São Paulo)  
- **Operating System:** Linux  
- **EBS Volume:** 80GB gp3 (storage only, no extra IOPS/throughput)  
- **Server Type:** CS2 via LinuxGSM  

Prices used:

| Item | Price |
|------|-------|
| EC2 t3a.medium | **US$ 0.0598/hour** |
| EC2 t3a.small | **US$ 0.0300/hour** |
| EC2 c5.large | **US$ 0.0960/hour** |
| EBS gp3 80GB | **US$ 6.40/month** |

---

### 1. Estimate – **t3a.medium**

#### Calculation (24h/day)
- 24h × 30 days = **720 hours**  
- 720 × 0.0598 = **US$ 43.05**  
- EBS: **US$ 6.40**  
- **Total:** US$ 49.45 / month

#### Calculation (3h/day)
- 3h × 30 days = **90 hours**  
- 90 × 0.0598 = **US$ 5.38**  
- EBS: **US$ 6.40**  
- **Total:** US$ 11.78 / month

---

### 2. Estimate – **t3a.small**

#### Calculation (24h/day)
- 720 hours × 0.0300 = **US$ 21.60**  
- EBS: **US$ 6.40**  
- **Total:** US$ 28.00 / month

#### Calculation (3h/day)
- 90 hours × 0.0300 = **US$ 2.70**  
- EBS: **US$ 6.40**  
- **Total:** US$ 9.10 / month

---

### 3. Estimate – **c5.large**

#### Calculation (24h/day)
- 720 hours × 0.0960 = **US$ 69.12**  
- EBS: **US$ 6.40**  
- **Total:** US$ 75.52 / month

#### Calculation (3h/day)
- 90 hours × 0.0960 = **US$ 8.64**  
- EBS: **US$ 6.40**  
- **Total:** US$ 15.04 / month

---

### Recommendations
- For savings, consider using **t3a.small** or reducing the number of hours per day.  
- Alternatively, moving to cheaper regions (like **us-east-1**) can reduce costs by up to **40%**.  
- **C5.large** gives more CPU performance but comes at a higher cost; ideal only if your CS2 server needs more processing power.