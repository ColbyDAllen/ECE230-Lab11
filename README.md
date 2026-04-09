# Lab 11 - Counters and Dividers

In this lab, we learned how to make clock dividers from two types of counters.

## Rubric

|Item|Description|Value|
|-|-|-|
|Summary Answers|Your writings about what you learned in this lab.|25%|
|Question 1|Your answers to the question|25%|
|Question 2|Your answers to the question|25%|
|Question 3|Your answers to the question|25%|

## Names

Austin Bartram, Colby Allen

## Summary

* This lab helped us understand two different ways to divide a clock signal. The modulo counter gives an exact configurable division value, while a ripple counter is simpler and divides by powers of two.

## Lab Questions

### 1 - Why does the Modulo Counter actually divide clocks by 2 \* Count?

* The modulo counter toggles its output once each time it reaches the terminal count, but one full cycle of a clock output requires both a high to low and a low to high transition. Because of that, it takes two full counts to complete one output cycle, so we this division by "2 \* Count".  

### 2 - Why does the ring counter's output go to all 1s on the first clock cycle?

* In our ripple counter, since all three T flip-flops start at 0 and each stage is clocked by the previous stage’s output, the first rising edge can ripple through the chain and toggle each stage from 0 to 1, so the visible state becomes 111.

### 3 - What width of ring counter would you use to get to an output of \~1KHz?

* For a ripple counter, each stage divides the input clock by 2, so the output frequency is `100 MHz / 2^N`. Solving for about 1 kHz gives N = log\_2(100,000,000 / 1000) = 16.6096, so we would use a 17-bit ripple counter to get close to 1 kHz.

